require "txtextcontrol/reportingcloud/merge_settings"

module TXTextControl
  module ReportingCloud
    class MergeBody
      attr_accessor :mergeData
      attr_accessor :template
      attr_accessor :mergeSettings
      
      def initialize(mergeData, template, mergeSettings = MergeSettings.new)
        # ToDo: implement 
      end
    end
  end 
end
