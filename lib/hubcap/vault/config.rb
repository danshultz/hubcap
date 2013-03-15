class Hubcap::Vault::Config

  class << self

    def configure(&blk)
      yield(config)
    end


    def reset!
      @@config = new
    end


    def cipher_key(name = nil)
      get_config(name).cipher_key
    end


    def cipher_iv(name = nil)
      get_config(name).cipher_iv
    end


    def store(name = nil)
      get_config(name).store
    end


    protected


    def get_config(name)
      config.bundles[name.to_s] || config
    end


    def config
      @@config ||= new
    end

  end


  attr_accessor :cipher_key, :cipher_iv, :store
  attr_reader :bundles, :name

  
  def initialize(name = "default")
    @name = name
    @bundles = {}
  end


  def define_bundle(name)
    name = name.to_s
    bundle = bundles[name] ||= set_defaults(self.class.new(name))
    yield(bundle)
  end


  def store
    @store ||= default_store
  end


  protected


  def default_store
    Hubcap::Vault::YamlStore.new
  end


  def set_defaults(bundle)
    default_props = [:cipher_key, :cipher_iv, :store]
    default_props.each { |prop|
      bundle.send("#{prop}=", send(prop))
    }
    bundle
  end

end
