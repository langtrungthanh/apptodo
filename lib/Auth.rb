require "sequel"
require 'bcrypt'
DB = Sequel.sqlite("datatodo.sqlite")

#DB = Sequel.connect(adapter: 'mysql2', host: 'localhost', port: 3306, database: 'blog', user: 'user', password: ENV['NF_APP_DB_PASSWORD'])
#DB = Sequel.connect(adapter: 'mysql2', host: ENV['NF_APP_DB_HOST'], port: ENV['NF_APP_DB_PORT'], database: ENV['NF_APP_DB_DATABASE'], user: ENV['NF_APP_DB_USERNAME'], password: ENV['NF_APP_DB_PASSWORD'])
#require './web.rb'

class Auth


def self.login(username, password) 
    users = DB[:users].where(username: username)
    
    if users.count == 0 
      return {
        status: "error",
        message: "User does not exist"
      }
    end
    
    pwhash = users.first[:password]
    pw = BCrypt::Password.new(pwhash)
    
    if users.count == 1 && pw == password
      return {
        status: "success"
      }
    end
    
    if users.count == 1 && pw != password
      return {
        status: 'error',
        message: 'Password incorrect'
      }
    end 
end

#2
def self.signup(username, password)
    users = DB[:users].where(username: username)
    pwhash = BCrypt::Password.create(password)
    
    if users.count != 1 
     DB[:users].insert(username: username, password: pwhash)
     return {
        status: "success"
      }
    else 
      return {
        status: "error"
      }
    end
end

#3
def self.changepw(username, password, newpw)

    new_pwhash = BCrypt::Password.create(newpw)
    
    if newpw != password
    users = DB[:users].where(username: username)
    users.update(password: new_pwhash) 
     return {
        status: "success"
      }
    else 
      return {
        status: "error"
      }
    end   
end



end