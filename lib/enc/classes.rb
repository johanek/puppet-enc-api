module Enc
  class Classes
    
    def initialize(host, options)
      @host = host
      @options = options
      @config = "#{options[:classdir]}/#{@host}"
    end
    
    # Returns Hash of classes
    def classes
      begin
        YAML::load(File.open(@config))
      rescue
        # Return basic array if file not found/read
        { 'classes' => nil }
      end
    end
    
    # Adds classes from Array data['add']['classes'] to host and writes to disk
    # Returns Array of classes that were requested to be added
    def add(data)
      classes = self.classes
      # Initialize new host if classes empty
      classes = { 'classes' => {} } if classes['classes'].nil?
      data['add']['classes'].each { |cl|
        classes['classes'][cl] = nil
      }
      write(classes)
      data['add']['classes']
    end
    
    # Deletes classes from Array data['delete']['classes'] from host and writes to disk
    # Calls Enc::Hirea::Deleteclass on each class to remove all related parameters
    # Returns Array of classes that were requested to be deleted
    def delete(data)
      classes = self.classes
      hiera = Enc::Hiera.new(@host, @options)
      data['delete']['classes'].each { |cl|
        classes['classes'].delete(cl)
        hiera.deleteclass(cl)
      }
      write(classes)
      data['delete']['classes']
    end
  
    private
    
    def write(classes)
      File.open(@config, 'w') { |f| f.write(classes.to_yaml) }
    end
  
  end # Class Classes
end # Module Enc