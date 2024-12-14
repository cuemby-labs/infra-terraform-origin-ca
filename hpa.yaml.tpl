
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: origin-ca-issuer
  namespace: ${namespace_name}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: origin-ca-issuer
  minReplicas: ${min_replicas}
  maxReplicas: ${max_replicas}
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: ${target_cpu_utilization}
    - type: Resource
      resource:
        name: memory
        target:
          type: Utilization
          averageUtilization: ${target_memory_utilization}