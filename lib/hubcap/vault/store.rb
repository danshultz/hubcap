# Used to store secrets that should be encrypted
class Hubcap::Vault::Store

  def initialize(bundle, config = Hubcap::Vault::Config.config)
    @bundle = bundle.to_s
    yield(config)
    @config = config
    @backing_store = config.store[@bundle]
  end


  def store(k, v)
    encrypted = data(:encrypt, v)
    backing_store.store(k.to_s, encrypted)
  end


  def key?(k)
    backing_store.key?(k.to_s)
  end


  def [](k)
    data(:decrypt, backing_store[k.to_s])
  end


  protected


  # data(:decrypt, "encrypted value")
  # data(:encrypt, "plain text value")
  def data(action, value)
    cipher = get_cipher(cipher_data, action.to_sym)
    '' << cipher.update(value) << cipher.final
  end


  def backing_store
    @backing_store
  end


  def cipher_data
    {
      :cipher_type => 'aes-256-cbc',
      :cipher_key => @config.cipher_key,
      :cipher_iv => @config.cipher_iv,
    }
  end


  def get_cipher(cipher_data, method)
    OpenSSL::Cipher.new(cipher_data[:cipher_type]).tap { |cipher|
      cipher.send(method.to_sym)
      cipher.key = cipher_data[:cipher_key]
      cipher.iv = cipher_data[:cipher_iv]
    }
  end

end
