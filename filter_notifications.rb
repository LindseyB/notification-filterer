require 'octokit'

API_KEY = ENV['API_KEY']
UNSUBSCRIBE_FILTER_STRINGS = ["grouped deploy branch", "wip"]
PULLS_REGEX = /pulls\/(\d+)/
client = Octokit::Client.new(access_token: API_KEY)

notifications = client.notifications
puts "📧 #{notifications.count} notifications to process"

notifications.each do |notification|
  notification_title = notification.subject.title.downcase
  if UNSUBSCRIBE_FILTER_STRINGS.any? { |filter| notification_title.include?(filter) }
    client.mark_thread_as_read(notification.id)
    client.delete_thread_subscription(notification.id)
    puts "unsubscribed from: #{notification_title}"
  end

  if notification.subject.type == "PullRequest"
    url = notification.subject.url
    if match = url.match(PULLS_REGEX)
      id = match.captures.first.to_i
      pr = client.pull_request(notification.repository.full_name, id)

      if pr.state != "open"
        client.mark_thread_as_read(notification.id)
        client.delete_thread_subscription(notification.id)
        puts "unsubscribed from: #{notification_title}"
      end
      
      if pr.draft
        client.mark_thread_as_read(notification.id)
        puts "marking #{notification_title} as read"
      end
    end
  end
end
