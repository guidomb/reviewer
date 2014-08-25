module GithubWebhooksHelper

  def post_hook_event(action, event, payload)
    json = payload.to_json
    hook_request_headers(event, json).each do |k,v| 
      request.env[to_rack_http_header(k)] = v
    end
    post action, json
  end

  def hook_request_headers(event, payload)
    {
      "X-Github-Event" => event,
      "X-Hub-Signature" => sign_payload(payload),
      "X-Github-Delivery" => rand(1..1000),
      "Content-Type" => "application/json"
    }
  end

  private

    def sign_payload(payload)
      "sha1=#{calculate_hmac_digest(payload)}"
    end

    def calculate_hmac_digest(payload)
      OpenSSL::HMAC.hexdigest(hmac_digest, github_webhook_secret, payload)
    end

    def hmac_digest
      @hmac_digest ||= OpenSSL::Digest.new('sha1')
    end

    def github_webhook_secret
      Rails.application.config.github.webhook_secret
    end

    def to_rack_http_header(header_name)
      "HTTP_#{header_name.upcase.gsub('-','_')}"
    end

end