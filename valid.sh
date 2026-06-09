mlx_lm.generate \
  --model ./models/Qwen3-8B-MLX-4bit \
  --adapter-path ./adapters/Qwen3-8B-MLX-4bit-lora \
  --prompt "대환의 생일은?" \
  --max-tokens 200
