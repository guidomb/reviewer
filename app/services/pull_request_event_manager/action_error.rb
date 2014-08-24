class PullRequestEventManager::ActionError < ArgumentError

  attr_reader :action

  def initialize(action)
    super "#{error_type} action #{action}"
    @action = action
  end

  def error_type
    self.class.name.match(/(.*)ActionError/)[1]
  end

end