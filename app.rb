require 'sinatra'
require_relative './lib/instagram.rb'
require_relative './lib/postcard_from_image.rb'

get '/insta/:instagram_username' do
  username = params['instagram_username']
  @urls = Instagram.feed(username)
  haml :insta
end

post '/insta/:instagram_username/postcard' do
  username = params['instagram_username']
  url = Instagram.feed(username).first
  PostcardFromImage.new(url).run
end
