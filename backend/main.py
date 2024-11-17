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

app = FastAPI()

# CORS 설정 - Streamlit과 통신을 위해 필요
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 실제 운영환경에서는 구체적인 origin을 지정하세요
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ------------------------------------------------------
# Amazon Bedrock - settings

bedrock_runtime = boto3.client(
    service_name="bedrock-runtime",
    region_name="us-east-1",
)

model_id = "anthropic.claude-3-haiku-20240307-v1:0"

model_kwargs = {
    "max_tokens": 2048,
    "temperature": 0.3,
    "top_k": 5,
    "top_p": 0.95,
    "stop_sequences": ["\n\nHuman"],
}

# ------------------------------------------------------
# LangChain - RAG chain with citations

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
    input_variables=["context", "question"]
)

# Amazon Bedrock - KnowledgeBase Retriever 
retriever = AmazonKnowledgeBasesRetriever(
    knowledge_base_id="ZR7PIA4I4M",
    retrieval_config={"vectorSearchConfiguration": {"numberOfResults": 2}},
)

model = ChatBedrock(
    client=bedrock_runtime,
    model_id=model_id,
    model_kwargs=model_kwargs,
)

chain = (
    RunnableParallel({"context": retriever, "question": RunnablePassthrough()})
    .assign(response=prompt | model | StrOutputParser())
    .pick(["response", "context"])
)

# ------------------------------------------------------
# FastAPI routes

class ChatRequest(BaseModel):
    prompt: str

@app.post("/chat")
async def chat(request: ChatRequest) -> Dict:
    """Non-streaming chat endpoint"""
    response = chain.invoke(request.prompt)
    return response

@app.post("/chat/stream")
async def chat_stream(request: ChatRequest):
    """Streaming chat endpoint"""
    async def generate():
        for chunk in chain.stream(request.prompt):
            yield f"{chunk}\n"

    return generate()