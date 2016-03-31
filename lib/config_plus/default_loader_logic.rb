require 'yaml'

module ConfigPlus
  class DefaultLoaderLogic
    def initialize(config)
      @config = config
    end

    def extension
      @config.extension || [:yml, :yaml]
    end

    def load_from(path)
      return load_file(path) if File.file?(path)
      load_dir(path)
    end

    def load_file(filepath)
      content = open(filepath).read
      YAML.load(content).to_hash
    end

    def load_dir(dirpath)
      ext = Array(extension).join(',')
      path = File.join(dirpath, '**', "*.{#{ext}}")
      Dir.glob(path).sort.inject({}) {|h, filepath|
        Merger.merge(h, load_file(filepath))
      }
    end
  end
end
