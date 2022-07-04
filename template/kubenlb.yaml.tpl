---
 apiVersion: v1
 kind: Service
 metadata:
   name: kandula-lb
   annotations:
        service.beta.kubernetes.io/do-loadbalancer-protocol: "https"
        service.beta.kubernetes.io/do-loadbalancer-algorithm: "round_robin"
        service.beta.kubernetes.io/do-loadbalancer-tls-ports: "443"
        service.beta.kubernetes.io/do-loadbalancer-certificate-id: "${certificate_id}"
        service.beta.kubernetes.io/do-loadbalancer-hostname: "kandula.ops.club"
        service.beta.kubernetes.io/do-loadbalancer-http2-ports: 443,80
        service.beta.kubernetes.io/aws-load-balancer-ssl-cert: "${finalproject_tls_arn}"
 spec:
   selector:
     app: kandula
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