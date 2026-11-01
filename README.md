# Dotfiles: Linux / macOS

Минималистичная конфигурация для Neovim **0.13 nightly**, tmux **3.3+**,
zsh, Starship и Kitty. Ветки `linux` и `macos` используют общую переносимую
конфигурацию; платформенные различия определяются при запуске. `master` сохранена
как прежняя версия. Проверено на Linux; запуск на настоящем macOS ещё необходим.

## Зависимости и подключение

Нужны Git, Neovim nightly со встроенной темой `catppuccin`, tmux, zsh, Starship,
`ripgrep` (Telescope live grep), Node.js/npm, Python с venv, C/C++ compiler,
`make`, `curl`, `unzip`, `tar`, CLI `tree-sitter` версии 0.26.1+. Опционально: `fd`, `fzf`
(с поддержкой `--zsh`), `zoxide`, Kitty и JetBrainsMono Nerd Font.
Для clipboard: `wl-clipboard` на Wayland, `xclip` на X11; macOS использует
`pbcopy`/`pbpaste`. OSC 52 требует поддержки и разрешения со стороны терминала.

На Arch зависимости доступны через pacman (включая `base-devel`,
`tree-sitter-cli`, `python`, `nodejs`, `npm`); nightly Neovim устанавливайте отдельно.
На macOS установите Command Line Tools (`xcode-select --install`), затем зависимости
через Homebrew; nightly Neovim — `brew install --HEAD neovim`.
Поддерживаются Homebrew `/opt/homebrew` и `/usr/local`.

Подключение выполняется вручную. Сначала сохраните имеющиеся файлы/симлинки,
затем свяжите следующие пути с соответствующими файлами в checkout:

| Репозиторий | Домашний каталог |
| --- | --- |
| `.zshrc` | `~/.zshrc` |
| `.config/nvim` | `${XDG_CONFIG_HOME:-~/.config}/nvim` |
| `.config/tmux/tmux.conf` | `~/.config/tmux/tmux.conf` |
| `.config/starship.toml` | `${XDG_CONFIG_HOME:-~/.config}/starship.toml` |
| `.config/kitty/kitty.conf` | `~/.config/kitty/kitty.conf` |

`~` в этой таблице обозначает домашний каталог, а не готовую shell-подстановку.
На обследованной Linux-машине `~/.zshrc` ссылался на отсутствующий `zsh/.zshrc`
внутри репозитория; новая структура использует `.zshrc` в его корне.
Скрипта установки нет; существующие домашние конфиги автоматически не меняются.

## Neovim

Семь плагинов через встроенный `vim.pack`: vim-surround, Telescope, Plenary,
Mason, mason-lspconfig, nvim-lspconfig, nvim-treesitter. Lock-файл фиксирует ревизии;
`:packupdate` предлагает обновления для просмотра перед сохранением.
Первый запуск требует сети. Старые плагины могут остаться на диске после смены
конфига, но не загружаются; просмотрите `:packupdate ++offline` и удалите ненужные
через `:packdel`, не удаляя пользовательские данные.

Mason устанавливает `clangd`, `pyright`, `lua_ls`, `bashls`, `marksman` и включает
установленные серверы. Остальные можно добавить через `:LspInstall`.
`:checkhealth vim.lsp mason nvim-treesitter` помогает проверить окружение.

Один раз выполните `:TSInstallDefaults`, дождитесь завершения и переоткройте файлы.
Команда устанавливает C/C++, Python, Lua, Vim/Vimdoc, Bash и Markdown-парсеры.
Обновление парсеров — явное `:TSUpdate`. Подсветка и folding используют API Neovim;
отступы — встроенные filetype scripts. Файл без парсера открывается нормально.

Форматтеры устанавливаются отдельно:

```vim
:MasonInstall clang-format ruff stylua shfmt prettier
```

`<Space>cf` форматирует именованный буфер вручную. Инструменты читают настройки
проекта; неуспешный запуск или редактирование во время работы не заменяет текст.
Результат можно отменить через `u`. Сохранение само по себе не форматирует и не
удаляет пробелы, включая значимые два пробела в Markdown.

