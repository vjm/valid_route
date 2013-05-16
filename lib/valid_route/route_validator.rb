class RouteValidator < ActiveModel::EachValidator

	def initialize(options)
	  # options[:get_all_conflicts] = true
	  super
	  scrub_options options
	  
	end

	def validate_each(record, attribute, value)
		# Get all Routes
		inspector = ActionDispatch::Routing::RoutesInspector.new(Rails.application.routes.routes)
		routes = inspector.format(ValidRoute::RouteFormatter.new)

		routes = scrub_routes routes

		conflicts = check_conflicts routes, record	

		unless conflicts.empty?
			record.errors[attribute] << (@options[:message] || "route is taken")
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
		possible_conflicts = []
		routes_to_create.each {|route_to_create|
			routes.each {|route|
				unless route == route_to_create
					parameter = route_to_create[:path].split(/.*?(:[^\/]*)/).last || ""
					substituted_route = route_to_create[:path].sub(parameter, record.to_param)
					if (route[:path] == route_to_create[:path]) or (route[:path] == substituted_route) and route[:reqs] != route_to_create[:reqs]
						possible_conflicts.push route 
					end
				end
			}

		}

		# if there is an already existing route for a non-show and non-edit action, add it to the list of conflicting paths
		possible_conflicts.each {|route|
			routes_to_create.each {|route_to_create|
				unless (route[:reqs].include?("#show") or route[:reqs].include?("#edit"))
					parameter = route_to_create[:path].split(/.*?(:[^\/]*)/).last || ""
					substituted_route = route_to_create[:path].sub(parameter, record.to_param)
					if (route[:path] == route_to_create[:path]) or (route[:path] == substituted_route)
						conflicts.push route
						break unless @options[:get_all_conflicts]
					end
				end
			}
			break if !conflicts.empty? unless @options[:get_all_conflicts]
		}

		# Check for existing records of other Classes' Show actions, add it to the conflicting paths if the record at that path already exists
		possible_conflicts.each {|route|
			routes_to_create.each {|route_to_create|
				if route[:reqs].include?("#show") or route[:reqs].include?("#edit")
					if route[:reqs].include?("/") # is this a namespaced route or anything?
						puts route[:reqs]
						route_controller_segments = route[:reqs].slice(/(.*)(#)(.*)/, 1).split(/^(.*\/)(.*)$/)
						last_segment = route_controller_segments.pop.singularize
						klass_underscored = route_controller_segments.join("") + last_segment

						# TODO: THIS has no coverage
					else
						klass_underscored = route[:reqs].slice(/(.*)(#)(.*)/, 1).singularize
					end
					klass = klass_underscored.classify.constantize
					if klass.exists?(record.to_param)
						conflicts.push route unless klass.find(record.to_param).eql? record
						break unless @options[:get_all_conflicts]
					end
					if record.class.exists?(record.to_param)
						conflicts.push route unless record.class.find(record.to_param).eql? record
						break unless @options[:get_all_conflicts]
					end
				end
			}
			break if !conflicts.empty? unless @options[:get_all_conflicts]
		}

		conflicts
	end

	def scrub_options(options)
		unless options[:reserved_routes].nil?
			options[:reserved_routes].map! { |route_path|
				route_path = "/" + route_path if route_path[0] != "/"
			}
		end

		unless options[:unreserved_routes].nil?
			options[:unreserved_routes].map! { |route_path|
				route_path = "/" + route_path if route_path[0] != "/"
			}
		end
	end

	def scrub_routes(routes)

		# Add the additional routes 
		unless @options[:reserved_routes].nil?
			@options[:reserved_routes].each { |route_path|
				routes << {path: route_path, verb: 'GET', reqs: ''}
			}
		end

		# Remove unreserved routes
		unless @options[:unreserved_routes].nil?
			routes.delete_if { |route|
				route_included = false
				@options[:unreserved_routes].each { |route_path|
					route_included = route_included || (route[:path] == route_path)
				}
				route_included
			}
		end

		# Filter for matching GET requests only
		routes.delete_if { |route|
			delete = false
			delete = route[:verb] != "GET" || delete
			# delete = route[:reqs].include?("redirect") || delete
			# delete
		}

		# Allow redirect paths 
		routes.each {|route|
			if route[:reqs].include?("redirect")
				redirected_path = route[:reqs].slice(/.*redirect\(\d*,\s([^\)]*)\)/, 1)
				delete_original = false
				routes.each {|route_to_match|
					if route_to_match[:path] == redirected_path
						redirected_route = route.clone
						redirected_route[:reqs] = route_to_match[:reqs]
						routes << redirected_route
						delete_original = true
					end
				}
				routes.delete route if delete_original
			end
		}

		routes.compact.flatten.uniq
	end
end