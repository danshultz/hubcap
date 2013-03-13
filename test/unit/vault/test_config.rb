require 'test_helper'
require 'rubygems'

class Hubcap::TestVaultConfig < Test::Unit::TestCase

  def teardown
    Hubcap::Vault::Config.reset!
  end


  def test_global_config
    assert(!Hubcap::Vault::Config.cipher_iv)
    assert(!Hubcap::Vault::Config.cipher_iv)

    cipher_key = "256 aes key"
    cipher_iv  = "the vector"
    Hubcap::Vault::Config.configure { |config|
      config.cipher_key = cipher_key
      config.cipher_iv  = cipher_iv
    }

    assert_equal(Hubcap::Vault::Config.cipher_key, cipher_key)
    assert_equal(Hubcap::Vault::Config.cipher_iv, cipher_iv)
  end


  def test_bundle_configs
    assert(!Hubcap::Vault::Config.cipher_iv)
    assert(!Hubcap::Vault::Config.cipher_iv)

    cipher_key = "256 aes key"
    cipher_iv  = "the vector"
    Hubcap::Vault::Config.configure { |config|

      config.define_bundle(:prod) { |prod_config|
        prod_config.cipher_key = cipher_key
        prod_config.cipher_iv  = cipher_iv
      }

    }

    assert_equal(Hubcap::Vault::Config.cipher_key(:prod), cipher_key)
    assert_equal(Hubcap::Vault::Config.cipher_iv(:prod), cipher_iv)
  end


  def test_bundle_config_with_defaults
    assert(!Hubcap::Vault::Config.cipher_iv)
    assert(!Hubcap::Vault::Config.cipher_iv)

    default_cipher_key = "256 aes key"
    cipher_iv  = "the vector"
    Hubcap::Vault::Config.configure { |config|
      config.cipher_key = default_cipher_key

      config.define_bundle(:prod) { |prod_config|
        prod_config.cipher_iv  = cipher_iv
      }

    }

    assert_equal(Hubcap::Vault::Config.cipher_key(:prod), default_cipher_key)
    assert_equal(Hubcap::Vault::Config.cipher_iv(:prod), cipher_iv)
  end

end
