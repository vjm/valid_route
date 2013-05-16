unless Page.exists?('home')
	Page.create(
		{:name => 'Home', :permalink => 'home', :content => 'Home Page'},
	)
end

unless Page.exists?('contact')
	Page.create(
		{:name => 'Contact', :permalink => 'contact', :content => 'Contact Page'}
	)
end

unless User.exists?('admin')
	User.create(
		{:username => 'admin', :first_name => 'Admin', :password => 'password'}
	)
end