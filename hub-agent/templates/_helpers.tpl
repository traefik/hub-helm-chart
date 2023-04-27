{{/*
Expand the name of the chart.
*/}}
{{- define "hub-helm-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create the chart image name.
*/}}

{{- define "hub-helm-chart.image-name" -}}
{{- printf "%s:%s" .Values.image.name (.Values.image.tag | default .Chart.AppVersion) }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "hub-helm-chart.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "hub-helm-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}



{{/* Shared labels used for selector*/}}
{{/* This is an immutable field: this should not change between upgrade */}}
{{- define "hub-helm-chart.labelselector" -}}
app.kubernetes.io/name: {{ template "hub-helm-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/* Shared labels used in metadata */}}
{{- define "hub-helm-chart.labels" -}}
{{ include "hub-helm-chart.labelselector" . }}
app.kubernetes.io/version: {{ .Chart.Version }}
{{- if not .Values.withoutHelmLabels }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ template "hub-helm-chart.chart" . }}
{{- end }}
{{- end }}

{{/* Default Traefik Proxy service */}}
{{- define "hub-helm-chart.traefikService" -}}
traefik-hub.{{ .Values.traefikNamespace }}.svc.cluster.local
{{- end }}
