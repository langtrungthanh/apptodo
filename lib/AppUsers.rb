require "./lib/Auth.rb"
require "Tabulo"
require "sequel"
require 'pry'
DB = Sequel.sqlite("datatodo.sqlite")

class AppUsers

	def self.userid(username) 
		user = DB[:users].where(username: username) # tìm user
		userid = DB[:users].first[:id] # tìm user id
	  	return userid
	end

end

class AppList

	def self.listwork(username) 
		user = DB[:users].where(username: username) # tìm user
		userid = DB[:users].first[:id] # tìm user id
		work = DB[:lists].where(user_id: userid) # tìm work có cùng user id
	  	return work
	end

	def self.listid(work) 
		list = DB[:lists].where(work: work) # tìm user
		listid = DB[:lists].first[:id] # tìm user id
	  	return listid
	end

	def self.add_listwork(newwork, userid) 
		DB[:lists].insert(work: newwork, user_id: userid)
	end

	def self.delete_listwork(list_id)
	    DB[:todo].where(list_id: list_id).delete
	    DB[:lists].where(id: list_id).delete 
	end

	def self.thework(list_id)
	   DB[:lists].where(id: list_id).first[:work]
	end

end


class AppTodo

	def self.listtodo(work, list_id) 
		todo = DB[:todo].where(list_id: list_id) # tìm todo có cùng list id
	  	return todo
	end

	def self.add_todo(newtodo, list_id) 
		DB[:todo].insert(todo: newtodo, list_id: list_id, status: '0')
	end

  	def self.delete_todo(todo_id)
    	DB[:todo].where(id: todo_id).delete
	end

	def self.status_todo(todo_id)
	    DB[:todo].where(id: todo_id).first[:status]
	end
	
	def self.status_todo_1(todo_id)
	   DB[:todo].where(id: todo_id)
	            .update(status:'1')
	end

    def self.status_todo_0(todo_id)
	   DB[:todo].where(id: todo_id)
	            .update(status:'0')
	end

end
