// 1. read the code  version
// 2. install dependencies
// 3. docker build
// 4. push images to ecr
// 5. k8 deployment

pipeline{
    agent{
        label 'AGENT-1' // jenkins agent server
    }

    options{
        timeout(time: 30, unit: 'MINUTES') // pipeline run time
        disableConcurrentBuilds() // only one build run at a time
    }

    environment{
        appVersion = '' // this will become global, we can use across pipeline
        DEBUG = 'true'
        region = 'us-east-1'
        account_id = '529088275803'
        project = 'expense'
        environment = 'dev'
        component = 'backend'
    }

    // read the package.json code version
    stages{
        stage('Read the version'){
            steps{
                script{
                // defining variable
                def packageJson = readJSON file: 'package.json' // web= pipeline utility steps --> readjson
                appVersion = packageJson.version // dynamically fetch the version from package.json
                echo "App version: ${appVersion}" // 1.0.0 
                }
            }
        }

        // install npm dependencies on agent
        stage('Install Dependencies'){
            steps{
                sh 'npm install'
            }
        }

        // install docker on agent and run Dockerfile
        stage('Docker build'){
            steps{
                withAWS(region: 'us-east-1', credentials: 'aws-creds'){
                    sh """
                        aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 529088275803.dkr.ecr.us-east-1.amazonaws.com

                        docker build -t ${account_id}.dkr.ecr.us-east-1.amazonaws.com/${project}/${component}:${appVersion} .

                        docker images

                        docker push ${account_id}.dkr.ecr.us-east-1.amazonaws.com/${project}/${component}:${appVersion}

                    """
                }
            }
        }

        // deploy
        stage('deploy') {
            steps{
                withAWS(region: 'us-east-1', credentials: 'aws-creds'){
                    sh """
                        aws eks update-kubeconfig --region us-east-1 --name expense-dev
                        cd helm
                        sed -i 's/IMAGE_VERSION/${appVersion}/g' values-dev.yaml
                        helm upgrade --install backend -n expense -f values-dev.yaml .
                    """
                }
            }
        }
    }
}