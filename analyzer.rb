class Analyzer
  attr_accessor :filename, :directory

  FILENAME_FORMAT = /\d{4}_\d{2}%2F\d{2}%2F\d{4}\.html/

  def initialize(item)
    if File.directory? item 
      @directory = item
    elsif File.exists? item
      raise RuntimeError, "invalid filename format" unless item =~ FILENAME_FORMAT 
      @filename = item
    elsif item != ""
      raise RuntimeError, "nonexistent file or directory" 
    end
  end

  def pull_data
    if (@filename)
      f = File.open(@filename)
    end
  end
end
