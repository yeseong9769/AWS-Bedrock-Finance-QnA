import streamlit as st
import requests
import json

st.set_page_config(
    page_title='재정정보 질의응답 시스템',
    initial_sidebar_state="expanded"
)

BACKEND_URL = st.secrets["BACKEND_URL"]

def clear_screen():
    st.session_state.messages = [{"role": "assistant", "content": "안녕하세요. 대한민국 재정정보 질의응답 시스템입니다. 궁금하신 내용을 입력해주세요."}]

# 스타일 정의
st.markdown("""
    <style>
    .stAlert {
        padding: 1rem;
        margin-bottom: 1rem;
        border-radius: 0.5rem;
    }
    .error {
        background-color: #f8d7da;
        color: #721c24;
    }
    </style>
""", unsafe_allow_html=True)

# 사이드바 구성
with st.sidebar:
    st.title('재정정보 질의응답 시스템')
    st.markdown("---")
    
    if st.button('새로운 대화', use_container_width=True):
        clear_screen()

# 세션 상태 초기화
if "messages" not in st.session_state:
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

    try:
        # 스트리밍 모드
        with st.chat_message("assistant"):
            placeholder = st.empty()
            with st.spinner('응답 생성 중...'):
                response = requests.post(
                    f"{BACKEND_URL}/chat/stream",
                    json={"prompt": prompt},
                    stream=True,
                    timeout=30
                )
                full_response = ''
                full_context = None
                
                for line in response.iter_lines():
                    if line:
                        try:
                            chunk = json.loads(line.decode('utf-8'))
                            if 'response' in chunk:
                                full_response += chunk['response']
                                placeholder.markdown(full_response)
                            else:
                                full_context = chunk
                        except json.JSONDecodeError:
                            continue
                            
                if full_context:
                    with st.expander("출처 문서 보기"): 
                        st.write(full_context)
                st.session_state.messages.append({"role": "assistant", "content": full_response})

    except requests.exceptions.Timeout:
        st.error("요청 시간이 초과되었습니다. 잠시 후 다시 시도해주세요.")
    except requests.exceptions.RequestException as e:
        st.error(f"오류가 발생했습니다: {str(e)}")
    except Exception as e:
        st.error(f"예상치 못한 오류가 발생했습니다: {str(e)}")