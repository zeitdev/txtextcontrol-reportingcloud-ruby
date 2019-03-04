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
  
    # Represents an incorrect word in spell checked text.
    # @attr_reader [Integer] length The length of the spelled word.
    # @attr_reader [Integer] start The starting position of a spelled word.
    # @attr_reader [String] text The text of the spelled word.
    # @attr_reader [Boolean] is_duplicate Indicating whether the spelled word is
    #   declared as incorrect, because the previous word has the same text.
    # @attr_reader [String] language Indicating the language the incorrect word 
    #   was spelled.
    # @author Thorsten Kummerow (@thomerow)
    class IncorrectWord
      attr_reader :length
      attr_reader :start
      attr_reader :text
      attr_reader :is_duplicate
      attr_reader :language
      
      alias_method :is_duplicate?, :is_duplicate

      # @param [Integer] length The starting position of a spelled word.
      # @param [Integer] start The starting position of a spelled word.
      # @param [String] text The text of the spelled word.
      # @param [Boolean] is_duplicate Indicating whether the spelled word is
      #   declared as incorrect, because the previous word has the same text.
      # @param [String] language Indicating the language the incorrect word 
      #   was spelled.
      def initialize(length, start, text, is_duplicate, language)
        @length = Integer(length)
        @start = Integer(start)
        @text = text
        @is_duplicate = !!is_duplicate
        @language = language
      end
      
      # Creates an IncorrectWord instance from a hash.
      # @param [Hash] hash The hash to try and create an IncorrectWord instance from.
      # @return [IncorrectWord] A newly created IncorrectWord instance.
      def self.from_camelized_hash(hash)
        l = hash["length"]
        s = hash["start"]
        txt = hash["text"]
        id = hash["isDuplicate"]
        lan = hash["language"]
        return IncorrectWord.new(l, s, txt, id, lan)
      end
    end
  end
end
