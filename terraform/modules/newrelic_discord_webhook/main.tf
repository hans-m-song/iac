resource "newrelic_notification_destination" "this" {
  name = var.name
  type = "WEBHOOK"

  property {
    key   = "url"
    value = var.webhook_url
  }
}

resource "newrelic_notification_channel" "this" {
  name           = var.name
  destination_id = newrelic_notification_destination.this.id
  product        = "IINT"
  type           = "WEBHOOK"

  property {
    key   = "payload"
    value = file("${path.module}/payload.tftpl")
  }
}
