require 'forwardable'

module ConfigPlus
  class Collection
    extend Forwardable

    def_delegators :data,
                   :each,
                   :include?,
                   :inspect,
                   :size,
                   :to_a,
                   :to_s,
                   :values_at

    def initialize(collection)
      @hash_data = nil
      @array_data = nil
      data = retrieve_data_out_of(collection)

      case data
      when Hash
        @hash_data = {}
      when Array
        @array_data = []
      else
        raise TypeError, "An argument should be Hash or Array " \
                         "but #{collection.class.name}"
      end
    end

    def [](key)
      self.fetch(key, nil)
    end

    def fetch(*arguments)
      raise ArgumentError if arguments.size > 2 or arguments.empty?
      args = arguments.dup
      args[0] = args[0].to_s

      if array? and args[0] =~ /\A\d+\z/
        args[0] = args[0].to_i
        data.fetch(*args)
      elsif hash?
        v = data.fetch(*args)
        if !v and args[0] =~ /\A\d+\z/
          args[0] = args[0].to_i
          v = data.fetch(*args)
        end
        v
      else
        raise
      end
    end

    def merge(collection)
      raise TypeError, "An argument should be an instance of #{data.class.name}" \
                       " but #{collection.class.name}" if
        self.miss_match?(collection)
      data = retrieve_data_out_of collection

      if hash?
        hash_data.merge(data)
      else
        array_data + data
      end
    end

    def merge!(collection)
      raise TypeError, "An argument should be an instance of #{data.class.name}" \
                       " but #{collection.class.name}" if
        self.miss_match?(collection)
      data = retrieve_data_out_of collection

      if hash?
        hash_data.merge!(data)
      else
        array_data.concat(data)
      end
    end

    def each_key
      if hash?
        hash_data.each_key
      else
        (0...array_data.size).each
      end
    end

    def each_pair
      if hash?
        hash_data.each_pair
      else
        array_data.lazy.with_index.map {|v, n|
          [n, v]
        }.each
      end
    end

    def keys
      if hash?
        hash_data.keys
      else
        Array.new(array_data, &:to_i)
      end
    end

    def key?(val)
      if hash?
        hash_data.key?(val.to_s)
      elsif val.to_s =~ /\A\d+\z/
        val.to_i.between?(0, array_data.size - 1)
      else
        false
      end
    end
    alias :has_key? :key?

    def store(key, val)
      if hash?
        hash_data.store(key.to_s, val)
      elsif key.to_s =~ /\A\d+\z/
        array_data[key.to_i] = val
      end
    end

    def to_hash
      if hash?
        hash_data.to_hash
      else
        Hash.try_convert(data)
      end
    end

    def value?(val)
      if hash?
        hash_data.value?(val)
      else
        array_data.include?(val)
      end
    end
    alias :has_value? :value?

    def values
      if hash?
        hash_data.values
      else
        array_data
      end
    end

    def data
      hash_data || array_data
    end

    def hash?
      !!hash_data
    end

    def array?
      !!array_data
    end

    protected

    def miss_match?(collection)
      data.class != collection.class && !collection.is_a?(self.class)
    end

    private

    attr_reader :hash_data, :array_data

    def retrieve_data_out_of(object)
      case object
      when Hash, Array
        object
      when self.class
        object.data
      else
        raise TypeError, "#{object.class.name} could not be acceptable"
      end
    end

    class << self
      def generate_for(collection)
        new(collection)
      end

      private :new
    end
  end
end
