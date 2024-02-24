data "template_file" "jenkins" {
  template = "${file("${path.module}/templates/jenkins.tpl")}"
}

data "template_file" "sonarqube" {
  template = "${file("${path.module}/templates/sonarqube.tpl")}"
  vars = {
    "db_host" = module.postgres.db_host
    "db_username" = jsondecode(data.aws_secretsmanager_secret_version.this.secret_string)["username"]
    "db_password" = jsondecode(data.aws_secretsmanager_secret_version.this.secret_string)["password"]
  }
}

data "aws_secretsmanager_secret" "this" {
  name = var.secretname
}

data "aws_secretsmanager_secret_version" "this" {
  secret_id     = data.aws_secretsmanager_secret.this.id
}
