require 'sinatra'
#require 'pry'
require './lib/Auth.rb'
require './lib/AppUsers.rb'
require 'sequel'

enable :sessions
DB = Sequel.sqlite("datatodo.sqlite")

# LOGIN

get '/' do
  erb :web  
end

post '/' do
  puts "#{params.inspect}"
  @username = params["user"]
  @password = params["pw"]
  @auth = Auth.login(@username, @password)
  @whyfailed =  @auth[:message] 

  if @auth[:status] == 'success'
    session[:username] = @username
    @work = AppList.listwork(@username)
    erb :listwork
  else
    erb :login_failed
  end
end

# APP 

get '/list' do
    erb :listwork
end

post '/list' do
    session[:username] = @username
    @work = AppList.listwork(@username)
    @userid = AppUsers.userid(@username)
    @newwork = params["new_work"] 
    AppList.add_listwork(@newwork, @userid)
    erb :listwork
end
 
get '/delete_list/:listid' do
    puts "#{params.inspect}"
    session[:username] = @username
    @work = AppList.listwork(@username)
    AppList.delete_listwork(params[:listid])
    erb :listwork
end

get '/list/:listid' do
    puts "#{params.inspect}"
    session[:work] = @work
    @todo = AppTodo.listtodo(@work, params[:listid])
    @listid = AppList.listid(@work)
    @thework = AppList.thework(params[:listid])
    erb :todo
end

post '/list/:listid' do
    session[:work] = @work
    @todo = AppTodo.listtodo(@work, params[:listid])
    @newtodo = params["new_todo"] 
    @thework = AppList.thework(params[:listid])
    AppTodo.add_todo(@newtodo, params[:listid]) 
    erb :todo
end

get '/delete_todo/:todoid' do
    puts "#{params.inspect}"
    session[:work] = @work
    AppTodo.delete_todo(params[:todoid])
    @listid = AppList.listid(@work)
    redirect "/list/#{@listid}"
end

get '/did_todo/:todoid' do
    puts "#{params.inspect}"
    session[:work] = @work
    @listid = AppList.listid(@work)
    @status = AppTodo.status_todo(params[:todoid])
    AppTodo.status_todo_1(params[:todoid])
    redirect "/list/#{@listid}"
end

get '/didnot_todo/:todoid' do
    puts "#{params.inspect}"
    session[:work] = @work
    @listid = AppList.listid(@work)
    @status = AppTodo.status_todo(params[:todoid])
    AppTodo.status_todo_0(params[:todoid])
    redirect "/list/#{@listid}"
end

# CHANGE PASSWORD

get '/changepw' do
  erb :changepw
end

post '/changepw' do
  puts "#{params.inspect}"
  @username = session[:username]
  @password = params["oldpw"]
  @newpw = params["newpw"]
  oldmk = Auth.login(@username, @password)

  if oldmk[:status] == "success" && @password != @newpw
    @auth = Auth.changepw(@username, @password, @newpw)

    if @auth[:status] == 'success'
      erb :changepw_success
    end
  else
    erb :changepw_failed
  end
end

# SIGNUP

get '/signup' do
  erb :signup
end

post '/signup' do
  puts "#{params.inspect}"
  @username = params["user"]
  @password = params["pw"]
  @auth = Auth.signup(@username, @password)

  if @auth[:status] == 'success'
    erb :signup_success
  else
    erb :signup_failed
  end
end

