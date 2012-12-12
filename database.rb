DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://localhost/itpchange")

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
    property :numscans, Integer,  :default => 0.00
    property :tagid, Integer,  :default => 0.00		# tag ID used by Arduino
    property :name, String,  :default => "none"	    # human readable name of item
    property :price, Float,  :default => 0.00		# price of item
    property :giving, Boolean,	:default => FALSE	# TRUE == item for charity, FALSE == item for self
    property :img, Text, :default => "none"	# Image address
    
end

class TagScan
    include DataMapper::Resource
    
    property :id, Serial
    property :created_at, DateTime
    property :created_on, Date
    property :tagid, Integer
    
end
DataMapper.finalize
#DataMapper.auto_upgrade!




