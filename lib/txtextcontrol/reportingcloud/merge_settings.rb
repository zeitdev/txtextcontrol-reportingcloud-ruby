module TXTextControl
  module ReportingCloud
    class MergeSettings
      attr_accessor :remove_empty_fields
      attr_accessor :remove_empty_blocks
      attr_accessor :remove_empty_images
      attr_accessor :remove_trailing_whitespace
      attr_accessor :author
      attr_accessor :creation_date
      attr_accessor :creator_application
      attr_accessor :document_subject
      attr_accessor :document_title
      attr_accessor :last_modification_date
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
      
      # Converts a MergeSettings instance to a hash while converting the attribute names
      # from snake case to camel case.
      # @return [Hash] A hash representing the MergeSettings instance.
      def to_camelized_hash
        return {
          :removeEmptyFields => @remove_empty_fields,
          :removeEmptyBlocks => @remove_empty_blocks,
          :removeEmptyImages => @remove_empty_images,
          :removeTrailingWhitespace => @remove_trailing_whitespace,
          :author => @author,
          :creationDate => @creation_date,
          :creatorApplication => @creator_application,
          :documentSubject => @document_subject,
          :documentTitle => @document_title,
          :lastModificationDate => @last_modification_date,
          :userPassword => @user_password
        }
      end
    end
  end
end
