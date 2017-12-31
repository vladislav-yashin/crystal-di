module DI::ContainerMixin
  macro included
    macro register(type, value, context = "", memoize = false)
      add_resolve_method(\{{type}}, \{{value}}, \{{context}}, \{{memoize}})
    end

    macro register(type, context = "", memoize = false, &block)
      add_resolve_method(\{{type}}, \{{yield}}, \{{context}}, \{{memoize}})
    end

    private macro add_resolve_method(type, value, context, memoize)
      def self.resolve(type : \{{type}}.class,
        \{% if context == "" %}
          context = nil
        \{% else %}
          context : \{{context}}.class
        \{% end %}
      )
        \{% if memoize %}
          Mutex.new.synchronize do
            @@\{{(type.id + "__" + context.id.stringify).gsub(/:/, "_").underscore}} ||= \{{value}}.as(\{{type}})
          end
        \{% else %}
          \{{value}}.as(\{{type}})
        \{% end %}
      end
    end
  end
end
