module ValidRoute
	class RouteFormatter
		def initialize
			@buffer = []
		end

		def result
			@buffer #.compact.uniq
		end

		def section_title(title)
		end

		def section(routes)
			@buffer << array_paths(routes)
			@buffer.flatten!
		end

		def header(routes)
		end

		def no_routes
			@buffer
		end

		private
		def array_paths(routes)
			regexp = "(.:format)"
			paths = []
			routes.map do |r|
				paths << {path: r[:path].sub(regexp, ""), verb: r[:verb], reqs: r[:reqs] }
			end
			paths
		end
	end
end