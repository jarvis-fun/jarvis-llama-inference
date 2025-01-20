import os
from flask import Flask, request, jsonify
from dotenv import load_dotenv
from transformers import AutoTokenizer, AutoModelForCausalLM
import torch

# Load environment variables from .env (HF_TOKEN, MODEL_NAME, etc.)
load_dotenv()

app = Flask(__name__)

# Optional: fetch Hugging Face token from environment
HF_TOKEN = os.environ.get("HF_TOKEN")

# Fetch model name from environment variable, default to Llama 2 7B Chat
MODEL_NAME = os.environ.get("MODEL_NAME", "meta-llama/Llama-2-13b-chat-hf")

print(f"Loading model: {MODEL_NAME} ...")

# If you are on CPU only, you may need to remove 'torch_dtype=torch.float16'
# or change to torch.bfloat16 or torch.float32 to avoid errors
tokenizer = AutoTokenizer.from_pretrained(
    MODEL_NAME,
    use_auth_token=HF_TOKEN  # Needed if model is gated (e.g., Llama 2)
)

model = AutoModelForCausalLM.from_pretrained(
    MODEL_NAME,
    use_auth_token=HF_TOKEN,
    load_in_8bit=True,  # or load_in_4bit=True
    device_map="auto"
)

print("Model loaded successfully!")

@app.route('/', methods=['GET'])
def health_check():
    return "Jarvis Llama Inference Server is up and running!"

@app.route('/generate', methods=['POST'])
def generate():
    data = request.get_json()
    prompt = data.get('prompt', '')
    max_new_tokens = data.get('max_new_tokens', 50)

    # Tokenize and move tensors to the model's device (GPU or CPU)
    inputs = tokenizer(prompt, return_tensors="pt").to(model.device)
    output_ids = model.generate(
        **inputs,
        max_new_tokens=max_new_tokens,
        temperature=0.7,
        top_p=0.9
    )

    output_text = tokenizer.decode(output_ids[0], skip_special_tokens=True)
    return jsonify({"response": output_text})

if __name__ == '__main__':
    # Host on all interfaces, port 8080
    app.run(host='0.0.0.0', port=8080)
