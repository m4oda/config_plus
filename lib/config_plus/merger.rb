module ConfigPlus
  module Merger
    MERGER = ->(key, h1, h2) do
      if h1.is_a?(Hash) and h2.is_a?(Hash)
        h1.merge(h2, &MERGER)
      else
        h2
      end
    end

    def self.merge(collection1, collection2)
      return collection2 unless collection1
      return collection1 unless collection2

      if collection1.is_a?(Array) and
          collection2.is_a?(Array)
        collection1.concat(collection2)
      else
        collection1.merge(collection2, &MERGER)
      end
    end
  end
end
