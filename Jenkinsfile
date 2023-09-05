pipeline {
    agent {
        node {
            label 'npm'
        }
    }
environment {
    PATH = "/usr/share/nodejs/npm/bin:$PATH"
   } 
 stages{
    stage("build"){
     steps {
        sh 'npm install'
     }

    }
 }

}



