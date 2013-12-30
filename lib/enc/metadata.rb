module Enc
  class Metadata
    
    def initialize(options)
      @config = "#{options[:metadatadir]}/classes.yaml"
    end
    
    # Returns Hash of content
    def content
      begin
        YAML::load(File.open(@config))
      rescue
        {}
      end
    end
    
  end # Class Metadata
end # Module Enc
