class Task < ActiveRecord::Base
  mount_uploader :ebook, EbookUploader

  validates :email, presence: true

  before_destroy :destroy_mobi_file

  private

  def destroy_mobi_file
    system('rm', mobi_path)
  end
end
