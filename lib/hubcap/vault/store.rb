# Used to store secrets that should be encrypted
class Hubcap::Vault::Store

  def initialize
    @backing_store = Hash.new
  end


  def store(k, v)
    backing_store.store(k, v)
  end


  def key?(k)
    backing_store.key?(k)
  end


  def [](k)
    backing_store[k]
  end


  protected


  def backing_store
    @backing_store
  end

end
