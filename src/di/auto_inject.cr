module DI::AutoInject(T)
  macro included
    macro finished
      \{% for method in @type.methods.select { |m| m.name == "initialize" } %}
        def self.new(**args)
          new(
            \{% for arg in method.args %}
              \{{arg.name.id}}: args[:\{{arg.name.id}}]? || T.resolve(\{{arg.restriction}}, context: \{{@type}}),
            \{% end %}
          )
        end
      \{% end %}
    end
  end
end
