require 'RMagick'

module LeeMe
  def self.cache
    @cache ||= {}
  end

  # Internal: lee
  def self.lee
    @lee ||= Magick::Image.from_blob(File.open(File.join(File.dirname(__FILE__), '..', 'dat-image', 'lee.png')).read).first
  end

  # Check to see if the file has already been composited. If so, return the path
  # to the composited file.
  #
  #   filename - the filename of an image to be checked
  #
  # Returns nil if this is a new image, or the existing composited path as a String
  def self.already_correct(filename)
    cache[filename]
  end

  # This does pretty much everything.
  #
  #    path - the path to the downloaded file to be fucked with
  #
  # Returns a String that is the path to the fucked with image.
  def self.lean_into_it(url)
    filename = File.basename(url)
    image = Magick::Image.from_blob(`curl -v -L "#{url}"`).first
    height = image.rows
    height_for_lee = height / 2

    resized = lee.resize_to_fit!(image.columns, height_for_lee)
    offset = height - height_for_lee
    cache[filename] = image.composite!(resized, 0, offset, Magick::OverCompositeOp).to_blob
  end
end
