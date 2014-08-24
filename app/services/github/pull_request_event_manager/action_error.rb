module Github

  module PullRequestEventManager

    class ActionError < ArgumentError

      attr_accesible :action

      def initialize(action)
        super "#{error_type} action #{action}"
        @action = action
      end

      def error_type
        self.class.name.match(/(.*)ActionError/)[1]
      end

    end

    class UnsupportedActionError < ActionError; ; end

    class InvalidActionError < ActionError; ; end 

  end

end