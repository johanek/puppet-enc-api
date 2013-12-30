require 'enc/version'
require 'enc/rest'
require 'enc/puppetdb'
require 'enc/classes'
require 'enc/hiera'
require 'enc/metadata'
require 'rest-client'
require 'json'
require 'open-uri'
require 'yaml'

module Enc
  
  # Return node classification
  def classify(host, options)
    enc = Enc::Classes.new(host, options)
    classes = enc.classes
    classes.to_yaml
  end
  
  # Process CRUD requests and return info
  def update(host, options = {}, data = {})
    enc = Enc::Classes.new(host, options)
    hiera = Enc::Hiera.new(host, options)
    output = String.new

    if data.has_key?('add')
      if data['add'].has_key?('classes')
        output += "Added the following classes: "
        enc.add(data).each { |x| output += "#{x} " }
      end
      if data['add'].has_key?('parameters')
        output += "Added the following parameters: "
        hiera.add(data).each { |k,v| output += "#{k} = #{v} " }
      end
    end
    
    if data.has_key?('delete')
      if data['delete'].has_key?('classes')
        output += "Deleted the following classes: "
        enc.delete(data).each { |x| output += "#{x} " }
      end
      if data['delete'].has_key?('parameters')
        output += "Deleted the following parameters: "
        hiera.delete(data).each { |x| output += "#{x} " }
      end
    end

    { 'result' => 0, 'status' => 'OK', 'reply' => { 'content' => output } }.to_json
  end
  
  # Lookup hiera parameters - for debugging
  def parameters(host, options)
    hiera = Enc::Hiera.new(host, options)
    params = hiera.params
    params.to_yaml
  end

  # Lookup class metadata
  def metadata(options)
    metadata = Enc::Metadata.new(options)
    content = metadata.content
    content.to_yaml
  end
  
end # Module Enc
