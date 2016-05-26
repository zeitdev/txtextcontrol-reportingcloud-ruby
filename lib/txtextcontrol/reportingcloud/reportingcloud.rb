require "uri"
require "net/http"
require "json"

module TXTextControl
  module ReportingCloud
    class ReportingCloud
      attr_accessor :username
      attr_accessor :password
      attr_accessor :uri
      
      def initialize(username, password, url)
        @username = username
        @password = password
        @uri = URI.parse(url)
      end
      
      def listTemplates
        res = get("/v1/templates/list")
        if res.kind_of? Net::HTTPSuccess
          tmplNames = Array.new
          data = JSON.parse(res.body, object_class: OpenStruct)
          data.each do |elem|
            tmplNames.push(elem.Filename)
          end
          return tmplNames
        else
          raise res.body
        end
      end
      
      def getTemplateCount
        res = get("/v1/templates/count")
        if res.kind_of? Net::HTTPSuccess
          return Integer(res.body)
        else
          raise res.body
        end
      end
      
      def getAccountSettings
        res = get("v1/account/settings")
        if res.kind_of? Net::HTTPSuccess
          
        else 
        end
      end
      
      private
      def get(requestUri)
        http = Net::HTTP.new(@uri.host, @uri.port)
        req = Net::HTTP::Get.new(requestUri, initheader = { "Content-Type" => "application/json" })
        req.basic_auth(@username, @password);
        return http.request(req)
      end
      
    end
  end
end