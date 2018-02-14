require 'config_plus/version'

module ConfigPlus
  autoload :Attachment, 'config_plus/attachment'
  autoload :Config, 'config_plus/config'
  autoload :DefaultLoaderLogic, 'config_plus/default_loader_logic'
  autoload :ErbYamlLoaderLogic, 'config_plus/erb_yaml_loader_logic'
  autoload :Helper, 'config_plus/helper'
  autoload :Loader, 'config_plus/loader'
  autoload :Merger, 'config_plus/merger'
  autoload :Node, 'config_plus/node'

  class << self
    attr_reader :root

    # Sets up configuration of ++ConfigPlus++ and loads data
    #
    # Set a YAML file path to ++source++ property and you can
    # access its data with ++ConfigPlus.root++.
    #
    #  ConfigPlus.configure do |conf|
    #    conf.source = '/path/to/yaml/file.yml'
    #  end
    #
    # When you set a directory path to ++source++,
    # you get configuration data that is merged every contents
    # of YAML files under the directory you specify.
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
    def generate(options={})
      config.source = options.delete(:from) || options.delete('from')
      options.each do |k, v|
        if config.has_property?(k)
          config.property_set(k, v)
        else
          raise "Unknown configuration property `#{k}'"
        end
      end
      load
    end

    def attach(source, options={})
      meth = [:as, :config_method].lazy.map {|nm|
        options.delete(nm) || options.delete(nm.to_s)
      }.find {|v| v } || :config
      klass = options.delete(:to) || options.delete('to')
      raise unless klass

      conf = self::Config.new
      conf.source = source
      options.each do |k, v|
        conf.has_property?(k) and conf.property_set(k, v) or
          raise "Unknown configuration property `#{k}'"
      end

      hsh = conf.loader.load
      conf.node_model.new(hsh).tap do |tree|
        [klass.singleton_class, klass].each do |obj|
          obj.instance_eval { define_method meth, lambda { tree } }
        end
      end
    end

    protected

    def config
      @config ||= self::Config.new
    end

    private

    # Loads a configuration data as a hash object
    # from files specified with ++source++ or
    # ++root_dir++ settings.
    #
    def load
      hash = config.loader.load
      @root = config.node_model.new(hash)
    end

    def inherited_config_of(klass)
      klass.ancestors.select {|clazz|
        clazz != klass and
        clazz != self and
        clazz.ancestors.include?(self)
      }.reverse.each.inject({}) {|hsh, clazz|
        h = clazz.public_send(self.config.config_method)
        h = self::Helper.config_for(clazz, self.root) unless
          h or h.is_a?(Hash)
        self::Merger.merge(hsh, h)
      }
    end

    def included(base)
      method_name = self.config.config_method
      return unless method_name
      own = self::Helper.config_for(base, self.root)
      inheritance = inherited_config_of(base)

      node_model = config.node_model
      [base, base.singleton_class].each do |obj|
        obj.instance_eval do
          config = inheritance ?
            ::ConfigPlus::Merger.merge(inheritance, own || {}) : own
          config = node_model.new(config)
          define_method method_name, lambda { config }
        end
      end
    end
  end
end
