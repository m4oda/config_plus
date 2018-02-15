require 'forwardable'

module ConfigPlus
  class Node
    extend Forwardable

    def_delegators :node, :keys, :values, :values_at, :has_key?, :key?, :inspect

    def initialize(hash = nil)
      @node = {}
      self.merge!(hash) if hash
    end

    def [](key)
      value = node.fetch(key.to_s, nil)
      value = node.fetch(key.to_i, nil) if
        value.nil? and key.to_s =~ /\A\d+\z/
      return value if value.is_a?(self.class)

      case value
      when Hash
        node.store(key.to_s, self.class.new(value))
      when Array
        node.store(key.to_s, convert_to_value(value))
      else
        value
      end
    end

    def get(path)
      key, rest = path.split('.', 2)
      return node[key] unless rest
      return nil unless node[key]
      self.class.new(node[key]).get(rest)
    end

    def merge!(hash)
      result = node.merge!(hash)
      hash.keys.each {|k| define_accessor(k) }
      result
    end

    def merge(hash)
      result = node.merge(hash)
      result.instance_eval {
        hash.keys.each {|k| define_accessor(k) }
      }
      result
    end

    def ==(object)
      if object.is_a? self.class
        node == object.__send__(:node)
      else
        node == object
      end
    end

    private

    attr_reader :node

    def convert_to_value(array)
      array.map do |v|
        v.is_a?(Hash) ? self.class.new(v) : v
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
