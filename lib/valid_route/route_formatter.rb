module ValidRoute
	class RouteFormatter
		def initialize
			@buffer = []
		end

		def result
			@buffer.join("\n").scan(/\s\/(\w+)/).flatten.compact.uniq
		end

		def section_title(title)
		end

		def section(routes)
			@buffer << array_paths(routes)
		end

		def header(routes)
		end

		def no_routes
			@buffer
		end

		private
		def array_paths(routes)
			paths = []
			routes.map do |r|
				paths << r[:path]
			end
			paths
		end
	end
end