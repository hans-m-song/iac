locals {
  cert_check_domains = [
    # "api.minio.k8s.axatol.xyz",
    # "arc.k8s.axatol.xyz",
    # "hass.k8s.axatol.xyz",
    # "minio.k8s.axatol.xyz",
    # "octopus.k8s.axatol.xyz",
  ]

  synthetics_ids = [
    for domain in local.cert_check_domains :
    "'${newrelic_synthetics_cert_check_monitor.this[domain].id}'"
  ]
}

resource "newrelic_alert_policy" "synthetics" {
  name = "Synthetics alerts"
}

resource "newrelic_synthetics_cert_check_monitor" "this" {
  for_each               = toset(local.cert_check_domains)
  name                   = each.value
  domain                 = each.value
  period                 = "EVERY_DAY"
  status                 = "ENABLED"
  certificate_expiration = 3
  locations_public       = ["AP_SOUTHEAST_2"]
}

resource "newrelic_nrql_alert_condition" "synthetic_failures" {
  policy_id                    = newrelic_alert_policy.synthetics.id
  type                         = "static"
  name                         = "Synthetic failures"
  enabled                      = true
  violation_time_limit_seconds = 259200
  fill_option                  = "none"
  aggregation_window           = 60
  aggregation_method           = "event_flow"
  aggregation_delay            = 120

  nrql {
    query = <<-EOT
    FROM SyntheticCheck
    SELECT filter(count(*), WHERE result = 'FAILED') AS 'Failures'
    WHERE entityGuid IN (${join(", ", local.synthetics_ids)})
    FACET monitorName
    EOT
  }

  critical {
    operator              = "above"
    threshold             = 1
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
}
