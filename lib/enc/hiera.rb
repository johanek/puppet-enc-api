module Enc
  class Hiera
    
    def initialize(host, options)
      @config = "#{options[:hieradir]}/#{host}.yaml"
    end
    
    # Returns Hash of parameters
    def params
      begin
        YAML::load(File.open(@config))
      rescue
        {}
      end
    end
    
    # Adds parameters from Hash data['add']['parameters'] to host and writes to disk
    # Returns Hash of parameters that were requested to be added
    def add(data)
      params = self.params
      data['add']['parameters'].each { |k,v|
        params[k] = v
      }
      write(params)
      data['add']['parameters']
    end
    
    # Deletes parameters from Array data['delete']['parameters'] from host and writes to disk
    # Returns Array of parameters that were requested to be deleted
    def delete(data)
      params = self.params
      data['delete']['parameters'].each { |p|
        params.delete(p) if params.has_key?(p)
      }
      write(params)
      data['delete']['parameters']
    end
    
    # Deletes from host all parameters matching class
    # Doesn't return
    def deleteclass(cl)
      params = self.params
      params.delete_if { |k,v| k.to_s.match(/#{cl}::.*/) }
      write(params)
    end
    
    
    private
    
    def write(params)
      File.open(@config, 'w') { |f| f.write(params.to_yaml) }
    end
    
  
  end # Class Hiera
end # Module Enc
