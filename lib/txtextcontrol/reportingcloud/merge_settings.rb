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
# Copyright: © 2016 Text Control GmbH

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
    # @attr author [String] The document's author.
    # @attr creation_date [DateTime] The document's creation date.
    # @attr creator_application [String] The application which created the document.
    # @attr document_subject [String] The document's subject.
    # @attr document_title [String] The document's title.
    # @attr last_modification_date [DateTime] The document's last modification date.
    # @attr user_password [String] The password needed to open the document.
    # @author Thorsten Kummerow (@thomerow)
    class MergeSettings
      attr_accessor :remove_empty_fields
      attr_accessor :remove_empty_blocks
      attr_accessor :remove_empty_images
      attr_accessor :remove_trailing_whitespace
      attr_accessor :author
      attr_accessor :creator_application
      attr_accessor :document_subject
      attr_accessor :document_title
      attr_accessor :user_password
            
      def initialize
        @remove_empty_fields = true
        @remove_empty_blocks = true
        @remove_empty_images = true
        @remove_trailing_whitespace = true
        
        @author = nil
        @creation_date = nil
        @creator_application = nil
        @document_subject = nil
        @document_title = nil
        @last_modification_date = nil
        @user_password = nil
      end 
      
      def creation_date
        @creation_date
      end
      
      def creation_date=(val)
        case val
          when nil
            @creation_date = nil
          when String 
            @creation_date = DateTime.iso8601(val)
          when DateTime
            @creation_date = val
          else raise ArgumentError, "Value must be a string or an instance of type DateTime."
        end
      end
      
      def last_modification_date
        @last_modification_date
      end
      
      def last_modification_date=(val)
        case val
          when nil
            @last_modification_date = nil
          when String 
            @last_modification_date = DateTime.iso8601(val)
          when DateTime
            @last_modification_date = val
          else raise ArgumentError, "Value must be a string or an instance of type DateTime."
        end         
      end
      
      # Converts a MergeSettings instance to a hash while converting the attribute names
      # from snake case to camel case.
      # @return [Hash] A hash representing the MergeSettings instance.
      def to_camelized_hash
        return {
          "removeEmptyFields" => @remove_empty_fields,
          "removeEmptyBlocks" => @remove_empty_blocks,
          "removeEmptyImages" => @remove_empty_images,
          "removeTrailingWhitespace" => @remove_trailing_whitespace,
          "author" => @author,
          "creationDate" => @creation_date.nil? ? nil : @creation_date.iso8601,
          "creatorApplication" => @creator_application,
          "documentSubject" => @document_subject,
          "documentTitle" => @document_title,
          "lastModificationDate" => @last_modification_date.nil? ? nil : @last_modification_date.iso8601,
          "userPassword" => @user_password
        }
      end
    end
  end
end
