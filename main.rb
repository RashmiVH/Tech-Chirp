require 'rubygems'
require 'mongo'
require 'sinatra'
require 'haml'


#configure :production do
#    require 'newrelic_rpm'
#end

$description = 'Website description' 
$keywords = 'Keywords'

get '/?' do
	@title = 'Welcome to Tech-Chirp'
	@description = 'Welcome to the Website babes'
	@keywords = 'More Keywords'
	haml :home
end

get '/post/?' do
  @title = 'Post'
  haml :post
end

post '/post/?' do
@title_name = params["title_name"]
@description = params["description"]
@categories = Array.new(4)
@categories[0] = params["Java"]
@categories[1] = params["Python"]
@categories[2] = params["Asp"]
@categories[3] = params["Ruby"]



for i in 0..3

if @categories[i] then
@cat = @categories[i]
break
end

end

puts @cat

db = Mongo::Connection.new.db("mydb")
#db = Mongo::Connection.new("localhost").db("mydb")
#db = Mongo::Connection.new("127.0.0.1", 27017).db("mydb")
coll = db.collection("mydb")
#coll = db["testCollection"]
doc = {"title" => @title_name, "description" => @description , "categories" => @cat}
coll.insert(doc)
 coll.find().each { |row| puts row.inspect }
#puts @title_name

 # @post_form = PostForm.new(params[:post_form])
 # if @post_form.valid?
 #   @post_form.clear
    haml :thanks
#  else
#    haml :post
#  end
end


