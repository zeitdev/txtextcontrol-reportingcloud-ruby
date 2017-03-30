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
# Copyright: © 2017 Text Control GmbH

require 'txtextcontrol/reportingcloud/merge_field'

module TXTextControl
  module ReportingCloud

    # Represents a merge block in a document template.
    # @attr_reader [String] name The merge block's' name.
    # @attr_reader [Array<MergeBlock>] merge_blocks The merge blocks nested 
    #   inside of the merge block.
    # @attr_reader [Array<MergeField>] merge_fields The merge fields inside 
    #   of the merge block.
    class MergeBlock
      attr_reader :name
      attr_reader :merge_blocks
      attr_reader :merge_fields

      def initialize(name, merge_blocks, merge_fields)
        # Parameter validation
        raise ArgumentError, "Block name must be a string." if !name.kind_of? String
        raise ArgumentError, "Parameter merge_blocks must be an array." if !merge_blocks.kind_of? Array
        raise ArgumentError, "Parameter merge_fields must be an array." if !merge_fields.kind_of? Array

        @name = name
        @merge_blocks = merge_blocks
        @merge_fields = merge_fields
      end

      # Creates an MergeBlock instance from a hash.
      # @param [Hash] hash The hash to try and create an MergeBlock instance from.
      # @return [MergeBlock] A newly created MergeBlock instance.
      def self.from_camelized_hash(hash) 
        # Parameter validation
        raise ArgumentError, "Parameter must be a Hash." if !hash.kind_of? Hash

        name = hash["name"]
        blocks = Array.new
        hash["mergeBlocks"].each do |elem|
          blocks.push(MergeBlock.from_camelized_hash(elem))
        end
        fields = Array.new 
        hash["mergeFields"].each do |elem|
          fields.push(MergeField.from_camelized_hash(elem))
        end
        return MergeBlock.new(name, blocks, fields)
      end      
    end    
  end
end