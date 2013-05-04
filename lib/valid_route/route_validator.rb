class RouteValidator < ActiveModel::EachValidator
	def validate_each(record, attribute, value)
		inspector = ActionDispatch::Routing::RoutesInspector.new(Rails.application.routes.routes)
		results = inspector.format(ValidRoute::RouteFormatter.new)

		req = record.class.name.underscore

		matches = []

		results.delete_if { |route|
			 route[:verb] != "GET"
		}

		results.each { |result|
			matches.push result if result[:reqs].include?(req)
		}




		# puts results

		unless options[:additional_routes_reserved].nil?
			results << options[:additional_routes_reserved]
			results = results.flatten.compact.uniq
		end


		

		unless options[:unreserved_routes].nil?
			results.delete_if { |route|
				options[:unreserved_routes].include?(route)
			}
		end

		if results.include?(value)
			record.errors[attribute] << (options[:message] || "route is taken")
		end
	end
end