require('test_helper')
require('rubygems')
require('hubcap/vault')

class Hubcap::TestVault < Test::Unit::TestCase

  Struct.new("VaultStore", :data, :saved_data) {
    def load; data; end
    def save(d); self.saved_data = d; end
  }


  def setup
    @vault = ::Hubcap::Vault.load(:prod) { |config|
      config.cipher_key = "Q6QIWe/tZBvdtT/vgWU74Tx0eDmpFh15jrz/O+bzm60="
      config.cipher_iv  = "qs2ZGxWHmqIDJNaaZgwohg=="
      config.store = @store = Struct::VaultStore.new({})
    }
  end


  def teardown
    @vault = nil
    @backing_store = nil
    Hubcap::Vault::Config.reset!
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


  def test_stores_value_encrypted
    @vault.store(:my_value, "the secret")
    assert_not_equal(@store.data["prod"]["my_value"], "the secret")
  end


  def test_values_are_saved
    assert_not_equal(@store.data, @store.saved_data)
    @vault.store(:my_value, "the secret")
    assert_not_equal(@store.data, @store.saved_data)
    @vault.save
    assert_equal(@store.data, @store.saved_data)
  end

end
