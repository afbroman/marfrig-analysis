require 'spec_helper'

describe Analyzer do

  before :each do
  end

  describe "new analyzer" do
    it "accepts a directory as a parameter and set the @directory variable" do
      analyzer = Analyzer.new("data/", nil)
      analyzer.should be_an_instance_of Analyzer
      analyzer.directory.should == "data/"
    end

    it "raises exception for non-existent item" do
      expect { Analyzer.new("nonexistent") }.to 
        raise_error(NonexistentFileException, "nonexistent file or directory") 
    end

    it "accepts filename with correct format" do
      fn = "data/2500_31%2F01%2F2011.html"
      analyzer = Analyzer.new(fn, nil)
      analyzer.should be_an_instance_of Analyzer
      analyzer.filename.should == fn 
    end

    it "raises exception for invalid filename format" do
      fn = "data/samplefile.html"
      expect { Analyzer.new(fn, nil) }.to 
        raise_error(InvalidFilenameException, "invalid filename format")
    end
  end

  describe "#filename" do
    it "returns the correct filename when a filename is given as the parameter" do
      fn = "data/2500_31%2F01%2F2011.html"
      analyzer = Analyzer.new(fn, nil)
      analyzer.filename.should == fn
    end

    it "returns nil when a directory is given as the parameter" do
      dir  = "data/"
      analyzer = Analyzer.new(dir, nil)
      analyzer.filename.should == nil 
    end
  end

  describe "#directory" do
    it "returns the correct directory name when a directory is given as the parameter" do
      dir = "data/"
      analyzer = Analyzer.new(dir, nil)
      analyzer.directory.should == dir
    end

    it "returns nil when a filename is given as the parameter" do
      fn = "data/2500_31%2F01%2F2011.html"
      analyzer = Analyzer.new(fn, nil)
      analyzer.directory.should == nil
    end
  end

  describe "pull_data" do
    describe "pull_data from file" do
      before :each do
        fn = "data/2500_31%2F01%2F2011.html"
        @analyzer = Analyzer.new(fn, nil)
        @fazendas = ["FAZENDA CAJUEIROS , 040313",
                     "FAZENDA FORTALEZA , 12643",
                     "FAZENDA PRENDA , 24963",
                     "NOSSA SENHORA APARECIDA, SN",
                     "PIRAPO",
                     "SONHO MEU"]
        @incricaos = ["13.371.622-8", "13.269.389-5", "13.285.324-8", "13.306.879-0", "13.388.007-9",
          "13.303.993-5"]
        @municipios = ["GAUCHA DO NORTE",
                        "NOVA XAVANTINA",
                        "PLANALTO DA SERRA",
                        "GAUCHA DO NORTE",
                        "SORRISO",
                        "CAMPINAPOLIS"]
        @estados = Array.new
        6.times { @estados << "MT" } # This file has Mato Grosso for the state each time
        
      end
      
      # Is there a way to _actually_ check if the file's been opened?
      it "opens the file" do
        expect { @analyzer.pull_data }.not_to raise_error
      end

      it "reads the fazendas from the file" do
        @analyzer.pull_data
        @analyzer.fazendas.should == @fazendas
      end

      it "reads the incricaos from the file" do
        @analyzer.pull_data
        @analyzer.incricaos.should == @incricaos
      end

      it "reads the municipios from the file" do
        @analyzer.pull_data
        @analyzer.municipios.should == @municipios
      end

      it "reads the estados from the file" do
        @analyzer.pull_data
        @analyzer.estados.should == @estados
      end
    end
  end

  describe "output_csv" do
    before :each do
      @output = "data/output.csv"
      fn = "data/2500_31%2F01%2F2011.html"
      @analyzer = Analyzer.new(fn,@output)
      @analyzer.pull_data
      @firstline = "\"FAZENDA CAJUEIROS , 040313\",13.371.622-8,GAUCHA DO NORTE,MT\n"
    end

    it "outputs the file as CSV" do
      @analyzer.output_csv
      File.exists?(@output).should be_true
    end

    it "outputs a CSV file with a valid first line" do
      @analyzer.output_csv
      File.open(@output).first.should == @firstline
    end
  end
  

end
