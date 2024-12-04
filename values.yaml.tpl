apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: cert-manager-controller-approve:cert-manager-k8s-cloudflare-com
rules:
  - apiGroups:
      - cert-manager.io
    resources:
      - signers
    verbs:
      - approve
    resourceNames:
      - originissuers.cert-manager.k8s.cloudflare.com/*
      - clusteroriginissuers.cert-manager.k8s.cloudflare.com/*
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: originissuer-control
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: originissuer-control
subjects:
  - kind: ServiceAccount
    name: originissuer-control
    namespace: ${namespace_name}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: cert-manager-controller-approve:cert-manager-k8s-cloudflare-com
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cert-manager-controller-approve:cert-manager-k8s-cloudflare-com
subjects:
- kind: ServiceAccount
  name: cert-manager
  namespace: cert-manager
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: originissuer-control
rules:
- apiGroups:
  - ""
  resources:
  - events
  verbs:
  - create
  - patch
- apiGroups:
  - ""
  resources:
  - secrets
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - cert-manager.io
  resources:
  - certificaterequests
  verbs:
  - get
  - list
  - update
  - watch
- apiGroups:
  - cert-manager.io
  resources:
  - certificaterequests/status
  verbs:
  - get
  - patch
  - update
- apiGroups:
  - cert-manager.k8s.cloudflare.com
  resources:
  - clusteroriginissuers
  verbs:
  - create
  - get
  - list
  - watch
- apiGroups:
  - cert-manager.k8s.cloudflare.com
  resources:
  - clusteroriginissuers/status
  verbs:
  - get
  - patch
  - update
- apiGroups:
  - cert-manager.k8s.cloudflare.com
  resources:
  - originissuers
  verbs:
  - create
  - get
  - list
  - watch
- apiGroups:
  - cert-manager.k8s.cloudflare.com
  resources:
  - originissuers/status
  verbs:
  - get
  - patch
  - update
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: origin-ca-issuer
  namespace: ${namespace_name}
spec:
  selector:
    matchLabels:
      app: origin-ca-issuer
  replicas: 1
  template:
    metadata:
      labels:
        app: origin-ca-issuer
    spec:
      serviceAccountName: originissuer-control
      containers:
        - name: origin-ca-controller
          image: ${image_version}
          args:
            - --cluster-resource-namespace=$(POD_NAMESPACE)
          env:
            - name: POD_NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
          resources:
            limits:
              cpu: ${limits_cpu}
              memory: ${limits_memory}
            requests:
              cpu: ${request_cpu}
              memory: ${request_memory}
          securityContext:
            allowPrivilegeEscalation: false
            capabilities:
              drop: 
              - "ALL"
            runAsNonRoot: true
            seccompProfile:
              type: "RuntimeDefault"
      terminationGracePeriodSeconds: 10
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: originissuer-control
  namespace: ${namespace_name}
---
apiVersion: v1 
kind: Secret
metadata:
  name: origin-ca-issuer-secret
  namespace: ${namespace_name}
data:
  key: ${key}
type: Opaque
---
apiVersion: cert-manager.k8s.cloudflare.com/v1
kind: ClusterOriginIssuer
metadata:
  name: origin-ca-issuer
  namespace: ${namespace_name}
spec:
  auth:
    serviceKeyRef:
      name: origin-ca-issuer-secret
      key: key
  requestType: OriginECC
