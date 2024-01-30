resource "newrelic_notification_destination" "discord_webhook" {
  name = "Discord - Fite Club - #bot-spam"
  type = "WEBHOOK"

  property {
    key   = "url"
    value = var.discord_webhook_url
  }
}

resource "newrelic_notification_channel" "discord_webhook" {
  name           = newrelic_notification_destination.discord_webhook.name
  destination_id = newrelic_notification_destination.discord_webhook.id
  product        = "IINT"
  type           = "WEBHOOK"

  property {
    key   = "payload"
    value = file("${path.module}/discord_webhook.tftpl")
  }
}

resource "newrelic_workflow" "discord_webhook" {
  name                  = newrelic_notification_channel.discord_webhook.name
  muting_rules_handling = "DONT_NOTIFY_FULLY_MUTED_ISSUES"

  destination {
    channel_id = newrelic_notification_channel.discord_webhook.id
  }

  issues_filter {
    name = "Filter"
    type = "FILTER"

    predicate {
      attribute = "labels.policyIds"
      operator  = "EXACTLY_MATCHES"
      values = [
        newrelic_alert_policy.kubernetes.id,
        newrelic_alert_policy.synthetics.id,
      ]
    }
  }
}
