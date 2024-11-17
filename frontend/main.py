# ------------------------------------------------------
# frontend/main.py
# Streamlit Frontend Application
# ------------------------------------------------------

import streamlit as st
import requests

# Page title
st.set_page_config(page_title='Knowledge Bases for Amazon Bedrock and LangChain 🦜️🔗')

# Backend API URL
BACKEND_URL = "http://localhost:8000"  # FastAPI 서버 주소

# Clear Chat History function
def clear_screen():
    st.session_state.messages = [{"role": "assistant", "content": "How may I assist you today?"}]

with st.sidebar:
    st.title('Knowledge Bases for Amazon Bedrock and LangChain 🦜️🔗')
    streaming_on = st.toggle('Streaming')
    st.button('Clear Screen', on_click=clear_screen)

# Store LLM generated responses
if "messages" not in st.session_state.keys():
    st.session_state.messages = [{"role": "assistant", "content": "How may I assist you today?"}]

# Display chat messages
for message in st.session_state.messages:
    with st.chat_message(message["role"]):
        st.write(message["content"])

# Chat Input - User Prompt 
if prompt := st.chat_input():
    st.session_state.messages.append({"role": "user", "content": prompt})
    with st.chat_message("user"):
        st.write(prompt)

    if streaming_on:
        # Streaming mode
        with st.chat_message("assistant"):
            placeholder = st.empty()
            
            # Stream from backend
            response = requests.post(
                f"{BACKEND_URL}/chat/stream",
                json={"prompt": prompt},
                stream=True
            )
            
            full_response = ''
            full_context = None
            
            for line in response.iter_lines():
                if line:
                    chunk = eval(line.decode('utf-8'))
                    if 'response' in chunk:
                        full_response += chunk['response']
                        placeholder.markdown(full_response)
                    else:
                        full_context = chunk
                        
            placeholder.markdown(full_response)
            if full_context:
                with st.expander("Show source details >"):
                    st.write(full_context)
            st.session_state.messages.append({"role": "assistant", "content": full_response})
    else:
        # Non-streaming mode
        with st.chat_message("assistant"):
            response = requests.post(
                f"{BACKEND_URL}/chat",
                json={"prompt": prompt}
            ).json()
            
            st.write(response['response'])
            with st.expander("Show source details >"):
                st.write(response['context'])
            st.session_state.messages.append({"role": "assistant", "content": response['response']})