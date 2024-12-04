# 생성형 AI를 활용한 재정정보 질의응답 시스템

이 프로젝트는 **Amazon Bedrock**을 활용하여 방대한 양의 **대한민국 중앙정부 재정정보 데이터**를 기반으로 사용자에게 신속하고 정확한 정보를 제공하는 생성형 AI 질의응답 시스템을 구축하는 것을 목표로 합니다.

## 🚀 주요 기능

- **질문 기반 재정정보 검색 및 답변 생성:** 사용자가 입력한 질문에 따라 중앙정부 재정정보를 검색하고, 관련 답변을 생성합니다.
- **실시간 질의응답 제공:** 사용자 친화적인 인터페이스를 통해 실시간으로 질문에 대한 답변을 제공하고 답변은 자연어 처리 모델을 통해 사용자가 이해하기 쉬운 문장으로 제공됩니다.

## 시현 화면

## Amazon Bedrock

Amazon Bedrock은 AWS(Amazon Web Services)에서 제공하는 생성형 AI(Generative AI) 서비스 플랫폼입니다. 이 플랫폼은 다양한 사전 학습된 AI 모델을 API를 통해 간편하게 활용할 수 있도록 설계되었으며, 복잡한 인프라 관리 없이도 AI 기술을 애플리케이션에 통합할 수 있는 기능을 제공합니다.

Amazon Bedrock은 AI 모델 구축 및 운영에 소요되는 시간을 줄이고, 개발자가 AI의 핵심 기능에 집중할 수 있도록 지원합니다. 이를 통해 기업은 AI 기반 애플리케이션을 빠르게 개발하고 배포할 수 있습니다.

**프로젝트에서의 Amazon Bedrock 역할:**
- **언어 모델 호스팅:** 다양한 생성형 AI 모델을 호스팅하여 질문에 대한 고품질의 답변을 생성합니다.
- **RAG (Retrieval-Augmented Generation):** 검색된 데이터와 결합하여 더욱 정확한 답변을 생성합니다.

## 🖥️ 사용 기술

