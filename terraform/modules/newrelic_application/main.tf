locals {
  tags = merge(var.tags, {
    "managed-by-terraform"    = "true"
    "terraform:workload-name" = var.name
  })
}

resource "newrelic_workload" "this" {
  name = var.name
  entity_search_query {
    query = "name LIKE '${var.name}%'"
  }
}

resource "newrelic_entity_tags" "workload" {
  guid = newrelic_workload.this.guid
  dynamic "tag" {
    for_each = local.tags
    content {
      key    = tag.key
      values = [tag.value]
    }
  }
}

resource "newrelic_alert_policy" "this" {
  name = var.name
}

resource "newrelic_nrql_alert_condition" "this" {
  for_each  = var.alerts
  name      = "${var.name} - ${each.key}"
  policy_id = newrelic_alert_policy.this.id

  type               = coalesce(each.value.type, "static")
  aggregation_delay  = coalesce(each.value.aggregation_delay, 60)
  aggregation_window = coalesce(each.value.aggregation_window, 60)
  aggregation_method = coalesce(each.value.aggregation_method, "event_flow")

  # expiration_duration            = 0
  # close_violations_on_expiration = true
  evaluation_delay             = each.value.evaluation_delay
  violation_time_limit_seconds = each.value.violation_time_limit_seconds

  nrql {
    query = each.value.query
  }

  dynamic "warning" {
    for_each = each.value.warning != null ? [0] : []
    content {
      operator              = try(warning.value.operator, "above_or_equals")
      threshold             = try(warning.value.threshold, 1)
      threshold_duration    = try(warning.value.threshold_duration, 60)
      threshold_occurrences = try(warning.value.threshold_occurrences, "at_least_once")
    }
  }

  dynamic "critical" {
    for_each = each.value.critical != null ? [0] : []
    content {
      operator              = try(critical.value.operator, "above_or_equals")
      threshold             = try(critical.value.threshold, 1)
      threshold_duration    = try(critical.value.threshold_duration, 60)
      threshold_occurrences = try(critical.value.threshold_occurrences, "at_least_once")
    }
  }
}

resource "newrelic_entity_tags" "nrql_alert_condition" {
  for_each = newrelic_nrql_alert_condition.this
  guid     = each.value.entity_guid
  dynamic "tag" {
    for_each = local.tags
    content {
      key    = tag.key
      values = [tag.value]
    }
  }
}
