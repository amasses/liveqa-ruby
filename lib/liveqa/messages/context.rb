require 'socket'

module LiveQA
  class Messages
    ##
    # == LiveQA \Messages \Context
    #
    # Return the context for an event
    class Context

      class << self

        def to_h
          Util.deep_compact(
            library: library,
            server: server,
            request: LiveQA::Store.get(:request),
            worker: LiveQA::Store.get(:worker),
            frameworks: LiveQA::Store.get(:frameworks),
            user_agent: LiveQA::Store.get(:user_agent),
            ip: LiveQA::Store.get(:ip),
            environement: LiveQA::Store.get(:environement)
          )
        end

        private

        def library
          {
            name: LiveQA::LIBRARY_NAME,
            language: 'ruby',
            version: LiveQA::VERSION
          }
        end

        def server
          {
            host: Socket.gethostname,
            pid: Process.pid,
            software: LiveQA::Store.get(:server_software)
          }
        end

      end
    end
  end
end
