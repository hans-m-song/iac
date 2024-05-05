# https://discohook.org
# https://pismute.github.io/Try-Dashbars
# https://app.slack.com/block-kit-builder

locals {
  tags = merge(var.tags, {
    "managed-by-terraform"    = "true"
    "terraform:workflow-name" = var.name
  })
}

resource "newrelic_notification_destination" "this" {
  name = var.name
  type = "WEBHOOK"

  property {
    key   = "url"
    value = var.webhook_url
  }
}

resource "newrelic_entity_tags" "notification_destination" {
  guid = newrelic_notification_destination.this.guid
  dynamic "tag" {
    for_each = local.tags
    content {
      key    = tag.key
      values = [tag.value]
    }
  }
}

resource "newrelic_notification_channel" "this" {
  name           = newrelic_notification_destination.this.name
  destination_id = newrelic_notification_destination.this.id
  product        = "IINT"
  type           = "WEBHOOK"

  property {
    key   = "payload"
    value = file("${path.module}/incident_payload_${var.webhook_format}.tftpl")
  }
}

resource "newrelic_workflow" "this" {
  name                  = newrelic_notification_channel.this.name
  muting_rules_handling = "DONT_NOTIFY_FULLY_MUTED_ISSUES"
  enabled               = true

  destination {
    channel_id = newrelic_notification_channel.this.id
  }

  issues_filter {
    name = "Filter"
    type = "FILTER"

    predicate {
      attribute = "labels.policyIds"
      operator  = "EXACTLY_MATCHES"
      values    = var.policy_ids
    }
  }
}

resource "newrelic_entity_tags" "workflow" {
  guid = newrelic_workflow.this.guid
  dynamic "tag" {
    for_each = local.tags
    content {
      key    = tag.key
      values = [tag.value]
    }
  }
}
