require 'test_helper'

class RouteFormatterTest < ActionController::TestCase

	test "routes returned as an array" do
		expected_results = []
		expected_results.push({path: '/pages', verb: 'GET', reqs: 'pages#index'})
		expected_results.push({path: '/pages/new', verb: 'GET', reqs: 'pages#new'})
		expected_results.push({path: '/pages/:id/edit', verb: 'GET', reqs: 'pages#edit'})
		expected_results.push({path: '/pages/:id', verb: 'GET', reqs: 'pages#show'})
		expected_results.push({path: '/:id', verb: 'GET', reqs: 'pages#show'})
		expected_results.push({path: '/', verb: 'GET', reqs: 'pages#show {:id=>"home"}'})
		expected_results.push({path: '/home', verb: 'GET', reqs: 'redirect(301, /)'})
		expected_results.push({path: '/contact_us', verb: 'GET', reqs: 'pages#show {:id=>"contact"}'})

		expected_results.push({:path=>"/users", :verb=>"GET", :reqs=>"users#index"})
		expected_results.push({:path=>"/users/new", :verb=>"GET", :reqs=>"users#new"})
		expected_results.push({:path=>"/users/:id/edit", :verb=>"GET", :reqs=>"users#edit"})
		expected_results.push({:path=>"/users/:id", :verb=>"GET", :reqs=>"users#show"})
		expected_results.push({:path=>"/:id", :verb=>"GET", :reqs=>"users#show"})
		expected_results.push({:path=>"/all_users", :verb=>"GET", :reqs=>"users#index"})

		expected_results.push({:path=>"/others", :verb=>"GET", :reqs=>"others#index"})
		expected_results.push({:path=>"/others/new", :verb=>"GET", :reqs=>"others#new"})
		expected_results.push({:path=>"/others/:id/edit", :verb=>"GET", :reqs=>"others#edit"})
		expected_results.push({:path=>"/others/:id", :verb=>"GET", :reqs=>"others#show"})
		expected_results.push({:path=>"/:id", :verb=>"GET", :reqs=>"others#show"})

		expected_results.push({:path=>"/namespaced/whizzers", :verb=>"GET", :reqs=>"namespaced/whizzers#index"})
		expected_results.push({:path=>"/namespaced/whizzers/new", :verb=>"GET", :reqs=>"namespaced/whizzers#new"})
		expected_results.push({:path=>"/namespaced/whizzers/:id/edit", :verb=>"GET", :reqs=>"namespaced/whizzers#edit"})
		expected_results.push({:path=>"/namespaced/whizzers/:id", :verb=>"GET", :reqs=>"namespaced/whizzers#show"})
		

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
