class Analyzer
  attr_accessor :filename, :directory

  def initialize(item="")
    if File.directory? item 
      @directory = item
    elsif File.exists? item
      @filename = item
    elsif item != ""
      raise RuntimeError, "nonexistent file or directory" 
    end
  end
end
