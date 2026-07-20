# Repositório de Tutoriais de Programação Lua

[![CI](https://github.com/dionipadilha/lua/actions/workflows/ci.yml/badge.svg)](https://github.com/dionipadilha/lua/actions/workflows/ci.yml)

Este repositório oferece guias para a linguagem de programação Lua, abrangendo diversos conceitos.
O material aqui apresentado é fruto de meu estudo e desenvolvimento, e visa auxiliar programadores em diferentes níveis de experiência.

## Objetivo:

Este repositório tem como objetivo contribuir para a comunidade de programadores.

## Conteúdo:

- **Explicações claras e concisas:** Conceitos básicos da linguagem de programação são expostos de forma didática e objetiva.
- **Exemplos práticos e soluções:** Diversos exemplos demonstram a aplicação prática dos conceitos, além de oferecer soluções para desafios comuns em programação.
- **Cobertura:** Os guias abrangem a instalação da linguagem, tópicos básicos e tópicos mais avançados.
- **Códigos revisados:** Todos os scripts são executados automaticamente pela CI (veja `smoke_test.sh`).

### Trilha sugerida:

| Tema | Onde começar |
|------|--------------|
| Primeiros passos | `lua_start.md`, `lua_fast_intro.lua`, `basics.md`, `hello_world.lua` |
| Tipos, strings e tabelas | `types.md`, `strings.md`, `tables.lua`, `arrays.lua`, `tablelib.lua` |
| Controle de fluxo e funções | `control_flow.md`, `functions.md`, `functions.lua`, `closures.lua`, `iterators.lua` |
| Orientação a objetos | `oop.md`, `class.lua`, `inheritance.lua`, `polymorphism.lua`, `metatable.lua`, `metamethods/` |
| Corrotinas | `coroutines.md`, `coroutines_expanded.md`, `coroutine_game.lua` |
| Erros e testes | `error.lua`, `pcall.lua`, `xpcall.lua`, `unit_tests.lua`, `Test/` |
| Padrões de projeto | `factory.lua`, `observer.lua`, `decorator.lua`, `strategy/`, `facade/`, `solid/`, `mvc/` |
| Projetos completos | `Pluralizer/`, `json/`, `crew/` |

A trilha completa de estudo está em `lua_roadmap.yml` e `study_guide.md`.

## Como executar:

Os exemplos têm como alvo o **Lua 5.4**. Cada arquivo é independente — execute a partir do diretório em que ele está:

```sh
lua5.4 hello_world.lua
cd json && lua5.4 main.lua
```

Para verificar todos os scripts de uma vez (o mesmo teste executado pela CI):

```sh
./smoke_test.sh
```

## Utilização:

Os códigos disponibilizados neste repositório são livres para uso, sob a [licença MIT](LICENSE).
A citação da fonte é apreciada.

## Links:
- https://gist.github.com/oatmealine/655c9e64599d0f0dd47687c1186de99f

**Espero que este material seja útil para o meu/seu aprendizado!**
