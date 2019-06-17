class MessagesController < ApplicationController
    protect_from_forgery except: :recievesms
    skip_before_action :verify_authenticity_token,only:[:recievesms]
    before_action :setuptwilio
    before_action :setup_twilio_number
    def index
        @threads=Messagethread.order('updated_at DESC').all    #TODO Need to add some pagination here.
        if(params.has_key?(:thread_id))
            @thread=Messagethread.find(params["thread_id"])
        else
            @thread=Messagethread.last
        end  
    end

    def create
        if(params.has_key?(:message))
            sendsms
        @thread=Messagethread.find(params["message"]["thread_id"])
        else
            recievesms
        @thread=Messagethread.find(@thread.id)
        end
       
    end


private

def setup_twilio_number
    @twilio_number=ENV['twilio_number']
end

def setuptwilio
    account_sid=ENV['account_sid']
    auth_token=ENV['auth_token']
    @client=Twilio::REST::Client.new(account_sid, auth_token);
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

def sendsms   
    if @client.messages.create(
     from:@twilio_number,
     to:params["message"]["to"],
     body:params["message"]["body"]
   )
   Message.create_message(params["message"]["to"],@twilio_number,params["message"]["body"],params["message"]["thread_id"])
   end
end
end
