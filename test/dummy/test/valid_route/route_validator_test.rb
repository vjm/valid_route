require 'test_helper'

class RouteValidatorTest < ActionController::TestCase

	test "existing routes should not be allowed to conflict" do

		FactoryGirl.create(:page, permalink: "home")
		assert Page.exists?("home")
		FactoryGirl.create(:page, permalink: "contact")
		assert Page.exists?("contact")

		FactoryGirl.create(:user, username: "vjm")
		assert User.exists?("vjm")

		assert_routing '/contact_us', { :controller => "pages", :action => "show", :id => "contact" }
		assert_routing '/pages/home/edit', { :controller => "pages", :action => "edit", :id => "home" }
		assert_routing '/pages/new', { :controller => "pages", :action => "new" }
		assert_routing '/pages', { :controller => "pages", :action => "index" }
		assert_routing "/", { :controller => "pages", :action => "show", :id => "home" }
		
		# assert_recognizes({:controller => 'pages', :action => 'show', :id => 'random_page'}, '/random_page')

		assert_routing '/users/vjm', { :controller => "users", :action => "show", :id => "vjm" }
		assert_routing '/users/vjm/edit', { :controller => "users", :action => "edit", :id => "vjm" }
		assert_routing '/users/new', { :controller => "users", :action => "new" }
		assert_routing '/users', { :controller => "users", :action => "index" }

		assert_recognizes({:controller => 'users', :action => 'index'}, '/all_users')
		# assert_recognizes page_permalink_path, '/'
		# assert_routing '/all_users', { :controller => "users", :action => "index" }

		# assert_recognizes {:controller => 'users', :action => 'show', :id => 'vjm'}, '/vjm'

		assert_routing '/namespaced/whizzers', { :controller => "namespaced/whizzers", :action => "index" }
		assert_routing '/namespaced/whizzers/new', { :controller => "namespaced/whizzers", :action => "new" }
		assert_routing '/namespaced/whizzers/one', { :controller => "namespaced/whizzers", :action => "show", :id => "one" }
		assert_routing '/namespaced/whizzers/one/edit', { :controller => "namespaced/whizzers", :action => "edit", :id => "one" }

		users_page = FactoryGirl.build(:page, permalink: "users")
		assert !users_page.valid?
		assert users_page.errors.full_messages.include?("Permalink route is taken"), users_page.errors.full_messages.inspect

		pages_page = FactoryGirl.build(:page, permalink: "pages")
		assert !pages_page.valid?, pages_page.errors.inspect
		assert pages_page.errors.full_messages.include?("Permalink route is taken"), pages_page.errors.full_messages.inspect

		vjm_page = FactoryGirl.build(:page, permalink: "vjm")
		assert !vjm_page.valid?, vjm_page.errors.inspect
		assert vjm_page.errors.full_messages.include?("Permalink route is taken"), vjm_page.errors.full_messages.inspect
		

		home_user = FactoryGirl.build(:user, username: "home")
		assert !home_user.valid?, home_user.errors.inspect
		assert home_user.errors.full_messages.include?("Username route is taken"), home_user.errors.full_messages.inspect

		contact_user = FactoryGirl.build(:user, username: "contact")
		assert !contact_user.valid?, contact_user.errors.inspect
		assert contact_user.errors.full_messages.include?("Username route is taken"), contact_user.errors.full_messages.inspect

		pages_user = FactoryGirl.build(:user, username: "pages")
		assert !pages_user.valid?, pages_user.errors.inspect
		assert pages_user.errors.full_messages.include?("Username route is taken"), pages_user.errors.full_messages.inspect

		pages_user = FactoryGirl.build(:user, username: "namespaced/whizzers")
		assert !pages_user.valid?, pages_user.errors.inspect
		assert pages_user.errors.full_messages.include?("Username route is taken"), pages_user.errors.full_messages.inspect

		pages_user = FactoryGirl.build(:user, username: "namespaced/whizzers/test")
		assert pages_user.valid?, pages_user.errors.inspect

		# TODO: add a test for namespaced routes



	end

	test "additional reserved routes option" do

		inspector = ActionDispatch::Routing::RoutesInspector.new(Rails.application.routes.routes)
		actual_results = inspector.format(ValidRoute::RouteFormatter.new)

		tommy_page = FactoryGirl.build(:page, permalink: "tommy")
		assert !tommy_page.valid?, actual_results
		assert tommy_page.errors.full_messages.include?("Permalink route is taken"), tommy_page.errors.full_messages.inspect

		reserved_page = FactoryGirl.build(:page, permalink: "reserved")
		assert !reserved_page.valid?, reserved_page.errors.inspect
		assert reserved_page.errors.full_messages.include?("Permalink route is taken"), reserved_page.errors.full_messages.inspect

		about_user = FactoryGirl.build(:user, username: "about")
		assert !about_user.valid?, about_user.errors.inspect
		assert about_user.errors.full_messages.include?("Username route is taken"), about_user.errors.full_messages.inspect

		admin_user = FactoryGirl.build(:user, username: "admin")
		assert !admin_user.valid?, admin_user.errors.inspect
		assert admin_user.errors.full_messages.include?("Username route is taken"), admin_user.errors.full_messages.inspect


	end

	test "unreserved routes option" do

		pages_user = FactoryGirl.build(:user, username: "pages")
		assert !pages_user.valid?, pages_user.errors.inspect
		assert pages_user.errors.full_messages.include?("Username route is taken"), pages_user.errors.full_messages.inspect

		pages_other = FactoryGirl.build(:other, permalink: "pages")
		assert pages_other.valid?
		# assert pages_other.errors.full_messages.include?("Permalink route is taken"), pages_other.errors.full_messages.inspect

		


	end
	
end
