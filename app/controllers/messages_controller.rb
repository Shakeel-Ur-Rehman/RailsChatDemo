class MessagesController < ApplicationController
    protect_from_forgery except: :recievesms
    skip_before_action :verify_authenticity_token,only:[:recievesms]
    before_action :setuptwilio
    before_action :setup_twilio_number
    def index
        @threads=Messagethread.order('updated_at DESC').all    #TODO Need to add some pagination here.
        if(params.has_key?(:thread_id))
            @thread_id=params["thread_id"]
            @thread=Messagethread.find(params["thread_id"])
            @messages=@thread.messages
        else
            @messages=[]
        end  
    end
    def create
        sendsms
        @thread=Messagethread.find(params["message"]["thread_id"])
        @messages=@thread.messages
    end
    def recievesms
        @thread=Messagethread.where(phone:params["From"]);
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
    @twilio_number=ENV['twilio_number']
end
def setuptwilio
    account_sid=ENV['account_sid']
    auth_token=ENV['auth_token']
    @client=Twilio::REST::Client.new(account_sid, auth_token);
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
    @message.messagethread_id=params["message"]["thread_id"]
    @message.body=params["message"]["body"]
    @message.save
   end
end
end
