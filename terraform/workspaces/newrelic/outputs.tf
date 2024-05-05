output "discord_notification_destination_id" {
  value = newrelic_notification_destination.discord_webhook.id
}

output "slack_notification_destination_id" {
  value = data.newrelic_notification_destination.slack.id
}
