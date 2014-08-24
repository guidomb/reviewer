class Github::PullRequestEventManager::PullRequestAlreadyOpenedError < StandardError

  attr_reader :number, :repository, :payload

  def initialize(number, repository, payload)
    @number = number
    @payload = payload
    @repository = repository
  end

end