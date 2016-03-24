require 'yaml'

module ConfigPlus
  class Config
    attr_reader :version
    attr_writer :namespace, :root_dir, :source, :loader
    attr_accessor :config_method

    def initialize
      @version = VERSION
      @config_method = :config
      @loader = {}
      @namespace = nil
      @root_dir = nil
      @source = nil
    end

    # loads a configuration data as a hash object
    # from files specified with ++source++ or 
    # ++root_dir++ settings.
    #
    def load_source
      pathes = source_pathes
      raise "No specified `source'" if pathes.empty?
      pathes.each.inject({}) do |h, path|
        hash = load_with_filepath(path)
        hash = hash[@namespace.to_s] if @namespace
        Merger.merge(h, hash)
      end
    end

    protected

    def source_pathes
      Array(@source).map {|s|
        source_path(s)
      }.reverse.uniq.compact.reverse
    end

    def source_path(filepath)
      return filepath unless @root_dir
      return @root_dir unless filepath
      return filepath if filepath.start_with?('/')
      File.join(@root_dir, filepath)
    end

    def load_with_filepath(path)
      return read_file(path) if File.file?(path)
      read_files(path)
    end

    def read_file(filepath)
      loader[:action].call(filepath)
    end

    def read_files(dirpath)
      ext = Array(loader[:extensions]).join(',')
      path = File.join(dirpath, '**', "*.{#{ext}}")
      Dir.glob(path).sort.inject({}) do |h, filepath|
        Merger.merge(h, read_file(filepath))
      end
    end

    def loader
      @loader_setting ||= {
        extensions: [:yml, :yaml],
        action: ->(filepath) {
          content = open(filepath).read
          YAML.load(content).to_hash
        },
      }.merge(@loader)
    end
  end
end
