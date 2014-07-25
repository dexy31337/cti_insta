#!/usr/bin/ruby
# encoding: utf-8

def picparse(pic={})
   if(Pic.count(:insta_id=>pic.id) == 0) then  
      i_pic = Pic.create(
        :insta_id => pic.id,
        :liked => false,
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
 #     print "Created pic #{i_pic.id} from user #{i_pic.user.username}\t\t"
      #Check location
      i_pic.update(:location=>Location.first_or_create(
        {:insta_id =>pic.location.id.to_s,
          :name => pic.location.name,
          :lat => pic.location.latitude.to_f,
          :lon => pic.location.longitude.to_f}
      )) if pic.location
#      print "location #{i_pic.location.name}\t\t" if pic.location
#      print "location unknown\t\t" if !pic.location
      #Tags
      if(pic.tags)
        pic.tags.each do |tag|
          t = Tag.first_or_create(:name=>tag.to_s)
          t.pics << i_pic
	  t.save
          i_pic.tags << t
#	  print "\##{t.name} "
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
      print "."
      end
    end
  end