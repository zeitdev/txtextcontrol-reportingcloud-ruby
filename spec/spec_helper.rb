$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'txtextcontrol/reportingcloud'
require 'webmock/rspec'

RSpec.configure do |c|
  c.include WebMock::API
end