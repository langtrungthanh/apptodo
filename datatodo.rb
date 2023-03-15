require 'sequel'

DB = Sequel.sqlite("datatodo.sqlite")

DB.create_table :users do
  primary_key :id
  String :username, unique: true, null: false
  String :password, unique: true, null: false
  String :email 
end

DB.create_table :lists do
  primary_key :id
  foreign_key :user_id, :users
  String :work
end

DB.create_table :todo do
  primary_key :id
  foreign_key :list_id, :lists
  String :todo
  Bool :abc
end
