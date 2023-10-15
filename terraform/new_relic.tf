resource "newrelic_nrql_drop_rule" "mqtt_container_logs" {
  action = "drop_data"
  nrql = replace(
    <<-EOT
    FROM Log
    SELECT *
    WHERE
      namespace_name = 'mqtt'
      AND container_name = 'mqtt-broker'
      AND (
        message LIKE '%PUBLISH%'
        OR message LIKE '%PINGREQ%'
        OR message LIKE '%PINGRESP%'
      )
    EOT
  , "/\\s*\n\\s*/", " ")
}

resource "newrelic_nrql_drop_rule" "newrelic_kubelet_cpu_metric_warning" {
  action = "drop_data"
  nrql = replace(
    <<-EOT
    FROM Log
    SELECT *
    WHERE
      namespace_name = 'newrelic'
      AND container_name = 'kubelet'
      AND message LIKE '%cpuLimitCores metric not available. using default max 96 cores%'
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
