module Hubcap::Vault
  class << self

    def load(bundle = nil, &blk)
      if bundle && block_given?
        Hubcap::Vault::Config.configure { |c| c.define_bundle(bundle, &blk) }
      elsif block_given?
        Hubcap::Vault::Config.configure(&blk)
      end

      Store.new(bundle)
    end

  end
end

require 'hubcap/vault/config'
require 'hubcap/vault/store'

