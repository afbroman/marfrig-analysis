require 'spec_helper'

describe Analyzer do

  before :each do
    @analyzer = Analyzer.new
  end

  describe "new analyzer" do
    it "returns a new analyzer object" do
      @analyzer.should be_an_instance_of Analyzer
    end

    it "accepts zero parameters" do
      analyzer = Analyzer.new
      analyzer.should be_an_instance_of Analyzer
    end

    it "accepts a file as a parameter and sets the @filename variable" do
    end

    it "accepts a directory as a parameter and set the @directory variable" do
      analyzer = Analyzer.new("data/")
      analyzer.should be_an_instance_of Analyzer
      analyzer.directory.should == "data/"
    end

    it "raises exception for non-existent item" do
      expect { Analyzer.new("nonexist") }.to raise_error(RuntimeError, "nonexistent file or directory") 
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

end
