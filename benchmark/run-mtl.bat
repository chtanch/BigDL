@REM @echo off
REM activate conda environment and run script from .\benchmark\

set CWD=%cd%

@REM Prep output folder
set OUTPUT_DIR=%cd%\results\%date:~10,4%-%date:~4,2%-%date:~7,2%_%time:~0,2%-%time:~3,2%-%time:~6,2%
@REM mkdir "%OUTPUT_DIR%"

@REM set environment variables
set SYCL_CACHE_PERSISTENT=1
set BIGDL_LLM_XMX_DISABLED=1
set IPEX_LLM_QUANTIZE_KV_CACHE=1
@REM copy run-mtl.bat "%OUTPUT_DIR%"

setlocal enabledelayedexpansion
for %%f in ("configs\transformers\*.yaml") do (
    rem Extract the basename of the file (without extension)
    set "full_path=%%~f"
    set "basename=%%~nf"
    @REM for %%A in ("!full_path!") do set "basename=%%~nxA"

    rem Split the basename by underscore and extract the second part
    for /f "tokens=1,* delims=_" %%B in ("!basename!") do (
        set "second_part=%%C"
        echo Second part of basename for file !basename!: !second_part!
    )

    python -m pip install transformers==!second_part!
    @REM copy !full_path! ..\python\llm\dev\benchmark\all-in-one\config.yaml
    cd ..\python\llm\dev\benchmark\all-in-one
    python run.py --config-path "..\\..\\..\\..\\..\\benchmark\\configs" "transformers=!basename!"
)
endlocal

cd %CWD%

@REM transformers==4.31.0
@REM python -m pip install transformers==4.31.0
@REM copy config_431.yaml ..\python\llm\dev\benchmark\all-in-one\config.yaml
@REM cd ..\python\llm\dev\benchmark\all-in-one
@REM python run.py
@REM move *.csv "%OUTPUT_DIR%"
@REM cd %CWD%

@REM transformers==4.34.0
@REM python -m pip install transformers==4.34.0
@REM pip list > "%OUTPUT_DIR%\config_434_requirements.txt"
@REM copy config_434.yaml ..\python\llm\dev\benchmark\all-in-one\config.yaml
@REM copy config_434.yaml "%OUTPUT_DIR%"
@REM cd ..\python\llm\dev\benchmark\all-in-one
@REM python run.py --config-path "..\\..\\..\\..\\..\\benchmark\\configs" "config-name" "default" "transformers=4.34"
@REM move *.csv "%OUTPUT_DIR%"
@REM cd %CWD%

@REM @REM transformers==4.38.0
@REM python -m pip install transformers==4.38.0
@REM pip list > "%OUTPUT_DIR%\config_438_requirements.txt"
@REM copy config_438.yaml ..\python\llm\dev\benchmark\all-in-one\config.yaml
@REM copy config_438.yaml "%OUTPUT_DIR%"
@REM cd ..\python\llm\dev\benchmark\all-in-one
@REM python run.py
@REM move *.csv "%OUTPUT_DIR%"
@REM cd %CWD%

@REM @REM concatenate all csv files
@REM python concat_csv.py -i "%OUTPUT_DIR%"
