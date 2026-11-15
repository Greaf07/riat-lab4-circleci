# Лабораторная работа № 4

Тема: автоматизация доставки проекта. Простой калькулятор на Python и проверки в CircleCI.
В методичке для этой лабораторной нет отдельных вариантов.

## Запуск в Windows и VS Code

Нужен Python 3.11 или 3.12. Откройте папку проекта в VS Code и нажмите **Ctrl+Shift+B**.
Также можно дважды нажать `start.cmd`. При первом запуске создаётся `.venv`
и устанавливаются зависимости из `requirements.txt`; для этого нужен интернет.
Дальнейшие локальные проверки работают без интернета.

Меню: 1 — калькулятор, 2 — тесты, 3 — оформление, 4 — обе проверки,
5 — CircleCI, 6 — GitHub, 0 — выход. В калькуляторе есть отдельное меню операций.
В пункте 4 локальные команды выполняются последовательно; в облаке это два независимых job.

Ручной запуск после подготовки окружения:

```powershell
.\.venv\Scripts\python.exe app.py
.\.venv\Scripts\python.exe -m pytest -v
.\.venv\Scripts\python.exe -m black --check app.py test_app.py
```

Linux / CircleCI:

```bash
python -m pip install -r requirements.txt
python -m pytest -v --junitxml=test-results/pytest.xml
python -m black --check app.py test_app.py
```

## Что реализовано

- `app.py`: сложение, вычитание, умножение, деление, русское меню.
- `test_app.py`: 18 тестов pytest, включая дробные числа и деление на ноль.
- `requirements.txt`: фиксированные версии pytest и Black.
- `.circleci/config.yml`: установка зависимостей, тесты, проверка стиля, кэш pip.
- `start.ps1`: подготовка окружения и выбор локальных команд.
- `.vscode/tasks.json`: запуск меню в терминале VS Code.

В CircleCI используется образ `cimg/python:3.11`. Workflow `build-and-test`
содержит задания `test` и `style` без `requires`: они могут выполняться параллельно.
Оба задания должны завершиться успешно. Если pytest или Black вернёт ненулевой
код, соответствующее задание и весь workflow будут иметь статус Failed.

Кэш `~/.cache/pip` сохраняется отдельно для каждого job. Ключ содержит архитектуру
и контрольную сумму `requirements.txt`. При изменении зависимостей создаётся новый
кэш; отсутствие кэша не мешает сборке. В кэше хранятся загрузки pip, поэтому шаг
установки зависимостей выполняется и после восстановления кэша.
JUnit XML сохраняется в CircleCI для просмотра результатов тестирования.

Здесь автоматизирована непрерывная интеграция (CI). Развёртывания приложения
на сервере нет: по заданию достаточно автоматической установки и проверок.

## Облачный проект

- GitHub: https://github.com/Greaf07/riat-lab4-circleci
- CircleCI: https://app.circleci.com/pipelines/github/Greaf07/riat-lab4-circleci

Для повторной проверки откройте CircleCI и выберите **Rerun workflow from start**.
Новый push в GitHub также запускает workflow. При работе через Git локально:

```bash
git add app.py test_app.py .circleci/config.yml requirements.txt
git commit -m "Update calculator checks"
git push
```

Git должен быть авторизован в вашем аккаунте GitHub. Пароли и токены в файлы
проекта добавлять не нужно. Отчёт и локальное окружение исключены из публикации.

## Если запуск не удался

- Сообщение о Python: установите Python 3.11/3.12 с python.org и повторите запуск.
- Ошибка установки: проверьте интернет; повторите `start.cmd`.
- `Failed` в CircleCI: откройте красный job и его шаг, прочитайте ошибку.
- Black сообщает `would reformat`: запустите `python -m black app.py test_app.py`,
  проверьте изменения и отправьте исправление.

Официальная документация:
https://circleci.com/docs/reference/configuration-reference/
https://circleci.com/docs/guides/optimize/caching/
