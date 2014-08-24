class Github::PullRequestEventManager::OpenedPullRequest

  attr_reader :payload

  def initialize(payload)
    @payload = payload
  end

  def handle_event
    unless PullRequest.find_by(number: number, repository: repository_name)
      PullRequest.create!(pull_request_attributes)
    else
      raise pull_request_already_opened_error
    end
  end

  private

    def pull_request_attributes
      extract_pull_request_attributes.merge({
        url: html_url,
        sender: sender, 
        repository: repository_name
      })
    end

    def extract_pull_request_attributes
      attributes = %q(number state title)
      pull_request.select { |k, v| attributes.include?(k) }
    end

    def pull_request
      payload['pull_request']
    end

    def html_url
      payload['pull_request']['html_url']
    end

    def repository_name
      payload['repository']['full_name']
    end

    def sender
      payload['sender']['login']
    end

    def number
      payload['number']
    end

    def pull_request_already_opened_error
      PullRequestAlreadyOpenedError.new(number, repository_name, payload)
    end

end