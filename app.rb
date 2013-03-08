require 'rubygems'
require 'sinatra'
require 'open-uri'
require_relative 'lib/lee-me.rb'

class LeeMeApp < Sinatra::Application
  configure do
    `mkdir -p #{Dir.pwd}/tmp`
  end

  get '/' do
    unless url = params[:url]
      return "nope"
    end

    # Ok, it's jpg
    content_type 'image/jpg'

    # Get the filename
    filename = File.basename(url)

    # Maybe we have it already
    if result = LeeMe.already_correct(filename)
      return File.read result
    end

    # Download the new file
    `curl -o #{Dir.pwd}/tmp/#{File.basename(url)} #{url}`

    File.read LeeMe.lean_into_it File.join(Dir.pwd, 'tmp', filename)
  end
end
