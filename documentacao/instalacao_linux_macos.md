# Para instalar Lua no Linux e no macOS, siga estas etapas:

Os exemplos deste repositório têm como alvo o **Lua 5.4** — prefira uma
versão 5.4.x ao instalar. (Para Windows, veja
[`instalacao_lua_win10.md`](instalacao_lua_win10.md).)

## Linux — pelo gerenciador de pacotes (recomendado)

1. **Debian, Ubuntu e derivados (apt)**:

   ```sh
   sudo apt update
   sudo apt install lua5.4
   ```

   O binário instala como `lua5.4` — o nome carrega a versão para que
   `lua5.1`, `lua5.3` e `lua5.4` possam conviver na mesma máquina.

2. **Fedora (dnf)**:

   ```sh
   sudo dnf install lua
   ```

3. **Arch Linux (pacman)**:

   ```sh
   sudo pacman -S lua
   ```

   No Fedora e no Arch o binário instala como `lua` (confirme a versão
   com `lua -v`).

4. **Cabeçalhos de desenvolvimento (opcional)**: só são necessários para
   compilar módulos C — por exemplo, a pasta `capi/` deste repositório ou
   rocks com código C. Instale `liblua5.4-dev` (apt) ou `lua-devel`
   (dnf); no Arch os cabeçalhos já acompanham o pacote `lua`.

## macOS — pelo Homebrew

```sh
brew install lua
```

Instala a versão 5.4.x atual, com binário `lua` e cabeçalhos inclusos.

## Alternativa universal: compilar o código-fonte

Funciona em qualquer Linux ou macOS e é o caminho oficial do site
lua.org (que distribui apenas o fonte). Pré-requisito: um compilador C
(`sudo apt install build-essential` no Debian/Ubuntu;
`xcode-select --install` no macOS).

```sh
curl -L -R -O https://www.lua.org/ftp/lua-5.4.8.tar.gz
tar zxf lua-5.4.8.tar.gz
cd lua-5.4.8
make linux        # no macOS: make macosx
sudo make install # instala lua e luac em /usr/local/bin
```

Confira em [lua.org/ftp](https://www.lua.org/ftp/) qual é a versão 5.4.x
mais recente e ajuste o nome do arquivo. No Linux, `make linux-readline`
(requer `libreadline-dev`) habilita setas e histórico no modo
interativo; o alvo `macosx` já usa a readline do sistema.

## Teste a instalação

```sh
lua5.4 -v   # Debian/Ubuntu
lua -v      # Fedora, Arch, Homebrew ou fonte compilado
```

A saída deve ser o cabeçalho do interpretador: `Lua 5.4.x  Copyright ...`.

### Nota: o nome do binário varia

- **Debian/Ubuntu:** `lua5.4`.
- **Fedora, Arch, Homebrew e fonte compilado:** `lua`.

Os comandos do README usam `lua5.4`; onde o binário se chama `lua`,
troque o nome no comando. O teste de fumaça do repositório
(`executar_testes.sh`) respeita a variável de ambiente `LUA` — o padrão
é `lua5.4`:

```sh
LUA=lua ./executar_testes.sh
```

## LuaRocks e luacheck

O LuaRocks é o gerenciador de pacotes de Lua; o luacheck é o linter que
a CI deste repositório executa.

```sh
sudo apt install luarocks   # Debian/Ubuntu
sudo dnf install luarocks   # Fedora
sudo pacman -S luarocks     # Arch
brew install luarocks       # macOS
```

Com o LuaRocks instalado:

```sh
luarocks install --local luacheck
eval "$(luarocks path)"   # põe os rocks --local no caminho do shell
luacheck . -q             # na raiz do repositório: 0 avisos esperados
```

`--local` instala em `~/.luarocks`, sem `sudo` (o `eval` acima precisa
ser repetido em cada shell novo, ou adicionado ao seu `~/.bashrc`).
Alternativa de sistema: `sudo luarocks install luacheck`.
