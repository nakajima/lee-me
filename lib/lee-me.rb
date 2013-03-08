module LeeMe
  # Internal: lee
  def self.lee
    File.join(File.dirname(__FILE__), '..', 'dat-image', 'lee.png')
  end

  # Resize dat image to the height passed.
  #
  #   height - the desired height of the resized image
  #
  # Returns String that is the path to the resized file
  def self.resize_lee(height)
    name = "#{Dir.pwd}/tmp/lee-#{height}.png"
    unless File.exists?(name)
      `convert -resize x#{height} #{lee} #{name}`
    end
    name
  end
  
  # Check to see if the file has already been composited. If so, return the path
  # to the composited file.
  #
  #   filename - the filename of an image to be checked
  #
  # Returns nil if this is a new image, or the existing composited path as a String
  def self.already_correct(filename)
    if File.exists? File.join(Dir.pwd, 'tmp', File.basename(filename) + '-result')
      File.join(Dir.pwd, 'tmp', File.basename(filename) + '-result', 'result.jpg')
    end
  end

  # This does pretty much everything.
  #
  #    path - the path to the downloaded file to be fucked with
  #
  # Returns a String that is the path to the fucked with image.
  def self.lean_into_it(path)
    height = LeeMe::Image.new(path).height
    height_for_lee = height / 2

    resized = resize_lee(height_for_lee)
    offset = height - height_for_lee
    
    result_dir = File.join(Dir.pwd, 'tmp', File.basename(path) + '-result')
    
    `mkdir -p #{result_dir}` unless File.exists?(result_dir)
    `composite -geometry +0+#{offset} #{resized} #{path} #{result_dir}/result.jpg`
    `rm #{resized}`
    
    "#{result_dir}/result.jpg"
  end

  # Internal: Just used to calculate the height of an image
  #
  #   path - a path to an image
  class Image
    def initialize(path)
      @path = path
    end

    def height
      identify[2].split('x').last.to_i
    end

    def identify
      @identify ||= `identify #{@path}`.split(' ')
    end
  end
end
