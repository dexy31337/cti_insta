#!/usr/bin/ruby
# encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'haml'
require 'json'
require 'rest-client'
require 'thread'

set :bind, '0.0.0.0'
set :port, 4568

RestClient.log=STDOUT

$counter = 0

Thread.new('thread') do |p|
	loop do
		$counter+=1
		sleep(1)
	end
end

get '/' do
	haml :index
end

get '/counter/' do
	"#{$counter}"
end

get '/andy/' do
	erb :andy
end

get '/app.php' do
	jdata = {
	:client_id=>'ecb050ce18984d9b91d4add9c86960b3',
	:client_secret=>'1fdca64aa1c74f038d7304c5be583b7e',
	:grant_type=>'authorization_code',
	:redirect_uri=>'http://www.delovayakolbasa.ru/app.php',
	:code=>params[:code]
	}
	
	@code = RestClient.post 'https://api.instagram.com/oauth/access_token',jdata, :content_type=>:json, :accept=>:json
	haml :app, :format=> :html5 
end

get '/app2.php' do
	jdata = {
	:client_id=>'5e4e396e82a9459bb33548d6c7a989a5',
	:client_secret=>'0f196f972c2641419476505d6159b682',
	:grant_type=>'authorization_code',
	:redirect_uri=>'http://www.delovayakolbasa.ru/app2.php',
	:code=>params[:code]
	}
	
	@code = RestClient.post 'https://api.instagram.com/oauth/access_token',jdata, :content_type=>:json, :accept=>:json
	haml :app, :format=> :html5 
end

get '/app3.php' do
	jdata = {
	:client_id=>'c30b505ed8eb4c40bbc5e95fd77a853f',
	:client_secret=>'0c8d4533b3384a3db8b22baf4ec1891d',
	:grant_type=>'authorization_code',
	:redirect_uri=>'http://www.delovayakolbasa.ru/app3.php',
	:code=>params[:code]
	}
	
	@code = RestClient.post 'https://api.instagram.com/oauth/access_token',jdata, :content_type=>:json, :accept=>:json
	haml :app, :format=> :html5 
end
