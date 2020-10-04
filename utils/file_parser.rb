require 'yaml'

module FileParser
  extend self
  def parse file_path
    YAML::load(File.open(file_path))
  end
end
