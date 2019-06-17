class Message < ApplicationRecord
    belongs_to :messagethread

    def self.create_message(to,from,body,thread_id)
    Message.create(to:to,from:from,body:body,messagethread_id:thread_id)
    end
end
