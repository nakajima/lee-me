require 'rubygems'
require 'sinatra'
require 'open-uri'
require_relative 'lib/lee-me.rb'

class LeeMeApp < Sinatra::Application
  get '/' do
    begin
      # Get the unescaped 'url' param
      match = env['REQUEST_URI'].match(/url=([^&]*)/)
      url = match && match[1]

      unless url
        content_type :text
        return "You need to pass a URL. http://#{request.host}/?url=YOUR_PHOTO_URL"
      end

      # Ok, it's jpg
      content_type 'image/jpg'

      # Get the filename
      filename = File.basename(url)

      # Maybe we have it already
      if result = LeeMe.already_correct(filename)
        return result
      end

      LeeMe.lean_into_it url
    rescue
      redirect 'http://tedgambordella.com/blog/wp-content/uploads/2010/12/bruce-lee-picture-large-180x300.jpg'
    end
  end

  get '/stats' do
    content_type :text
    `ls -l tmp/*-result/* | wc -l`.strip
  end
end
