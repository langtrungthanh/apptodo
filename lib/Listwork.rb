require "./lib/Auth.rb"
require "Tabulo"
require "sequel"
require 'pry'
DB = Sequel.sqlite("datatodo.sqlite")

class Auth2

	def self.listwork(username) 
		user = DB[:users].where(username: username) # tìm user
		userid = DB[:users].first[:id] # tìm user id
		work = DB[:lists].where(user_id: userid) # tìm work có cùng user id
	  	return work
	end

	def self.userid(username) 
		user = DB[:users].where(username: username) # tìm user
		userid = DB[:users].first[:id] # tìm user id
	  	return userid
	end

end

class Auth3

	def self.listtodo(work, list_id) 
		todo = DB[:todo].where(list_id: list_id) # tìm todo có cùng list id
	  	return todo
	end

	def self.listid(work) 
		list = DB[:lists].where(work: work) # tìm user
		listid = DB[:lists].first[:id] # tìm user id
	  	return listid
	end

end




