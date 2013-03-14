class Hubcap::Vault::YamlStore

  attr_reader :file_name


  def initialize(file_name=nil)
    @file_name = file_name || ".vault_data"
  end


  def load
    Yaml.load(file_name) || {}
  end

  
  def save(data)
    Yaml.dump(data, File.open(file_name, "w+"))
  end

end
