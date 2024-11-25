# ------------------------------------------------------
# backend/main.py
# FastAPI Backend Application
# ------------------------------------------------------

import boto3
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Dict

from langchain_core.prompts import PromptTemplate
from langchain_core.runnables import RunnablePassthrough, RunnableParallel
from langchain_core.output_parsers import StrOutputParser
from langchain_aws import ChatBedrock
from langchain_aws import AmazonKnowledgeBasesRetriever

# FastAPI 애플리케이션 초기화
app = FastAPI()

# CORS 설정
# Streamlit 프론트엔드와 통신을 허용하기 위한 설정
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 운영 환경에서는 특정 origin만 허용하도록 수정 권장
    allow_credentials=True,
    allow_methods=["POST"],
    allow_headers=["*"],
)

# ------------------------------------------------------
# Amazon Bedrock 설정

# Bedrock 런타임 클라이언트 생성
bedrock_runtime = boto3.client(
    service_name="bedrock-runtime",
    region_name="us-east-1",  # AWS 리전
)

# 사용 모델 ID와 기본 파라미터 설정
model_id = "anthropic.claude-3-haiku-20240307-v1:0"
model_kwargs = {
    "max_tokens": 2048,  # 최대 생성 토큰 수
    "temperature": 0.3,  # 생성의 다양성 조절
    "top_k": 5,          # 상위 K개의 토큰만 고려
    "top_p": 0.95,       # 누적 확률 기반 토큰 필터링
    "stop_sequences": ["\n\nHuman"],  # 출력 중단 시퀀스
}

# ------------------------------------------------------
# LangChain 설정 - RAG (Retrieval-Augmented Generation) 체인

# 프롬프트 템플릿 정의
# 입력 컨텍스트와 질문을 기반으로 적절한 응답을 생성
prompt = PromptTemplate(
    template="""
        "task_instructions" : [

        당신은 재정 정보 관련 전문가 입니다. 문서를 바탕으로 질문에 한 문장 이내로 답변하세요.
        1. 문서에 있는 내용을 자르거나 편집하지 않고 그대로 가져오세요.
        2. 순서에 따른 번호를 매기지 마세요. 출력 시 불이익을 줄 것입니다.
        3. 수치에 단위가 있다면 문서를 바탕으로 답변에 단위를 포함하세요.
        4. 질문의 키워드를 바탕으로 문서를 끝까지 검토하세요.
        5. 답변 외에 예시, 참고, 정보 출처, 신뢰도, 확장된 답변, '답변: ', '참고: '를 절대로 출력하지 마세요.

        ]

        "문서":
        {context},

        "질문":
        {question},

        "주어진 질문에 대한 답변만 한 문장으로 생성한다."

        "output": 
        """,
    input_variables=["context", "question"]  # 입력 변수 정의
)

# Amazon Bedrock - Knowledge Base Retriever 설정
retriever = AmazonKnowledgeBasesRetriever(
    knowledge_base_id="ZR7PIA4I4M",  # 지식베이스 ID
    retrieval_config={"vectorSearchConfiguration": {"numberOfResults": 2}},  # 검색 결과 개수 제한
)

# Bedrock Chat 모델 구성
model = ChatBedrock(
    client=bedrock_runtime,  # Bedrock 런타임 클라이언트
    model_id=model_id,       # 모델 ID
    model_kwargs=model_kwargs,  # 모델 매개변수
)

# RAG 체인 정의
chain = (
    RunnableParallel({"context": retriever, "question": RunnablePassthrough()})  # 입력 처리
    .assign(response=prompt | model | StrOutputParser())  # 프롬프트, 모델, 출력 파싱 연결
    .pick(["response", "context"])  # 최종 응답 데이터 선택
)

# ------------------------------------------------------
# FastAPI 라우트 정의

# 요청 데이터 모델 정의
class ChatRequest(BaseModel):
    prompt: str  # 사용자 입력 프롬프트

@app.post("/chat")
async def chat(request: ChatRequest) -> Dict:
    """
    Non-streaming chat endpoint
    한 번에 전체 응답을 반환하는 엔드포인트
    """
    response = chain.invoke(request.prompt)  # 체인을 호출하여 응답 생성
    return response

@app.post("/chat/stream")
async def chat_stream(request: ChatRequest):
    """
    Streaming chat endpoint
    응답을 스트리밍 방식으로 반환하는 엔드포인트
    """
    async def generate():
        for chunk in chain.stream(request.prompt):  # 체인 스트림 호출
            yield f"{chunk}\n"  # 실시간으로 응답 조각 반환

    return generate()

@app.get("/health")
async def health():
    """
    Health check endpoint
    서버 상태 확인용 엔드포인트
    """
    return {"status": "ok"}  # 상태 반환