locals {
   jenkins_useradata = data.template_file.jenkins.rendered
   sonarqube_userdata = data.template_file.sonarqube.rendered
}