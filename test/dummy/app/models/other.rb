class Other < ActiveRecord::Base
	# rails g scaffold Other name:string permalink:string content:text

	validates :permalink, :route => { unreserved_routes: ["pages"] }

	validates_format_of :permalink, :without => /^\d/, :multiline => true
	
	def self.find(input)
		input.to_i == 0 ? find_by_permalink(input) : super(input)
	end

	def self.exists?(input)
		input.to_i == 0 ? super(permalink: input) : super(input)
	end

	def to_param  # overridden
		self.permalink
	end
end
