require 'spec_helper'

describe Analyzer do

  before :each do
  end

  describe "new analyzer" do
    it "accepts a directory as a parameter and set the @directory variable" do
      analyzer = Analyzer.new("data/")
      analyzer.should be_an_instance_of Analyzer
      analyzer.directory.should == "data/"
    end

    it "raises exception for non-existent item" do
      expect { Analyzer.new("nonexistent") }.to raise_error(RuntimeError, "nonexistent file or directory") 
    end

    it "accepts filename with correct format" do
      fn = "data/2500_31%2F01%2F2011.html"
      analyzer = Analyzer.new(fn)
      analyzer.should be_an_instance_of Analyzer
      analyzer.filename.should == fn 
    end

    it "raises exception for invalid filename format" do
      fn = "data/samplefile.html"
      expect { Analyzer.new(fn) }.to raise_error(RuntimeError, "invalid filename format")
    end
  end

  describe "#filename" do
    it "returns the correct filename when a filename is given as the parameter" do
      fn = "data/2500_31%2F01%2F2011.html"
      analyzer = Analyzer.new(fn)
      analyzer.filename.should == fn
    end

    it "returns nil when a directory is given as the parameter" do
      dir  = "data/"
      analyzer = Analyzer.new(dir)
      analyzer.filename.should == nil 
    end
  end

  describe "#directory" do
    it "returns the correct directory name when a directory is given as the parameter" do
      dir = "data/"
      analyzer = Analyzer.new(dir)
      analyzer.directory.should == dir
    end

    it "returns nil when a filename is given as the parameter" do
      fn = "data/2500_31%2F01%2F2011.html"
      analyzer = Analyzer.new(fn)
      analyzer.directory.should == nil
    end
  end

  describe "pull_data" do
    describe "pull_data from file" do
      it "opens the file" do
        fn = "data/2500_31%2F01%2F2011.html"
        analyzer = Analyzer.new(fn)
        expect { analyzer.pull_data }.not_to raise_error
      end

      
    end
  end
  

end
