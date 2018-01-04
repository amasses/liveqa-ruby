module LiveQA
  module AsyncHandlers
    class Base

      def enqueue(*)
        raise LiveQA::MissingImplementation, 'Method \'enqueue\' need to be implemented in a subclass'
      end

      def execute(args)
        Object.const_get(args[0]).send(args[1].to_sym, *args[2..-1])
      end

    end
  end
end
