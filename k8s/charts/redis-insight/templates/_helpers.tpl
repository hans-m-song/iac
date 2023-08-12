{{/*
Common labels
*/}}
{{- define "redis-insight.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ include "redis-insight.selectors" . }}
{{- end -}}

{{/*
Common selectors
*/}}
{{- define "redis-insight.selectors" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "redis-insight.serviceName" -}}
{{ default .Release.Name .Values.service.name }}
{{- end -}}
