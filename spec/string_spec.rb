require 'spec_helper'

describe String do
  describe "#remove_first_and_last" do
    it "handles strings with length 0" do
      str = ""
      expect(str.remove_first_and_last).to eq("")
    end
    
    it "handles strings with length 1" do
      str = "a"
      expect(str.remove_first_and_last).to eq("")
    end
    
    it "removes the first and the last character" do
      str = "abcd"
      expect(str.remove_first_and_last).to eq("bc")
    end
  end 
end