# resource "newrelic_nrql_alert_condition" "container_cpu_throttling_is_high" {
#   name                           = "Container cpu throttling is high"
#   description                    = "Alert when container is being throttled > 25% of the time for more than 5 minutes"
#   policy_id                      = var.policy_id
#   aggregation_delay              = "60"
#   aggregation_method             = "EVENT_FLOW"
#   close_violations_on_expiration = true
#   expiration_duration            = 300
#   slide_by                       = 60
#   violation_time_limit_seconds   = 21600

#   critical {
#     operator              = "above"
#     threshold             = 90
#     threshold_duration    = 300
#     threshold_occurrences = "all"
#   }

#   nrql {
#     query = <<-EOT
#     FROM K8sContainerSample
#     SELECT sum(containerCpuCfsThrottledPeriodsDelta) / sum(containerCpuCfsPeriodsDelta) * 100
#     FACET containerName, podName, namespaceName, clusterName
#     EOT
#   }
# }

# resource "newrelic_nrql_alert_condition" "container_high_cpu_utilization" {
#   name                           = "Container high cpu utilization"
#   description                    = "Alert when the average container cpu utilization (vs. Limit) is > 90% for more than 5 minutes"
#   policy_id                      = var.policy_id
#   aggregation_delay              = "60"
#   aggregation_method             = "EVENT_FLOW"
#   close_violations_on_expiration = true
#   expiration_duration            = 300
#   slide_by                       = 60
#   violation_time_limit_seconds   = 21600

#   critical {
#     operator              = "above"
#     threshold             = 90
#     threshold_duration    = 300
#     threshold_occurrences = "all"
#   }

#   nrql {
#     query = <<-EOT
#     FROM K8sContainerSample
#     SELECT average(cpuCoresUtilization)
#     FACET containerName, podName, namespaceName, clusterName
#     EOT
#   }
# }

# resource "newrelic_nrql_alert_condition" "container_high_memory_utilization" {
#   name                           = "Container high memory utilization"
#   description                    = "Alert when the average container memory utilization (vs. Limit) is > 90% for more than 5 minutes"
#   policy_id                      = var.policy_id
#   aggregation_delay              = "60"
#   aggregation_method             = "EVENT_FLOW"
#   close_violations_on_expiration = true
#   expiration_duration            = 300
#   slide_by                       = 60
#   violation_time_limit_seconds   = 21600

#   critical {
#     operator              = "above"
#     threshold             = 90
#     threshold_duration    = 300
#     threshold_occurrences = "all"
#   }

#   nrql {
#     query = <<-EOT
#     FROM K8sContainerSample
#     SELECT average(memoryWorkingSetUtilization)
#     FACET containerName, podName, namespaceName, clusterName
#     EOT
#   }
# }

resource "newrelic_nrql_alert_condition" "container_is_restarting" {
  name                           = "Container is Restarting"
  description                    = "Alert when the container restart count is greater than 0 in a sliding 5 minute window"
  policy_id                      = var.policy_id
  aggregation_delay              = "60"
  aggregation_method             = "EVENT_FLOW"
  close_violations_on_expiration = true
  expiration_duration            = 300
  slide_by                       = 60
  violation_time_limit_seconds   = 21600

  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  nrql {
    query = <<-EOT
    FROM K8sContainerSample
    SELECT sum(restartCountDelta)
    FACET containerName, podName, namespaceName, clusterName
    EOT
  }
}

resource "newrelic_nrql_alert_condition" "container_is_waiting" {
  name                           = "Container is Waiting"
  description                    = "Alert when a container is Waiting for more than 5 minutes"
  policy_id                      = var.policy_id
  aggregation_delay              = "60"
  aggregation_method             = "EVENT_FLOW"
  close_violations_on_expiration = true
  expiration_duration            = 300
  violation_time_limit_seconds   = 21600

  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  nrql {
    query = <<-EOT
    FROM K8sContainerSample
    SELECT uniqueCount(podName)
    WHERE status = 'Waiting'
    FACET containerName, podName, namespaceName, clusterName
    EOT
  }
}

resource "newrelic_nrql_alert_condition" "daemonset_is_missing_pods" {
  name                           = "Daemonset is missing Pods"
  description                    = "Alert when Daemonset is missing Pods for > 5 minutes"
  policy_id                      = var.policy_id
  aggregation_delay              = "60"
  aggregation_method             = "EVENT_FLOW"
  close_violations_on_expiration = true
  expiration_duration            = 300
  violation_time_limit_seconds   = 21600

  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  nrql {
    query = <<-EOT
    FROM K8sDaemonsetSample
    SELECT latest(podsMissing)
    FACET daemonsetName, namespaceName, clusterName
    EOT
  }
}

