class Task < ActiveRecord::Base
  enum status: [:initial, :converting, :broken, :mailing, :sent]
  mount_uploader :ebook, EbookUploader

  validates :email, presence: true, email: true

  before_destroy :destroy_mobi_file

  private

  def destroy_mobi_file
    system('rm', mobi_path) unless mobi_path.nil?
  end
end
