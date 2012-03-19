require 'spec_helper'

describe Analyzer do
  
  before :each do
    @analyzer = Analyzer.new
  end

  describe "#new" do
    it "returns a new analyzer object" do
      @analyzer.should be_an_instance_of Analyzer
    end

    
  end
  
end
