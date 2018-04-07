require 'sinatra'
require_relative './lib/instagram.rb'
require_relative './lib/postcard_from_image.rb'


get '/' do
  @content = "Hey there"
  haml :index
end

get '/insta/:instagram_username' do
  username = params['instagram_username']
  @urls = Instagram.feed(username)
  haml :insta
end

get '/insta/:instagram_username/prepare' do
  username = params['instagram_username']
  url = Instagram.feed(username).first
  PostcardFromImage.new(url).run
end
