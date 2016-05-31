require "txtextcontrol/reportingcloud/hashable"

module TXTextControl
  module ReportingCloud
    class MergeSettings < Hashable
      attr_accessor :removeEmptyFields
      attr_accessor :removeEmptyBlocks
      attr_accessor :removeEmptyImages
      attr_accessor :removeTrailingWhitespace
      attr_accessor :author
      attr_accessor :creationDate
      attr_accessor :creatorApplication
      attr_accessor :documentSubject
      attr_accessor :documentTitle
      attr_accessor :lastModificationDate
      attr_accessor :userPassword
            
      def initialize
        @removeEmptyFields = true
        @removeEmptyBlocks = true
        @removeEmptyImages = true
        @removeTrailingWhitespace = true
        
        @author = nil
        @creationDate = nil
        @creatorApplication = nil
        @documentSubject = nil
        @documentTitle = nil
        @lastModificationDate = nil
        @userPassword = nil
      end 
    end
  end
end
