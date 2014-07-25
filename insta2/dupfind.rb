#!/usr/bin/ruby
# encoding: utf-8

require 'rubygems'
#require 'instagram'
#require 'open-uri'
require 'pg'
#require 'thread'
require '/home/dexy/instagrab/dm_model.rb'
#require_relative 'picparse.rb'
#require_relative 'inputdata.rb'

conn = PGconn.new('192.168.0.53','5432','','','instadb','insta','qdvvhZ37a')
dupusers = conn.exec('select insta_id from (
  SELECT insta_id,
  ROW_NUMBER() OVER(PARTITION BY insta_id ORDER BY id asc) AS Row
  FROM public.users
) dups
where 
dups.Row > 1
;')
dupusers.each do |d|
	u = User.first(:insta_id => d["insta_id"])
	duplicates = User.find(:insta_id => d["insta_id"], :id.not => u[:id])
	duplicates.each do |dup|
		p dup
	end
end
