data "template_file" "jenkins" {
  template = "${file("${path.module}/templates/jenkins.tpl")}"
}

data "template_file" "sonarqube" {
  template = "${file("${path.module}/templates/sonarqube.tpl")}"
}