require 'test_helper'
require 'rubygems'

class Hubcap::TestVaultConfig < Test::Unit::TestCase

  def setup
    assert(!Hubcap::Vault::Config.cipher_iv)
    assert(!Hubcap::Vault::Config.cipher_iv)
  end


  def teardown
    Hubcap::Vault::Config.reset!
  end


  def test_default_config
    cipher_key = "256 aes key"
    cipher_iv  = "the vector"
    Hubcap::Vault::Config.configure { |config|
      config.cipher_key = cipher_key
      config.cipher_iv  = cipher_iv
    }

    assert_equal(Hubcap::Vault::Config.cipher_key, cipher_key)
    assert_equal(Hubcap::Vault::Config.cipher_iv, cipher_iv)

    assert_equal(Hubcap::Vault::Config.cipher_key(:prod), cipher_key)
    assert_equal(Hubcap::Vault::Config.cipher_iv(:prod), cipher_iv)
  end


  def test_bundle_configs
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


  def test_default_file_store
    Hubcap::Vault::Config.configure {}
    assert_equal(Hubcap::Vault::YamlStore, Hubcap::Vault::Config.store.class)
  end


end
