module ValidRoute
	class RouteFormatter
		def initialize
			@buffer = []
			@current_route_set = nil
			@main_app_routes = []
			@engine_routes = []
		end

		def result
			@buffer #.compact.uniq
		end

		def section_title(title) # only called for engines
			engine_regexp = /Routes for (.*)/
			if title.match(engine_regexp)
				@current_route_set = title.slice(engine_regexp,1)
			end
		end

		def section(routes)
			formatted_routes = array_paths(routes)
			if @main_app_routes.empty?
				@main_app_routes = formatted_routes
			else
				@engine_routes << formatted_routes
			end
			@buffer << formatted_routes
			@buffer.flatten!
		end

		def header(routes)
		end

		def no_routes
			@buffer
		end

		private
		def array_paths(routes)
			format_regexp = "(.:format)"
			path_prefix = ""
			unless @current_route_set.nil?
				engine_route = @main_app_routes.select { |r| r[:reqs] == @current_route_set}
				unless engine_route.empty?
					path_prefix = engine_route.first[:path]
					@buffer = @buffer - engine_route
					# @main_app_routes = @main_app_routes - engine_route
				end
				@current_route_set = nil
			end
			paths = []
			routes.map do |r|
				path = r[:path].sub(format_regexp, "")
				path = path_prefix + path
				path = path[1..-1] if path[0..1] == "//"
				path.chop! if path[-1, 1] == "/" and path != "/"
				paths << {path: path, verb: r[:verb], reqs: r[:reqs], name: r[:name] }
			end
			paths
		end
	end
end