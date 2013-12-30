#!/usr/bin/env ruby

$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
require 'enc'
require 'sinatra/base'
require 'socket'
# require 'webrick'
# require 'webrick/https'
# require 'openssl'

include Enc

class EncApi < Sinatra::Base

  # Config
  opts = Hash.new
  opts[:classdir] = ENV['CLASSDIR'] ? ENV['CLASSDIR'] : '/etc/puppet/classes'
  opts[:hieradir] = ENV['HIERADIR'] ? ENV['HIERADIR'] : '/etc/puppet/hiera'
  opts[:metadatadir] = ENV['METADATADIR'] ? ENV['METADATADIR'] : '/etc/puppet/metadata'
    
  # Authenticate access
  if ENV['APIKEY']
    before do
      error 401 unless params[:apikey] == ENV['APIKEY']
    end
  end
  
  # Return node classification
  get '/node/:node' do
    classify(params[:node], opts)
  end
  
  # Return node parameters
  get '/parameters/:node' do
    parameters(params[:node], opts)
  end
  
  # Update node config
  post '/node/:node' do
    content_type :json
    body_content = request.body.read
    data = (body_content.nil? or body_content.empty?) ? {} : JSON.parse(body_content)
    update(params[:node], opts, data)
  end
  
  # Get list of nodes from puppetdb
  get '/nodes' do
    nodes = Enc::Puppetdb.new
    nodes.host = Socket::gethostname
    nodes.active
  end
  
  # Get classes, parameters and documentation
  get '/classes' do
    metadata(opts)
  end

end # class EncApi

