class Task < ActiveRecord::Base
  validates :email, presence: true
end