| Клавиши | Действие |
| --- | --- |
| `Space ff / fg / fb / fd` | Файлы / grep / буферы / диагностика |
| `Space fr / fws / fic / foc` | References / workspace symbols / incoming / outgoing calls |
| `Space e` | Встроенный файловый браузер |
| `Ctrl-Space` в insert | LSP completion; автоматический показ по триггерам сервера |
| `Ctrl-y / Ctrl-e` в completion | Принять / закрыть меню |
| `K`, `grn`, `gra`, `grr`, `gri`, `gO` | Штатные LSP hover, rename, actions, references, implementations, symbols |
| `Ctrl-h/j/k/l` в normal | Окна Neovim, затем соседние панели tmux |
| `ys`, `cs`, `ds` | Добавить / изменить / удалить surround |
| `Space cf` | Ручное форматирование |
| `Space ud` | Список ветвей undo |
| `g- / g+`, `:earlier`, `:later` | Навигация по истории изменений |

Persistent undo хранится в стандартном каталоге состояния Neovim. Панели дерева
undo нет. Statusline и светлая Catppuccin встроенные, отдельные плагины не нужны.
Вне normal mode используйте `Ctrl-w` после выхода в normal либо tmux prefix:
`Ctrl-h` в insert остаётся backspace. При zoom переход из Neovim в другую панель
заблокирован до снятия zoom.

## tmux

Префикс — `Ctrl-a`. Мышь выключена. Тема и statusline реализованы штатными форматами:
сессия, окна, индикаторы PREFIX/ZOOM/SYNC и время; дата скрывается при ширине <100.
Никаких submodule/TPM. Новые панели и popup наследуют текущий каталог.

| Клавиши после префикса | Действие |
| --- | --- |
| `r` | Перечитать конфиг |
| `c`, `\|`, `-` | Новое окно, разделить слева/справа, сверху/снизу |
| `h/j/k/l`, `H/J/K/L` | Выбор панели / изменение размеров |
| `Ctrl-p / Ctrl-n` | Предыдущее / следующее окно |
| `Ctrl-l` | Передать очистку экрана в shell |
| `z`, `Ctrl-s` | Zoom / synchronize-panes |
| `s`, `O`, `e` | Выбор сессии / shell popup / меню |
| `Escape`, затем `v`, `y` | Copy mode, выделить, скопировать |
| `p`, `P` | Вставить буфер / включить или выключить лог панели |

Без префикса `Ctrl-h/j/k/l` перемещают между панелями или передаются активному
Neovim. Popup использует default-shell tmux; для zsh задайте его login shell
или настройте `default-shell` самостоятельно. Логи пишутся с закрытыми правами в
`${XDG_STATE_HOME:-$HOME/.local/state}/tmux/`; учтите, что вывод может содержать секреты.

## zsh / Starship

Нет Oh My Zsh/Powerlevel10k. Сохранены vi-mode, `Ctrl-e` для редактирования команды
в Neovim, fzf и zoxide (если установлены). `cd` заменяется на `z` только при наличии
zoxide. Starship показывает каталог, ветку и состояние Git; без него есть простой prompt.

История — `$XDG_STATE_HOME/zsh/history`, до 100000 записей; старый history-файл
автоматически не переносится. XDG имеет стандартные значения по умолчанию.
GPG/pass используют заданные переменные, затем существующие XDG-хранилища, иначе
свои обычные пути. Никаких перемещений ключей или password store.

## Проверки конфигурации

`zsh -n .zshrc` проверяет синтаксис shell. Для Neovim скопируйте `.config/nvim`
в отдельный `$XDG_CONFIG_HOME/nvim`, задайте временные `XDG_DATA_HOME`,
`XDG_STATE_HOME`, `XDG_CACHE_HOME`, затем выполните:

```sh
nvim --headless -c 'luafile tests/nvim.lua'
```

Тест требует установленный `clang-format` и загрузку плагинов при первом запуске.
Проверяются запуск, Telescope, theme/surround, Markdown-пробелы, форматирование,
undo, ошибки инструментов и защита от устаревшего асинхронного результата.
Mason не устанавливает LSP автоматически в headless-режиме; первую установку
серверов выполняйте в обычном интерактивном Neovim.
Для tmux используйте отдельный socket (`tmux -L dotfiles-check -f ...`),
чтобы проверка не меняла рабочие сессии.
