module ConfigPlus
  module Attachment
    private

    def attach(source, options={})
      opt = options.merge(to: self) unless options.key?(:to) or options.key('to')
      ::ConfigPlus.attach(source, opt || options)
    end
  end
end
