import time
import boto3
import logging.config

from fastapi import FastAPI, Request, Depends
from fastapi.responses import StreamingResponse, JSONResponse

from langchain_core.prompts import PromptTemplate
from langchain_core.runnables import RunnablePassthrough, RunnableParallel
from langchain_core.output_parsers import StrOutputParser
from langchain_aws import ChatBedrock, AmazonKnowledgeBasesRetriever

from config import get_settings
from uuid import uuid4

# FastAPI 애플리케이션 초기화
app = FastAPI()

# 로깅 설정
logging.baseConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s"
)
logger = logging.getLogger(__name__)

def get_chain():
    settings = get_settings()

    # AWS 클라이언트 설정
    bedrock_runtime = boto3.client(
        service_name="bedrock-runtime",
        region_name=settings.AWS_REGION
    )

    # LangChaing 설정
    prompt = PromptTemplate(
        template=settings.PROMPT,
        input_variables=["context", "question"]
    )

    # Retriever 설정
    session = boto3.Session()
    retriever = AmazonKnowledgeBasesRetriever(
        knowledge_base_id=settings.KNOWLEDGE_BASE_ID,
        retrieval_config={"vectorSearchConfiguration": {"numberOfResults": 3}},
        client=session.client("bedrock-agent-runtime", settings.AWS_REGION)
    )

    # Bedrock 모델 설정
    model = ChatBedrock(
        client=bedrock_runtime,
        model_id=settings.MODEL_ID,
        model_kwargs=settings.MODEL_KWARGS
    )

    # Chain 설정
    chain = (
        RunnableParallel({"context": retriever, "question": RunnablePassthrough()}).
        assign(response=prompt | model | StrOutputParser()).
        pick(["response", "context"])
    )

    return chain

@app.middleware("http")
async def log_requests(request: Request, call_next):
    request_id = str(uuid4())
    logger.info(f"Request {request_id} started: {request.method} {request.url}")
    start_time = time.time()
    
    response = await call_next(request)
    
    process_time = time.time() - start_time
    logger.info(
        f"Request {request_id} completed: {response.status_code} ({process_time:.2f}s)"
    )
    return response

@app.post("/chat")
async def chat(request: dict):
    try:
        chain = get_chain()
        response = chain.invoke(request["prompt"])
        return {
            "response": response["response"],
            "context": response["context"],
            "request_id": str(uuid4())
        }
    except Exception as e:
        logger.error(f"Error generating response: {str(e)}")
        return JSONResponse(
            status_code=503,
            content={"error": str(e)}
        )

# @app.post("/chat/stream")
# async def chat_stream(request: ChatRequest):
#     """
#     Streaming chat endpoint
#     응답을 스트리밍 방식으로 반환하는 엔드포인트
#     """
#     async def generate():
#         for chunk in chain.stream(request.prompt):  # 체인 스트림 호출
#             yield f"{chunk}\n"  # 실시간으로 응답 조각 반환

#     return generate()

@app.get("/health")
async def health():
    return {"status": "ok"}