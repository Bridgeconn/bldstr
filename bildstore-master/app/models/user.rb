class User < ApplicationRecord
	rolify
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable, :confirmable,
		:recoverable, :rememberable, :trackable, :validatable

	has_many :addresses
	accepts_nested_attributes_for :addresses, :allow_destroy => true

	has_many :orders
	has_many :recent_product_visits, dependent: :destroy

	validates_presence_of :first_name, :last_name, :email, :phone_number, :password

	after_create :send_account_info

	def is_admin?
		self.has_role? :admin
	end

	def to_s
		full_name
	end

	def full_name
		"#{first_name} #{last_name}"
	end

	def send_account_info
		UserMailer.send_account_info(self).deliver
	end
end
