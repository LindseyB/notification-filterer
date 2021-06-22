require 'octokit'

UNSUBSCRIBE_FILTER_STRINGS = ["grouped deploy branch", "wip"]
PULLS_REGEX = /pulls\/(\d+)/
client = Octokit::Client.new(access_token: ENV["API_KEY"])


notifications = client.notifications
puts "📧 #{notifications.count} notifications to process"

notifications.each do |notification|
  notification_title = notification.subject.title.downcase
  if UNSUBSCRIBE_FILTER_STRINGS.any? { |filter| notification_title.include?(filter) }
    client.delete_thread_subscription(notification.id)
  end

  if notification.subject.type == "PullRequest"
    url = notification.subject.url
    if match = url.match(PULLS_REGEX)
      id = match.captures.first.to_i
      pr = client.pull_request(notification.repository.full_name, id)

      if pr.state != "open"
        client.delete_thread_subscription(notification.id)
      end
    end
  end
end
