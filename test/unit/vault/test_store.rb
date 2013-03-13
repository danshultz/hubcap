require 'test_helper'
require 'rubygems'
require 'hubcap/vault'

class Hubcap::TestVault < Test::Unit::TestCase

  def setup
    @vault = ::Hubcap::Vault.load(:prod)
  end

  def teardown
    @vault = nil
  end

  def test_store_key
    @vault.store(:my_value, "the secret")
    assert(@vault.key?(:my_value))
  end

  def test_get
    value = "the secret"
    @vault.store(:my_value, value)
    assert_equal(@vault[:my_value], value)
  end

end
