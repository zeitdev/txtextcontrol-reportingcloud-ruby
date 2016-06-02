require "txtextcontrol/reportingcloud/merge_settings"

module TXTextControl
  module ReportingCloud
  
    # ...
    # @athor T. Kummerow
    # @attr_accessor merge_data [Array<Hash>] The merge data.
    # @attr_accessor template [String, nil] Base64 encoded template document.
    #   Supported formats are RTF, DOC, DOCX and TX. 
    # @attr_accessor merge_settings [MergeSettings, nil] Merge settings to specify 
    #   merge properties and document properties such as title and 
    #   author.
    class MergeBody
      attr_accessor :merge_data
      attr_accessor :template
      attr_accessor :merge_settings
      
      # The constructor.
      # @param merge_data [Array<Hash>] The merge data. Must be an array of hashes.
      # @param template [String, nil] Base64 encoded template document.
      #   Supported formats are RTF, DOC, DOCX and TX.
      # @param merge_settings [MergeSettings, nil] Merge settings to specify 
      #   merge properties and document properties such as title and 
      #   author.
      def initialize(merge_data, merge_settings = nil, template = nil)
        @merge_data = merge_data
        @template = template
        @merge_settings = merge_settings
      end      
      
      # Converts a MergeBody instance to a hash while converting the attribute names
      # from snake case to camel case.
      # @return [Hash] A hash representing the MergeBody instance.
      def to_camelized_hash
        return {
          :mergeData => @merge_data,
          :template => @template,
          :mergeSettings => @merge_settings.nil? ? nil : merge_settings.to_camelized_hash
        }
      end
    end
  end 
end
