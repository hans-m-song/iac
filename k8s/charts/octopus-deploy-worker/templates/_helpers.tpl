{{/*
Common labels
*/}}
{{- define "octopus-deploy-worker.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ include "octopus-deploy-worker.selectors" . }}
{{- end -}}

{{/*
Common selectors
*/}}
{{- define "octopus-deploy-worker.selectors" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
