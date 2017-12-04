module LiveQA
  module AsyncHandlers
    class Base

      def enqueue(*)
        raise LiveQA::MissingImplementation, 'Method \'enqueue\' need to be implemented in a subclass'
      end

      def execute(args)
        klass_name, method, payload, request_options = args

        Object.const_get(klass_name).send(method.to_sym, payload, request_options)
      end

    end
  end
end
