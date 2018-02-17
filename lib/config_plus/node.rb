require 'forwardable'

module ConfigPlus
  class Node
    extend Forwardable
    include Enumerable

    def_delegators :node,
                   :array?,
                   :each,
                   :each_key,
                   :each_pair,
                   :hash?,
                   :keys,
                   :key?,
                   :has_key?,
                   :to_a,
                   :to_hash,
                   :to_s,
                   :value?,
                   :values,
                   :values_at

    def initialize(collection)
      @node = ::ConfigPlus::Collection.generate_for(collection)
      self.merge!(collection) if hash
    end

    def [](key)
      value = node[key]
      return value if value.is_a?(self.class)

      case value
      when Hash, Array, ::ConfigPlus::Collection
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

    def dig(*keys)
      key = keys.first
      rest = keys[1..-1]
      return self[key] if rest.empty?
      return nil unless self[key]
      self[key].dig(rest)
    end

    def merge(collection)
      self.class.new(node.merge(convert(collection)))
    end

    def ==(object)
      node.data == data_of(object)
    end

    protected

    attr_reader :node

    def merge!(collection)
      node.merge!(convert(collection)).tap {
        node.keys.each {|k| define_accessor(k) }
      }
    end

    private

    def data_of(collection)
      collection.is_a?(self.class) ? collection.node : collection
    end

    def convert(collection)
      case collection
      when Array
        collection.map do |data|
          data.is_a?(Array) || data.is_a?(Hash) ? self.class.new(data) : data
        end
      else
        collection
      end
    end

    def define_accessor(method_name)
      name = method_name.to_s
      return if respond_to?(name) or
        private_methods.include?(name.to_sym)
      singleton_class.class_exec(self) do |node|
        define_method name, lambda { node[method_name] }
      end
    end
  end
end
