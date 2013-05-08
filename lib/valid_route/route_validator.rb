class RouteValidator < ActiveModel::EachValidator
	# include ActionView::Helpers::UrlHelper
	# include ActionDispatch::Routing
	# include Rails.application.routes.url_helpers

	def validate_each(record, attribute, value)
		# Get all Routes
		inspector = ActionDispatch::Routing::RoutesInspector.new(Rails.application.routes.routes)
		routes = inspector.format(ValidRoute::RouteFormatter.new)
		
		# options = clean_options(options)

		unless options[:additional_routes_reserved].nil?
			options[:additional_routes_reserved].map! { |route_path|
				route_path = "/" + route_path if route_path[0] != "/"
			}
		end

		unless options[:unreserved_routes].nil?
			options[:unreserved_routes].map! { |route_path|
				route_path = "/" + route_path if route_path[0] != "/"
			}
		end


		# Add the additional routes 
		unless options[:additional_routes_reserved].nil?
			options[:additional_routes_reserved].each { |route_path|
				routes << {path: route_path, verb: 'GET', reqs: ''}
			}
		end

		# Remove unreserved routes
		unless options[:unreserved_routes].nil?
			routes.delete_if { |route|
				route_included = false
				options[:unreserved_routes].each { |route_path|
					route_included = route_included || route[:path].include?(route_path)
				}
				route_included
			}
		end


		# Filter for matching GET requests only
		routes.delete_if { |route|
			route[:verb] != "GET"
		}

		conflicts = check_conflicts(routes, record)

		

		unless conflicts.empty?
			record.errors[attribute] << (options[:message] || "route is taken")
		end
	end

	private
	def check_conflicts(routes, record)
		
		# Get the Class of the record we want to validate
		endpoint = record.class.name.underscore

		conflicts = []

		# Get the list of routes we want to create which may conflict with other routes based off of the controller
		routes_to_create = []
		routes.each { |result|
			routes_to_create.push result if result[:reqs].include?(endpoint)
		}


		# Get all possibly conflicting paths (routes to the same path, unless it's a path for the current controller)
		# TODO: this will try to match '/pages' and '/:id', instead of '/pages' to '/pages'.
		# make sure that you're checking the symbol path as well as the symbol-replaced path
		# hardcoded to :id right now. can we get more intelligent about that?
		# The 301 redirect route is breaking this right now for the home page.
		possible_conflicts = []
		routes_to_create.each {|route_to_create|
			routes.each {|route|
				unless route == route_to_create
					substituted_route = route_to_create[:path].sub(":id", record.to_param)
					if (route[:path] == route_to_create[:path]) or (route[:path] == substituted_route)
						possible_conflicts.push route 
					end
				end
			}

		}

		# if there is an already existing route for a non-show and non-edit action, add it to the list of conflicting paths
		# TODO: this will try to match '/pages' and '/:id', instead of '/pages' to '/pages'.
		# make sure that you're checking the symbol path as well as the symbol-replaced path.
		# hardcoded to :id right now. can we get more intelligent about that?
		# The 301 redirect route is breaking this right now for the home page.
		# contact_us can be a username right now for some reason.
		possible_conflicts.each {|route|
			routes_to_create.each {|route_to_create|
				# unless (route[:reqs].include?("#show") or route[:reqs].include?("#edit"))
					substituted_route = route_to_create[:path].sub(":id", record.to_param)
					if (route[:path] == route_to_create[:path]) or (route[:path] == substituted_route)
						conflicts.push route
					end
				# end
			}
		}

		# Check for existing records of other Classes' Show actions, add it to the conflicting paths if the record at that path already exists
		possible_conflicts.each {|route|
			routes_to_create.each {|route_to_create|
				if route[:reqs].include?("#show") or route[:reqs].include?("#edit")
					if route[:reqs].include?("/") # is this a namespaced route or anything?
						route_controller_segments = route[:reqs].split(/^(.*\/)(.*)$/)
						klass_underscored = route_controller_segments[0] + route_controller_segments[1].singularize
					else
						klass_underscored = route[:reqs].slice(/(.*)(#)(.*)/, 1).singularize
					end
					
					klass = klass_underscored.classify.constantize
					conflicts.push route if klass.exists?(record.to_param)
				end
			}
		}

		conflicts
	end

	def clean_options(options)
		unless options[:additional_routes_reserved].nil?
			options[:additional_routes_reserved].map! { |route_path|
				route_path = "/" + route_path if route_path[0] != "/"
			}
		end

		unless options[:unreserved_routes].nil?
			options[:unreserved_routes].map! { |route_path|
				route_path = "/" + route_path if route_path[0] != "/"
			}
		end

	end
end