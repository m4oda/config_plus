module ConfigPlus
  class Node < Hash
    def initialize(hash = nil)
      node = super()
      node.merge!(hash) if hash
    end

    def [](key)
      value = self.fetch(key.to_s, nil)
      value = self.fetch(key.to_i, nil) if
        value.nil? and key.to_s =~ /\A\d+\z/
      return value unless value.is_a?(Hash)
      return value if value.is_a?(self.class)

      self.store(key.to_s, self.class.new(value))
    end

    def get(path)
      key, rest = path.split('.', 2)
      return self[key] unless rest
      return nil unless self[key]
      self[key].get(rest)
    end

    def merge!(hash)
      result = super
      hash.keys.each {|k| define_accessor(k) }
      result
    end

    def merge(hash)
      result = super
      result.instance_eval {
        hash.keys.each {|k| define_accessor(k) }
      }
      result
    end

    private

    def define_accessor(method_name)
      return unless method_name.is_a?(String) or
        method_name.is_a?(Symbol)
      return if respond_to?(method_name) or
        private_methods.include?(method_name.to_sym)
      singleton_class.class_eval do
        define_method method_name, -> { self[method_name] }
      end
    end
  end
end
