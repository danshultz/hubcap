module Hubcap::Vault
  class << self

    def load(bundle)
      Store.new
    end

  end
end

require 'hubcap/vault/store'

