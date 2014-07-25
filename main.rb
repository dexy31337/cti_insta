#!/usr/bin/ruby
# encoding: utf-8
require 'rubygems'
require 'instagram'
require 'open-uri'
require 'pg'
require 'thread'
require 'json'
#require 'rest-client'
require 'haml'
require_relative 'lib/dm_model'
require_relative 'lib/picparse'

#require 'sinatra'
#set :bind, '0.0.0.0'
#set :port, 4600

#RestClient.log=STDOUT

CrawlJob = Struct.new(:type,:data)

#Настройки кроулеров

$queue = Queue.new      # input queue
$job_queue = Queue.new
$cti_job_queue = Queue.new



$access_tokens.each do |token|
  Thread.new(token) do |j|
    loop do
      begin
        job = $queue.pop
        inster = Instagram::Client.new(:client_id=>$client_id[0],:access_token=>token)
        if job.type == 'ht'
          pics = inster.tag_recent_media(URI::encode(job.data),:count=>100)
          $job_queue.push(CrawlJob.new('pic2like',pics))if pics != nil
        end
        if job.type == 'lc'
          pics = inster.location_recent_media(job.data,:count=>100)
          $job_queue.push(CrawlJob.new('pic2like',pics))if pics != nil
        end
        if job.type == 'lk'
          pic = job.data
          result = inster.media_likes(pic.insta_id)
          if result.collect{|p| p.username}.include?('ctibrace')
            job.data.update(:liked=>true)
            print '+'
          else
            print '-'
          end
        end
      rescue Exception=>e
        pic.update(:liked=>true)
        pic.update(:skip=>true)
        puts "Exception '#{e.message}' in pic #{pic.id}\n#{e.backtrace}"
      end
    end
  end
end

10.times do |i|
  Thread.new("parser#{i}") do
    loop do
      ht = $job_queue.pop
      if ht.type=='pic2like'
        ht.data.each do |pic|
          picparse(pic)
        end
      end
    end
  end
end

#Thread.new('info') do |p|
#	loop do
#		puts "QL = #{$job_queue.length}"
#		sleep 5
#	end
#end

$cti_access_tokens.each do |token|
  Thread.new(token) do |p|
    loop do
      puts "\nPerform search...\n"
      loop do
        begin
          pic = $cti_job_queue.pop
          check=system %x(curl -s #{pic.link} | grep -o 'Page Not Found')
          if(check ==  nil)
            likerequest =`curl -s -F 'access_token=#{token}' -A 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.62 Safari/537.36' https://api.instagram.com/v1/media/#{pic.insta_id.to_s}/likes`
            result = JSON.parse(likerequest)
            if(result["meta"]["code"] != 200)
              if(result["meta"]["error_type"] == 'OAuthRateLimitException')
                puts "Limit hit #{pic.id} ! #{pic.link}"
                break
              elsif(result["meta"]["error_type"] == 'APINotAllowedError')
                puts "Private pic from user #{pic.user.username}"
                pic.user.update(:private=>true)
                pic.user.update(:status=>'gethim') if pic.user.status == '' or pic.user.status == nil
              end
              print "\n* Error liking #{pic.link} - #{JSON.parse(likerequest)}\n"
              pic.update(:skip=>true)
              pic.update(:liked=>false)
              pic.update(:status=>JSON.parse(likerequest)["meta"]["error_type"])
            else

              result =`curl -s #{pic.link} | grep -o ctibrace`
              if(result != '')
                pic.update(:liked=>true)
                pic.update(:status=>"OK")
                print "!"
              else
                print "\n* Error liking #{pic.link}: unknown error at 1\n"
                pic.update(:skip=>true)
                pic.update(:liked=>false)
                pic.update(:status=>"unknown1")
              end

            end
          else
            puts "Sanity check fail. Nonexistent pic #{pic.id}"
            pic.update(:skip=>true)
            pic.update(:status=>"notfound")
          end
        rescue Exception=>e
          puts "Exception '#{e.message}' in pic #{pic.id}\n#{e.backtrace}"
        end
      end
      sleep(20*60)
    end
  end
end
Thread.new('vacuum') do |p|
  loop do
    print 'V'
    $hashtags.each do |tag|
      begin
        $queue.push(CrawlJob.new('ht',tag))
      rescue Exception=>e
        p e
      end
    end
    $locations.each do |tag|
      $queue.push(CrawlJob.new('lc',tag))
    end
    sleep (5*60)
  end
end

#Thread.new('doworkdone') do |p|
#	loop do
#		tagstocheck.each do |tag|
#			$queue.push(CrawlJob.new('tc',tag))
#		end
#		sleep (5)
#	end
#end


#Thread.new('doworkdone') do |p|
#	loop do
#		Pic.all(:liked=>false,:skip=>false).each do |pic|
#			$queue.push(CrawlJob.new('lk',pic))
#		end
#	end
#end

Thread.new('pumppics') do |p|
  loop do
    while($cti_job_queue.length < 10)
      pics = Pic.all(:liked=>false,:skip=>false,:limit=>10)
      pics.each {|pic| $cti_job_queue.push(pic)}
    end
  end
end

#get '/' do
#	"CTi workers
#end
sleep 1 while true
