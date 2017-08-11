module DI::Container
  macro included
    macro register(type, value, context = nil, memoize = false)
      def self.resolve(type : \{{type}}.class)
        @@\{{type.id.gsub(/:/, "_").underscore}} ||= \{{value}}.as(\{{type}})
      end
    end
  end
end
