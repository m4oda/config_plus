module ConfigPlus
  class Config
    class << self
      attr_reader :properties

      def prop_accessor(*names)
        @properties ||= []
        @properties.concat(names)
        attr_accessor *names
      end

      private :prop_accessor
    end

    prop_accessor :config_method,
                  :extension,
                  :namespace,
                  :node_model,
                  :root_dir,
                  :source,
                  :loader_logic

    def initialize
      @config_method = :config
      @extension = nil
      @loader_logic = :default
      @namespace = nil
      @node_model = Node
      @root_dir = nil
      @source = nil
    end

    def loader
      Loader.new(self)
    end

    def loader_logic
      return @loader_logic if @loader_logic.is_a?(Class)

      name = ::ConfigPlus::Helper.classify(@loader_logic.to_s)
      name = "#{name}LoaderLogic"
      raise "Unknown loader logic named `#{name}'" unless
        ::ConfigPlus::const_defined?(name)
      ::ConfigPlus::const_get(name)
    end

    def version
      VERSION
    end

    def has_property?(name)
      self.class.properties.include?(name.to_sym)
    end

    def property_set(name, value)
      instance_variable_set("@#{name}", value)
    end
  end
end
