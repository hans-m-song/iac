output "workload_guid" {
  value = newrelic_workload.this.guid
}

output "alert_policy_id" {
  value = newrelic_alert_policy.this.id
}
