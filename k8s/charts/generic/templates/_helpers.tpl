{{/*
Common labels
*/}}
{{- define "generic.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ include "generic.selectors" . }}
{{- end -}}

{{/*
Common selectors
*/}}
{{- define "generic.selectors" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Config checksum
*/}}
{{- define "generic.configChecksum" -}}
{{- $secrets := $.Values.secrets | toYaml -}}
{{- $config := include (print $.Template.BasePath "/configmap.yaml") $ }}
{{- print $secrets $config | sha256sum -}}
{{- end -}}
