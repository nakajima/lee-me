module LeeMe
  def self.lee
    File.join(File.dirname(__FILE__), '..', 'dat-image', 'lee.png')
  end

  def self.resize_lee(height)
    name = "#{Dir.pwd}/tmp/lee-#{height}.png"
    unless File.exists?(name)
      `convert -resize x#{height} #{lee} #{name}`
    end
    name
  end
  
  def self.already_correct(filename)
    if File.exists? File.join(Dir.pwd, 'tmp', File.basename(filename) + '-result')
      File.join(Dir.pwd, 'tmp', File.basename(filename) + '-result', 'result.jpg')
    end
  end

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
