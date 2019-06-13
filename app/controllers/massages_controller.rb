class MassagesController < ApplicationController
    protect_from_forgery except: :recievesms
    skip_before_action :verify_authenticity_token,only:[:recievesms]
    before_action :setuptwilio
    before_action :setup_twilio_number

    def create
        @threads=Messagethread.order('updated_at DESC').all
        @twilio=@twilio_number
        if(params.has_key?(:thread_id))
        @thread_id=params["thread_id"]
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
    end
        @message=Message.new
        @message.to="+923015067211"
        @message.from=@twilio_number
        @message.messagethread_id=params["message"]["thread_id"]
        @message.body=params["message"]["body"]
        @message.save
        redirect_to controller: "massages", action: 'create',thread_id: params["message"]["thread_id"]
    end

    def recievesms
        phonenumber=params["From"];
        @thread=Messagethread.where(phone:phonenumber);
        if @thread.length > 0
            message=Message.new
            message.to=@twilio_number
            message.from=params["From"]
            message.messagethread_id=@thread.id
            message.body=params["Body"]
            message.save
        else
            @thread=Messagethread.new
            @thread.description=params["Body"]
            @thread.phone=params["From"]
            @thread.topic="Thread Topic"
            @thread.save
            message=Message.new
            message.to=@twilio_number
            message.from=params["From"]
            message.messagethread_id=@thread.id
            message.body=params["Body"]
            message.save
        end
   
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
