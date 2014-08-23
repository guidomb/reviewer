class Github

  attr_reader :github_client, :webhook_secret, :webhook_url

  WEBHOOK_NAME = 'web' 

  class MissingOptionError < ArgumentError
    def initialize(option_key)
      super("Option #{option_key} cannot be nil")
    end
  end

  def initialize(github_client, options = {})
    @github_client = validate_github_client(github_client)
    @webhook_secret = extract_option(:webhook_secret, options)
    @webhook_url = extract_option(:webhook_url, options)
  end

  def create_webhooks!(owner, repo_name)
    repo_full_name = "#{owner}/#{repo_name}"
    github_client.create_hook(repo_full_name, WEBHOOK_NAME, 
                              webhooks_config, webhooks_options)
  end

  private

    def validate_github_client(github_client)
      raise InvalidAgumentError, "Github client cannot be nil" unless github_client
      github_client
    end

    def extract_option(option, options)
      value = options[option]
      raise MissingOptionError.new(option) unless value
      value
    end

    def webhooks_events
      @webhooks_events ||= %w(pull_request)
    end

    def webhooks_options
      @webhooks_options ||= {
        events: webhooks_events,
        active: true
      }
    end

    def webhooks_config
      @webhooks_config ||= {
        url: webhook_url,
        content_type: :json,
        secret: webhook_secret,
        insecure_ssl: true
      }
    end

end