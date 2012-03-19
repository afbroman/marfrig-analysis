require 'nokogiri'

class Analyzer
  attr_accessor :filename, :directory, :fazendas

  FILENAME_FORMAT = /\d{4}_\d{2}%2F\d{2}%2F\d{4}\.html/

  def initialize(item)
    @fazendas = Array.new 
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
      result = Array.new
      doc = Nokogiri::HTML(open(@filename))
      doc.css('table tr td').each { |i| result << i.content }
      # strip off header information
      result = result[5..-1]
      # grab fazendas
      result.each_slice(5).map {|i| @fazendas << i[0]}
      
    end
  end
end
