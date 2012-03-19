require 'nokogiri'

class Analyzer
  attr_accessor :filename, :directory, :fazendas, :incricaos, :municipios, :estados

  FILENAME_FORMAT = /\d{4}_\d{2}%2F\d{2}%2F\d{4}\.html/

  def initialize(item)
    @fazendas = Array.new
    @incricaos = Array.new
    @municipios = Array.new
    @estados = Array.new
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
      result.each_slice(5).map do |i| 
        # grab fazendas
        @fazendas << i[0].rstrip
        # grab incricaos
        @incricaos << i[1].rstrip
        # grab municipios
        @municipios << i[2].rstrip
        # grab estados
        @estados << i[3].rstrip
      end
      
    end
  end
end
