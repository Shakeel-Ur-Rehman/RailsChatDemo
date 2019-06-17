Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post "create",to:"messages#create",as:"sendsms"
  post "sms/reply",to:"messages#recievesms"
  root "messages#index"
end
