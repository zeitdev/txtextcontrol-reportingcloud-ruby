# ReportingCloud Ruby SDK
#
# Official Ruby SDK for the ReportingCloud Web API. Authored, maintained and fully supported 
# by Text Control GmbH. (http://www.textcontrol.com).
#
# Go to http://www.reporting.cloud to learn more about ReportingCloud
# Go to https://github.com/TextControl/txtextcontrol-reportingcloud-ruby for the 
# canonical source repository.
#
# License: https://raw.githubusercontent.com/TextControl/txtextcontrol-reportingcloud-ruby/master/LICENSE.md
#
# Copyright: © 2019 Text Control GmbH

require "txtextcontrol/reportingcloud/append_document"
require "txtextcontrol/reportingcloud/document_settings"

module TXTextControl
  module ReportingCloud

    # Passes data to the {ReportingCloud.append_documents} method.
    # @attr documents [Array<AppendDocument>] The documents that are appended.
    # @attr document_settings [DocumentSettings] Optional. Document settings to specify 
    #   document properties such as title and author.
    # @author Thorsten Kummerow (@thomerow)
    class AppendBody
      
      def initialize(documents, document_settings = nil)
        self.documents = documents
        self.document_settings = document_settings
      end

      def documents
        @documents
      end      

      def documents=(val)
        unless val.kind_of?(Array) 
          raise ArgumentError, "Not an qarray."
        end
        val.each do |elem|
          unless elem.is_a?(TXTextControl::ReportingCloud::AppendDocument)
            raise ArgumentError, "Only elements of type \"AppendDocument\" are allowed."
          end
        end
        @documents = val
      end

      def document_settings
        @document_settings
      end      

      def document_settings=(val)
        unless val.is_a?(TXTextControl::ReportingCloud::DocumentSettings) 
          raise ArgumentError, "Must be a DocumentSettings instance."
        end
        @document_settings = val;
      end

      # Converts an AppendBody instance to a hash while converting the attribute names
      # from snake case to camel case.
      # @return [Hash] A hash representing the AppendBody instance.
      def to_camelized_hash
        return {
          "documents" => @documents.map { |d| d.to_camelized_hash },
          "documentSettings" => @document_settings.nil? ? nil : @document_settings.to_camelized_hash
        }
      end
    end    
  end
end
