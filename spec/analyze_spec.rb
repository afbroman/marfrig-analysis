require 'spec_helper'

describe Analyzer do
  
  before :each do
    @analyzer = Analyzer.new
  end

  describe Analyzer do
    it "returns a new analyzer object" do
      @analyzer.should be_an_instance_of Analyzer
    end

    it "accepts zero parameters" do
      analyzer = Analyzer.new
      analyzer.should be_an_instance_of Analyzer
    end

    it "accepts a file as a parameter and sets the @filename variable" do
      analyzer = Analyzer.new("data/samplefile.html")
      analyzer.should be_an_instance_of Analyzer
      analyzer.filename.should == "data/samplefile.html"
    end

    it "accepts a directory as a parameter and set the @directory variable" do
      analyzer = Analyzer.new("data/")
      analyzer.should be_an_instance_of Analyzer
      analyzer.directory.should == "data/"
    end

    it "raise exception for non-existent item" do
      expect { Analyzer.new("nonexist") }.to raise_error(RuntimeError) 
    end
  end
  
end
