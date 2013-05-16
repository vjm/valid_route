require 'test_helper'

class RouteFormatterTest < ActionController::TestCase

	test "routes returned as an array" do
		expected_results = []
		expected_results.push({path: '/pages', verb: 'GET', reqs: 'pages#index', name: "pages"})
		expected_results.push({path: '/pages/new', verb: 'GET', reqs: 'pages#new', name: "new_page"})
		expected_results.push({path: '/pages/:id/edit', verb: 'GET', reqs: 'pages#edit', name: "edit_page"})
		expected_results.push({path: '/pages/:id', verb: 'GET', reqs: 'pages#show', name: "page"})
		expected_results.push({path: '/:id', verb: 'GET', reqs: 'pages#show', name: "page_permalink"})
		expected_results.push({path: '/', verb: 'GET', reqs: 'pages#show {:id=>"home"}', name: "root"})
		expected_results.push({path: '/home', verb: 'GET', reqs: 'redirect(301, /)', name: "home"})
		expected_results.push({path: '/contact_us', verb: 'GET', reqs: 'pages#show {:id=>"contact"}', name: "contact_us"})

		expected_results.push({path: "/users", :verb=>"GET", :reqs=>"users#index", name: "users"})
		expected_results.push({path: "/users/new", :verb=>"GET", :reqs=>"users#new", name: "new_user"})
		expected_results.push({path: "/users/:id/edit", :verb=>"GET", :reqs=>"users#edit", name: "edit_user"})
		expected_results.push({path: "/users/:id", :verb=>"GET", :reqs=>"users#show", name: "user"})
		expected_results.push({path: "/:id", :verb=>"GET", :reqs=>"users#show", name: "user_profile"})
		expected_results.push({path: "/all_users", :verb=>"GET", :reqs=>"users#index", name: "all_users"})

		expected_results.push({path: "/others", :verb=>"GET", :reqs=>"others#index", name: "others"})
		expected_results.push({path: "/others/new", :verb=>"GET", :reqs=>"others#new", name: "new_other"})
		expected_results.push({path: "/others/:id/edit", :verb=>"GET", :reqs=>"others#edit", name: "edit_other"})
		expected_results.push({path: "/others/:id", :verb=>"GET", :reqs=>"others#show", name: "other"})
		expected_results.push({path: "/:id", :verb=>"GET", :reqs=>"others#show", name: "other_permalink"})

		expected_results.push({path: "/namespaced/whizzers", :verb=>"GET", :reqs=>"namespaced/whizzers#index", name: "namespaced_whizzers"})
		expected_results.push({path: "/namespaced/whizzers/new", :verb=>"GET", :reqs=>"namespaced/whizzers#new", name: "new_namespaced_whizzer"})
		expected_results.push({path: "/namespaced/whizzers/:id/edit", :verb=>"GET", :reqs=>"namespaced/whizzers#edit", name: "edit_namespaced_whizzer"})
		expected_results.push({path: "/namespaced/whizzers/:id", :verb=>"GET", :reqs=>"namespaced/whizzers#show", name: "namespaced_whizzer"})
		

		inspector = ActionDispatch::Routing::RoutesInspector.new(Rails.application.routes.routes)
		actual_results = inspector.format(ValidRoute::RouteFormatter.new)

		actual_results.delete_if { |route|
			 route[:verb] != "GET"

		}

		unexpected_routes = actual_results - expected_results
		expected_routes_missing = expected_results - actual_results

		
		assert unexpected_routes.empty?, "\n" + "unexpected_routes:" + "\n" + "#{unexpected_routes}"
		assert expected_routes_missing.empty?, "\n" + "expected_routes_missing:" + "\n" + "#{expected_routes_missing}"
		

	end

end
