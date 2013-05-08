# http://robotslacker.com/2012/01/rails-3-routes-configuration-dynamic-segments-constraints-and-scope/
class PageConstraint
	def initialize
	end

	def matches?(request)
		Page.exists?(request.path_parameters[:id])
	end
end