resource "newrelic_nrql_alert_condition" "deployment_is_missing_pods" {
  name                           = "Deployment is missing Pods"
  description                    = "Alert when Deployment is missing Pods for > 5 minutes"
  policy_id                      = var.policy_id
  aggregation_delay              = "60"
  aggregation_method             = "EVENT_FLOW"
  close_violations_on_expiration = true
  expiration_duration            = 300
  violation_time_limit_seconds   = 21600

  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  nrql {
    query = <<-EOT
    FROM K8sDeploymentSample
    SELECT latest(podsMissing)
    FACET deploymentName, namespaceName, clusterName
    EOT
  }
}

resource "newrelic_nrql_alert_condition" "etcd_file_descriptor_utilization_is_high" {
  name                           = "Etcd file descriptor utilization is high"
  description                    = "Alert when Etcd file descriptor utilization is > 90% for more than 5 minutes"
  policy_id                      = var.policy_id
  aggregation_delay              = "60"
  aggregation_method             = "EVENT_FLOW"
  close_violations_on_expiration = true
  expiration_duration            = 300
  violation_time_limit_seconds   = 21600

  critical {
    operator              = "below"
    threshold             = 1
    threshold_duration    = 60
    threshold_occurrences = "all"
  }

  nrql {
    query = <<-EOT
    FROM K8sEtcdSample
    SELECT max(processFdsUtilization)
    FACET displayName, clusterName
    EOT
  }
}

resource "newrelic_nrql_alert_condition" "etcd_has_no_leader" {
  name                           = "Etcd has no leader"
  description                    = "Alert when Etcd has no leader for more than 1 minute"
  policy_id                      = var.policy_id
  aggregation_delay              = "60"
  aggregation_method             = "EVENT_FLOW"
  close_violations_on_expiration = true
  expiration_duration            = 300
  violation_time_limit_seconds   = 21600

  critical {
    operator              = "below"
    threshold             = 1
    threshold_duration    = 60
    threshold_occurrences = "all"
  }

  nrql {
    query = <<-EOT
    FROM K8sEtcdSample
    SELECT min(etcdServerHasLeader)
    FACET displayName, clusterName
    EOT
  }
}

