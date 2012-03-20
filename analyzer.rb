require 'nokogiri'
require 'csv'

class Analyzer
  attr_accessor :filename, :directory, :output, :fazendas, :numeros, :incricaos, :municipios, :estados

  FILENAME_FORMAT = /\d{4}_\d{2}%2F\d{2}%2F\d{4}\.html/

  def initialize(item, out)
    @fazendas = Array.new
    @numeros = Array.new
    @incricaos = Array.new
    @municipios = Array.new
    @estados = Array.new
    @output = out
    
    if File.directory? item 
      @directory = item
    elsif File.exists? item
      raise InvalidFilenameException, "invalid filename format" unless item =~ FILENAME_FORMAT 
      @filename = item
    elsif item != ""
      raise NonexistentFileException, "nonexistent file or directory" 
    end
  end

  def pull_data
    if (@filename)
      result = Array.new
      doc = Nokogiri::HTML(open(@filename))
      doc.css('table tr td').each { |i| result << i.content }
      # strip off header
      result = result[5..-1]
      extract_fields result
    else
      
    end
  end

  def output_csv
    CSV.open(@output, 'wb') do |csv|
      for i in 0...@fazendas.length
        csv << [@fazendas[i],@numeros[i],@incricaos[i],@municipios[i],@estados[i]] 
      end
    end
  end

  private
  def extract_fields(data)
    faz_num = Array.new
    data.each_slice(5).map do |slc| 
      [faz_num, @incricaos, @municipios, @estados].each_with_index do |item,index|
        item << slc[index].rstrip
      end
    end
    faz_num.each do |i|
      temp = i.split(',')
      @fazendas << temp[0].strip
      if temp.length == 2
        @numeros << temp[1].strip
      else
        @numeros << "NA"
      end
    end
  end
  
end

class NonexistentFileException < Exception; end
class InvalidFilenameException < Exception; end
