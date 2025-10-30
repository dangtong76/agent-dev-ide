docker volume create  \
--opt device="/Users/dangtongbyun/Library/CloudStorage/GoogleDrive-dbyun@redhat.com/내 드라이브/05.Lecture/cicd/devops-cicd/storage/devops-cicd-apps" \
--opt o=bind --opt type=none devops-cicd-apps

docker volume create  \
--opt device="/Users/dangtongbyun/Library/CloudStorage/GoogleDrive-dbyun@redhat.com/내 드라이브/05.Lecture/cicd/devops-cicd/storage/devops-cicd-vscode" \
--opt o=bind --opt type=none devops-cicd-vscode

# 볼륨 생성 확인
docker volume ls

# 네트워크 확인
docker network ls
docker network inspect kind