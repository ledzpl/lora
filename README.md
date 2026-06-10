# MLX LoRA 학습 절차

## 1. Python 가상환경 활성화

```bash
source .venv/bin/activate
```

## 2. 모델 다운로드
https://huggingface.co/settings/tokens
```bash
#허깅페이스 로그인
hf auth login
```

훈련 시킬 모델 다운로드
```bash
#왜인지, gemma 최신 버전에선 모두 실패, 일단 Qwen 으로 시도
hf download  --local-dir ./models/Qwen3-8B-MLX-4bit  Qwen/Qwen3-8B-MLX-4bit
```

## 3. 데이터를 준비한다.
- train.jsonl
- valid.jsonl

대화형
```jsonl
#{"messages":[{"role":"user","content":"환불은 얼마나 걸리나요?"},{"role":"assistant","content":"환불은 결제 수단에 따라 영업일 기준 3~5일 정도 소요될 수 있습니다."}]}
#{"messages":[{"role":"user","content":"환불 기간 알려주세요."},{"role":"assistant","content":"환불은 결제 수단에 따라 영업일 기준 3~5일 정도 소요될 수 있습니다."}]}
```

텍스트형
```json
#{"text":"배송 정책\n\n일반 배송은 결제 완료 후 영업일 기준 2~3일 정도 소요됩니다. 도서산간 지역은 추가로 1~2일이 더 걸릴 수 있습니다."}
#{"text":"환불 정책\n\n환불은 결제 수단에 따라 영업일 기준 3~5일 정도 소요됩니다. 상품이 이미 발송된 경우에는 반품 접수 후 환불이 진행됩니다."}
#{"text":"회원 계정 안내\n\n비밀번호를 잊어버린 경우 로그인 화면의 비밀번호 찾기를 통해 재설정할 수 있습니다. 이메일 인증이 필요할 수 있습니다."}
```

데이터 갯수
```
#50~100개: 파이프라인 테스트용
#300~500개: 톤/형식 학습 가능
#1,000~3,000개: 작은 업무 도메인에서 쓸 만함
#5,000개 이상: 카테고리 다양성이 있는 업무용에 안정적
```

## 3. 트레이닝 
- train.sh

```bash
mlx_lm.lora \
  --model ./models/Qwen3-8B-MLX-4bit \
  --train \
  --data ./data \
  --adapter-path ./adapters/Qwen3-8B-MLX-4bit-lora \
  --iters 600 \
  --batch-size 1 \
  --learning-rate 1e-5
```

## 4. 밸리데이션
- valid.sh

```bash
mlx_lm.generate \
  --model ./models/Qwen3-8B-MLX-4bit \
  --adapter-path ./adapters/Qwen3-8B-MLX-4bit-lora \
  --prompt "대환의 생일은?" \
  --max-tokens 200
```

## 5. base 모델에 lora 머징
- merge.sh

```bash
mlx_lm.fuse \
  --model ./models/Qwen3-8B-MLX-4bit \
  --adapter-path ./adapters/Qwen3-8B-MLX-4bit-lora \
  --save-path ./models/Qwen3-cs-fused-4bit \
```

----

TODO 
- ollama 에서 사용하기 위한 방법
- 배포
  
  
