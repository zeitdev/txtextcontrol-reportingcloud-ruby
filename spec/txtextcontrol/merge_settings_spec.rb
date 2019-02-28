require 'spec_helper'
require "txtextcontrol/reportingcloud/merge_settings"

describe TXTextControl::ReportingCloud::MergeSettings do

  describe "#to_camlized_hash" do
    before do
      @ms = TXTextControl::ReportingCloud::MergeSettings.new
    end

    it "includes super class properties" do      
      converted = @ms.to_camelized_hash
      expect(converted).to include("author")
      expect(converted).to include("creationDate")
      expect(converted).to include("creatorApplication")
      expect(converted).to include("documentSubject")
      expect(converted).to include("documentTitle")
      expect(converted).to include("lastModificationDate")
      expect(converted).to include("userPassword")
    end
  end

end