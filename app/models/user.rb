class User < ApplicationRecord
	has_secure_password

	enum role: { admin: 'admin', manager: 'manager' }

	has_many :projects, dependent: :destroy
	has_many :tasks, through: :projects

	validates :email, presence: true, uniqueness: true
	validates :role, inclusion: { in: %w[admin manager] }

end
