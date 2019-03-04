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

require "txtextcontrol/reportingcloud/merge_settings"

module TXTextControl
  module ReportingCloud

    # The request body of requests to the endpoint "/document/findandreplace". Contains 
    # an array of string arrays, a template encoded as a Base64 string and a ReportingCloud 
    # MergeSettings object.
    # @attr find_and_replace_data [Array<Array<String>>] The find and replace
    #   pair values as an array of string arrays.
    # @attr merge_settings [MergeSettings] Merge settings to specify merge 
    #   properties and document properties such as title and author.
    # @attr template [String] The source document encoded as a Base64 string.
    class FindAndReplaceBody
      attr_accessor :find_and_replace_data
      attr_accessor :merge_settings
      attr_accessor :template

      # @param find_and_replace_data [Array<Array<String>>] The find and replace
      #   pair values as an array of string arrays.
      # @param template [String] The source document encoded as a Base64 string. 
      #   The supported document formats are +.rtf+, +.doc+, +.docx+, and +.tx+.
      # @param merge_settings [MergeSettings] Merge settings to specify merge 
      #   properties and document properties such as title and author.
      def initialize(find_and_replace_data, template = nil, merge_settings = nil)
        self.find_and_replace_data = find_and_replace_data
        self.template = template
        self.merge_settings = merge_settings
      end

      def find_and_replace_data
        @find_and_replace_data
      end

      def find_and_replace_data=(val)
        unless !val.nil? && (val.kind_of? Array) && !val.empty? && (val.all? { |elem| elem.kind_of? Array }) &&
          (val.all? { |elem| (elem.length == 2) && (elem[0].kind_of? String) && (elem[1].kind_of? String) })
          raise ArgumentError, "Find and replace data must be a non empty array of string arrays containing two strings each."
        end       
        @find_and_replace_data = val 
      end      

      def merge_settings
        @merge_settings
      end
      
      def merge_settings=(val)
        unless val.nil? || (val.kind_of? MergeSettings)
          raise ArgumentError, "Merge settings must be of type MergeSettings."
        end
        @merge_settings = val
      end
      
      def template
        @template
      end
      
      def template=(val)
        unless val.nil? || ((val.kind_of? String) && !val.to_s.empty?)
          raise ArgumentError, "Template data must be a non empty string."
        end
        @template = val
      end
      
      # Converts a FindAndReplaceBody instance to a hash while converting the attribute names
      # from snake case to camel case.
      # @return [Hash] A hash representing the FindAndReplaceBody instance.
      def to_camelized_hash
        return {
          "findAndReplaceData" => @find_and_replace_data,
          "template" => @template,
          "mergeSettings" => @merge_settings
        }
      end      
    end
  end
end

