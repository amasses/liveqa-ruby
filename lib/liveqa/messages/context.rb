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
          {
            library: library,
            server:  server
          }
        end

        private

        def library
          {
            name:     LiveQA::LIBRARY_NAME,
            language: 'ruby',
            version:  LiveQA::VERSION
          }
        end

        def server
          {
            host: Socket.gethostname,
            pid:  Process.pid
          }
        end

      end
    end
  end
end
