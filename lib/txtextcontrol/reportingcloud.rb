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

require "txtextcontrol/reportingcloud/version"
require_relative "./reportingcloud/reportingcloud.rb"

# The TXTextControl module.
module TXTextControl

  # The ReportingCloud module.
  module ReportingCloud
  
    # Default API base url.
    DEFAULT_BASE_URI = "https://api.reporting.cloud"
    # Default API version.
    DEFAULT_VERSION = "v1"
    # Default http request timeout in seconds.
    DEFAULT_TIMEOUT = 10
    
  end
end
