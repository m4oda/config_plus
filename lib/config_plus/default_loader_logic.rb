require 'yaml'

module ConfigPlus
  # This loader reads configuration from the specified
  # a YAML file with its ++load_from++ method.
  # When a directory is specified this recurses a file
  # tree and reads all YAML files.
  #
  class DefaultLoaderLogic
    def initialize(extension)
      @extension = extension || [:yml, :yaml]
    end

    def load_from(path)
      raise Errno::ENOENT, "No such file or directory: `#{path}'" unless File.exist?(path)
      return load_file(path) if File.file?(path)
      load_dir(path)
    end

    private

    attr_reader :extension

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
