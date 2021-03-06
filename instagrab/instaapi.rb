#!/usr/bin/ruby
# encoding: utf-8

require 'rubygems'
require 'instagram'
require 'open-uri'
require 'pg'
require '/home/dexy/instagrab/dm_model.rb'

Instagram.configure do |config|
  config.client_id = 'ecb050ce18984d9b91d4add9c86960b3'
  config.access_token = '298454841.ecb050c.f4b4e7e913f043de937ab4cc3b6d1762'
end

hashtags = []
hashtags << 'вейк' << 'вейкборд'
hashtags << 'мото' << 'мотокросс' << 'эндуро' << 'байк'
hashtags << 'сноуборд'<<'горныелыжи'<<'twintip'
hashtags << 'спорт' << 'экстрим'
hashtags << 'снежком' << 'snejcom'
hashtags << 'красная_поляна' << 'krasnaya_polyana' << 'волен'
hashtags << 'кайт' << 'серфинг' << 'серф'
hashtags << '2manwakepark' << 'kraskovowakepark'
hashtags << 'колено'
#hashtags << 'олимпиада'
hashtags << 'хоккей'
#hashtags = ['ctibrace']

hashtags.each do |tag|
  picmash = Instagram.tag_recent_media(URI::encode(tag),:count=>100)
  picmash.each do |pic|
    #create Pic
    if(Pic.count(:insta_id=>pic.id) == 0) then
      
      i_pic = Pic.create(
        :insta_id => pic.id,
        :liked => pic.user_has_liked,
        :link => pic.link,
        :created_at => Time.now,
        :insta_created => Time.at(pic.created_time.to_i).to_datetime,
        :user=>User.first_or_create(
                  {:insta_id => pic.user.id.to_s,
                  :fullname => pic.user.full_name,
                  :username => pic.user.username,
                  :website => pic.user.website}
              )
      )
      print "Created pic #{i_pic.id} from user #{i_pic.user.username}\t\t"
      #Check location
      i_pic.update(:location=>Location.first_or_create(
        {:insta_id =>pic.location.id.to_s,
          :name => pic.location.name,
          :lat => pic.location.latitude.to_f,
          :lon => pic.location.longitude.to_f}
      )) if pic.location
      print "location #{i_pic.location.name}\t\t" if pic.location
      print "location unknown\t\t" if !pic.location
      #Tags
      if(pic.tags)
        pic.tags.each do |tag|
          t = Tag.first_or_create(:name=>tag.to_s)
          t.pics << i_pic
	  t.save
          i_pic.tags << t
	  print "\##{t.name} "
        end
      end
      i_pic.save  
      #Likes
      if(pic.likes)
        pic.likes.data.each do |like|
          Like.first_or_create(
            {:pic_id=>i_pic.id,
              :user_id=>
                User.first_or_create(
                {:insta_id => like.id.to_s,
                :fullname => like.full_name,
                :username => like.username,
                :website => like.website}
                ).id
            }
          )
        end
      print "\n"
      end
    end
  end
end
conn = PGconn.new('192.168.0.53','5432','','','instadb','insta','qdvvhZ37a')
conn.exec ("INSERT INTO records (time,n_pics,n_users,n_locations,n_tags,n_likes) VALUES(
now(),
(SELECT n_live_tup FROM pg_stat_user_tables WHERE relname = 'pics'),
(SELECT n_live_tup FROM pg_stat_user_tables WHERE relname = 'users'),
(SELECT n_live_tup FROM pg_stat_user_tables WHERE relname = 'locations'),
(SELECT n_live_tup FROM pg_stat_user_tables WHERE relname = 'tags'),
(SELECT n_live_tup FROM pg_stat_user_tables WHERE relname = 'likes')
);")

#each.find_all{|f| f.user_has_liked? == false}.each do |pic|
#  if(pic.comments.count != 0) then
#    p pic.comments
#    p pic.tags
#    p pic.caption
#  end
#  end#
#end:
