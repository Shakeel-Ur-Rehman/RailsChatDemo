class TwilioAPI
    attr_accessor :client,:account_sid
    def initialize
        account_sid=ENV['account_sid']
        auth_token=ENV['auth_token']
        @client=Twilio::REST::Client.new(account_sid, auth_token);
    end
    def validate_twilio_request?(accountid)
        return account_sid==accountid
    end
    def sendSms(to,body)
        client.messages.create(
            from:ENV["twilio_number"],
            to:to,
            body:body
          )
    end
end