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

    # Represents a ReportingCloud API key object.
    # @attr key [String] The actual API Key that belongs to the account.
    # @attr is_active [Boolean] Specifies whether the API Key is active or not (not used yet).
    # @author Thorsten Kummerow (@thomerow)
    class APIKey
      attr_reader :is_active

      # @param key [String] The actual API Key that belongs to the account.
      # @param is_active [Boolean] Specifies whether the API Key is active or not (not used yet).
      def initialize(key, is_active = true)
        self.key = key
        @is_active = is_active
      end

      def key
        @key
      end

      def key=(val)
        unless val.nil? || ((val.kind_of? String) && !val.to_s.empty?)
          raise ArgumentError, "API key must be a non empty string."
        end
        @key = val
      end

    end
  end
end
