@echo off
REM activate conda environment and run script from .\benchmark\

set CWD=%cd%

@REM Prep output folder
set OUTPUT_DIR=%cd%\results\%date:~10,4%-%date:~4,2%-%date:~7,2%_%time:~0,2%-%time:~3,2%-%time:~6,2%
mkdir "%OUTPUT_DIR%"

@REM Ensure no csv files in all-in-one folder
cd ..\python\llm\dev\benchmark\all-in-one
if exist *.csv (
    echo csv file exists. Stopping.
    exit /b 1
)
cd %CWD%

@REM set environment variables
set SYCL_CACHE_PERSISTENT=1
set BIGDL_LLM_XMX_DISABLED=1
set IPEX_LLM_QUANTIZE_KV_CACHE=1
copy run-mtl.bat "%OUTPUT_DIR%"

@REM transformers==4.31.0
@REM python -m pip install transformers==4.31.0
@REM copy config_431.yaml ..\python\llm\dev\benchmark\all-in-one\config.yaml
@REM cd ..\python\llm\dev\benchmark\all-in-one
@REM python run.py
@REM move *.csv "%OUTPUT_DIR%"
@REM cd %CWD%

@REM transformers==4.34.0
python -m pip install transformers==4.34.0
pip list > "%OUTPUT_DIR%\config_434_requirements.txt"
copy config_434.yaml ..\python\llm\dev\benchmark\all-in-one\config.yaml
copy config_434.yaml "%OUTPUT_DIR%"
cd ..\python\llm\dev\benchmark\all-in-one
python run.py
move *.csv "%OUTPUT_DIR%"
cd %CWD%

@REM transformers==4.38.0
python -m pip install transformers==4.38.0
pip list > "%OUTPUT_DIR%\config_438_requirements.txt"
copy config_438.yaml ..\python\llm\dev\benchmark\all-in-one\config.yaml
copy config_438.yaml "%OUTPUT_DIR%"
cd ..\python\llm\dev\benchmark\all-in-one
python run.py
move *.csv "%OUTPUT_DIR%"
cd %CWD%

@REM concatenate all csv files
python concat_csv.py -i "%OUTPUT_DIR%"