### 🎨 Front-end
- ![Streamlit](https://img.shields.io/badge/Streamlit-F37626?style=flat&logo=Streamlit&logoColor=white): 사용자 친화적인 웹 인터페이스를 신속하게 개발하고 배포하여, 실시간 질의응답 기능을 제공

### 🧰 Back-end
- ![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=Python&logoColor=white): 백엔드 로직 구현 및 데이터 처리, AI 모델과의 통합에 사용
- ![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=flat&logo=FastAPI&logoColor=white): API를 구축하여 프론트엔드와 백엔드 간의 효율적인 통신을 지원
- ![Langchain](https://img.shields.io/badge/Langchain-FF9900?style=flat&logo=Langchain&logoColor=white): 자연어 처리 파이프라인을 구성하고, 생성형 AI 모델과의 상호작용을 관리

### ☁️ Infra
- ![AWS](https://img.shields.io/badge/AWS-232F3E?style=flat&logo=Amazon-AWS&logoColor=white): 전체 인프라를 호스팅
- ![Amazon Bedrock](https://img.shields.io/badge/Amazon%20Bedrock-232F3E?style=flat&logo=Amazon-AWS&logoColor=white): 생성형 AI 모델을 호스팅하고 관리하며, RAG (Retrieval-Augmented Generation) 기능을 통해 정확한 답변 생성을 지원
- ![Terraform](https://img.shields.io/badge/Terraform-623CE4?style=flat&logo=Terraform&logoColor=white): 인프라를 코드로 관리하여 AWS 자원의 자동화된 배포와 관리, 일관성을 유지

### 🤖 ML
- **Amazon Bedrock KnowledgeBase:**
  - **Anthropic Claude 3 Haiku**
  - **Titan Embeddings G1 - Text v1.2:** 텍스트 데이터를 임베딩하여 벡터화하는 데 사용되는 고성능 모델로, 효율적인 유사도 검색을 가능하게 합니다.
- **Pinecone**: 벡터 데이터베이스로서, 임베딩된 데이터를 효율적으로 저장하고 유사도 검색을 수행합니다.

## 프로세스 흐름

![시스템 프로세스](https://github.com/user-attachments/assets/654ea54d-295b-4058-8f16-0b75b69ef048)
*그림 1: 사용자 질문 입력부터 답변 생성까지의 전체 시스템 흐름*  

### 질문 답변 처리 프로세스
1. **유저의 질문 입력:** 사용자가 시스템에 질문을 입력합니다.
2. **백엔드 API 호출:** 입력된 질문을 처리하기 위해 백엔드 API가 호출됩니다.
3. **질문을 임베딩 벡터로 변환:** 질문을 벡터화하여 유사한 데이터를 검색할 수 있도록 변환합니다.
4. **벡터 데이터베이스에서 유사한 데이터 검색:** 벡터 데이터베이스에서 유사한 데이터를 검색합니다.
5. **검색 결과와 질문을 함께 전달하여 답변 생성:** 검색된 데이터와 원본 질문을 결합하여 Amazon Bedrock을 통해 답변을 생성합니다.
6. **최종 답변 반환:** 생성된 답변을 사용자에게 반환합니다.

### 데이터 벡터 DB화 프로세스
1. **문서 업로드:** 관리자가 PDF 또는 HWP 파일을 S3 버킷에 업로드합니다.
2. **데이터 임베딩 벡터로 변환:** 업로드된 문서를 벡터화하여 데이터의 의미를 유지합니다.
3. **벡터 DB에 저장:** 변환된 벡터를 Pinecone 벡터 데이터베이스에 저장합니다.

## 시스템 인프라

![시스템 인프라](https://github.com/user-attachments/assets/20a4af29-3861-4ea8-946a-e800dbeab745)
*그림 2: AWS 인프라와 주요 서비스 간의 연동을 시각적으로 표현한 인프라 구성도*  

### 인프라 구성 상세
- **AWS IAM:** 사용자와 서비스의 접근 권한을 관리
- **Secrets Manager:** Bedrock과 Pinecone간의 통신을 위한 민감한 정보를 안전하게 저장하고 관리
- **Region (ap-northeast-2, us-east-1):** 현재 Amazon Bedrock 서비스의 대부분의 기능을 지원하는 지역은 us-east-1이기 때문에 두 개의 region으로 구현
- **VPC:**
  - **IGW (Internet Gateway):** VPC 외부와의 네트워크 트래픽을 관리
  - **Public Subnet:**
    - **NAT Gateway:** 프라이빗 서브넷의 인스턴스가 인터넷에 접근할 수 있도록 합니다.
    - **Bastion Host:** 프라이빗 서브넷의 리소스에 안전하게 접근할 수 있는 점검용 호스트입니다.
    - **Public LB (Load Balancer):** 외부 트래픽을 분산시켜 웹 서버로 전달합니다.
  - **Private Subnet:**
    - **Web Server:** 사용자 요청을 처리하는 웹 서버입니다.
    - **Internal LB:** 내부 트래픽을 분산시켜 API 서버로 전달합니다.
    - **API Server:** 백엔드 로직을 처리하는 API 서버입니다.

## 📊 사용한 데이터

이 프로젝트에서는 **DACON** 플랫폼에서 제공하는 중앙정부 재정정보 및 질의응답 데이터([DACON 재정정보 데이터](https://dacon.io/competitions/official/236295/data))를 활용하였습니다.

- **재정정보 데이터:** 대한민국 중앙정부 재정정보로, 각 항목에 대한 세부적인 설명과 데이터가 포함되어 있습니다.
- **질의응답 데이터:** 재정 관련 데이터에 대한 다양한 질문과 이에 대한 답변 세트를 포함하여, 질의응답 시스템 학습에 활용되었습니다.

## 사용 방법

1. **데이터 업로드**
   - 관리자는 PDF 또는 HWP 파일을 S3 버킷에 업로드합니다.
   - 업로드된 파일은 자동으로 임베딩되어 벡터 DB에 저장됩니다.
2. **질문 및 답변 생성**
   - 사용자는 원하는 재정 관련 질문을 시스템에 입력합니다.
   - 시스템은 관련 데이터를 검색하여 답변을 생성하고 반환합니다.

## 🔧 추가적인 개선 방향

### RAG 프로세스
- **임베딩 벡터화 방식 및 벡터 검색 알고리즘 최적화**
- **데이터 업데이트 자동화:** 새로운 문서 업로드 시 실시간으로 벡터화 및 DB 업데이트가 가능하도록 파이프라인을 개선

### 인프라
- **Terraform 코드 최적화:** 인프라 코드의 효율성과 가독성을 높이고, 재사용 가능한 모듈을 도입하여 관리 용이성을 향상
- **서버리스 아키텍처 도입:** AWS Lambda를 활용하여 질문 처리의 서버리스 아키텍처 전환을 검토하여 비용 효율성과 확장성을 향상
- **Kubernetes 환경 지원:** ECS 기반에서 EKS로의 확장을 통해 Kubernetes 환경에서의 배포 및 관리를 지원
- **Bedrock 서비스 이중화:** 현재 us-east-1에 있는 Bedrock만을 이용하고 있지만, cross-region inference를 통해 이중화를 구현
- **모니터링:** 시스템 성능과 안정성을 실시간으로 모니터링하기 위해 AWS CloudWatch와 같은 모니터링 도구를 도입
- Route 53

### CI/CD
- **자동화 배포 파이프라인 구축:** GitHub Actions와 Terraform을 결합하여 코드 변경 시 자동으로 배포되는 CI/CD 파이프라인을 구축

## 프로젝트 특징
- **Amazon Bedrock 활용:** Amazon Bedrock을 통한 다양한 생성형 AI 모델의 손쉬운 통합과 관리로 신속한 답변 생성을 구현했습니다.
- **RAG 방식의 정확도 향상:** Retrieval-Augmented Generation을 활용하여 단순한 QA 시스템보다 높은 정확도의 답변을 제공합니다.
- **벡터 데이터베이스의 효율적 활용:** Pinecone을 사용한 고속 유사도 검색으로 대규모 데이터에서도 빠른 응답 시간을 보장합니다.
