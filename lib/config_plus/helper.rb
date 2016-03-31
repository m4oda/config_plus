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
        mod = object.is_a?(Module) ? object : object.class
        path = underscore(mod.name)

        [node[mod.name],
         node[path],
         node.get(path),
        ].uniq.compact
      end
    end
  end
end
