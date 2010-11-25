require 'rubygems'
require 'mongo'
require 'sinatra'
require 'haml'

#configure :production do
#    require 'newrelic_rpm'
#end
enable :sessions
$description = 'Website description' 
$keywords = 'Keywords'

get '/?' do
	@title = 'Welcome to JobTech Tweet'
	@description = 'Welcome to the Website babes'
	@keywords = 'More Keywords'
	haml :login
end

post '/' do
	@username = params["user"]
	@password = params["pass"]
	db = Mongo::Connection.new.db("mydb")
	coll = db.collection("User")
	my_doc = coll.find_one("username"=>@username, "password"=>@password)
	
	if my_doc then
		
		@user=my_doc.values_at("username")
		@pass=my_doc.values_at("password")
		@id = my_doc.values_at("_id")
		session[:message] = @id
		redirect '/home'

	else
		haml :login
	end
	
end

get '/home/?' do
	@user_id = session[:message]
	haml :home
end


get '/post/?' do
  @title = 'Post'
  haml :post
end

get '/register/?' do
  @title = 'Post'
  haml :register
end

post '/register/?' do
@fullname = params["fullname"]
@email = params["email"]
@username = params["user"]
@password = params["pass"]
db = Mongo::Connection.new.db("mydb")
coll = db.collection("User")
doc = {"fullname" => @fullname, "email" => @email , "username" => @username , "password" => @password}
coll.insert(doc)
#puts @email
haml :home
end

post '/post/?' do

@user_id = session[:message]
puts "session in post #{@user_id}"
@title_name = params["title_name"]
@description = params["description"]
@categories = Array.new(4)
@categories[0] = params["Java"]
@categories[1] = params["Python"]
@categories[2] = params["Asp"]
@categories[3] = params["Ruby"]
 j=0
@cat=Array.new()
for i in 0..3
if @categories[i] then
@cat[j] = @categories[i]
j=j+1
end

end

db = Mongo::Connection.new.db("mydb")
coll = db.collection("post")
doc = {"userid"=>@user_id,"title" => @title_name, "description" => @description , "categories" => @cat}
coll.insert(doc)
haml :thanks
end


__END__

@@ home
-db = Mongo::Connection.new.db("mydb")
-coll = db.collection("post")
%ul
  %li
    %a{ :href => "/post" } Post	
-coll.find().each  do |cursor| 
  %div 
    %h3 Title: #{cursor.values_at("title")}
  %div Post: #{cursor.values_at("description")}
   



