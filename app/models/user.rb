require 'digest/sha1'
class User < ActiveRecord::Base
  has_many :events
  has_many :openings
  has_and_belongs_to_many :books, :join_table=>'users_books'
  attr_protected :verified, :form
  attr_accessor :new_password
  def generate_security_token(hours = 1)
    if  self.security_token.nil? or self.token_expiry.nil? or (Time.now.to_i + (60*60) / 2) >= self.token_expiry.to_i
      return new_security_token(hours)
    else
      return self.security_token
    end
  end
  def self.authenticate(login, password)
    u = find(:first, :conditions => ["login = ? AND verified = 1 AND deleted = 0", login])
    return nil if u.nil?
    find(:first, :conditions => ["login = ? AND salted_password = ? AND verified = 1", login, "#{u.salt}#{hash(password)}"])
  end

  protected

  attr_accessor :password, :password_confirmation
  def new_security_token(hours = 1)
    write_attribute('security_token', hash(self.salted_password + Time.now.to_i.to_s + rand.to_s))
    write_attribute('token_expiry', Time.at(Time.now.to_i + hours*60*60))
    update_without_callbacks
    return self.security_token
  end
  def hash(str)
    salt = "kjfkuck6yl876i3i^$$I^izkyr75"
    return Digest::SHA1.hexdigest("#{salt}--#{str}--}")[0..39]
  end
end
