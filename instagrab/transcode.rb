#!/usr/bin/ruby
# encoding: utf-8

require '/home/dexy/instagrab/dm_model.rb'
limitnum = 100
threads = []
#148654
for picnum in (109693..147654).step(1000)
	Pic.all(:id=> picnum..picnum+999).each do |pic|
		while(threads.size >= limitnum)
	    	sleep(0.2)
	    	print "^"
	    	threads.delete_if { |thr| !thr.status }
		end
		threads << Thread.new {
			comms = pic.comment.encode!('UTF-8', 'UTF-8', :invalid => :replace).gsub(/\\u(0...)/) {|s| [$1.to_i(16)].pack("U*")}.gsub(/.*\:\"(.*)\"/, '\1').strip
			#print "#{pic.id.to_s}\t#{comms}\n"
			comms.scan(/#[[:alnum:]]*/) do |tag|
				t = Tag.first_or_create(:name=>tag.sub(/#/,'').to_s)
        		t.pics << pic
	  			t.save
        		pic.tags << t
	  			#print "\t\t\##{t.name}\n"
	  			print '.'
    		end
    		pic.save 
			print "!"
		}
	end
	print threads.size
	threads.each { |thr| thr.join }
	threads.delete_if { |thr| !thr.status }
	print "\n------------------------------Ran #{picnum}-#{picnum+999}-------------------------------------\n"
end
threads.each { |thr| thr.join }
