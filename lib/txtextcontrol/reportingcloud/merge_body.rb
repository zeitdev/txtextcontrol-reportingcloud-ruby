require "txtextcontrol/reportingcloud/merge_settings"

module TXTextControl
  module ReportingCloud
    class MergeBody < Hashable
      attr_accessor :mergeData
      attr_accessor :template
      attr_accessor :mergeSettings
      
      # The constructor.
      # @param mergeData [Array<Object>] The merge data.
      # @param template [String] Base64 encoded template document.
      #        Supported formats are RTF, DOC, DOCX and TX.
      # @param mergeSettings [MergeSettings] Merge settings to specify 
      #        merge properties and document properties such as title and 
      #        author.
      def initialize(mergeData, mergeSettings = nil, template = nil)
        @mergeData = mergeData
        @template = template
        @mergeSettings = mergeSettings
      end      
    end
  end 
end
