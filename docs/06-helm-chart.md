# Helm Chart

Initially, the [Helm Chart for Drupal](https://github.com/drupalwxt/helm-drupal) had to be cloned into the [tenant-gitops-ea352d](https://github.com/bcgov-c/tenant-gitops-ea352d/) repository because the BCGov platform does not allow remote Helm charts to be called via Argo CD.

The good news is that only minimal adjustments were required for the successful deployment of a Drupal site, and most of these changes have been contributed back to the open-source chart.

Some of the changes made are discussed below.

## Network Policies

The following network policies needed to be added.

Allow from OpenShift ingress

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: {{ include "drupal.fullname" . }}-allow-openshift-ingress
  labels:
    app.kubernetes.io/name: {{ include "drupal.name" . }}
    helm.sh/chart: {{ include "drupal.chart" . }}
    app.kubernetes.io/instance: {{ .Release.Name }}
    app.kubernetes.io/managed-by: {{ .Release.Service }}
spec:
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          network.openshift.io/policy-group: ingress
  podSelector: {}
  policyTypes:
  - Ingress
```

Allow connectivity from same namespace

```yaml
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: {{ include "drupal.fullname" . }}-allow-same-ns
  labels:
    app.kubernetes.io/name: {{ include "drupal.name" . }}
    helm.sh/chart: {{ include "drupal.chart" . }}
    app.kubernetes.io/instance: {{ .Release.Name }}
    app.kubernetes.io/managed-by: {{ .Release.Service }}
spec:
  podSelector: {}
  ingress:
  - from:
    - podSelector: {}
```

> **Note**: These currently are more permissive then they need to be and will be refined.

## Security Contexts

The default [Helm Chart for Drupal](https://github.com/drupalwxt/helm-drupal) sets Security Contexts and this conflicts with OpenShift which dynamically sets these.

Simply setting `securityContext` to an empty object resolves all of these errors.

## Nginx

While mentioned in the containers section Nginx needed a few adjustments at the Helm Chart level in order to successfully deploy.

* Port 8080 instead of 80 (since 80 is a reserved port)
* The nginx.conf configmap needed to be slightly edited

The adjustments that needed to be made to the nginx.conf are encapsulated in the below screen shot:

![nginx.conf](assets/images/helm-chart-nginx.png)

## PostgresCluster

The BCGov platform provides the CrunchyDB Operator so support for that was added to the Helm Chart.

```sh
{{- if .Values.postgresOperator.enabled }}
apiVersion: postgres-operator.crunchydata.com/v1beta1
kind: PostgresCluster
metadata:
  name: {{ .Release.Name }}-postgres-cluster
  labels:
    app.kubernetes.io/name: {{ include "drupal.name" . }}
    helm.sh/chart: {{ include "drupal.chart" . }}
    app.kubernetes.io/instance: {{ .Release.Name }}
    app.kubernetes.io/managed-by: {{ .Release.Service }}
spec:
  imagePullPolicy: IfNotPresent
  postgresVersion: {{ .Values.postgresOperator.version }}
  metadata:
    labels:
      app.kubernetes.io/name: {{ include "drupal.name" . }}
      helm.sh/chart: {{ include "drupal.chart" . }}
      app.kubernetes.io/instance: {{ .Release.Name }}
      app.kubernetes.io/managed-by: {{ .Release.Service }}
  instances:
    - name: {{ .Values.postgresOperator.instances.name }}
      replicas: {{ .Values.postgresOperator.instances.replicas }}
      {{- if .Values.postgresOperator.instances.resources }}
      resources:
        {{- toYaml .Values.postgresOperator.instances.resources | nindent 8 }}
      {{- end }}
      sidecars:
        replicaCertCopy:
          {{- if .Values.postgresOperator.instances.sidecars.resources }}
          resources:
            {{- toYaml .Values.postgresOperator.instances.sidecars.resources | nindent 12 }}
          {{- end }}
      dataVolumeClaimSpec:
        accessModes:
          - {{ .Values.postgresOperator.persistence.accessMode }}
        resources:
          requests:
            storage: {{ .Values.postgresOperator.persistence.size }}
        storageClassName: {{ .Values.postgresOperator.persistence.storageClass }}
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
            - weight: 1
              podAffinityTerm:
                topologyKey: kubernetes.io/hostname
                labelSelector:
                  matchLabels:
                    postgres-operator.crunchydata.com/cluster: {{ .Release.Name }}-postgres-cluster
                    postgres-operator.crunchydata.com/instance-set: {{ .Values.postgresOperator.instances.name }}
  users:
    - name: {{ .Values.postgresOperator.auth.username }}
      databases:
        - {{ .Values.postgresOperator.auth.database }}
      options: "CREATEROLE"
    - name: postgres
      databases:
        - {{ .Values.postgresOperator.auth.database }}
  backups:
    pgbackrest:
      global:
        repo1-retention-full: "{{ .Values.postgresOperator.retention.count }}"
        repo1-retention-full-type: {{ .Values.postgresOperator.retention.type }}
      manual:
        repoName: repo1
        options:
          - --type=full
      {{- if .Values.postgresOperator.backups.restore.options }}
      restore:
        enabled: true
        repoName: repo1
        options:
          {{- toYaml .Values.postgresOperator.backups.restore.options | nindent 10 }}
      {{- end }}
      repos:
        - name: repo1
          {{- if .Values.postgresOperator.retention.schedules }}
          schedules:
            {{- toYaml .Values.postgresOperator.retention.schedules | nindent 12 }}
          {{- end }}
          volume:
            volumeClaimSpec:
              accessModes:
                - {{ .Values.postgresOperator.backups.persistence.accessMode }}
              resources:
                requests:
                  storage: {{ .Values.postgresOperator.backups.persistence.size }}
              storageClassName: {{ .Values.postgresOperator.backups.persistence.storageClass }}
      repoHost:
        resources:
          requests:
            cpu: 10m
            memory: 64Mi
          limits:
            cpu: 50m
            memory: 128Mi
      sidecars:
        pgbackrest:
          resources:
            requests:
              cpu: 10m
              memory: 64Mi
            limits:
              cpu: 50m
              memory: 128Mi
        pgbackrestConfig:
          resources:
            requests:
              cpu: 10m
              memory: 64Mi
            limits:
              cpu: 50m
              memory: 128Mi
  patroni:
    dynamicConfiguration:
      postgresql:
        pg_hba:
          - host all all 0.0.0.0/0 scram-sha-256
          - host all all ::1/128 scram-sha-256
        parameters:
          # https://pgtune.leopard.in.ua/
          # DB Version: 16
          # OS Type: linux
          # DB Type: mixed
          # Total Memory (RAM): 2 GB
          # CPUs num: 2
          # Connections num: 200
          # Data Storage: ssd
          max_connections: 100
          shared_buffers: 512MB
          effective_cache_size: 1536MB
          maintenance_work_mem: 128MB
          checkpoint_completion_target: 0.9
          wal_buffers: 16MB
          default_statistics_target: 100
          random_page_cost: 1.1
          effective_io_concurrency: 200
          work_mem: 8MB
          huge_pages: off
          min_wal_size: 1GB
          max_wal_size: 4GB
  proxy:
    pgBouncer:
      config:
        global:
          client_tls_sslmode: disable
      replicas: 1
      resources:
        requests:
          cpu: 100m
          memory: 128Mi
        limits:
          cpu: 200m
          memory: 256Mi
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
            - weight: 1
              podAffinityTerm:
                topologyKey: kubernetes.io/hostname
                labelSelector:
                  matchLabels:
                    postgres-operator.crunchydata.com/cluster: {{ include "drupal.fullname" . }}-postgres-cluster
                    postgres-operator.crunchydata.com/role: pgbouncer
{{- end }}
```
