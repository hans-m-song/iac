locals {
  slack_destination_id    = "dd9b27ba-9f78-4bc5-a0ae-5b63a5896c27"
  alerts_slack_channel_id = "C05QK1T67JA"
}

resource "newrelic_nrql_drop_rule" "kubernetes_logs" {
  action = "drop_data"
  nrql = replace(
    <<-EOT
    FROM Log
    SELECT *
    WHERE
      (
        namespace_name = 'kube-system' 
        AND container_name = 'coredns'
        AND message LIKE '%No files matching import glob pattern%'
      ) OR (
        namespace_name = 'newrelic'
        AND container_name = 'kubelet'
        AND message LIKE '%cpuLimitCores metric not available. using default max 96 cores%'
      ) OR (
        namespace_name = 'mqtt'
        AND container_name = 'mqtt-broker'
        AND (
          message LIKE '%PUBLISH%'
          OR message LIKE '%PINGREQ%'
          OR message LIKE '%PINGRESP%'
        )
      ) OR (
        namespace_name = 'flipt'
        AND grpc.method = 'Check'
        AND grpc.code = 'OK'
      )
    EOT
  , "/\\s*\n\\s*/", " ")
}

data "newrelic_test_grok_pattern" "actions_runner_controller_hra" {
  grok = "%%{TIMESTAMP_ISO8601:timestamp}\\s+%%{NOTSPACE:severity}\\s+%%{NOTSPACE:resource}\\s+Calculated desired replicas of %%{INT:replicas}\\s+%%{GREEDYDATA:scaling:json({\"dropOriginal\":true})}"
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

data "newrelic_test_grok_pattern" "zigbee2mqtt_publish_payload" {
  grok = "Zigbee2MQTT:(?<severity>.*?)\\s+(?<timestamp>.*?):\\s+MQTT publish:\\s+topic\\s+'(?<topic>.*?)',\\s+payload\\s+'%%{DATA:payload:json}'"
  log_lines = [
    "Zigbee2MQTT:info 2024-05-18 13:23:38: MQTT publish: topic 'zigbee2mqtt/Theater', payload '{\"battery\":100,\"humidity\":62.65,\"linkquality\":168,\"temperature\":22.35,\"voltage\":3000}'",
    "Zigbee2MQTT:info 2024-05-18 13:23:38: MQTT publish: topic 'zigbee2mqtt/Theater', payload '{\"battery\":100,\"humidity\":62.51,\"linkquality\":160,\"temperature\":22.35,\"voltage\":3000}'",
    "Zigbee2MQTT:info 2024-05-18 13:25:50: MQTT publish: topic 'zigbee2mqtt/Server Closet', payload '{\"battery_state\":\"medium\",\"humidity\":62,\"linkquality\":255,\"temperature\":23.7,\"temperature_unit\":\"celsius\"}'",
    "Zigbee2MQTT:info 2024-05-18 13:25:50: MQTT publish: topic 'zigbee2mqtt/Server Closet', payload '{\"battery_state\":\"medium\",\"humidity\":63,\"linkquality\":255,\"temperature\":23.7,\"temperature_unit\":\"celsius\"}'",
  ]
}

resource "newrelic_log_parsing_rule" "zigbee2mqtt_publish_payload" {
  name    = "Zigbee2mqtt Publish Payload"
  enabled = true
  grok    = data.newrelic_test_grok_pattern.zigbee2mqtt_publish_payload.grok
  nrql    = "FROM Log SELECT * WHERE container_name = 'zigbee2mqtt'"
  lucene  = ""
}
