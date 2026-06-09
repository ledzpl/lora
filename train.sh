mlx_lm.lora \
  --model ./models/Qwen3-8B-MLX-4bit \
  --train \
  --data ./data \
  --adapter-path ./adapters/Qwen3-8B-MLX-4bit-lora \
  --iters 600 \
  --batch-size 1 \
  --learning-rate 1e-5
