pipeline {
    agent any

    environment {
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

                    // Extraire l'ID du conteneur
                    def containerId = output.split('\n')[0].trim()

                    // Vérifier si un ID valide a été extrait
                    if (!containerId || containerId.isEmpty()) {
                        error "Failed to extract Docker container ID. Output: ${output}"
                    }

                    echo "Extracted Container ID: ${containerId}"

                    // Écrire l'ID dans un fichier pour persistance
                    writeFile file: 'container_id.txt', text: containerId
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    echo "Starting tests..."

                    // Lire l'ID du conteneur depuis le fichier
                    def containerId = readFile('container_id.txt').trim()
                    echo "Using Container ID: ${containerId}"

                    def testLines = readFile(env.TEST_FILE_PATH).split('\n')
                    for (line in testLines) {
                        def vars = line.split(' ')
                        def arg1 = vars[0]
                        def arg2 = vars[1]
                        def expectedSum = vars[2].toFloat()

                        def output = bat(
                            script: "docker exec ${containerId} python /app/sum.py ${arg1} ${arg2}",
                            returnStdout: true
                        ).trim()

                        echo "Test Output: ${output}"
                    }
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning up..."
            script {
                def containerId = readFile('container_id.txt').trim()
                bat "docker stop ${containerId} || true"
                bat "docker rm ${containerId} || true"
            }
        }
    }
}
