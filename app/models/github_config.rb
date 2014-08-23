module GithubConfig
  
  def method_missing(method, *args, &block)
    config_attr = config_attr(method)
    super unless respond_to_config?(config_attr)
    config.send(config_attr)
  end

  def respond_to?(method, include_all = false)
    respond_to_config?(config_attr(method)) || super
  end

  def config
    Rails.application.config.github
  end

  private

    def respond_to_config?(config_attr)
      config_attr && config.respond_to?(config_attr)
    end

    def config_attr(method)
      result = method.to_s.match(/github_(.*)/)
      if result && config.respond_to?(result[1])
        result[1]
      end
    end

end