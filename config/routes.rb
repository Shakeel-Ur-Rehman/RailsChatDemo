Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "sms",to:"massages#create",as:"create"
  post "sendsms",to:"massages#sendsms",as:"sendsms"
  post "sms/reply",to:"massages#recievesms"
  root "massages#create"
end
