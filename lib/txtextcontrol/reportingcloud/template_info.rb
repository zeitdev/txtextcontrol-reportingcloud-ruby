# ReportingCloud Ruby Wrapper
#
# Official wrapper (authored by Text Control GmbH, publisher of ReportingCloud) to access 
# ReportingCloud in Ruby.
#
# Go to http://www.reporting.cloud to learn more about ReportingCloud
# Go to https://github.com/TextControl/txtextcontrol-reportingcloud-ruby for the 
# canonical source repository.
#
# License: https://raw.githubusercontent.com/TextControl/txtextcontrol-reportingcloud-ruby/master/LICENSE.md
#
# Copyright: © 2019 Text Control GmbH

require 'txtextcontrol/reportingcloud/merge_field'
require 'txtextcontrol/reportingcloud/merge_block'

module TXTextControl
  module ReportingCloud

    # Holds information about the merge blocks and merge fields in a template
    #   in the template storage.
    # @attr_reader template_name [String] The template file name.
    # @attr_reader merge_blocks [Array<MergeBlock>] Contains all top level merge 
    #   blocks in the template.
    # @attr_reader merge_fields [Array<MergeField>] Contains all top level merge 
    #   fields in the template.
    # @author Thorsten Kummerow (@thomerow)
    class TemplateInfo
      attr_reader :template_name
      attr_reader :merge_blocks
      attr_reader :merge_fields

      # @param template_name [String] The template file name.
      # @param merge_blocks [Array<MergeBlock>] The top level merge blocks in the template.
      # @param merge_fields [Array<MergeField>] The top level merge fields in the template.
      def initialize(template_name, merge_blocks, merge_fields)
        # Parameter validation
        raise ArgumentError, "Block name must be a string." if !template_name.kind_of? String
        raise ArgumentError, "Parameter merge_blocks must be an array." if !merge_blocks.kind_of? Array
        raise ArgumentError, "Parameter merge_fields must be an array." if !merge_fields.kind_of? Array

        @template_name = template_name
        @merge_blocks = merge_blocks
        @merge_fields = merge_fields
      end      
      
      # Creates a TemplateInfo instance from a hash.
      # @param hash [Hash] The hash to try and create a TemplateInfo instance from.
      # @return [TemplateInfo] A newly created TemplateInfo instance.
      def self.from_camelized_hash(hash)
        # Parameter validation
        raise ArgumentError, "Parameter must be a Hash." if !hash.kind_of? Hash

        name = hash["templateName"]
        blocks = Array.new
        hash["mergeBlocks"].each do |elem|
          blocks.push(MergeBlock.from_camelized_hash(elem))
        end
        fields = Array.new 
        hash["mergeFields"].each do |elem|
          fields.push(MergeField.from_camelized_hash(elem))
        end
        return TemplateInfo.new(name, blocks, fields)
      end
    end
  end
end