require 'spec_helper'
require "txtextcontrol/reportingcloud/template_data_validator"

describe TXTextControl::ReportingCloud::TemplateDataValidator do
  describe ".validate" do
    it "raises error on empty string or nil" do
      expect { TXTextControl::ReportingCloud::TemplateDataValidator.validate("") }.to raise_error(ArgumentError)
      expect { TXTextControl::ReportingCloud::TemplateDataValidator.validate(nil) }.to raise_error(ArgumentError)
    end
    
    it "validates a valid string" do
      expect { TXTextControl::ReportingCloud::TemplateDataValidator.validate("not empty") }.not_to raise_error
    end
  end
end