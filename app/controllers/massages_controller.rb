class MassagesController < ApplicationController
    protect_from_forgery except: :recievesms
    skip_before_action :verify_authenticity_token,only:[:recievesms]
    before_action :setuptwilio
    before_action :setup_twilio_number

    def create
        @threads=Messagethread.all
        @twilio=@twilio_number
        if(params.has_key?(:thread_id))
        @thread=Messagethread.find(params["thread_id"])
        @messages=@thread.messages
        else
            @messages=[]
        end
        
      
    end
    def sendsms
       if @client.messages.create(
            from:@twilio_number,
            to:"+923015067211",
            body:params["message"]["body"]
        )
        @message=Message.new
        @message.to="+923015067211"
        @message.from=@twilio_number
        @message.body=params["message"]["body"]
        @message.save
       end
        redirect_to :create
    end

    def recievesms
    message=Message.new
    message.to=@twilio_number
    message.from=params["From"]
    message.body=params["Body"]
    message.save
    end

private
def setup_twilio_number
    @twilio_number="+12566774391"
end
def setuptwilio
    account_sid="ACab6167f6a86e1da9a2d17e8717249d6d"
    auth_token="c1c6069c707156c12e5fac43dfa33267"
    @client=Twilio::REST::Client.new(account_sid, auth_token);
end
end
