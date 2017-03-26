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
      @properties = self.class.default_properties
      setup_attrs
    end

    # returns a new loader instance
    def loader
      Loader.new(self)
    end

    # returns loader class specified by +loader_logic+ property
    def loader_logic
      setting = properties[:loader_logic]
      return setting if setting.is_a?(Class)

      name = ::ConfigPlus::Helper.classify(setting.to_s)
      name = "#{name}LoaderLogic"
      raise "Unknown loader logic named `#{name}'" unless
        ::ConfigPlus::const_defined?(name)
      ::ConfigPlus::const_get(name)
    end

    def version
      VERSION
    end

    def has_property?(name)
      properties.keys.include?(name.to_sym)
    end

    def property_set(name, value)
      properties[name.to_sym] = value
    end

    private

    attr_reader :properties

    def setup_attrs
      singleton_class.instance_exec(methods, properties) do |used, props|
        props.keys.each do |nm|
          define_method "#{nm}=", ->(val) { property_set(nm, val) }
          define_method nm, -> { properties[nm] } unless used.include?(nm)
        end
      end
    end
  end
end
