class Account < ActiveRecord::Base

  has_many :diabetics

  has_secure_password
  attr_accessible :username, :email, :password, :password_confirmation

  after_validation { self.errors.messages.delete(:password_digest) }

  validates_uniqueness_of :email, :username
  validates_presence_of :username, :email
  validates_length_of :password, :within => 5..40
  validates_format_of :email, :with => /^\w+[\.\w\-]*@\w+\.\w{2,5}$/

  validates_presence_of :password,
                        :message => Proc.new { |error, attributes|
                          "#{attributes[:value]} can't be blank."
                        }

  def confirmed?(params)
    params[:account][:password_confirmation] == params[:account][:new_password]
  end

end
