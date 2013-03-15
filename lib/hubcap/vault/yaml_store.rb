require('yaml')

class Hubcap::Vault::YamlStore

  attr_reader :file_name


  def initialize(file_name=nil)
    @file_name = file_name || File.join(Dir.pwd, ".vault.yaml")
  end


  def load
    YAML.load(File.open(file_name, "a+")) || {}
  end

  
  def save(data)
    YAML.dump(data, File.open(file_name, "w+"))
  end

end
