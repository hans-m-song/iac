resource "newrelic_nrql_drop_rule" "kubernetes_logs" {
  action = "drop_data"
  nrql = replace(
    <<-EOT
    FROM Log
    SELECT *
    WHERE
      (
        namespace_name = 'kube-system' 
        AND container_name = 'coredns 
        AND message LIKE '%No files matching import glob pattern%'
      ) OR (
        namespace_name = 'newrelic'
        AND container_name = 'kubelet'
        AND message LIKE '%cpuLimitCores metric not available. using default max 96 cores%'
      )
    EOT
  , "/\\s*\n\\s*/", " ")
}

data "newrelic_test_grok_pattern" "actions_runner_controller_hra" {
  grok = join("\\s", [
    "%%{TIMESTAMP_ISO8601:timestamp}",
    "%%{NOTSPACE:severity}",
    "%%{NOTSPACE:resource}",
    "Calculated desired replicas of %%{INT:replicas}",
    "%%{GREEDYDATA:scaling:json({\"dropOriginal\":true})}",
  ])

  log_lines = [
    "2023-08-12T02:47:49Z DEBUG horizontalrunnerautoscaler Calculated desired replicas of 0 {\"horizontalrunnerautoscaler\": \"actions-runner-system/arc-axatol\", \"suggested\": 0, \"reserved\": 0, \"min\": 0, \"max\": 3}",
    "2023-08-12T02:47:49Z DEBUG horizontalrunnerautoscaler Calculated desired replicas of 0 {\"horizontalrunnerautoscaler\": \"actions-runner-system/arc-hans-m-song-blog\", \"suggested\": 0, \"reserved\": 0, \"min\": 0, \"max\": 3}",
    "2023-08-12T02:47:49Z DEBUG horizontalrunnerautoscaler Calculated desired replicas of 0 {\"horizontalrunnerautoscaler\": \"actions-runner-system/arc-hans-m-song-huisheng\", \"suggested\": 0, \"reserved\": 0, \"min\": 0, \"max\": 3}",
  ]
}

resource "newrelic_log_parsing_rule" "actions_runner_controller_hra" {
  name      = "Actions Runner Controller HRA"
  enabled   = true
  grok      = data.newrelic_test_grok_pattern.actions_runner_controller_hra.grok
  nrql      = "FROM Log SELECT * WHERE namespace_name = 'actions-runner-system' AND container_name = 'manager'"
  lucene    = ""
  attribute = "message"
}

resource "newrelic_alert_policy" "kubernetes" {
  name                = "Kubernetes alerts"
  incident_preference = "PER_CONDITION"
}

module "newrelic_kubernetes_alerts" {
  source    = "./modules/newrelic_kubernetes_alerts"
  policy_id = newrelic_alert_policy.kubernetes.id
}
resource "newrelic_alert_policy" "synthetics" {
  name = "Synthetics alerts"
}

module "newrelic_synthetics" {
  source    = "./modules/newrelic_synthetics"
  policy_id = newrelic_alert_policy.synthetics.id

  cert_check_domains = [
    "api.minio.k8s.axatol.xyz",
    "arc.k8s.axatol.xyz",
    "hass.k8s.axatol.xyz",
    "minio.k8s.axatol.xyz",
    "octopus.k8s.axatol.xyz",
  ]
}

module "newrelic_discord_webhook_fite_club_bot_spam" {
  source      = "./modules/newrelic_discord_webhook"
  name        = "Discord - Fite Club - #bot-spam"
  webhook_url = var.new_relic_discord_webhook_url
}

resource "newrelic_workflow" "discord_fite_club_bot_spam" {
  name                  = "Discord - Fite Club - #bot-spam"
  muting_rules_handling = "DONT_NOTIFY_FULLY_MUTED_ISSUES"

  destination {
    channel_id = module.newrelic_discord_webhook_fite_club_bot_spam.channel_id
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
