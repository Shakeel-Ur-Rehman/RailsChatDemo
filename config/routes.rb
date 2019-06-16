Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "sms",to:"messages#create",as:"create"
  post "sendsms",to:"messages#sendsms",as:"sendsms"
  post "sms/reply",to:"messages#recievesms"
  root "messages#create"
end
