require 'sinatra'
require 'dm-core'

DataMapper::setup(:default, {:adapter => 'yaml', :path => 'db'}) #talk to database yaml (type, could be mysql, to the db folder

class Money
  include DataMapper::Resource

  property :id,   Serial
  property :time, Integer
  property :lasttotal, Float # old total
  property :penny, Integer   # number of pennys
  property :nickel, Integer  # number of nickels
  property :dime, Integer	 # number of dimes	
  property :quarter, Integer  # number of quarters
  property :total, Float	 # new total
  
end

class Tag
  include DataMapper::Resource
  
  property :id, Serial
  property :tagid, Integer		# tag ID used by Arduino
  property :name, String	    # human readable name of item
  property :price, Float		# price of item
  property :giving, Boolean		# TRUE == item for charity, FALSE == item for self
  property :lastscan, Integer   # Time of last scan by Arduino
  property :numscans, Integer
  property :img, String			# Image address
  property :onarduino, Boolean  # FALSE == tag made on web not updated to arduino
  
end

DataMapper.finalize

# Main route
get '/' do
  erb :home, :layout => false
end

get '/totals' do

  "Connection Success"
end

get '/lastcollec' do

  "here's the last collection"
end

get '/analyze' do

  "here are statistics about your collection"
end

get '/alltags' do

	"hello"
end

get '/newtag' do

  "make a new tag here"
end

post '/maketag' do

  "Make a tag success"
end

###############################################################
# Arduino routes (not for people)

# or you could do it as a get request with the params in the url

# http://itp.nyu.edu/~netid/sinatra/yourapp?name=Rune  => params[:name]
# http://itp.nyu.edu/~tca241/sinatra/change/updatetotal?time=1234&lasttotal=10.00&penny=3&nickel=5&dime=6&quarter=58&total=39.40


get '/updatetotal' do 		# total sent from arduino after a new collection
  # params[:yourname] will be replaced with the value entered for 
  # the input with name 'yourname'  


  @m = Money.new
  @m.time = params[:time]
  @m.lasttotal = params[:lasttotal]
  @m.penny = params[:penny]
  @m.nickel = params[:nickel]
  @m.dime = params[:dime]
  @m.quarter = params[:quarter]
  @m.total = @totaltemp
  @m.save
# raise Exception, @m.save
    "hurray"
end

post '/tagscan' do			# tag scan data sent from arduino

	"Tag Success"
end


	
###############################################################
# Arduino future use

get '/newtags' do # send new tags to arduino
	
	"new tags sent"
end