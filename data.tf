data "template_file" "kubenlb" {
  template = "${file("${path.module}/template/kubenlb.yaml.tpl")}"
  vars ={
    certificate_id = "${split("/",module.instance.finalproject_tls_arn)[1]}",
    finalproject_tls_arn = "${module.instance.finalproject_tls_arn}"
  }
  depends_on= [module.eks_cluster]
}

resource "local_file" "kubenlb" {
    content = "${data.template_file.kubenlb.rendered}"
    filename = "temp/kubenlb.yaml"
    depends_on = [data.template_file.kubenlb]

}

resource "null_resource" remoteExecProvisionerWFolder {

  provisioner "file" {
    source      = "temp/kubenlb.yaml"
    destination = "/tmp/kubenlb.yaml"
  }

  connection {
    host     = "${module.jenkins.jenkins_agent_ip}"
    type     = "ssh"
    user     = "ubuntu"
    private_key = file(module.ssh-key.key_local)
    bastion_host        = "${module.instance.bastion_public_ip[0]}"
    bastion_private_key = file(module.ssh-key.key_local)
    agent               = false
    }
  depends_on = [local_file.kubenlb]
}


data "template_file" "postgres_ansible" {
  template = "${file("${path.module}/template/postgresql_vars_ansible.yaml.tpl")}"
  vars ={
    dbusername = "${module.db.db_admin}",
    dbpassword = "${module.db.db_pass}",
    dbname = "${module.db.db_name}",
    dbhost = "${module.db.db_host}"
  }
  depends_on= [module.db]
}

resource "local_file" "postgres_ansible" {
    content = "${data.template_file.postgres_ansible.rendered}"
    filename = "temp/vars.yaml"
    depends_on = [data.template_file.postgres_ansible]
}

resource "null_resource" remoteExecProvisionerWFolderansible {

  provisioner "file" {
    source      = "temp/vars.yaml"
    destination = "/tmp/vars.yml"
  }

  connection {
    host     = "${module.ansible_server.ansible_server_private_ip[0]}"
    type     = "ssh"
    user     = "ubuntu"
    private_key = file(module.ssh-key.key_local)
    bastion_host        = "${module.instance.bastion_public_ip[0]}"
    bastion_private_key = file(module.ssh-key.key_local)
    agent               = false
    }
  depends_on = [local_file.postgres_ansible]
}