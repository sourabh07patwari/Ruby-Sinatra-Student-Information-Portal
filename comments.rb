require 'dm-core'
require 'dm-migrations'
require 'sass'
require 'dm-timestamps'
require './main'

DataMapper.setup(:default, ENV['DATABASE_URL']|| "sqlite3://#{Dir.pwd}/scuwebapp.db")

class Comment 
	include DataMapper::Resource
	property :id, Serial
	property :name, String
	property :comment_txt, String
	property :created_at, DateTime	
end

DataMapper.finalize
DataMapper.auto_upgrade!

get '/comments' do
  @title = "Student Information System - Comments"
  @comments = Comment.all
  erb :comments_home
end

get '/comments/new' do
  @title = "Student Information System - Comments"
  halt(401, 'Not Authorized, Please go back and login') unless session[:admin]
  @comment = Comment.new
  erb :new_comments
end

get '/comments/:id' do
  @title = "Student Information System - Comments"
  halt(401, 'Not Authorized, Please go back and login') unless session[:admin]
  @comment = Comment.get(params[:id])
  erb :show_comments
end

post '/comments' do  
  # @student = Student.create(params[:student])
  if (params[:name].empty? || params[:comment_txt].empty?) 
    halt(401, 'Incomplete Fields, Please go back and fill all the fields')
  end
  @comment = Comment.new
  @comment.id = params[:id]
  @comment.name = params[:name]
  @comment.comment_txt = params[:comment_txt]
  @comment.created_at = params[:created_at]
  @comment.save
  redirect to("/comments")
end

delete '/comments/:id' do
  Comment.get(params[:id]).destroy
  redirect to('/comments')
end

