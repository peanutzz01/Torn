class User


	def initialize(user, pass)
	@user = user
	@pass = pass
	@site = "http://torn.com"
	@form = "login"
	end

	def login
		a = Mechanize.new { |agent|
			agent.user_agent_alias = 'Windows Mozilla'
		}
		p = a.get(@site)
		# Submit the login form
		page = p.form_with(:name => @form) do |f|
			f.player=@user
			f.password=@pass
		end.submit
		page
	end
	
	def nav_to_text(nav_to, p)
		p.links_with(:text => nav_to)[0].click
	end
	
	def nav_to_href_text(nav_to_href, nav_to_text, p)
		p.links_with(:href => nav_to_href, :text => nav_to_text)[0].click
	end

	def nav_to_href(nav_to, p)
		p.links_with(:href => nav_to).click
	end
	
end