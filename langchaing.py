# ------------------------------------------------------
# Streamlit
# Knowledge Bases for Amazon Bedrock and LangChain 🦜️🔗
# ------------------------------------------------------

import boto3

from langchain_core.prompts import ChatPromptTemplate
from langchain_core.runnables import RunnablePassthrough, RunnableParallel
from langchain_core.output_parsers import StrOutputParser
from langchain_aws import ChatBedrock
from langchain_aws import AmazonKnowledgeBasesRetriever

# ------------------------------------------------------
# Amazon Bedrock - settings

bedrock_runtime = boto3.client(
    service_name="bedrock-runtime",
    region_name="us-east-1",
)

model_id = "anthropic.claude-3-sonnet-20240229-v1:0"

model_kwargs =  { 
    "max_tokens": 2048,
    "temperature": 0.0,
    "top_k": 250,
    "top_p": 1,
    "stop_sequences": ["\n\nHuman"],
}

# ------------------------------------------------------
# LangChain - RAG chain with citations

template = '''다음 정보를 바탕으로 질문에 답하세요:
{context}

질문의 핵심만 파악하여 간결하게 1-2문장으로 답변하고, 불필요한 설명은 피하며 요구된 정보만 제공하세요.

Question: {question}'''

prompt = ChatPromptTemplate.from_template(template)

# Amazon Bedrock - KnowledgeBase Retriever 
retriever = AmazonKnowledgeBasesRetriever(
    knowledge_base_id="JY9GSAOJIG", # 👈 Set your Knowledge base ID
    retrieval_config={"vectorSearchConfiguration": {"numberOfResults": 4}},
)

model = ChatBedrock(
    client=bedrock_runtime,
    model_id=model_id,
    model_kwargs=model_kwargs,
)

chain = (
    RunnableParallel({"context": retriever, "question": RunnablePassthrough()})
    .assign(response = prompt | model | StrOutputParser())
    .pick(["response", "context"])
)

# ------------------------------------------------------
# Streamlit

import streamlit as st

# Page title
st.set_page_config(page_title='Knowledge Bases for Amazon Bedrock and LangChain 🦜️🔗')

# Clear Chat History fuction
def clear_screen():
    st.session_state.messages = [{"role": "assistant", "content": "How may I assist you today?"}]

with st.sidebar:
    st.title('Knowledge Bases for Amazon Bedrock and LangChain 🦜️🔗')
    streaming_on = st.toggle('Streaming')
    st.button('Clear Screen', on_click=clear_screen)

# Store LLM generated responses
if "messages" not in st.session_state.keys():
    st.session_state.messages = [{"role": "assistant", "content": "How may I assist you today?"}]

# Display or clear chat messages
for message in st.session_state.messages:
    with st.chat_message(message["role"]):
        st.write(message["content"])

# Chat Input - User Prompt 
if prompt := st.chat_input():
    st.session_state.messages.append({"role": "user", "content": prompt})
    with st.chat_message("user"):
        st.write(prompt)

    if streaming_on:
        # Chain - Stream
        with st.chat_message("assistant"):
            placeholder = st.empty()
            full_response = ''
            # Chain Stream
            for chunk in chain.stream(prompt):
                if 'response' in chunk:
                    full_response += chunk['response']
                    placeholder.markdown(full_response)
                else:
                    full_context = chunk
            placeholder.markdown(full_response)
            with st.expander("Show source details >"):
                st.write(full_context)
            st.session_state.messages.append({"role": "assistant", "content": full_response})
    else:
        # Chain - Invoke
        with st.chat_message("assistant"):
            response = chain.invoke(prompt)
            st.write(response['response'])
            with st.expander("Show source details >"):
                st.write(response['context'])
            st.session_state.messages.append({"role": "assistant", "content": response['response']})