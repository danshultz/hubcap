module Hubcap::Vault
  class << self

    def load(bundle, &blk)
      Store.new(bundle, &blk)
    end

  end
end

require 'hubcap/vault/config'
require 'hubcap/vault/store'

