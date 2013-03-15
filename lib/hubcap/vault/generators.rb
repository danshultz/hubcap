require('openssl')
require('base64')
require('ostruct')
require('erb')

class Hubcap::Vault::Generators

  class << self

    def iv
      Base64.encode64(cipher.random_iv).strip
    end

    
    def aes_key
      Base64.encode64(cipher.random_key).strip
    end


    def cipher
      OpenSSL::Cipher.new('aes-256-cbc')
    end


    def config
      render(<<-EOL, { :aes_key => aes_key, :iv => iv })
require('hubcap')
require('hubcap/vault')

::Hubcap::Vault::Config.configure { |config|
  config.cipher_key = "<%= aes_key %>"
  config.cipher_iv  = "<%= iv %>"
}
EOL
    end


    def render(template, vars)
      erb = ERB.new(template)
      erb.result(OpenStruct.new(vars).instance_eval { binding  })
    end

  end

end

