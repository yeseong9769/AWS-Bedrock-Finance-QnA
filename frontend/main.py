# ------------------------------------------------------
# frontend/main.py
# Streamlit Frontend Application
# ------------------------------------------------------

import streamlit as st 
import requests         

st.set_page_config(page_title='재정정보 질의응답 시스템')
BACKEND_URL = st.secrets["BACKEND_URL"]

# 채팅 기록 초기화 함수
def clear_screen():
    st.session_state.messages = [{"role": "assistant", "content": "안녕하세요. 대한민국 재정정보 질의응답 시스템입니다. 궁금하신 내용을 입력해주세요."}]

# 사이드바 구성
with st.sidebar:
    st.title('재정정보 질의응답 시스템')
    streaming_on = st.toggle('Streaming')
    st.button('Clear Screen', on_click=clear_screen)

# 세션 상태 초기화
if "messages" not in st.session_state.keys():
    clear_screen()

# 이전 메시지 표시
for message in st.session_state.messages:
    with st.chat_message(message["role"]):
        st.write(message["content"])

# 사용자 입력 처리
if prompt := st.chat_input():
    st.session_state.messages.append({"role": "user", "content": prompt})
    with st.chat_message("user"):
        st.write(prompt)

    if streaming_on:
        # 스트리밍 모드
        with st.chat_message("assistant"):
            placeholder = st.empty()
            response = requests.post(f"{BACKEND_URL}/chat/stream", json={"prompt": prompt}, stream=True)
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
            if full_context:
                with st.expander("Source Document > "): 
                    st.write(full_context)
            st.session_state.messages.append({"role": "assistant", "content": full_response})
    else:
        # 비스트리밍 모드
        with st.chat_message("assistant"):
            response = requests.post(f"{BACKEND_URL}/chat", json={"prompt": prompt}).json()
            st.write(response['response'])
            with st.expander("Source Document > "): 
                st.write(response['context'])
            st.session_state.messages.append({"role": "assistant", "content": response['response']})