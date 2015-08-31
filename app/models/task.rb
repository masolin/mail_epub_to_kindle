class Task < ActiveRecord::Base
  mount_uploader :ebook, EbookUploader

  validates :email, presence: true
end