resource "newrelic_nrql_alert_condition" "hpa_current_replicas_desired_replicas" {
  name                           = "HPA current replicas < desired replicas"
  description                    = "Alert when a Horizontal Pod Autoscaler's current replicas < desired replicas for > 5 minutes"
  policy_id                      = var.policy_id
  aggregation_delay              = "60"
  aggregation_method             = "EVENT_FLOW"
  close_violations_on_expiration = true
  expiration_duration            = 300
  violation_time_limit_seconds   = 21600

  nrql {
    query = <<-EOT
    FROM K8sHpaSample
    SELECT latest(desiredReplicas - currentReplicas)
    FACET displayName, namespaceName, clusterName
    EOT
  }

  warning {
    operator              = "equals"
    threshold             = 0
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
}

resource "newrelic_nrql_alert_condition" "hpa_has_reached_maximum_replicas" {
  name                           = "HPA has reached maximum replicas"
  description                    = "Alert when a Horizontal Pod Autoscaler has reached its maximum replicas for > 5 minutes"
  policy_id                      = var.policy_id
  aggregation_delay              = "60"
  aggregation_method             = "EVENT_FLOW"
  close_violations_on_expiration = true
  expiration_duration            = 300
  violation_time_limit_seconds   = 21600

  nrql {
    query = <<-EOT
    FROM K8sHpaSample
    SELECT latest(maxReplicas - currentReplicas)
    FACET displayName, namespaceName, clusterName
    EOT
  }

  warning {
    operator              = "equals"
    threshold             = 0
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
}

resource "newrelic_nrql_alert_condition" "job_failed" {
  name                           = "Job Failed"
  description                    = "Alert when a Job reports a failed status"
  policy_id                      = var.policy_id
  aggregation_delay              = "60"
  aggregation_method             = "EVENT_FLOW"
  close_violations_on_expiration = true
  expiration_duration            = 300
  violation_time_limit_seconds   = 21600

  nrql {
    query = <<-EOT
    FROM K8sJobSample
    SELECT uniqueCount(jobName)
    WHERE failed = 'true'
    FACET jobName, namespaceName, clusterName, failedPodsReason
    EOT
  }

  warning {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 60
    threshold_occurrences = "at_least_once"
  }
}

# resource "newrelic_nrql_alert_condition" "more_than_5_pods_failing_in_namespace" {
#   name                           = "More than 5 pods failing in namespace"
#   description                    = "AAlert when more than 5 pods are failing in a namespace for more than 5 minutes"
#   policy_id                      = var.policy_id
#   aggregation_delay              = "60"
#   aggregation_method             = "EVENT_FLOW"
#   close_violations_on_expiration = true
#   expiration_duration            = 300
#   violation_time_limit_seconds   = 21600

#   critical {
#     operator              = "above"
#     threshold             = 0
#     threshold_duration    = 300
#     threshold_occurrences = "all"
#   }

#   nrql {
#     query = <<-EOT
#     FROM K8sPodSample
#     SELECT uniqueCount(podName)
#     WHERE status = 'Failed'
#     FACET namespaceName, clusterName
#     EOT
#   }
# }

resource "newrelic_nrql_alert_condition" "node_allocatable_cpu_utilization_is_high" {
  name                           = "Node allocatable cpu utilization is high"
  description                    = "Alert when the average Node allocatable cpu utilization is > 90% for more than 5 minutes"
  policy_id                      = var.policy_id
  aggregation_delay              = "60"
  aggregation_method             = "EVENT_FLOW"
  close_violations_on_expiration = true
  expiration_duration            = 900
  slide_by                       = 60
  violation_time_limit_seconds   = 21600

  critical {
    operator              = "above"
    threshold             = 90
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  nrql {
    query = <<-EOT
    FROM K8sNodeSample
    SELECT average(allocatableCpuCoresUtilization)
    FACET nodeName, clusterName
    EOT
  }
}

resource "newrelic_nrql_alert_condition" "node_allocatable_memory_utilization_is_high" {
  name                           = "Node allocatable memory utilization is high"
  description                    = "Alert when the average Node allocatable memory utilization is > 90% for more than 5 minutes"
  policy_id                      = var.policy_id
  aggregation_delay              = "60"
  aggregation_method             = "EVENT_FLOW"
  close_violations_on_expiration = true
  expiration_duration            = 900
  slide_by                       = 60
  violation_time_limit_seconds   = 21600

  critical {
    operator              = "above"
    threshold             = 90
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  nrql {
    query = <<-EOT
    FROM K8sNodeSample
    SELECT average(allocatableMemoryUtilization)
    FACET nodeName, clusterName
    EOT
  }
}

# resource "newrelic_nrql_alert_condition" "node_is_not_ready" {
#   name                           = "Node is not ready"
#   description                    = "Alert when a Node is not ready for > 5 minutes"
#   policy_id                      = var.policy_id
#   aggregation_delay              = "60"
#   aggregation_method             = "EVENT_FLOW"
#   close_violations_on_expiration = true
#   expiration_duration            = 300
#   violation_time_limit_seconds   = 21600

#   critical {
#     operator              = "below"
#     threshold             = 1
#     threshold_duration    = 300
#     threshold_occurrences = "all"
#   }

#   nrql {
#     query = <<-EOT
#     FROM K8sNodeSample
#     SELECT latest(condition.Ready)
#     FACET nodeName, clusterName
#     EOT
#   }
# }

# resource "newrelic_nrql_alert_condition" "node_is_unschedulable" {
#   name                           = "Node is unschedulable"
#   description                    = "Alert when Node has been marked as unschedulable"
#   policy_id                      = var.policy_id
#   aggregation_delay              = "60"
#   aggregation_method             = "EVENT_FLOW"
#   close_violations_on_expiration = true
#   expiration_duration            = 900
#   violation_time_limit_seconds   = 21600

#   nrql {
#     query = <<-EOT
#     FROM K8sNodeSample
#     SELECT latest(unschedulable)
#     FACET nodeName, clusterName
#     EOT
#   }

#   warning {
#     operator              = "above"
#     threshold             = 0
#     threshold_duration    = 300
#     threshold_occurrences = "all"
#   }
# }

# resource "newrelic_nrql_alert_condition" "node_pod_count_nearing_capacity" {
#   name                           = "Node Pod count nearing capacity"
#   description                    = "Alert when the Running pod count on a Node is > 90% of the Node's Pod Capacity for more than 5 minutes"
#   policy_id                      = var.policy_id
#   aggregation_delay              = "60"
#   aggregation_method             = "EVENT_FLOW"
#   close_violations_on_expiration = true
#   expiration_duration            = 300
#   violation_time_limit_seconds   = 21600

#   nrql {
#     query = <<-EOT
#     FROM K8sPodSample, K8sNodeSample
#     SELECT ceil(filter(uniqueCount(podName), where status = 'Running') / latest(capacityPods) * 100) as 'Pod Capacity %'
#     WHERE nodeName != '' and nodeName is not null
#     FACET nodeName, clusterName
#     EOT
#   }

#   warning {
#     operator              = "above"
#     threshold             = 90
#     threshold_duration    = 300
#     threshold_occurrences = "all"
#   }
# }

# resource "newrelic_nrql_alert_condition" "node_root_file_system_capacity_utilization_is_high" {
#   name                           = "Node root file system capacity utilization is high"
#   description                    = "Alert when the average Node root file system capacity utilization is > 90% for more than 5 minutes"
#   policy_id                      = var.policy_id
#   aggregation_delay              = "60"
#   aggregation_method             = "EVENT_FLOW"
#   close_violations_on_expiration = true
#   expiration_duration            = 900
#   slide_by                       = 60
#   violation_time_limit_seconds   = 21600

#   critical {
#     operator              = "above"
#     threshold             = 90
#     threshold_duration    = 300
#     threshold_occurrences = "all"
#   }

#   nrql {
#     query = <<-EOT
#     FROM K8sNodeSample
#     SELECT average(fsCapacityUtilization)
#     FACET nodeName, clusterName
#     EOT
#   }
# }

resource "newrelic_nrql_alert_condition" "persistent_volume_has_errors" {
  name                           = "Persistent Volume has errors"
  description                    = "Alert when Persistent Volume is in a Failed or Pending state for more than 5 minutes"
  policy_id                      = var.policy_id
  aggregation_delay              = "60"
  aggregation_method             = "EVENT_FLOW"
  close_violations_on_expiration = true
  expiration_duration            = 300
  violation_time_limit_seconds   = 21600

  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  nrql {
    query = <<-EOT
    FROM K8sPersistentVolumeSample
    SELECT uniqueCount(volumeName)
    WHERE statusPhase in ('Failed','Pending')
    FACET volumeName, clusterName
    EOT
  }
}

resource "newrelic_nrql_alert_condition" "pod_cannot_be_scheduled" {
  name                           = "Pod cannot be scheduled"
  description                    = "Alert when a Pod cannot be scheduled for more than 5 minutes"
  policy_id                      = var.policy_id
  aggregation_delay              = "60"
  aggregation_method             = "EVENT_FLOW"
  close_violations_on_expiration = true
  expiration_duration            = 300
  violation_time_limit_seconds   = 21600

  critical {
    operator              = "below"
    threshold             = 1
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  nrql {
    query = <<-EOT
    FROM K8sPodSample
    SELECT latest(isScheduled)
    FACET podName, namespaceName, clusterName
    EOT
  }
}

resource "newrelic_nrql_alert_condition" "pod_is_not_ready" {
  name                           = "Pod is not ready"
  description                    = "Alert when a Pod is not ready for > 5 minutes"
  policy_id                      = var.policy_id
  aggregation_delay              = "60"
  aggregation_method             = "EVENT_FLOW"
  close_violations_on_expiration = true
  expiration_duration            = 300
  violation_time_limit_seconds   = 21600

  critical {
    operator              = "below"
    threshold             = 1
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  nrql {
    query = <<-EOT
    FROM K8sPodSample
    SELECT latest(isReady)
    WHERE status not in ('Failed', 'Succeeded')
    FACET podName, namespaceName, clusterName
    EOT
  }
}

# resource "newrelic_nrql_alert_condition" "statefulset_is_missing_pods" {
#   name                           = "Statefulset is missing Pods"
#   description                    = "Alert when Statefulset is missing Pods for > 5 minutes"
#   policy_id                      = var.policy_id
#   aggregation_delay              = "60"
#   aggregation_method             = "EVENT_FLOW"
#   close_violations_on_expiration = true
#   expiration_duration            = 300
#   violation_time_limit_seconds   = 21600

#   critical {
#     operator              = "above"
#     threshold             = 0
#     threshold_duration    = 300
#     threshold_occurrences = "all"
#   }

#   nrql {
#     query = <<-EOT
#     FROM K8sStatefulsetSample
#     SELECT latest(podsMissing)
#     FACET daemonsetName, namespaceName, clusterName
#     EOT
#   }
# }
