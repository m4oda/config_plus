module ConfigPlus
  module Single
    private

    def generate_config(source, options={})
      opt = options.merge(to: self) unless options.key?(:to) or options.key('to')
      ::ConfigPlus.single_generate(source, opt || options)
    end
  end
end
