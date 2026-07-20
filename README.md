# Repositório de Tutoriais de Programação Lua

[![CI](https://github.com/dionipadilha/aprendendo_lua/actions/workflows/ci.yml/badge.svg)](https://github.com/dionipadilha/aprendendo_lua/actions/workflows/ci.yml)

Este repositório oferece guias para a linguagem de programação Lua, abrangendo diversos conceitos.
O material aqui apresentado é fruto de meu estudo e desenvolvimento, e visa auxiliar programadores em diferentes níveis de experiência.

## Objetivo:

Este repositório tem como objetivo contribuir para a comunidade de programadores.

## Conteúdo:

- **Explicações claras e concisas:** Conceitos básicos da linguagem de programação são expostos de forma didática e objetiva.
- **Exemplos práticos e soluções:** Diversos exemplos demonstram a aplicação prática dos conceitos, além de oferecer soluções para desafios comuns em programação.
- **Cobertura:** Os guias abrangem a instalação da linguagem, tópicos básicos e tópicos mais avançados.
- **Códigos revisados:** Todos os scripts são executados automaticamente pela CI (veja `executar_testes.sh`).

### Organização do repositório:

| Pasta | Tema |
|-------|------|
| `basico/` | Primeiros passos, tipos, cadeias de texto, operadores e formatação |
| `controle_de_fluxo/` | Condicionais, laços, break, switch e goto |
| `funcoes/` | Funções, clausuras, varargs, múltiplos retornos e memoização |
| `tabelas/` | Tabelas, vetores, pilhas, listas, iteradores, buracos/`#` e cópias |
| `poo/` | Classes, herança, polimorfismo e interfaces |
| `metatabelas/` | Metatabelas, metamétodos, proxies e tabelas somente leitura |
| `gc/` | Coleta de lixo e tabelas fracas |
| `corrotinas/` | Guias e exemplos de corrotinas |
| `erros/` | error, assert, pcall, xpcall e try/except |
| `modulos/` | require, dofile, loadfile e rockspec |
| `io/` | Leitura e escrita de arquivos |
| `sistema/` | Data e hora, relógio, esperas e números aleatórios |
| `banco_de_dados/` | Integração com SQLite via CLI |
| `padroes/` | Padrões de projeto: fábrica, fábrica abstrata, construtor, protótipo, singleton, adaptador, comando, memento, decorador, composto, estratégia, fachada, observador, método modelo, MVC, máquina de estados |
| `solid/` | Princípios SOLID, um arquivo por princípio |
| `testes/` | Framework de teste unitário e exemplos de testes |
| `projetos/` | Projetos completos: `pluralizador/`, `json/`, `equipe/` |
| `documentacao/` | Guia de estudos, roteiro, paradigmas e convenções |

A trilha completa de estudo está em `documentacao/roteiro_de_estudos.yml` e `documentacao/guia_de_estudos.md`.

### Convenções de idioma:

Todo o material — nomes de arquivos, identificadores, comentários e mensagens — está em **pt-BR**. Permanecem em inglês apenas o que pertence à própria linguagem (palavras-chave, biblioteca padrão como `table.insert`, metamétodos como `__index`) e termos técnicos consagrados (siglas como CRUD, MVC e SOLID). Identificadores não levam acento porque Lua só aceita ASCII em nomes (`funcao`, `heranca`).

## Como executar:

Os exemplos têm como alvo o **Lua 5.4**. Cada arquivo é independente — execute a partir do diretório em que ele está:

```sh
lua5.4 basico/ola_mundo.lua
cd projetos/json && lua5.4 principal.lua
```

Para verificar todos os scripts de uma vez (o mesmo teste executado pela CI):

```sh
./executar_testes.sh
```

## Utilização:

Os códigos disponibilizados neste repositório são livres para uso, sob a [licença MIT](LICENSE).
A citação da fonte é apreciada.

## Links:
- https://gist.github.com/oatmealine/655c9e64599d0f0dd47687c1186de99f

**Espero que este material seja útil para o meu/seu aprendizado!**
