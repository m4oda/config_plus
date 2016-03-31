module ConfigPlus
  class Config
    attr_accessor :config_method,
                  :extension,
                  :namespace,
                  :root_dir,
                  :source
    attr_reader :version
    attr_writer :loader_logic

    def initialize
      @version = VERSION
      @config_method = :config
      @extension = nil
      @loader_logic = :default
      @namespace = nil
      @root_dir = nil
      @source = nil
    end

    def loader
      Loader.new(self)
    end

    def loader_logic
      name = @loader_logic.to_s.capitalize
      name = "#{name}LoaderLogic"
      raise "Unknown loader logic named `#{name}'" unless
        ConfigPlus::const_defined?(name)
      ConfigPlus::const_get(name)
    end
  end
end
