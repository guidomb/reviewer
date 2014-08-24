class PullRequestEventManager

  VALID_ACTIONS = %w(
    assigned
    unassigned
    labeled
    unlabeled
    opened
    closed
  )

  SUPPORTED_ACTIONS = %w(
    opened
  )

  def handle_pull_request_event(action, payload)
    raise InvalidActionError.new(action) unless valid_action?(action)
    raise UnsupportedActionError.new(action) unless supported_action?(action)
    dispatch_pull_request_event(action, payload)
  end

  def valid_action?(action)
    ACTIONS.include?(action)
  end

  def supported_action?(action)
    SUPPORTED_ACTIONS.include?(action)
  end

  private

    def dispatch_pull_request_event(action, payload)
      action_handler(action).handle(payload)
    end

    def action_handler_class(action)
      "#{action.capitalize}PullRequest".constantize
    end

    def action_handler(action)
      action_handler_class(action).new
    end

end