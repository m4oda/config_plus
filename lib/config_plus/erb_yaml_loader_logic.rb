require 'erb'

module ConfigPlus
  class ErbYamlLoaderLogic < DefaultLoaderLogic
    def load_file(filepath)
      content = open(filepath).read
      content = ERB.new(content).result
      YAML.load(content).to_hash
    end
  end
end
