require 'forwardable'

module ConfigPlus
  class Node
    extend Forwardable
    include Enumerable

    def_delegators :node, :keys, :values, :values_at, :has_key?, :key?, :each, :inspect

    def initialize(collection = nil)
      @node = generate_node(collection)
      self.merge!(collection) if hash
    end

    def [](key)
      value = node.fetch(key.to_i, nil) if key.to_s =~ /\A\d+\z/
      value ||= node.fetch(key.to_s, nil) unless data_is_a?(Array)
      return value if value.is_a?(self.class)

      case value
      when Hash, Array
        node.store(key.to_s, self.class.new(value))
      else
        value
      end
    end

    def get(path)
      key, rest = path.split('.', 2)
      return self[key] unless rest
      return nil unless self[key]
      self[key].get(rest)
    end

    def merge!(collection)
      execute_merge(
        collection,
        hash: lambda {|data|
          node.merge!(data).tap {
            data.keys.each {|k| define_accessor(k) }
          }
        },
        array: lambda {|data|
          node.concat(data.map(&method(:convert))).tap {
            node.each_with_index {|_, n| define_accessor(n.to_s) }
          }
        }
      )
    end

    def merge(collection)
      execute_merge(
        collection,
        hash: lambda {|data| self.class.new(node.merge(collection)) },
        array: lambda {|data| self.class.new(node + data.map(&method(:convert))) }
      )
    end

    def ==(object)
      node == data_of(object)
    end

    def data_is_a?(clazz)
      node.is_a?(clazz)
    end

    protected

    attr_reader :node

    private

    def generate_node(collection)
      case collection
      when Hash then {}
      when Array then []
      when self.class
        generate_node(collection.node)
      else
        raise "Cannot accept `#{collection.class}' data"
      end
    end

    def execute_merge(collection, logic)
      data = data_of(collection)
      raise if node.class != data.class

      key = node.class.name.downcase.to_sym
      logic[key].call(data)
    end

    def data_of(collection)
      collection.is_a?(self.class) ? collection.node : collection
    end

    def convert(collection)
      case collection
      when Hash, Array then self.class.new(collection)
      else
        collection
      end
    end

    def define_accessor(method_name)
      return unless method_name.is_a?(String) or
        method_name.is_a?(Symbol)
      return if respond_to?(method_name) or
        private_methods.include?(method_name.to_sym)
      singleton_class.class_exec(self) do |node|
        define_method method_name, lambda { node[method_name] }
      end
    end
  end
end
