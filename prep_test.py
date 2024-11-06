import pandas as pd
import random

# CSV 파일을 로드합니다.
csv_file = 'data/train.csv'  # 원본 CSV 파일 경로
df = pd.read_csv(csv_file, encoding='utf-8-sig')

# 데이터의 총 행 수 확인
total_rows = len(df)

# 랜덤으로 10개씩 뽑아서 5개 파일로 나눕니다.
for i in range(5):
    # 10개의 랜덤 샘플을 뽑습니다.
    sampled_df = df.sample(n=10, random_state=random.randint(1, 10000))  # 랜덤 시드를 고정하면 결과가 동일하게 나오므로, 랜덤 값으로 설정
    
    # 샘플링된 데이터를 새로운 파일로 저장합니다.
    output_file = f'data/output_{i+1}.csv'  # 출력 파일 이름 설정
    sampled_df.to_csv(output_file, index=False, encoding='utf-8-sig')
    print(f'파일 {output_file} 저장 완료')