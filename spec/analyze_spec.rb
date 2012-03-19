require 'spec_helper'

describe Analyzer do
  
  before :each do
    @analyzer = Analyzer.new
  end

  describe "#new" do
    it "returns a new analyzer object" do
      @analyzer.should be_an_instance_of Analyzer
    end

    it "accepts zero parameters" do
      analyzer = Analyzer.new
      analyzer.should be_an_instance_of Analyzer
    end

    it "accepts one parameter" do
      analyzer = Analyzer.new("filename")
      analyzer.should be_an_instance_of Analyzer
    end

    it "accepts an existing file as a parameter" do
      analyzer = Analyzer.new("data/samplefile.html")
      samplefile.should be
    end
    
  end
  
end
