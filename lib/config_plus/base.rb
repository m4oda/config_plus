module ConfigPlus
  class << self
    attr_reader :root

    # Sets up configuration of ++ConfigPlus++ and loads data
    #
    # When a YAML file path is specified with
    # ++source++ (or ++root_dir++) setting as below,
    # configuration data would be loaded from the file.
    #
    #  ConfigPlus.configure do |conf|
    #    conf.source = '/path/to/yaml/file.yml'
    #  end
    #
    # When a directory path is specified, configuration
    # would be loaded from all YAML files under the
    # specified directory.
    #
    def configure
      yield config if block_given?
      load
    end

    # Sets up configuration of ++ConfigPlus++ and loads data
    #
    # You can describe the following code, when it needs
    # only a single file for a resource of ++ConfigPlus++.
    #
    #  ConfigPlus.generate(from: '/path/to/yaml/file.yml')
    #
    def generate(from: nil, **properties)
      config.source = from if from
      properties.each do |k, v|
        attr = "#{k}="
        config.public_send(attr, v) if config.respond_to? attr
      end
      load
    end

    protected

    def config
      @config ||= ::ConfigPlus::Config.new
    end

    private

    def load
      hash = config.load_source
      @root = ::ConfigPlus::Node.new(hash)
    end
  end

  def self.included(base)
    method_name = self.config.config_method
    return unless method_name
    variable_name = "@#{method_name}"
    helper = ::ConfigPlus::Helper

    [base, base.singleton_class].each do |obj|
      obj.instance_eval do
        define_method method_name, -> {
          config = instance_variable_get(variable_name)
          return config if config
          config = helper.config_for(self, ::ConfigPlus.root)
          instance_variable_set(variable_name, config)
        }
      end
    end
  end
end
