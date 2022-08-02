<h1 align="center">Hi 👋, I'm Lihi Reisman</h1>
<p align="left"> <img src="https://komarev.com/ghpvc/?username=lihilu&label=Profile%20views&color=0e75b6&style=flat" alt="lihilu" /> </p>

- 🔭 I’m currently working on **Opsschool Mid-Project**

<h3 align="left">Languages and Tools:</h3>
<p align="left"> <a href="https://aws.amazon.com" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/amazonwebservices/amazonwebservices-original-wordmark.svg" alt="aws" width="40" height="40"/> </a> <a href="https://www.gnu.org/software/bash/" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/gnu_bash/gnu_bash-icon.svg" alt="bash" width="40" height="40"/> </a> <a href="https://www.docker.com/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/docker/docker-original-wordmark.svg" alt="docker" width="40" height="40"/> </a> <a href="https://flask.palletsprojects.com/" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/pocoo_flask/pocoo_flask-icon.svg" alt="flask" width="40" height="40"/> </a> <a href="https://git-scm.com/" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/git-scm/git-scm-icon.svg" alt="git" width="40" height="40"/> </a> <a href="https://www.jenkins.io" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/jenkins/jenkins-icon.svg" alt="jenkins" width="40" height="40"/> </a> <a href="https://kubernetes.io" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/kubernetes/kubernetes-icon.svg" alt="kubernetes" width="40" height="40"/> </a> <a href="https://www.linux.org/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/linux/linux-original.svg" alt="linux" width="40" height="40"/> </a> <a href="https://www.python.org" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/python/python-original.svg" alt="python" width="40" height="40"/> </a> </p>


# Mid Project

Envrioment for OpsSchool final project
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
4. After complete, connect to kubectl and config the secret.yaml+creat kandula name space:
```bash
kubectl apply -f "C:\Users\<USER>\Desktop\importent not delete\kube\secret.yaml"
kubectl create ns kandula
```
5. Update the ssh config file

```python
Host bastion
    HostName <BASTION PUBLIC IP>
    User ubuntu
    IdentityFile C:\Users\<USERNAME>\Documents\GitHub\kandula_project\lihilu-kandula_project\project_instance_key.pem
    Port 22
    ForwardAgent yes

Host 10.0.*.*
    User ubuntu
    IdentityFile C:\Users\<USERNAME>\Documents\GitHub\kandula_project\lihilu-kandula_project/project_instance_key.pem
    ProxyJump bastion
    StrictHostKeyChecking no
    ProxyCommand ssh bastion -W %h:%p
```

## Consul
[finalproject.ops.club:8500](http://finalproject.ops.club:8500/)

![](https://github.com/lihilu/lihilu-kandula_project/blob/readme/pic/consuland_services.gif)

## jenkins
http://finalproject.ops.club:8080/ or https://finalproject.ops.club:443

![](https://github.com/lihilu/lihilu-kandula_project/blob/readme/pic/jenkins.gif)

## Ansible

Connect to ansible and run the following playbooks:
* playbook_kube
* playbook_elk
* playbook_filebeat
* playbook_psql

## Kandula app
https://kandula.ops.club/

![](https://github.com/lihilu/lihilu-kandula_project/blob/elk/pic/kandukla-stopinstance.gif)


![](https://github.com/lihilu/lihilu-kandula_project/blob/elk/pic/OpsSchool-Coding-Welcome-to-Kandula-scheduling-in-ui.gif)

## Elastic search + filebeat
http://finalproject.ops.club:6501

![](https://github.com/lihilu/lihilu-kandula_project/blob/elk/pic/ElasticSearch.gif)

![](https://github.com/lihilu/lihilu-kandula_project/blob/elk/pic/OpsSchool-Coding-Welcome-to-Kandula-scheduling-in-ui.gif)

## Prometheus
http://kube_pro.ops.club:9090

Inside kube and monitoring also services and instances outside kubernetes

![](https://github.com/lihilu/lihilu-kandula_project/blob/elk/pic/PromOnKubewithEc2Instances.JPG)

## Grafana
http://kube_graf.ops.club/

Based on prometheus data source and exposing kandula and other services metrics


# Known Issue
* ansible - automation
* install Load Balancer service and add it as a record to rout 53 - automation
* Jenkins - update agent ip with ansible playbook
* Jmatar - implement it
* VPN - implement it

Thanks
