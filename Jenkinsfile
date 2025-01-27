pipeline {
    agent any

    environment {
        CONTAINER_ID = ""
        SUM_PY_PATH = "./sum.py"
        DIR_PATH = "./"
        TEST_FILE_PATH = "./test_variables.txt"
    }

    stages {
        stage('Build') {
            steps {
                script {
                    echo "Building Docker image..."
                    bat "docker build -t sum-calculator ${env.DIR_PATH}"
                }
            }
        }

      stage('Run') {
            steps {
                script {
                    echo "Running Docker container..."
                    def output = bat(
                        script: "docker run -d sum-calculator",
                        returnStdout: true
                    ).trim()

                    echo "Raw Output: ${output}"

                    // Nettoyer la sortie pour extraire uniquement l'ID
                    def containerId = output.split('\n')[-1].trim()
                    
                    // Vérifier si un ID valide a été extrait
                    if (!containerId || containerId.isEmpty()) {
                        error "Failed to extract Docker container ID. Output: ${output}"
                    }

                    echo "Extracted Container ID: ${containerId}"

                    bat(
                        script: "docker container prune -f || true",
                    )

                    echo "Extracted Container ID: ${containerId}"

                    // Explicitly set the environment variable using withEnv
                    withEnv(["CONTAINER_ID=${containerId}"]) {
                        echo "Container ID: ${env.CONTAINER_ID}"
                    }
                }
        }
}

    stage('Test') {
        steps {
            script {
                echo "Starting tests..."
                withEnv(["CONTAINER_ID=${env.CONTAINER_ID}"]) {
                    // Récupérer l'ID du conteneur
                    def containerId = env.CONTAINER_ID
                    // Exécuter les tests
                    // Pour l'exemple, nous allons exécuter un simple test de somm

                    echo "Using Container ID: ${containerId}" // Add this line for debugging
                    def testLines = readFile(env.TEST_FILE_PATH).split('\n')
                    for (line in testLines) {
                        def vars = line.split(' ')
                        def arg1 = vars[0]
                         def arg2 = vars[1]
                        def expectedSum = vars[2].toFloat()

                        def output = bat(
                            script: "docker exec ${env.CONTAINER_ID} python /app/sum.py ${arg1} ${arg2}",
                            returnStdout: true
                        ).trim()

                        echo "Test Output: ${output}"
                    }
                }
            }
        }
    }

        // stage('Deploy to DockerHub') {
        //     steps {
        //         script {
        //             echo "Tagging and pushing image to DockerHub..."
        //             bat "docker login -u <your-dockerhub-username> -p <your-dockerhub-password>"
        //             bat "docker tag sum-calculator <your-dockerhub-username>/sum-calculator:latest"
        //             bat "docker push <your-dockerhub-username>/sum-calculator:latest"
        //         }
        //     }
        // }
    }

    post {
        always {
            echo "Cleaning up..."
            bat "docker stop ${env.CONTAINER_ID} || true"
            bat "docker rm ${env.CONTAINER_ID} || true"
        }
    }
}
