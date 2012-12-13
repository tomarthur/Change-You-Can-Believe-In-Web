require 'rubygems'
require 'bundler'
Bundler.require
require './database.rb'
require 'sinatra/support/numeric'

set :root, File.dirname(__FILE__)

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

	@tags = Tag.all
	@total = Money.last.total
	@total * 100
	@scans = TagScan.all

  erb :trinkets
end

get '/lastcollection' do

  @lasttotal = Money.last

  @lastpennymoney = @lasttotal.penny * 0.01
  @lastnickelmoney = @lasttotal.nickel * 0.05
  @lastdimemoney = @lasttotal.dime * 0.10
  @lastquartermoney = @lasttotal.quarter * 0.25
  
  @lastt = @lastpennymoney +  @lastnickelmoney +   @lastdimemoney +   @lastquartermoney


  @savings = Money.all

  erb :coinscounted
end

get '/newtag' do

  erb :newtag
end

get '/tagdelete' do

  @tags = Tag.all

  erb :deletetag
end

post '/deletegonetag' do

	tag = Tag.all(:name => params[:tagdel])
	tag.destroy
  "Tag was deleted"
end
 
get '/saveingdelete' do

  @money = Money.all

  erb :deletemoney
end

post '/deletegonesave' do

	money = Money.all(:created_at => params[:date])
	money.destroy
  "Savings entry was deleted"
end
 
  
post '/reset116232' do

# Money.destroy
# TagScan.destroy
# Tag.destroy

"if active, will delete all records"
end


post '/maketag' do #for adding new RFID tags to the database

	@t = Tag.new
	@t.tagid = params[:tagid].to_s
	@t.name = params[:name]
	@t.price = params[:price]
	@t.giving = params[:purpose]
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
  @s.tagid = params[:tagid].to_s
  @s.save

  "Tag Captured"
end
end