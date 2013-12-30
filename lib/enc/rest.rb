module Enc
  class Rest
 
    attr_accessor :client_cert, :client_key, :ca_cert
    
    def get(uri, accept)
      https = connect(uri)
      https.get :accept => accept
    end

    def put(uri, pson)
      https = connect(uri)
      https.put pson, :content_type => 'text/pson'
    end

    def delete(uri)
      https = connect(uri)
      https.delete :accept => 'pson'
    end

    private
    
    def connect(uri)
      RestClient::Resource.new(
        uri
        # :ssl_client_cert  =>  OpenSSL::X509::Certificate.new(from_file(@client_cert)),
        # :ssl_client_key   =>  OpenSSL::PKey::RSA.new(from_file(@client_key)),
        # :ssl_ca_file      =>  from_file(@ca_cert),
        # :verify_ssl       =>  OpenSSL::SSL::VERIFY_NONE
      )
    end
    
    private
    
    def from_file(filename)
      IO.read(filename)
    rescue Errno::ENOENT
      puts "#{filename} does not exist!"
      exit 1
    end
    
  end
end
