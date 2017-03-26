module ConfigPlus
  # Configuration of ConfigPlus
  class Config
    def self.default_properties
      {
        config_method: :config,
        extension: nil,
        namespace: nil,
        node_model: Node,
        root_dir: nil,
        source: nil,
        loader_logic: :default,
      }
    end

    def initialize
      self.class.default_properties.each do |k, v|
        instance_variable_set("@#{k}", v)
      end

      setup_attrs
    end

    # returns a new loader instance
    def loader
      Loader.new(self)
    end

    # returns loader class specified by +loader_logic+ property
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
      instance_variable_defined?("@#{name}")
    end

    def property_set(name, value)
      instance_variable_set("@#{name}", value)
    end

    private

    def setup_attrs
      vars = instance_variables.map {|v| v.to_s[1..-1].to_sym }

      singleton_class.instance_exec(methods) do |used|
        attr_writer *vars
        attr_reader *(vars - used)
      end
    end
  end
end
