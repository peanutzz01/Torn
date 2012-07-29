require 'rubygems'
require 'mechanize'
require_relative 'User'

money = 10000000
afford = 60000
cost1 = Array.new[0]
#Create new instance and login
user = User.new('lazzo', 'pppppp')
login = user.login

#If not enough money stop checking
while money >= 100000

	#Navigate to the city
	p = user.nav_to_text('City', login)
	
	#Check how much money do we have left
	money = p.parser.xpath("//span[@class='pos']").to_s
	money = money.scan(/\d/).join("").to_i
	pp money
	
	#Navigate to the points market
	p = user.nav_to_text('Points Market', p)
	
	#Check the first (cheapest) points entry
	tr = p.parser.xpath("//table[@class='data']//tr")
	td_prof = p.parser.xpath("//table[@class='data']//td[@align='center']//div/a")
	pp td_profile = td_prof[0].attr('href')
	td_price_per_point = p.parser.xpath("//table[@class='data']//tr//td[@align='center']")[2].to_s
	td_total_price = p.parser.xpath("//table[@class='data']//tr//td[@align='center']")[3].to_s

#	tr.each do |row|
#		pp td_profile = row.to_s.scan(/\/profiles.php\?XID=\d*/)
#		cost = row.to_s.scan(/\$\d.*</)
#		cost.each do |m|
#		cost = m.gsub("<","").gsub("$", "").gsub(",","").to_i
#		cost1 << cost
#		end
#		pp cost
#		end
	
	
	#Get the price per point and total price
	price_per_point = td_price_per_point.scan(/\d/).join("").to_i
	total_price = td_total_price.scan(/\d/).join("").to_i
	points = total_price/price_per_point
	puts "Number of Points: #{points} \nPrice per point: #{price_per_point} \nTotal price: #{total_price}"
	#if we have the money and points are cheap buy them
	if total_price <= money and price_per_point <= afford
		puts "We have enough money and points are cheap enough"
		buy_link = p.parser.xpath("//table[@class='data']//tr[@class='bgAlt1']//td[@align='center']/a")
		buy_link = buy_link[0].attr('href').to_s
		p = user.nav_to_href_text(buy_link, 'Buy', p)
		p = user.nav_to_text('Yes', p)
		puts "We just bought #{points} through #{buy_link}"
		# Create a new file and write to it  
		File.open('bought.txt', 'r+') do |f2|  
		  # use "\n" for two lines of text  
f2. >> "
#############
Bought: #{points} points
From: #{td_profile}
Price per point: #{price_per_point}
Total price: #{total_price}"  
		end  
	else 
		if price_per_point > afford
			puts "Points cost too much"
		else 
			puts "Not enough money!"
		end
	end
	
	#Wait a random ammount of time
	s = rand(5..10)
	puts "Sleeping for: #{s} \n"
	sleep s
end
#  p.links.each do |link|
#    text = link.text.strip
#    next unless text.length > 0
#    puts text
#  end
