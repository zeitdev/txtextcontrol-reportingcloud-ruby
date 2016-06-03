require "txtextcontrol/reportingcloud/version"
require_relative "./reportingcloud/reportingcloud.rb"

# ReportingCloud Ruby Wrapper
#
# Official wrapper (authored by Text Control GmbH, publisher of ReportingCloud) to access 
# ReportingCloud in Ruby.
#
# The TXTextControl module.
module TXTextControl

  # The ReportingCloud module.
  module ReportingCloud
  
    # Default API base url.
    DEFAULT_BASE_URI = "http://api.reporting.cloud"
    # Default API version.
    DEFAULT_VERSION = "v1"
    # Default http request timeout in seconds.
    DEFAULT_TIMEOUT = 10
    
  end
end
