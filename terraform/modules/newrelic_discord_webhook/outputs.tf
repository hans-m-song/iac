output "destination_id" {
  value = newrelic_notification_destination.this.id
}

output "channel_id" {
  value = newrelic_notification_channel.this.id
}
