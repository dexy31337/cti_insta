#!/usr/bin/ruby
# encoding: utf-8

#curl http://instagram.com/p/drOVj6i4tS/ 2>&1 | grep -oP "\"caption\":\"(.*?)\""
#curl http://instagram.com/p/drOVj6i4tS/ 2\>\&1 | grep -oP \"\\\"caption\\\":\\\"(.*?)\\\"\"

require '/home/dexy/instagrab/dm_model.rb'
require 'json'
limitnum = 150
threads = []
#access_token = '298454841.ecb050c.f4b4e7e913f043de937ab4cc3b6d1762'
Pic.all(:id=> 167..148654,:comment=>nil).each do |pic|
print '.'
    while(threads.size >= limitnum)
    	sleep(0.1)
    	print "Too many threads"
    	threads.delete_if { |thr| !thr.status }
    end
    t = Thread.new {out = %x[curl -A 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.62 Safari/537.36' #{pic.link} 2>&1 | grep -oP \"\\"caption\\":\\".*?\\"\"]
		pic.update(:comment=>out)
		#.gsub(/\\u(....)/) {|s| [$1.to_i(16)].pack("U*")}.gsub(/.*\:\"(.*)\"/, '\1').strip
		print "Fetched data for pic #{pic.id}\n"
	}
	threads << t
end
threads.each { |thr| thr.join }
