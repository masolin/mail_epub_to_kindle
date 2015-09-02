class Task < ActiveRecord::Base
  enum status: [:initial, :converting, :broken, :mailing, :sent]
  mount_uploader :ebook, EbookUploader

  validates :email, presence: true, email: true
  validate :ebook_size

  before_destroy :destroy_mobi_file

  private

  def destroy_mobi_file
    system('rm', mobi_path) unless mobi_path.nil?
  end

  def ebook_size
    errors.add(:ebook, "should be less than 12MB") if ebook.size > 12.megabytes
  end
end
