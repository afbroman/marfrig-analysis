require 'nokogiri'
require 'csv'

class Analyzer
  attr_accessor :filename, :directory, :output, :fazendas, :numeros, :incricaos, :municipios, :estados
  attr_accessor :dir_filenames, :sifs, :dates

  FILENAME_FORMAT = /(?<sif>\d{4})_(?<day>\d{2})%2F(?<month>\d{2})%2F(?<year>\d{4})\.html/

  def initialize(item, out)
    @fazendas = Array.new
    @numeros = Array.new
    @incricaos = Array.new
    @municipios = Array.new
    @estados = Array.new
    @sifs = Array.new
    @dates = Array.new
    
    @output = out
    @dir_filenames = Array.new
    
    if File.directory? item 
      @directory = item
      Dir.entries(@directory).each {|i| @dir_filenames << "#{@directory}/#{i}"}
    elsif File.exists? item
      raise InvalidFilenameException, "invalid filename format" unless FILENAME_FORMAT.match(item)
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
      extract_fields(result, @filename)

    # Handles memory very poorly. Should append to output file after pulling from each file?
    else # directory
      dir_filenames.each do |fn|
        result = Array.new
        if FILENAME_FORMAT.match(fn)
          doc = Nokogiri::HTML(open(fn))
          doc.css('table tr td').each { |i| result << i.content }
          result = result[5..-1]
          extract_fields(result, fn)
        end
      end
    end
  end

  def output_csv
    #if (@filename && m = FILENAME_FORMAT.match(@filename))
    #  @date = "#{m[:month].to_i}/#{m[:day].to_i}/#{m[:year]}"
    #  @sif = m[:sif]
    #end
    CSV.open(@output, 'wb') do |csv|
      for i in 0...@fazendas.length
        csv << [@sifs[i],@dates[i],@fazendas[i],@numeros[i],@incricaos[i],@municipios[i],@estados[i]] 
      end
    end
  end

  private
  def extract_fields(data, filename)
    faz_num = Array.new
    m = FILENAME_FORMAT.match(filename)
    count = 0
    data.each_slice(5).map do |slc| 
      [faz_num, @incricaos, @municipios, @estados].each_with_index do |item,index|
        item << slc[index].rstrip
      end
      count += 1
    end
    count.times do
      @sifs << m[:sif]
      @dates << "#{m[:month].to_i}/#{m[:day].to_i}/#{m[:year]}" 
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
    m = FILENAME_FORMAT.match(filename)
  end
  
end

class NonexistentFileException < Exception; end
class InvalidFilenameException < Exception; end
