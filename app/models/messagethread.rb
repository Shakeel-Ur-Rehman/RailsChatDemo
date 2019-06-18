class Messagethread < ApplicationRecord
    has_many :messages,dependent: :destroy
end
