class Page < ActiveRecord::Base
	# rails g scaffold Page name:string permalink:string content:text slug:string

	# extend FriendlyId
	# friendly_id :permalink #, use: :slugged

	validates :permalink, :route => true

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
