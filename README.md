<h1 align="center">Hi 👋, I'm Lihi Reisman</h1>
<p align="left"> <img src="https://komarev.com/ghpvc/?username=lihilu&label=Profile%20views&color=0e75b6&style=flat" alt="lihilu" /> </p>

- 🔭 I’m currently working on **Opsschool Mid-Project**

<h3 align="left">Connect with me:</h3>
<p align="left">
</p>

<h3 align="left">Languages and Tools:</h3>
<p align="left"> <a href="https://aws.amazon.com" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/amazonwebservices/amazonwebservices-original-wordmark.svg" alt="aws" width="40" height="40"/> </a> <a href="https://www.gnu.org/software/bash/" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/gnu_bash/gnu_bash-icon.svg" alt="bash" width="40" height="40"/> </a> <a href="https://www.docker.com/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/docker/docker-original-wordmark.svg" alt="docker" width="40" height="40"/> </a> <a href="https://flask.palletsprojects.com/" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/pocoo_flask/pocoo_flask-icon.svg" alt="flask" width="40" height="40"/> </a> <a href="https://git-scm.com/" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/git-scm/git-scm-icon.svg" alt="git" width="40" height="40"/> </a> <a href="https://www.jenkins.io" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/jenkins/jenkins-icon.svg" alt="jenkins" width="40" height="40"/> </a> <a href="https://kubernetes.io" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/kubernetes/kubernetes-icon.svg" alt="kubernetes" width="40" height="40"/> </a> <a href="https://www.linux.org/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/linux/linux-original.svg" alt="linux" width="40" height="40"/> </a> <a href="https://www.python.org" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/python/python-original.svg" alt="python" width="40" height="40"/> </a> </p>


# Mid Project

Envrioment for mid - OpsSchool project
## Installation

1. Fork this repo and download it to your local machine.
2. Create S3 bucket to hold the state of the configuration 

```bash
terraform init
```
3. Provision of the project environment

```bash
terraform apply --auto-aprove
```
4. After complete, connect to kubectl and config the secret.yaml:
```bash
kubectl apply -f "C:\Users\<USER>\Desktop\importent not delete\kube\secret.yaml"
```
5. Update the ssh config file

```python
Host bastion
    HostName <BASTION PUBLIC IP>
    User ubuntu
    IdentityFile C:\Users\LihiZohara\Documents\GitHub\kandula_project\lihilu-kandula_project\project_instance_key.pem
    Port 22
    ForwardAgent yes

Host 10.0.*.*
    User ubuntu
    IdentityFile C:\Users\LihiZohara\Documents\GitHub\kandula_project\lihilu-kandula_project/project_instance_key.pem
    ProxyJump bastion
    StrictHostKeyChecking no
    ProxyCommand ssh bastion -W %h:%p
```

## Consul
<Load-Balancer-URL>:8500

Gif Consul

## jenkins
<Load-Balancer-URL>:8080

Gif Jenkins run job: mid project kandula opsschool

## Kandula app

GIF KANDULA

# Known Issue
* Jenkins job running without build num so before re-running the job please run the following command
```bash
kubectl delete pod kandula-pod
kubectl delete svc backend-service
```
* Consul > Jenkins agent, needed to add a count to it.

Thanks
