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

  UNSUPPORTED_ACTIONS = VALID_ACTIONS - SUPPORTED_ACTIONS

  def handler_for_pull_request_event(action, payload)
    raise InvalidActionError.new(action) unless valid_action?(action)
    raise UnsupportedActionError.new(action) unless supported_action?(action)
    action_handler(action, payload)
  end

  def valid_action?(action)
    VALID_ACTIONS.include?(action)
  end

  def supported_action?(action)
    SUPPORTED_ACTIONS.include?(action)
  end

  private

    def action_handler_class(action)
      "PullRequestEventManager::#{action.capitalize}PullRequest".constantize
    end

    def action_handler(action, payload)
      action_handler_class(action).new(payload)
    end

end