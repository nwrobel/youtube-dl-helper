$venvDir = Join-Path $PSScriptRoot -ChildPath "py-venv"
$activateFilePath = Join-Path $venvDir -ChildPath "Scripts\activate"
$pipReqsFilePath = Join-Path $PSScriptRoot -ChildPath "requirements.txt"

virtualenv.exe $venvDir
& $activateFilePath
pip install -r $pipReqsFilePath
