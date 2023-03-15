require "./lib/Auth.rb"

print "Enter your username: "
username = gets.chomp

print "Enter your password: "
password = gets.chomp

print "Enter your email: "
email = gets.chomp

auth = Auth.signup(username, password, email)

puts "Sign-up successful!" if auth[:status] == 'success'
puts "Sign-up unsuccessful: Already have this user" if auth[:status] != 'success'