require 'openssl'

class Hubcap::Vault
    
  class << self

    def load(bundle = nil, &blk)
      if bundle && block_given?
        Hubcap::Vault::Config.configure { |c| c.define_bundle(bundle, &blk) }
      elsif block_given?
        Hubcap::Vault::Config.configure(&blk)
      end

      new(bundle)
    end

  end


  attr_reader :bundle


  def initialize(bundle = "default")
    @bundle = bundle.to_s
  end


  def store(k, v)
    encrypted = data(:encrypt, v)
    bundle_store.store(k.to_s, encrypted)
  end


  def key?(k)
    bundle_store.key?(k.to_s)
  end


  def [](k)
    data(:decrypt, bundle_store[k.to_s])
  end

  def save
    config_store.save(backing_store)
  end


  protected


  # data(:decrypt, "encrypted value")
  # data(:encrypt, "plain text value")
  def data(action, value)
    cipher = get_cipher(cipher_data, action.to_sym)
    '' << cipher.update(value) << cipher.final
  end


  def bundle_store
    @bundle_store ||= (backing_store[@bundle] = backing_store[@bundle] || {})
  end


  def backing_store
    @backing_store ||= config_store.load
  end


  def config_store
    @store ||= config.store(@bundle)
  end


  def cipher_data
    {
      :cipher_type => 'aes-256-cbc',
      :cipher_key => config.cipher_key(bundle),
      :cipher_iv => config.cipher_iv(bundle)
    }
  end


  def get_cipher(cipher_data, method)
    OpenSSL::Cipher.new(cipher_data[:cipher_type]).tap { |cipher|
      cipher.send(method.to_sym)
      cipher.key = cipher_data[:cipher_key]
      cipher.iv = cipher_data[:cipher_iv]
    }
  end


  def config
    Hubcap::Vault::Config
  end

end

require 'hubcap/vault/config'
require 'hubcap/vault/yaml_store'
