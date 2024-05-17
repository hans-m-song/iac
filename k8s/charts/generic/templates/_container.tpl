{{- define "generic.container" -}}
{{- $ := .root }}
{{- $name := .name }}
{{- with .container -}}
{{- $ports := .ports | default (dict) }}
{{- $env := .env | default (dict) }}
{{- $envFrom := .envFrom | default (list) }}
{{- if gt (len $.Values.secrets) 0 }}
{{- $envFrom = append $envFrom (dict
  "secretRef" (dict
    "name" $.Release.Name
  )
)}}
{{- end }}
{{- $volumes := .volumes | default (dict) }}
{{- if gt (len $.Values.files) 0 }}
{{- $volumes = set $volumes "files" (dict
  "mount" (dict
    "mountPath" "/opt/files"
  )
)}}
{{- end }}
{{- $args := .args | default (list) }}
{{- $command := .command | default (list) }}
name: {{ $name }}
image: {{ .image }}
imagePullPolicy: {{ .imagePullPolicy | default "IfNotPresent" }}
resources:
  limits:
    cpu: {{ ((.resources).limits).cpu | default "100m" }}
    memory: {{ ((.resources).limits).memory | default "256Mi" }}
  requests:
    cpu: {{ ((.resources).requests).cpu | default "100m" }}
    memory: {{ ((.resources).requests).memory | default "256Mi" }}
{{- if .lifecycle }}
lifecycle: {{ .lifecycle | toYaml | nindent 2 }}
{{- end }}
{{- if .securityContext }}
securityContext: {{ .securityContext | toYaml | nindent 2 }}
{{- end }}
{{- if gt (len $args) 0 }}
args: {{ $args | toYaml | nindent 2 }}
{{- end }}
{{- if gt (len $command) 0 }}
command: {{ $command | toYaml | nindent 2 }}
{{- end }}
{{- if gt (len $ports) 0 }}
ports:
{{- range $name, $port := $ports }}
- name: {{ $name }}
  containerPort: {{ $port.internalPort }}
  protocol: {{ $port.protocol }}
{{- end }}
{{- end }}
{{- if gt (len $env) 0 }}
env:
{{- range $key, $value := $env }}
- name: {{ $key }}
  value: {{ quote $value }}
{{- end }}
{{- end }}
{{- if gt (len $envFrom) 0 }}
envFrom:
{{ $envFrom | toYaml }}
{{- end }}
{{- if gt (len $volumes) 0 }}
volumeMounts:
{{- range $name, $config := $volumes }}
- name: {{ $name }}
  {{- $config.mount | toYaml | nindent 2 }}
{{- end }}
{{- end }}
{{- if .readinessProbe }}
readinessProbe: {{- .readinessProbe | toYaml | nindent 2 }}
{{- end }}
{{- if .livenessProbe }}
livenessProbe: {{- .livenessProbe | toYaml | nindent 2 }}
{{- end }}
{{- end -}}
{{- end -}}
