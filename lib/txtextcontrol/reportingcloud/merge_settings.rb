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

require "txtextcontrol/reportingcloud/document_settings"

module TXTextControl
  module ReportingCloud
  
    # Holds the merge settings needed by the merge method.
    # @attr remove_empty_fields [Boolean] Specifies whether empty fields
    #   should be removed from the template or not.
    # @attr remove_empty_blocks [Boolean] Specifies whether the content of 
    #   empty merge blocks should be removed from the template or not.
    # @attr remove_empty_images [Boolean] Specifies whether images which 
    #   don't have merge data should be removed from the template or not.
    # @attr remove_trailing_whitespace [Boolean] Specifies whether trailing 
    #   whitespace should be removed before saving a document.
    # @attr merge_html [Boolean] Specifies whether field data can contain 
    #   formatted Html content or not. The default value is false. Html 
    #   content must be enclosed in an <html /> tag element. Only active in 
    #   the Merge endpoint.
    # @author Thorsten Kummerow (@thomerow)
    class MergeSettings < DocumentSettings
      attr_accessor :remove_empty_fields
      attr_accessor :remove_empty_blocks
      attr_accessor :remove_empty_images
      attr_accessor :remove_trailing_whitespace
      attr_accessor :merge_html
            
      alias_method :remove_empty_fields?, :remove_empty_fields
      alias_method :remove_empty_blocks?, :remove_empty_blocks
      alias_method :remove_empty_images?, :remove_empty_images
      alias_method :remove_trailing_whitespace?, :remove_trailing_whitespace
      alias_method :merge_html?, :merge_html

      def initialize
        @remove_empty_fields = true
        @remove_empty_blocks = true
        @remove_empty_images = true
        @remove_trailing_whitespace = true
        @merge_html = false
      end 
            
      # Converts a MergeSettings instance to a hash while converting the attribute names
      # from snake case to camel case.
      # @return [Hash] A hash representing the MergeSettings instance.
      def to_camelized_hash
        result = {
          "removeEmptyFields" => @remove_empty_fields,
          "removeEmptyBlocks" => @remove_empty_blocks,
          "removeEmptyImages" => @remove_empty_images,
          "removeTrailingWhitespace" => @remove_trailing_whitespace,
          "mergeHtml" => @merge_html,
        }
        result.merge(super)
      end
    end
  end
end
