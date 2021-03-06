class User < ActiveRecord::Base

  ROLES = ["admin", "moderator", "blogger"]

  has_many :ratings
  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one :payment_profile

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :password, presence: true, length: 3..20, :if => :password_changed?

  before_save :encrypt_password, :if => :password_changed?

  before_create :activation_processing

  User::ROLES.each do |role|
    define_method("#{role}?") do
       self.role == role
     end
  end

  def expiry_time
    if (Time.now.utc - created_at)/1.day <= Subscription::TRIAL_PERIOD  
      created_at + Subscription::TRIAL_PERIOD.days
    else
      payment_profile.try(:expiry_time) || Time.now.utc
    end
  end

  def self.by_login_data params
  	return unless user = User.find_by_email(params[:email])
    encrypted_password = Encryptor.new(user.salt).encrypt(params[:password])
    user if encrypted_password == user.password
  end

  private

  def activation_processing
    setting = Setting.find_by_name("Automatic activation")
    if setting.value == "on"
      self.active = true
    else
      UsersMailer.activate(self).deliver
    end
  end


  def encrypt_password
  	self.salt = SecureRandom.hex
  	self.password = Encryptor.new(salt).encrypt(password)
  end

end