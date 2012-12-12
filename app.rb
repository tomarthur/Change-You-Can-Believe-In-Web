require 'sinatra/base'
require 'data_mapper'
require 'dm-timestamps'
require 'sinatra/support/numeric'

DataMapper::setup(:default, {:adapter => 'yaml', :path => 'db'})
#talk to database yaml (type, could be mysql, to the db folder

class Money
  include DataMapper::Resource

  property :id,   Serial		  # each record is equal to one coin collection event
  property :created_at, DateTime
  property :created_on, Date 
  property :lasttotal, Float, :default => 0.00
  property :penny, Integer, :default => 0  		  # number of pennys
  property :nickel, Integer, :default => 0 	  # number of nickels
  property :dime, Integer, :default => 0 	  # number of dimes	
  property :quarter, Integer, :default => 0 	  # number of quarters
  property :total, Float, :default => 0.00 	  # new total

end

class Tag
  include DataMapper::Resource
  
  property :id, Serial	
  property :created_at, DateTime
  property :created_on, Date
  property :updated_at, DateTime
  property :updated_on, Date
  property :numscans, Integer
  property :tagid, Integer		# tag ID used by Arduino
  property :name, String	    # human readable name of item
  property :price, Float		# price of item
  property :giving, Boolean		# TRUE == item for charity, FALSE == item for self
  property :img, String			# Image address
 
end

class TagScan
  include DataMapper::Resource
  
  property :id, Serial
  property :created_at, DateTime
  property :created_on, Date
  property :tagid, Integer
  
end
  
DataMapper.finalize


class ChangeITP < Sinatra::Base
register Sinatra::Numeric
# Homepage
get '/' do
  erb :home, :layout => false
end

get '/about' do

  erb :about
end

get '/savings' do
  @savings = Money.all

  @totalpenny = 0
  @totalnickel = 0
  @totaldime = 0
  @totalquarter = 0
  
  for thissavings in @savings
  	@totalpenny += thissavings.penny
  	@totalnickel += thissavings.nickel
  	@totaldime += thissavings.dime
  	@totalquarter += thissavings.quarter
  end

  @pennymoney = @totalpenny * 0.01
  @nickelmoney = @totalnickel * 0.05
  @dimemoney = @totaldime * 0.10
  @quartermoney = @totalquarter * 0.25
  
  @lasttotal = Money.last


  @lastpennymoney = @lasttotal.penny * 0.01
  @lastnickelmoney = @lasttotal.nickel * 0.05
  @lastdimemoney = @lasttotal.dime * 0.10
  @lastquartermoney = @lasttotal.quarter * 0.25

  erb :savings
end

get '/trinkets' do

  erb :trinkets
end

get '/lastcollection' do

  erb :lastcollection
end

get '/newtag' do

  erb :newtag
end

post '/maketag' do #for adding new RFID tags to the database

	@t = Tag.new
	@t.tagid = params[:tagid]
	@t.name = params[:name]
	@t.price = params[:price]
	@t.giving = params[:giving]
	@t.img = params[:imgurl]
	@t.save

    if (@t.save == true)
	    erb :success
    else
	    erb :fail
    end
end

get '/success' do
	
	"tag was made successfully"
end

###############################################################
# Arduino routes (not for people)

# or you could do it as a get request with the params in the url

# http://itp.nyu.edu/~netid/sinatra/yourapp?name=Rune  => params[:name]
# http://itp.nyu.edu/~tca241/sinatra/change/updatetotal?time=1234&lasttotal=10.00&penny=3&nickel=5&dime=6&quarter=58&total=39.40
# http://changeitp.herokuapp.com/updatetotal?



get '/updatetotal' do 		# total sent from arduino after a new collection
  @m = Money.new
  @m.lasttotal = params[:lasttotal]
  @m.penny = params[:penny]
  @m.nickel = params[:nickel]
  @m.dime = params[:dime]
  @m.quarter = params[:quarter]
  @m.total = params[:total]
  @m.save
# raise Exception, @m.save
   "Update Captured"
end

get '/tagscan' do			# tag scan data sent from arduino


  @s = TagScan.new
  @s.tagid = params[:tagid]
  @s.save

  "Tag Captured"
end

end
