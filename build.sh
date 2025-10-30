# show build version
docker buildx version

# Buildx 활성화
docker buildx create --name multiarch --use
docker buildx inspect --bootstrap

# 각 아키텍처별로 빌드
docker build -f Dockerfile.amd64 -t dangtong76/agent-ai-ide:amd64 .
docker build -f Dockerfile.arm64 -t dangtong76/agent-ai-ide:arm64 .

# 푸시
docker push dangtong76/agent-ai-ide:amd64
docker push dangtong76/agent-ai-ide:arm64

# 매니페스트 생성
docker manifest create dangtong76/agent-ai-ide:latest \
  dangtong76/agent-ai-ide:amd64 \
  dangtong76/agent-ai-ide:arm64

docker manifest push dangtong76/agent-ai-ide:latest



# AMD64용 빌드
docker build -f Dockerfile.amd64 -t dangtong76/agent-ai-ide:amd64 .

# ARM64용 빌드  
docker build -f Dockerfile.arm64 -t dangtong76/agent-ai-ide:arm64 .

# Docker Hub에 푸시
docker push dangtong76/agent-ai-ide:amd64
docker push dangtong76/agent-ai-ide:arm64


# 매니페스트 생성 (여러 아키텍처를 하나의 태그로 통합)
docker manifest create dangtong76/agent-ai-ide:latest \
  dangtong76/agent-ai-ide:amd64 \
  dangtong76/agent-ai-ide:arm64

# 3. 매니페스트 푸시
docker manifest push dangtong76/agent-ai-ide:latest


# Basic build command
docker build -t dangtong76/cloud-cicd-ide .

# Create the builder
docker buildx build  --builder multi-builder --platform linux/amd64,linux/arm64  -t dangtong76/agent-ai-ide --push .
docker buildx build  --platform linux/amd64,linux/arm64  -t dangtong76/agent-ai-ide --push .