require 'digest/sha1'
class User < ActiveRecord::Base
  has_attached_file :beard, :storage=>:s3, 
    :s3_credentials=>{:access_key_id=>ENV['ACCESS_KEY_ID'], 
    :secret_access_key=>ENV['SECRET_ACCESS_KEY'] }, 
    :bucket=>'rmn.bdx', :path => ":class/:attachment/:id/:style/:filename", 
    :styles=> {:thumb=>"90x90"}
  has_many :events
  has_many :openings
  has_many :projects
  has_one :for_hire
  named_scope :beardos, :conditions => 'beard_file_name is not null'
  attr_protected :verified, :form
  after_validation :encrypt_password
  validates_confirmation_of :password , :msg=>"Confirmation password should match", :on=>:create
  validates_uniqueness_of :login, :email
  validates_presence_of :login, :email, :firstname, :lastname
  validates_presence_of :password, :on=>:create

  def self.calc_bdx
    b = beardos.count.to_f
    a = count.to_f
    if b > 0
      (b/a)*100.0
    else
      0.0
    end
  end

  def crypt_new_password
    encrypt_password
    save!
  end

  def to_param
    self[:login]
  end
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
    crypted = hashify(u.salt+hashify(password))
    find(:first, :conditions => ["login = ? AND salted_password = ? AND verified = 1", login, crypted])
  end

  attr_accessor :password, :password_confirmation
  def admin?
    return role == 'admin'
  end
  protected

  def new_security_token(hours = 1)
    write_attribute('security_token', User.hashify(self.salted_password + Time.now.to_i.to_s + rand.to_s))
    write_attribute('token_expiry', Time.at(Time.now.to_i + hours*60*60))
    update_without_callbacks
    return self.security_token
  end
  def self.hashify(str)
    salt = "kjfkuck6yl876i3i^$$I^izkyr75"
    return Digest::SHA1.hexdigest("#{salt}--#{str}--}")[0..39]
  end
  def encrypt_password
    if password
      salt = User.hashify("salt-#{Time.now}")
      logger.debug "encrypting password : #{password}"
      self[:salted_password]=User.hashify(salt+User.hashify(password))
      self[:salt] = salt
    end
  end
end
