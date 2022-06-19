---
 apiVersion: v1
 kind: Service
 metadata:
   name: backend-service
   annotations:
        service.beta.kubernetes.io/do-loadbalancer-protocol: "https"
        service.beta.kubernetes.io/do-loadbalancer-algorithm: "round_robin"
        service.beta.kubernetes.io/do-loadbalancer-tls-ports: "443"
        service.beta.kubernetes.io/do-loadbalancer-certificate-id: "${certificate_id}"
        service.beta.kubernetes.io/do-loadbalancer-hostname: "kandula.ops.club"
        service.beta.kubernetes.io/do-loadbalancer-http2-ports: 443,80
        service.beta.kubernetes.io/aws-load-balancer-ssl-cert: "${finalproject_tls_arn}"
        prometheus.io/scrape: "true"
        prometheus.io/port: "9100"
 spec:
   selector:
     app: backend
   type: LoadBalancer
   ports:
    - name: http
      protocol: TCP
      port: 80
      targetPort: 5000
    - name: https
      protocol: TCP
      port: 443
      targetPort: 5000
    - name: node
      port: 9100
      targetPort: 9100
      protocol: TCP