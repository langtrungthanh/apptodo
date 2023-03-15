
require "./lib/Auth.rb"
require "Tabulo"

print "Enter your username: "
username = gets.chomp

print "Enter your password: "
password = gets.chomp

auth = Auth.login(username, password)


puts "Login unsuccessful: #{auth[:message]}" if auth[:status] != 'success'


if auth[:status] == 'success'
puts "Login successful!" 
userid = DB[:users].first[:id]
	work = DB[:lists].where(user_id: userid)
puts work 
#	table = Tabulo::Table.new(work.all) do |t|
#  		t.add_column("Id") { |h| h.fetch(:id) }
#  		t.add_column("Work") { |h| h.fetch(:work) }	
#  	end
#  	puts table.pack

end