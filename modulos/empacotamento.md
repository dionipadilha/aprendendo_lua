# Empacotamento com LuaRocks

O [LuaRocks](https://luarocks.org) é o gerenciador de pacotes de Lua: os
pacotes se chamam **rocks**, e cada rock é descrito por um arquivo
**rockspec**. Este repositório tem um rockspec real e funcional — o do
[pluralizador](../projetos/pluralizador/pluralizador-1.0-1.rockspec) —
e a CI o instala e usa a cada execução. Esta lição explica esse arquivo
e o ciclo de vida de uma rock.

> O trecho ilustrativo em [`rockspec.lua`](rockspec.lua) mostra só o
> campo `dependencies`; aqui está o arquivo completo em ação.

## Anatomia de um rockspec

```lua
rockspec_format = "3.0"        -- versão do formato do próprio arquivo
package = "pluralizador"       -- nome da rock
version = "1.0-1"              -- versão do código - revisão do rockspec

source = {
  url = "git+https://github.com/dionipadilha/aprendendo_lua.git"
}

description = {
  summary = "Pluralizador de substantivos do inglês (projeto didático)",
  license = "MIT"
}

dependencies = {
  "lua >= 5.4"                 -- a própria linguagem é uma dependência
}

build = {
  type = "builtin",            -- o construtor nativo: copia módulos Lua
  modules = {
    pluralizador = "principal.lua",  -- require "pluralizador" → este arquivo
    regulares = "regulares.lua",
    excecoes = "excecoes.lua",
    irregulares = "irregulares.lua"
  }
}
```

Pontos que merecem atenção:

- **`version = "1.0-1"`**: a parte antes do hífen é a versão do
  **código**; a parte depois é a **revisão do rockspec** (mudou só o
  empacotamento? incremente apenas o `-1`).
- **`build.type = "builtin"`**: para módulos Lua puros, o LuaRocks só
  precisa saber **qual nome de módulo** corresponde a **qual arquivo**.
  Módulos em C usam o mesmo construtor com tabelas `sources` (ver a
  pasta [`../capi/`](../capi/) para módulos C compilados à mão).
- **Nomes dos módulos**: o pluralizador instala `regulares`, `excecoes`
  e `irregulares` como nomes de topo porque é assim que
  `principal.lua` os requer. Uma biblioteca publicada de verdade
  usaria o prefixo do pacote (`pluralizador.regulares`), para não
  disputar nomes com outras rocks — essa é a convenção da comunidade.
- **O que fica de fora**: `teste.lua` e `validacao.lua` não aparecem em
  `modules` — testes acompanham o repositório, não a biblioteca.

## O ciclo de vida

```sh
cd projetos/pluralizador

# 1. Instalar a partir do código local (ignora source.url):
luarocks --lua-version=5.4 make --local pluralizador-1.0-1.rockspec

# 2. Configurar o ambiente para achar a árvore local (~/.luarocks):
eval "$(luarocks --lua-version=5.4 path)"

# 3. Usar de QUALQUER diretório — o módulo agora é global ao usuário:
cd /tmp
lua5.4 -e 'print(require("pluralizador")("child"))'  --> children

# 4. Gerar um pacote distribuível (.rock):
luarocks --lua-version=5.4 pack pluralizador
```

Comandos do dia a dia:

| Comando | O que faz |
|---|---|
| `luarocks make` | instala a rock a partir do código no diretório atual |
| `luarocks install <rock>` | baixa e instala do servidor público (luarocks.org) |
| `luarocks list` | lista as rocks instaladas |
| `luarocks show <rock>` | detalha uma rock instalada (módulos, licença, árvore) |
| `luarocks remove <rock>` | desinstala |
| `luarocks path` | imprime os exports de `LUA_PATH`/`LUA_CPATH` |

## Árvore local vs. global

- `--local` instala em `~/.luarocks` (sem sudo, por usuário) — é o que
  a CI usa.
- Sem `--local`, instala na árvore do sistema (requer permissão de
  administrador).
- `luarocks path` imprime as variáveis de ambiente que fazem o `require`
  enxergar a árvore escolhida; o `eval "$(...)"` as aplica ao shell.

## Onde isso é testado

O job de CI (`.github/workflows/ci.yml`, passo "Empacotar e instalar o
pluralizador") executa exatamente o ciclo acima: `luarocks make` +
`require "pluralizador"` de fora da pasta do projeto. Se o rockspec
quebrar, a CI quebra.
