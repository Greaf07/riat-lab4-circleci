$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath $PSScriptRoot
[Console]::InputEncoding = [System.Text.UTF8Encoding]::new($false)
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
$env:PYTHONIOENCODING = 'utf-8'
$env:PYTHONUTF8 = '1'
$python = Join-Path $PSScriptRoot '.venv\Scripts\python.exe'

if (-not (Test-Path -LiteralPath $python)) {
    $installedPython = Join-Path $env:LOCALAPPDATA 'Programs\Python\Python312\python.exe'
    if (Test-Path -LiteralPath $installedPython) {
        & $installedPython -m venv .venv
    } elseif (Get-Command py -ErrorAction SilentlyContinue) {
        & py -3 -m venv .venv
    } else {
        throw 'Установите Python 3.11 или 3.12 с python.org и повторите запуск.'
    }
    if ($LASTEXITCODE -ne 0) { throw 'Не удалось создать окружение Python.' }
}

& $python -c "from importlib.metadata import distributions; versions = {d.metadata['Name'].lower(): d.version for d in distributions()}; raise SystemExit(versions.get('pytest') != '7.4.4' or versions.get('black') != '24.10.0')" 2>$null
if ($LASTEXITCODE -ne 0) {
    & $python -m pip install -r requirements.txt
    if ($LASTEXITCODE -ne 0) { throw 'Не удалось установить зависимости. Проверьте интернет.' }
}

function Show-CheckResult {
    param([int]$Code)
    if ($Code -eq 0) {
        Write-Host 'Проверка пройдена.' -ForegroundColor Green
    } else {
        Write-Host "Проверка не пройдена. Код завершения: $Code" -ForegroundColor Red
    }
}

while ($true) {
    Write-Host ''
    Write-Host 'Лабораторная работа № 4. Автоматизация доставки проекта'
    Write-Host '1 — Запустить калькулятор'
    Write-Host '2 — Запустить тесты pytest'
    Write-Host '3 — Проверить оформление Black'
    Write-Host '4 — Выполнить обе проверки'
    Write-Host '5 — Открыть CircleCI'
    Write-Host '6 — Открыть репозиторий GitHub'
    Write-Host '0 — Выход'
    $choice = Read-Host 'Выберите пункт'

    switch ($choice) {
        '1' { & $python app.py }
        '2' {
            & $python -m pytest -v --junitxml=test-results/pytest.xml
            Show-CheckResult $LASTEXITCODE
        }
        '3' {
            & $python -m black --check app.py test_app.py
            Show-CheckResult $LASTEXITCODE
        }
        '4' {
            & $python -m pytest -v --junitxml=test-results/pytest.xml
            $testCode = $LASTEXITCODE
            & $python -m black --check app.py test_app.py
            $styleCode = $LASTEXITCODE
            if ($testCode -eq 0 -and $styleCode -eq 0) {
                Write-Host 'Тесты и проверка оформления пройдены.' -ForegroundColor Green
            } else {
                Write-Host 'Есть ошибки. Посмотрите результаты выше.' -ForegroundColor Red
            }
        }
        '5' { Start-Process 'https://app.circleci.com/pipelines/github/Greaf07/riat-lab4-circleci' }
        '6' { Start-Process 'https://github.com/Greaf07/riat-lab4-circleci' }
        '0' { exit 0 }
        default { Write-Host 'Введите номер от 0 до 6.' }
    }
}
