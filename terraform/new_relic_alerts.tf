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
