module ConfigPlus
  class Loader
    def initialize(config)
      @config = config
    end

    def load
      paths = source_paths
      raise "No specified `source'" if paths.empty?

      paths.each.inject({}) do |h, path|
        hsh = loader_logic.load_from(path)
        hsh = hsh[@config.namespace.to_s] if @config.namespace
        Merger.merge(h, hsh)
      end
    end

    protected

    def loader_logic
      @loader_logic ||= @config.loader_logic.new(@config.extension)
    end

    def source_paths
      Array(@config.source).map {|s|
        source_path(s)
      }.reverse.uniq.compact.reverse
    end

    def source_path(filepath)
      return filepath unless @config.root_dir
      return @config.root_dir unless filepath
      return filepath if filepath.start_with?('/')
      File.join(@config.root_dir, filepath)
    end
  end
end
