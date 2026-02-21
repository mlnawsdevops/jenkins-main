pipeline{
    agent{
        label 'AGENT-1'
    }

    options{
        timeout(time: 30, unit: 'MINUTES')
        disableConcurrentBuilds()
        ansiColor('xterm')
    }

    environment{
        appVersion = '' // this will become global, we can use across pipeline
        DEBUG = 'true'
        region = 'us-east-1'
        account_id = '529088275803'
        project = 'expense'
        environment = 'dev'
        component = 'frontend'
    }

    stages{
        stage('read version'){
            steps{
                script{
                    def packageJson = readJSON file: 'package.json'
                    appVersion = packageJson.version
                    echo "APP version: ${appVersion}"
                }
            }
        }

        stage('docker build'){
            steps{
                withAWS(region: 'us-east-1', credentials: 'aws-creds'){
                    sh """
                        aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${account_id}.dkr.ecr.us-east-1.amazonaws.com

                        docker build -t ${account_id}.dkr.ecr.us-east-1.amazonaws.com/${project}/${component}:${appVersion} .

                        docker images

                        docker push ${account_id}.dkr.ecr.us-east-1.amazonaws.com/${project}/${component}:${appVersion}
                    """
                }
            }
        }

        stage('deploy'){
            steps{
                withAWS(region: 'us-east-1', credentials: 'aws-creds'){
                    sh """
                        aws eks update-kubeconfig --region us-east-1 --name expense-dev

                        cd helm

                        sed -i 's/IMAGE_VERSION/${appVersion}/g' values-dev.yaml

                        helm upgrade --install frontend -n expense -f values-dev.yaml .
                    """
                }
            }
        }
    }
}