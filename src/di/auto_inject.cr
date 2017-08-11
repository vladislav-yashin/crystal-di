module DI::AutoInject(ContainerClass)
  macro included
    macro finished
      def self.new(**args)
        new(
          \{% for arg in @type.methods.find { |m| m.name == "initialize" }.args %}
            \{{arg.name.id}}: args[:\{{arg.name.id}}]? || ContainerClass.resolve(\{{arg.restriction}}),
          \{% end %}
        )
      end
    end
  end
end
