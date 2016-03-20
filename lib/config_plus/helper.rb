module ConfigPlus
  module Helper
    class << self
      def config_for(object, config)
        configs = matched_configs(object, config)
        return configs.first if configs.size <= 1

        if configs.all? {|c| c.is_a? Hash }
          configs.inject(::ConfigPlus::Node.new) {|h, conf|
            ::ConfigPlus::Merger.merge(h, conf)
          }
        else
          configs.inject([]) {|a, conf| a << conf }
        end
      end

      def underscore(name)
        name.gsub(/::/, '.')
          .gsub(/((\A|\b)([A-Z]+))|([A-Z]+)/) do
          next $3.downcase if $3
          "_#{$4.downcase}"
        end
      end

      private

      def matched_configs(object, node)
        klass = object.is_a?(Class) ? object : object.class
        path = underscore(klass.name)

        [node[klass.name],
         node[path],
         node.get(path),
        ].uniq.compact
      end
    end
  end
end
