class User < ActiveRecord::Base
	# rails g scaffold User username:string password:string first_name:string slug:string

	# extend FriendlyId
 #  	friendly_id :username #, use: :slugged

	validates :username, :route => true

	validates_format_of :username, :without => /^\d/, :multiline => true

	def self.find(input)
		input.to_i == 0 ? find_by_username(input) : super(input)
	end

	def self.exists?(input)
		input.to_i == 0 ? super(username: input) : super(input)
	end

	def to_param
		self.username
	end
end
