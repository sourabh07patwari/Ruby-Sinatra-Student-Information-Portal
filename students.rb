require 'dm-core'
require 'dm-migrations'
require 'sass'
require './main'

DataMapper.setup(:default, ENV['DATABASE_URL']|| "sqlite3://#{Dir.pwd}/scuwebapp.db")

class Student
  include DataMapper::Resource
  property :id, Serial
  property :firstname, String
  property :lastname, String
  property :address, String
  property :birthday, String
  property :scuid, String
end

DataMapper.finalize
DataMapper.auto_upgrade!

get '/students' do
  @title = "Student Information System - Students"
  @students = Student.all
  erb :students_home
end

get '/students/new' do
  @title = "Student Information System - Students"
  halt(401, 'Not Authorized, Please go back and login') unless session[:admin]
  @student = Student.new
  erb :new_students
end

get '/students/:id' do
  @title = "Student Information System - Students"
  halt(401, 'Not Authorized, Please go back and login') unless session[:admin]
  @student = Student.get(params[:id])
  erb :show_students
end

get '/students/:id/edit' do
  @title = "Student Information System - Students"
  halt(401, 'Not Authorized, Please go back and login') unless session[:admin]
  @student = Student.get(params[:id])
  erb :edit_students
end

post '/students' do  
  # @student = Student.create(params[:student])
  @student = Student.new
  @student.id = params[:id]
  @student.firstname = params[:firstname]
  @student.lastname = params[:lastname]
  @student.address = params[:address]
  @student.birthday = params[:birthday]
  @student.scuid = params[:scuid]
  if (@student.id == "" || @student.firstname == "" || @student.lastname == "" || @student.address == "" || @student.birthday == "" || @student.scuid == "") 
    halt(401, 'Incomplete Fields, Please go back and fill all the fields')
  end
  @student.save
  redirect to("/students")
end

put '/students/:id' do
  @student = Student.get(params[:id])
  @student.id = params[:id]
  @student.firstname = params[:firstname]
  @student.lastname = params[:lastname]
  @student.address = params[:address]
  @student.birthday = params[:birthday]
  @student.scuid = params[:scuid]
  if (@student.id == "" || @student.firstname == "" || @student.lastname == "" || @student.address == "" || @student.birthday == "" || @student.scuid == "") 
    halt(401, 'Incomplete Fields, Please go back and fill all the fields')
  end
  @student.save
  redirect to("/students/#{@student.id}")
end

delete '/students/:id' do
  Student.get(params[:id]).destroy
  redirect to('/students')
end

