### Installation
Install ipex-llm using the guide [here](https://ipex-llm.readthedocs.io/en/latest/doc/LLM/Quickstart/install_windows_gpu.html)

Install pip packages used in benchmark.
``` 
cd benchmark
pip install -r requirements.txt
``` 

### Download models
Models can be downloaded from huggingface hub with the script `python\llm\test\win\download_from_huggingface.py`.
Download the models to `<models folder>`


### Running benchmark
Set environment variable for `<models folder>`
``` 
set MODEL_HUB_PATH=<models folder>
``` 

Run benchmark
``` 
cd benchmark
run-mtl.bat
``` 

Results will be saved to `benchmark\results`