# 생성형 AI를 활용한 재정정보 질의응답 시스템

이 프로젝트는 **Amazon Bedrock**을 활용하여 방대한 양의 **대한민국 중앙정부 재정정보 데이터**를 기반으로 사용자에게 신속하고 정확한 정보를 제공하는 생성형 AI 질의응답 시스템을 구축하는 것을 목표로 합니다.

## 🚀 주요 기능

- 자연어 질문을 통한 재정 데이터 검색 및 답변 생성
- 실시간 RAG (Retrieval-Augmented Generation) 기반 정확한 답변 제공
- 답변과 함께 참고한 원본 문서 내용 제공
- 대화 맥락을 고려한 연속적인 질의응답 지원

## 구현 예시
![image](https://github.com/user-attachments/assets/d05a03e8-2ced-4c8e-9e43-95b4d3251335)

## Amazon Bedrock

Amazon Bedrock은 AWS(Amazon Web Services)에서 제공하는 생성형 AI(Generative AI) 서비스 플랫폼입니다. 이 플랫폼은 다양한 사전 학습된 AI 모델을 API를 통해 간편하게 활용할 수 있도록 설계되었으며, 복잡한 인프라 관리 없이도 AI 기술을 애플리케이션에 통합할 수 있는 기능을 제공합니다.

Amazon Bedrock은 AI 모델 구축 및 운영에 소요되는 시간을 줄이고, 개발자가 AI의 핵심 기능에 집중할 수 있도록 지원합니다. 이를 통해 기업은 AI 기반 애플리케이션을 빠르게 개발하고 배포할 수 있습니다.

## 🛠️ 기술 스택

### 🎨 Front-end
- ![Streamlit](https://img.shields.io/badge/Streamlit-F37626?style=flat&logo=Streamlit&logoColor=white)

### 🧰 Back-end
- ![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=Python&logoColor=white)
- ![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=flat&logo=FastAPI&logoColor=white)
- ![Langchain](https://img.shields.io/badge/Langchain-FF9900?style=flat&logo=Langchain&logoColor=white)

### ☁️ Infra
- ![AWS](https://img.shields.io/badge/AWS-232F3E?style=flat&logo=Amazon-AWS&logoColor=white)
- ![Amazon Bedrock](https://img.shields.io/badge/Amazon%20Bedrock-232F3E?style=flat&logo=Amazon-AWS&logoColor=white)
- ![Terraform](https://img.shields.io/badge/Terraform-623CE4?style=flat&logo=Terraform&logoColor=white)

### 🤖 ML
- **Amazon Bedrock KnowledgeBase:**
  - **Anthropic Claude 3 Haiku**
  - **Titan Embeddings G1 - Text v1.2**
- **Pinecone**

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

## 📊 사용한 데이터

이 프로젝트에서는 **DACON** 플랫폼에서 제공하는 중앙정부 재정정보 및 질의응답 데이터([DACON 재정정보 데이터](https://dacon.io/competitions/official/236295/data))를 활용하였습니다.

- **재정정보 데이터:** 대한민국 중앙정부 재정정보로, 각 항목에 대한 세부적인 설명과 데이터가 포함되어 있습니다.
- **질의응답 데이터:** 재정 관련 데이터에 대한 다양한 질문과 이에 대한 답변 세트를 포함하여, 질의응답 시스템 학습에 활용되었습니다.

## 실행 가이드

### 사전 요구사항
- AWS 계정 및 액세스 키
- Terraform
- S3 버킷 구성 및 Bedrock Knowledge Base 구성

### 설치 및 설정
1. **리포지토리 클론:**
    ```bash
    git clone https://github.com/yeseong9769/AWS-Bedrock-Finance-QnA.git
    cd AWS-Bedrock-Finance-QnA
    ```

2. **인프라 배포**
    ```bash
    cd infra
    terraform init
    terraform apply
    ```

## 📈 향후 개선 계획

### 성능 개선
- 실시간 데이터 업데이트 파이프라인 구축
- 다중 리전 지원을 통한 서비스 안정성 강화

### 인프라 개선
- 컨테이너 기반 배포 환경으로 전환
- 모니터링 시스템 구축을 통한 안정성 확보

### 개발 프로세스 개선
- CI/CD 파이프라인 구축으로 배포 자동화
- 인프라 코드 모듈화를 통한 재사용성 향상