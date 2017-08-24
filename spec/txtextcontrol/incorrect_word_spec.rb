require 'spec_helper'
require "txtextcontrol/reportingcloud/incorrect_word"

describe TXTextControl::ReportingCloud::IncorrectWord do
  describe ".from_camelized_hash" do
    it "creates an instance from a hash using camel case attributes" do
      hash = {
        "length" => 4,
        "start" => 123,
        "text" => "This",
        "isDuplicate" => false,
        "language" => "en_US.dic",
      }
      
      s = TXTextControl::ReportingCloud::IncorrectWord::from_camelized_hash(hash)
      expect(s.length).to be(4)
      expect(s.start).to be(123)
      expect(s.text).to eq("This")
      expect(s.is_duplicate?).to be(false)
      expect(s.is_duplicate).to be(false)
      expect(s.language).to eq("en_US.dic")
    end
  end
end