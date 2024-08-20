import streamlit as st
from app import get_answer

st.title("FAST NUCES AI BATCH 2020 Q & A")

question = st.text_input("Question:")

if question:
    answer = get_answer(question)
    st.text("Answer:")
    st.write(answer)