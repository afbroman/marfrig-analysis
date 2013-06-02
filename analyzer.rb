require 'nokogiri'
require 'csv'

class Analyzer
  attr_accessor :filename, :directory, :output
  attr_accessor :dir_filenames, :data_result

  FILENAME_FORMAT = /(?<sif>\d{4})_(?<day>\d{2})_(?<month>\d{2})_(?<year>\d{4})\.html/

  def initialize(item, out)
    
    @output = out
    @dir_filenames = Array.new

    @data_result = []
    
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

      if m = FILENAME_FORMAT.match(@filename)
        sif = m[:sif]
        date = m[:day] + "/" + m[:month] + "/" + m[:year]
      end



      doc = Nokogiri::HTML(open(@filename))
      doc.css('table tr').each do |i| 

        @data_result << "#{sif}\n#{date}\n" + i.content.strip unless i.content =~ %r|APTAS PELO IBAMA|

      end

    # Handles memory very poorly. Should append to output file after pulling from each file?
    else # directory
      dir_filenames.each do |fn|

        if m = FILENAME_FORMAT.match(fn)
          sif = m[:sif]
          date = m[:day] + "/" + m[:month] + "/" + m[:year]

          doc = Nokogiri::HTML(open(fn))
          doc.css('table tr').each do |i| 
            @data_result << "#{sif}\n#{date}\n" + i.content.strip unless i.content =~ %r|APTAS PELO IBAMA| 
          end
        end
      end
    end

    @data_result = @data_result.map { |i| i.split("\n").each { |j| j.strip! } }
  end

  def output_csv
    CSV.open(@output, 'wb') do |csv|
      @data_result.each do |row|

        csv << row

      end

    end
  end
end

class NonexistentFileException < Exception; end
class InvalidFilenameException < Exception; end
