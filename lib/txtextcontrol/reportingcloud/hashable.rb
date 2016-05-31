module TXTextControl
  module ReportingCloud
    class Hashable
      def to_hash
        hash = {}
        self.instance_variables.each do |var|
          varName = var.to_s.delete("@") 
          val = self.instance_variable_get var
          if val.respond_to?(:to_hash)
            hash[varName] = val.to_hash 
          else
            hash[varName] = val
          end
        end
        return hash
      end
    end
  end
end