#!/usr/bin/ruby
# encoding: utf-8

require '/home/dexy/instagrab/dm_model.rb'
likenum = Random.rand(11)+20
access_token = '298454841.ecb050c.f4b4e7e913f043de937ab4cc3b6d1762'
Pic.all(:liked=>false,:skip=>false,:limit=>likenum).each do |pic|
	#Do a like
	system("curl -F 'access_token=#{access_token}' -A 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.62 Safari/537.36' https://api.instagram.com/v1/media/#{pic.insta_id.to_s}/likes")
	#Check
	result = %x(curl -s #{pic.link} | grep -o ctibrace)
	#Update DB
	if(result != '') then
		pic.update(:liked=>true)
		print "#{pic.id} Like!\n"
	else
		print "Not liked pic #{pic.id}!\n"
		pic.update(:skip=>true)
	end	
end
