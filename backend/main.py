# Import required libraries
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

# Initialize FastAPI application
app = FastAPI()

# Configure logging settings
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s"
)
logger = logging.getLogger(__name__)

def get_chain():
    """
    Creates and returns a LangChain chain for processing chat requests
    Combines document retrieval, prompt creation, and model interaction
    """
    settings = get_settings()
    
    # Configure AWS Bedrock runtime client
    bedrock_runtime = boto3.client(
        service_name="bedrock-runtime",
        region_name=settings.AWS_REGION
    )

    # Set up the prompt template for structuring model inputs
    prompt = PromptTemplate(
        template=settings.PROMPT,
        input_variables=["context", "question"]
    )

    # Configure the document retriever for fetching relevant context
    session = boto3.Session()
    retriever = AmazonKnowledgeBasesRetriever(
        knowledge_base_id=settings.KNOWLEDGE_BASE_ID,
        retrieval_config={"vectorSearchConfiguration": {"numberOfResults": 3}},
        client=session.client("bedrock-agent-runtime", settings.AWS_REGION)
    )

    # Set up the Bedrock model with specified configuration
    model = ChatBedrock(
        client=bedrock_runtime,
        model_id=settings.MODEL_ID,
        model_kwargs=settings.MODEL_KWARGS
    )

    # Create the processing chain:
    # 1. Parallel processing of context retrieval and question
    # 2. Generate response using prompt and model
    # 3. Select relevant output fields
    chain = (
        RunnableParallel({"context": retriever, "question": RunnablePassthrough()}).
        assign(response=prompt | model | StrOutputParser()).
        pick(["response", "context"])
    )
    return chain

# Middleware for request logging
@app.middleware("http")
async def log_requests(request: Request, call_next):
    """
    Middleware to log HTTP request details and timing
    Generates unique ID for each request and tracks processing time
    """
    request_id = str(uuid4())
    logger.info(f"Request {request_id} started: {request.method} {request.url}")
    start_time = time.time()
   
    response = await call_next(request)
   
    process_time = time.time() - start_time
    logger.info(
        f"Request {request_id} completed: {response.status_code} ({process_time:.2f}s)"
    )
    return response

# Main chat endpoint for handling chat requests
@app.post("/chat")
async def chat(request: dict):
    """
    Processes chat requests and returns responses
    Includes error handling and response formatting
    """
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

# Streaming endpoint (currently commented out)
# @app.post("/chat/stream")
# async def chat_stream(request: ChatRequest):
#     """
#     Streaming chat endpoint
#     Returns responses in a streaming fashion
#     """
#     async def generate():
#         for chunk in chain.stream(request.prompt):
#             yield f"{chunk}\n"
#     return generate()

# Health check endpoint
@app.get("/health")
async def health():
    """
    Simple health check endpoint
    Returns OK status to verify server is running
    """
    return {"status": "ok"}