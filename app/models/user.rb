# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :email, :name, :password, :password_confirmation
  validates :name, :presence=>true, :length=>{:maximum=>50}
  email_regex = /\A[\w+\-._]+@[a-z\d\-._]+\.[a-z]+\z/i
  validates :email, :format=>{:with=>email_regex}, :presence=>true, :uniqueness=>{ :case_sensitive => false }
  validates :password, :confirmation=>true, :presence=>true, :length=>{:within=>6..40}

before_save :encrypt_password

  def has_password?(submited_password)
    #check whether hashed submited password = stored hashed password
    encrypted_password == encrypt(submited_password)
  end

  def self.authenticate(submitted_email,submitted_password)
    found_user = find_by_email(submitted_email)
    found_user && found_user.has_password?(submitted_password)? found_user : nil
  end
  def self.authenticate_with_salt(id,salt)
    found_user = find_by_id(id)
    (found_user && found_user.salt==salt) ? found_user : nil
  end

  private  
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(self.password)
    end
    def encrypt(passwd)
      secure_hash("#{salt}--#{passwd}")
    end
    def make_salt #called only when a fresh record is created
      secure_hash("#{Time.now.utc}--#{email}")
    end
    def secure_hash(salted_passwd)
      Digest::SHA2.hexdigest(salted_passwd)
    end
end
