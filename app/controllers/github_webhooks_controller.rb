class GithubWebhooksController < ApplicationController
  include GithubWebhook::Processor
  include GithubConfig

  delegate :valid_action?, 
           :supported_action?,
           :handler_for_pull_request_event, to: :pull_request_manager

  def pull_request(payload)
    action = payload['action']
    if valid_action?(action)
      handle_valid_pull_request_event(action, payload)
      head(:ok)
    else
      render_invalid_action_error(action)
    end
  end

  def webhook_secret(payload)
    github_webhook_secret
  end

  private

    def pull_request_manager
      @pull_request_manager ||= PullRequestEventManager.new
    end

    def handle_valid_pull_request_event(action, payload)
      if supported_action?(action)
        handler_for_pull_request_event(action, payload).handle_event
      else
        message = "Ignoring pull request event with action " + 
                  "#{action} for repository "                +
                  "#{payload['repository']['full_name']}"
        logger.debug(message)
      end
    end

    def render_invalid_action_error(action)
      render status: :bad_request, json: { message: "invalid action #{action}" }
    end

end