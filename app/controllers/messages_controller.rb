class MessagesController < ApplicationController
    require 'twilio'
    protect_from_forgery except: :recievesms
    skip_before_action :verify_authenticity_token,only:[:recievesms]
    before_action :authenticate_twilio_request,only:[:recievesms]
    before_action :setup_twilio_number
    def index
        @threads=Messagethread.order('updated_at DESC').all    #TODO Need to add some pagination here.
        if(params.has_key?(:thread_id))?@thread=Messagethread.find(params["thread_id"]):@thread=Messagethread.last
        end
    end

    def create
        if(params.has_key?(:message))
            TwilioAPI.new.sendSms(params["message"]["to"],params["message"]["body"])
            Message.create_message(params["message"]["to"],@twilio_number,params["message"]["body"],params["message"]["thread_id"])
            @thread=Messagethread.find(params["message"]["thread_id"])
        end
    end

    def recievesms
        @thread=Messagethread.where(phone:params["From"]);
        if @thread.length > 0 
            Message.create_message(@twilio_number,params["From"],params["Body"],@thread.id)
        else
            @thread=Messagethread.create(:topic=>"Thread Topic",:phone=>params["From"],:description=>params["Body"])
            @thread.messages.create(:to=>@twilio_number,:from=>params["From"],:body=>params["Body"])
        end
    
    end


private

def authenticate_twilio_request 
    unless TwilioAPI.new.validate_twilio_request?(params["AccountSid"])
        redirect_to("422.html")
    end
end

def setup_twilio_number
    @twilio_number=ENV['twilio_number']
end
end
