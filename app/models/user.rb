require 'digest/sha1'

class User < ActiveRecord::Base
  has_many :events
  has_many :openings, :dependent => :destroy
  has_many :projects
  has_one :for_hire, :dependent => :destroy

  after_validation :encrypt_password

  validates :password,  :confirmation => { :message => "doesn't match confirmation" }, :on => :create
  validates :password,  :presence     => true, :on => :create
  validates :login,     :uniqueness   => true
  validates :email,     :uniqueness   => true
  validates :login,     :presence     => true
  validates :email,     :presence     => true
  validates :firstname, :presence     => true
  validates :lastname,  :presence     => true

  attr_protected :verified, :form, :security_token, :salted_password, :delete_after, :deleted

  scope :verified, where('verified != 0')

  def crypt_new_password
    encrypt_password
    save!
  end

  def to_param
    self[:login]
  end

  def generate_security_token(hours = 1)
    if self.security_token.nil? or self.token_expiry.nil? or (Time.now.to_i + (60*60) / 2) >= self.token_expiry.to_i
      new_security_token(hours)
    else
      self.security_token
    end
  end

  def self.authenticate(login, password)
    u = find(:first, :conditions => ["(email = ? OR login = ?) AND verified = 1 AND deleted = 0", login, login])
    return nil if u.nil?
    crypted = hashify(u.salt + hashify(password))
    find(:first, :conditions => ["(email = ? OR login = ?) AND salted_password = ? AND verified = 1", login, login, crypted])
  end

  attr_accessor :password, :password_confirmation
  def admin?
    role == 'admin'
  end

  def full_name
    [firstname, lastname].compact.join(' ') if firstname? || lastname?
  end

  protected

    def new_security_token(hours = 1)
      write_attribute(:security_token, User.hashify(self.salted_password + Time.now.to_i.to_s + rand.to_s))
      write_attribute(:token_expiry, Time.at(Time.now.to_i + hours * 60 * 60))
      save!
      return self.security_token
    end

    def self.hashify(str)
      salt = "kjfkuck6yl876i3i^$$I^izkyr75"
      return Digest::SHA1.hexdigest("#{salt}--#{str}--}")[0..39]
    end

    def encrypt_password
      if password
        salt = User.hashify("salt-#{Time.now}")

        self[:salted_password] = User.hashify(salt+User.hashify(password))
        self[:salt]            = salt
      end
    end
end
