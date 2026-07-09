pipeline {
    agent any

    environment {
        IMAGE_NAME     = 'securedev-app'
        CONTAINER_NAME = 'securedev-app'
    }

    stages {
        stage('Build') {
            steps {
                echo 'Etapa Build: construyendo imagen de la aplicacion...'
                sh 'docker build -t $IMAGE_NAME:$BUILD_NUMBER .'
            }
        }

        stage('Test') {
            steps {
                echo 'Etapa Test: verificando que la aplicacion carga correctamente...'
                sh 'docker run --rm $IMAGE_NAME:$BUILD_NUMBER python -c "import vulnerable_flask_app"'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Etapa Deploy: desplegando en entorno de prueba...'
                sh 'docker rm -f $CONTAINER_NAME || true'
                sh 'docker run -d --name $CONTAINER_NAME -p 5000:5000 $IMAGE_NAME:$BUILD_NUMBER'
                sh 'sleep 10'
            }
        }

        stage('Security - OWASP ZAP') {
            steps {
                echo 'Etapa Security: ejecutando OWASP ZAP Baseline Scan...'
                sh 'docker run --rm --link securedev-app ghcr.io/zaproxy/zaproxy:stable zap-baseline.py -t http://securedev-app:5000 -I || true'
            }
        }
    }

    post {
        success {
            echo 'Pipeline DevSecOps completado: Build + Test + Deploy + ZAP.'
        }
        failure {
            echo 'El pipeline fallo. Revisar los logs.'
        }
    }
}
