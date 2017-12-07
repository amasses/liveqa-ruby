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
            request: request,
            user_agent: LiveQA::Store.get(:user_agent),
            ip: LiveQA::Store.get(:ip)
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

        def request
          {
            url: LiveQA::Store.get(:url),
            ssl: LiveQA::Store.get(:ssl),
            host: LiveQA::Store.get(:host),
            port: LiveQA::Store.get(:port),
            path: LiveQA::Store.get(:path),
            referrer: LiveQA::Store.get(:referrer),
            method: LiveQA::Store.get(:request_method),
            xhr: LiveQA::Store.get(:xhr)
          }
        end

        def server
          {
            host: Socket.gethostname,
            pid: Process.pid
          }
        end

      end
    end
  end
end
