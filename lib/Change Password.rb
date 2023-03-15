require "./lib/Auth.rb"

print "Enter your username: "
username = gets.chomp

print "Enter your password: "
password = gets.chomp

auth = Auth.login(username, password)


if auth[:status] == 'success'
print "Login successful! Enter new password: "
newpw = gets.chomp
auth2 = Auth.changepw(username, password, newpw)

puts "Change password successful!" if auth2[:status] == 'success'
puts "Change password unsuccessful" if auth2[:status] != 'success'

else
puts "Login unsuccessful"
end