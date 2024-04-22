@echo off
REM activate conda environment and run script from .\benchmark\

set CWD=%cd%

@REM Prep output folder
set OUTPUT_DIR=%cd%\results\%date:~10,4%-%date:~4,2%-%date:~7,2%_%time:~0,2%-%time:~3,2%-%time:~6,2%
mkdir "%OUTPUT_DIR%"

REM Ensure no csv files in all-in-one folder
cd ..\python\llm\dev\benchmark\all-in-one
if exist *.csv (
    echo csv file exists. Stopping.
    exit /b 1
)
cd %CWD%

REM set environment variables
set SYCL_CACHE_PERSISTENT=1
set BIGDL_LLM_XMX_DISABLED=1

REM transformers==4.31.0
python -m pip install transformers==4.31.0
copy config_431.yaml ..\python\llm\dev\benchmark\all-in-one\config.yaml
cd ..\python\llm\dev\benchmark\all-in-one
python run.py
move *.csv "%OUTPUT_DIR%"
cd %CWD%

REM transformers==4.37.0
python -m pip install transformers==4.37.0
copy config_437.yaml ..\python\llm\dev\benchmark\all-in-one\config.yaml
cd ..\python\llm\dev\benchmark\all-in-one
python run.py
move *.csv "%OUTPUT_DIR%"
cd %CWD%


