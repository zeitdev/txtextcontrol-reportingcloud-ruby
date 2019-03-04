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

module TXTextControl
  module ReportingCloud

    # Passes data to the {ReportingCloud.append_documents} method.
    # @attr document [String] The document as a Base64 encoded string.
    # @attr document_divider [Symbol] The document divider option. Possible values are
    #   +:none+, +:new_paragraph+ and +:new_section+.
    # @author Thorsten Kummerow (@thomerow)
    class AppendDocument
      attr_accessor :document_divider

      def initialize(document, document_divider = :none)
        self.document = document
        @document_divider = document_divider
      end

      def document 
        @document
      end

      def document=(val)
        unless val.is_a?(String)
          raise ArgumentError, "document must be a Base64 encoded string."
        end
        @document = val
      end

      # Converts an AppendBody instance to a hash while converting the attribute names
      # from snake case to camel case.
      # @return [Hash] A hash representing the AppendBody instance.
      def to_camelized_hash
        result = {
          "document" => @document,
          "documentDivider" => "None"
        }

        case @document_divider
        when :new_paragraph
          result["documentDivider"] = "NewParagraph"
        when :new_section
          result["documentDivider"] = "NewSection"
        end

        return result
      end
    end    
  end
end
