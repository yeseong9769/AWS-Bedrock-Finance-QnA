# AWS-Bedrock-Finance-QnA-Infra

AWS-Bedrock-Finance-QnA-Infra는 AWS Bedrock을 활용하여 대한민국 중앙정부 재정정보 분야의 질문과 답변 애플리케이션을 구축하기 위한 인프라 프로젝트입니다.

⚠️ **참고:** 이 프로젝트는 공식 프로젝트가 아닌 개인 프로젝트입니다.

## 프로젝트 아키텍처

![AWS 인프라 아키텍처](https://github.com/user-attachments/assets/b7b6bd1f-1169-4b1d-81ed-8365a6e10e3a)

## 주요 인프라 구성 요소

### 네트워크 인프라
- **VPC**: 프로젝트를 위한 가상 사설 클라우드 네트워크
- **서브넷**: 퍼블릭 및 프라이빗 서브넷으로 분리
- **라우트 테이블**: 네트워크 트래픽 경로 설정
- **인터넷 게이트웨이**: 클라우드 인프라의 인터넷 연결 지원
- **NAT 게이트웨이**: 프라이빗 서브넷의 외부 인터넷 접근 지원

### 보안 및 컴퓨팅
- **보안 그룹**: 네트워크 트래픽에 대한 세분화된 보안 규칙
- **EC2 인스턴스**: 애플리케이션 호스팅 서버
- **애플리케이션 로드 밸런서(ALB)**: 트래픽 부하 분산 및 고가용성 지원

### AI 및 벡터 데이터베이스
- **Amazon Bedrock**: 
  - 대규모 언어 모델(LLM) 기반 생성형 AI 서비스
  - 재정 정보 질문-답변 시스템의 핵심 인공지능 엔진
  - 다양한 AI 모델 지원 (Anthropic Claude, AI21 Labs, Cohere 등)
  - 안전하고 확장 가능한 AI 추론 및 생성 기능 제공

- **Pinecone**:
  - 클라우드 네이티브 벡터 데이터베이스
  - 대규모 임베딩 벡터 저장 및 의미론적 검색 지원
  - 고성능 유사도 검색 기능
  - 재정 정보 문서의 벡터 임베딩 저장 및 검색 최적화
  - 실시간 벡터 인덱싱 및 스케일링 기능

## 사전 준비사항

1. **AWS 계정**
   - 필요한 리소스를 프로비저닝할 수 있는 충분한 권한 보유

2. **개발 환경 설정**
   - [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) 설치
   - AWS CLI 자격 증명 구성
     ```bash
     aws configure
     ```

## 배포 절차

1. 저장소 클론
   ```bash
   git clone https://github.com/yeseong9769/AWS-Bedrock-Finance-QnA-Infra.git
   ```

2. 프로젝트 디렉토리 이동
   ```bash
   cd AWS-Bedrock-Finance-QnA-Infra
   ```

3. Terraform 초기화
   ```bash
   terraform init
   ```

4. Terraform 리소스 프로비저닝
   ```bash
   terraform apply
   ```

5. 생성된 리소스 확인
   ```bash
   terraform show
   ```

## 추가 구성 요구사항

**⚠️ 주의:** US-EAST-1 리전의 Bedrock 및 PineCONE 서비스는 본 코드에 포함되지 않았으므로 별도로 설정해야 합니다:

1. **AWS Bedrock**
   - AWS Management Console에서 us-east-1 리전으로 이동
   - Bedrock 서비스 활성화 및 필요한 모델 접근 권한 설정

2. **PineCONE**
   - PineCONE 계정 생성
   - 벡터 데이터베이스 인스턴스 생성
   - API 키 및 환경 설정 구성