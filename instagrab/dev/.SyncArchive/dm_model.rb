#!/usr/bin/ruby

require 'rubygems'
require 'data_mapper'
require 'dm-migrations'

DataMapper.setup(:default, 'postgres://insta:qdvvhZ37a@192.168.0.52:5432/instadb')
DataMapper::Model.raise_on_save_failure = true 

class Pic
	include DataMapper::Resource
	
	property :id,			        Serial
	property :created_at,	    DateTime
	
	property :insta_id,		    String
	property :liked,		      Boolean
	property :link,			      String
	property :insta_created,  DateTime
	property :skip,		Boolean, :default => false
	
	belongs_to :user
	belongs_to :location,   :required => false
	
	has n, :likes
#	has n, :comments
	has n, :tags, :through => Resource
end

class User
  include DataMapper::Resource
  
  property :id,       Serial
  property :insta_id, Numeric
  property :fullname,  String
  property :username, String
  property :website,  String, :length=>200
  property :follower, Boolean, :default=>false
  
  has n,  :pics
#  has n,  :comments
  has n,  :likes
end

class Tag
  include DataMapper::Resource
  
  property  :id,    Serial
  property  :name,  String
  
  has n, :pics, :through => Resource
end

#class Comment
#  include DataMapper::Resource
#  
#  property  :id,        Serial
#  property  :insta_id,  Numeric
#  property  :text,      Text
#  
#  belongs_to  :user
#end

class Location
  include DataMapper::Resource
  
  property  :id,    Serial
  property  :insta_id, Numeric
  property  :name,  String, :length => 200
  property  :lat,   Float
  property  :lon,   Float
  
  has n, :pics
  has n, :users, :through => :pics
end  

class Like
  include DataMapper::Resource
  
  property  :id,    Serial
  
  belongs_to :pic
  belongs_to :user
end

DataMapper.finalize
DataMapper.auto_upgrade!
