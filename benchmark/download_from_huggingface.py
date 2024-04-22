#
# Copyright 2016 The BigDL Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


import os
from huggingface_hub import login
from huggingface_hub import snapshot_download

if __name__ == '__main__':
    access_token_read = os.environ.get('HF_TOKEN')  # set huggingface token value in the env var first
    login(token = access_token_read)

    repos = [
        # 'Qwen/Qwen-1_8B-Chat'
        # 'meta-llama/Llama-2-7b-chat-hf',
        # 'mistralai/Mistral-7B-Instruct-v0.2',
        # 'bigcode/starcoder2-3b',
        # 'Qwen/Qwen1.5-4B-Chat',
        # 'google/gemma-2b',
        # 'google/gemma-7b',
        # 'microsoft/phi-2',
        # '01-ai/Yi-6B-Chat',
        # 'tiiuae/falcon-7b-instruct',
        # 'lmsys/vicuna-7b-v1.5',
        # 'codellama/CodeLlama-7b-hf',
        # 'cognitivecomputations/dolphin-2.6-mistral-7b',
        # 'google/codegemma-7b',
        # 'bigcode/starcoder2-3b',
        # 'deepseek-ai/deepseek-coder-7b-instruct-v1.5',
        # 'ise-uiuc/Magicoder-S-DS-6.7B'   

        # 'HuggingFaceH4/zephyr-7b-beta',
        
        # 'meta-llama/Meta-Llama-3-8B-Instruct',
        # 'Qwen/Qwen1.5-7B-Chat',
        # 'stabilityai/stablelm-zephyr-3b'
        # 'microsoft/Phi-3-mini-128k-instruct',
        # 'nlpaueb/legal-bert-base-uncased',
        # 'Equall/Saul-Instruct-v1',
        # 'AdaptLLM/law-chat',
        # 'AdaptLLM/finance-chat',
        # 'nlpaueb/sec-bert-base'

    ]

    for repo in repos:
        local_dir = repo.split("/")[1]

        snapshot_download(repo_id=repo, local_dir=local_dir,
                        local_dir_use_symlinks=False)
