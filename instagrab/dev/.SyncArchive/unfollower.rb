#!/usr/bin/ruby
# encoding: utf-8

require 'instagram'
require '/home/dexy/instagrab/dm_model.rb'

Instagram.configure do |config|
  config.client_id = 'ecb050ce18984d9b91d4add9c86960b3'
  config.access_token = '298454841.ecb050c.f4b4e7e913f043de937ab4cc3b6d1762'
end

@users = Instagram.user_follows(:id=>298454841)
begin
p @users.map{|u| u.username}.collect
p @users.pagination
page = @users.pagination.next_cursor
@users.each do |user|
	p Instagram.unfollow_user(user.id)
end
@users = Instagram.user_follows(:id=>298454841,:cursor=>page)  if(@users.pagination)
end while(@users.pagination)
