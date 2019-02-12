require 'rubygems'
require 'sinatra'
require 'pony'
require 'sinatra/reloader'
require 'sqlite3'

=begin
configure do
  db = SQLite3::Database.new 'base.db'
  db.execute 'CREATE TABLE IF NOT EXISTS
  "Users"
  (
  	"id" Integer NOT NULL PRIMARY KEY AUTOINCREMENT,
  	"username" Text,
  	"userphone" Text,
  	"date_stamp" Text,
  	"worker" Text
    )'
    db.close
end
=end

get '/' do
  erb :index
end

get '/about' do
  erb :about
end

get '/job' do
  erb :job
end

get '/visit' do
  erb :visit
end

get '/admin' do
  erb :admin
end

get '/showusers' do
  erb "showusers"
end

post '/index' do
  @user = params[:user_name]
  @pass = params[:user_pass]
  if @user == 'admin' && @pass == '123'
    erb :admin
  else
    erb :index
  end
end

post '/visit' do
  @user_name = params[:user_name]
  @user_phone = params[:user_phone]
  @user_date = params[:user_date]
  @worker = params[:worker]

  hh = {
    :user_name => 'Введите имя пользователя',
    :user_phone => 'Введите номер телефона',
    :user_date => 'Неверно введена дата'
  }

  @error = hh.select {|key,value| params[key] == ''}.values.join(", ")

  if @error != ''
    return erb :visit
  end
=begin
  f = File.open "./public/clients.txt", "a"
  f.write "Клиент #{@user_name} записался на #{@user_date} к специалисту #{@worker}. Контактный телефон: #{@user_phone}\n"
  f.close
=end
#Save in to database ----------------------------------------

  db = get_db
  db.execute 'INSERT INTO Users
    (
      username,
      userphone,
      date_stamp,
      worker
      )
      VALUES (?,?,?,?)', [@user_name, @user_phone, @user_date, @worker];

#-------------------------------------------------------------
  @message = "#{@user_name}, Вы записаны на #{@user_date}"
=begin
  Pony.options = {
        :subject => "ivan@wannagift.ru",
        :body => "Тело сообщения",
        :via => :smtp,
        :via_options => {
          :address              => 'smtp.timeweb.ru',
          :port                 =>  '2525',
          :enable_starttls_auto => true,
          :user_name            => "ivan@wannagift.ru",
          :password             => "tassadar1987",
          :authentication       => :plain,
          :domain               => 'smtp.timeweb.ru'
          }
        }

        Pony.mail(:to => 'filin87@gmail.com', :from => 'ivan@wannagift.ru', :subject => "Запись в Барбершоп", :body => "#{@message}")
=end
  erb :visit

end

post '/job' do
  @job_email = params[:job_email]
  @job_text = params[:job_text]

  j = File.open "./public/job_list.txt", "a"
  j.write "Кандидат #{@job_email} желает работать. Имеет навыки #{@job_text}.\n"
  j.close
  erb :job
end

def get_db
  return SQLite3::Database.new 'base.db'
end
