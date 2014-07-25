#!/usr/bin/env ruby
# encoding: utf-8

require 'instagram'
require '/home/dexy/instagrab/dm_model.rb'

Instagram.configure do |config|
  config.client_id = 'ecb050ce18984d9b91d4add9c86960b3'
  config.access_token = '298454841.ecb050c.f4b4e7e913f043de937ab4cc3b6d1762'
end
total = 0 
@users = Instagram.user_followed_by(:id=>298454841,:count=>1000)
total+=@users.count
@users.each do |user|
	begin
	u=User.first_or_create(
                  {:insta_id => user.id.to_s,
                  :fullname => user.full_name,
                  :username => user.username,
                  :website => user.website}
              )
	u.update(:follower=>true)	
	rescue DataMapper::SaveFailureError =>e
	p e.resource.errors.inspect
	end
end
p total
while(@users.pagination) do
	@users = Instagram.user_followed_by(:id=>298454841,:count=>1000,:cursor=>@users.pagination.next_cursor)
	total += @users.count
	@users.each do |user|
		begin
		u=User.first_or_create(
                  {:insta_id =>user.id.to_s,
                  :fullname => user.full_name,
                  :username => user.username,
                  :website => user.website}
              	)
		u.update(:follower=>true)	
		rescue DataMapper::SaveFailureError =>e
			p e.resource.errors.inspect
		end
	end	
	p total
end
