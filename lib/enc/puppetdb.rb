module Enc
  class Puppetdb
    
    attr_accessor :host
    
    # Returns JSON encoded array of active nodes in puppetdb
    def active
      rest = Enc::Rest.new
      url = %(http://#{@host}:8080/nodes?query=[\"=\", [\"node\", \"active\"], true])
      rest.get(URI::encode(url), :json)
    end 
  
  end # Class Puppetdb
end # Module Enc