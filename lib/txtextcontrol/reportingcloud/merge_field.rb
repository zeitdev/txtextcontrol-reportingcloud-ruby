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

module TXTextControl
  module ReportingCloud

    # Represents a merge field in a document template.
    # @attr_reader [String] date_time_format The format which is applied to
    #   date / time values.
    # @attr_reader [String] name The name of the field.
    # @attr_reader [String] numeric_format The format which is applied to
    #   numeric values.
    # @attr_reader [Boolean] preserve_formatting Specifies whether formatting is
    #   preserverd.
    # @attr_reader [String] text The field text.
    # @attr_reader [String] text_after The text after the field.
    # @attr_reader [String] text_before The text before the field.
    class MergeField
      attr_reader :date_time_format
      attr_reader :name
      attr_reader :numeric_format
      attr_reader :preserve_formatting
      attr_reader :text
      attr_reader :text_after
      attr_reader :text_before

      def initialize(date_time_format, name, numeric_format, preserve_formatting, text, text_after, text_before)
        # Parameter validation
        unless date_time_format.nil? || (date_time_format.kind_of? String)
          raise ArgumentError, "Date / time format must be a string."
        end
        raise ArgumentError, "Field name must be a string." if !name.kind_of? String
        unless numeric_format.nil? || (numeric_format.kind_of? String)
          raise ArgumentError, "Numeric format must be a string"
        end
        raise ArgumentError, "Preserve formatting parameter must be a boolean value." if !!preserve_formatting != preserve_formatting
        raise ArgumentError, "Field text must be a string." if !text.kind_of? String
        raise ArgumentError, "Text after must be a string." if !text_after.nil? && (!text_after.kind_of? String)
        raise ArgumentError, "Text before must be a string." if !text_before.nil? && (!text_before.kind_of? String)

        @date_time_format = date_time_format
        @name = name
        @numeric_format = numeric_format
        @preserve_formatting = preserve_formatting
        @text = text
        @text_after = text_after
        @text_before = text_before
      end

      # Creates an MergeField instance from a hash.
      # @param [Hash] hash The hash to try and create an MergeField instance from.
      # @return [MergeField] A newly created MergeField instance.
      def self.from_camelized_hash(hash) 
        # Parameter validation
        raise ArgumentError, "Parameter must be a Hash." if !hash.kind_of? Hash

        date_time_format = hash["dateTimeFormat"]
        name = hash["name"]
        numeric_format = hash["numericFormat"]
        preserve_formatting = hash["preserveFormatting"]
        text = hash["text"]
        text_after = hash["textAfter"]
        text_before = hash["textBefore"]
        return MergeField.new(date_time_format, name, numeric_format, preserve_formatting, text, text_after, text_before)
      end
    end      
  end
end