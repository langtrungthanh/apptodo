require 'sinatra'
#require 'pry'
require './lib/Auth.rb'
require './lib/Listwork.rb'
require 'sequel'
require 'pry'

enable :sessions
DB = Sequel.sqlite("datatodo.sqlite")

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
    @work = Auth2.listwork(@username)
  
    erb :listwork
  else
    erb :loginnotok
  end
end

get '/list' do
    erb :listwork
end

post '/list' do

    session[:username] = @username
    @work = Auth2.listwork(@username)
    @userid = Auth2.userid(@username)
    @newwork = params["new_work"] 
    DB[:lists].insert(work: @newwork, user_id: @userid)

    erb :listwork
end
 
get '/delete_list/:listid' do
    puts "#{params.inspect}"
    session[:username] = @username
    @work = Auth2.listwork(@username)
    DB[:todo].where(list_id: params[:listid]).delete
    DB[:lists].where(id: params[:listid]).delete 
    erb :listwork
end

get '/list/:listid' do
    puts "#{params.inspect}"
    session[:work] = @work
    @todo = Auth3.listtodo(@work, params[:listid])
    @listid = Auth3.listid(@work)
    @thework = DB[:lists].where(id: params[:listid]).first[:work]
    erb :todo
end

post '/list/:listid' do
  # them todo trong database voi so list_id
    session[:work] = @work
    @todo = Auth3.listtodo(@work, params[:listid])
    @newtodo = params["new_todo"] 
    @thework = DB[:lists].where(id: params[:listid]).first[:work]
    DB[:todo].insert(todo: @newtodo, list_id: params[:listid], abc: '0')
    erb :todo
end

get '/delete_todo/:todoid' do
    puts "#{params.inspect}"
    session[:work] = @work
    @listid = DB[:todo].where(id: params[:todoid]).first[:list_id]
    DB[:todo].where(id: params[:todoid]).delete
    redirect "/list/#{@listid}"
end

get '/ok_todo/:todoid' do
    puts "#{params.inspect}"
    session[:work] = @work
    @listid = DB[:todo].where(id: params[:todoid]).first[:list_id]
    DB2 = DB[:todo].where(id: params[:todoid])
    @abc = DB[:todo].where(id: params[:todoid]).first[:abc]
    DB2.update(abc:'1')
    redirect "/list/#{@listid}"
end

get '/notok_todo/:todoid' do
    puts "#{params.inspect}"
    session[:work] = @work
    @listid = DB[:todo].where(id: params[:todoid]).first[:list_id]
    DB2 = DB[:todo].where(id: params[:todoid])
    @abc = DB[:todo].where(id: params[:todoid]).first[:abc]
    DB2.update(abc:'0')
    redirect "/list/#{@listid}"
end

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
      erb :changepwok
    end
  else
    erb :changepwnotok
  end
end


get '/signup' do
  erb :signup
end

post '/signup' do
  puts "#{params.inspect}"
  @username = params["user"]
  @password = params["pw"]
  @auth = Auth.signup(@username, @password)

  #puts "#{@auth}"

  if @auth[:status] == 'success'
    erb :signupok
  else
    erb :signupnotok
  end
end

