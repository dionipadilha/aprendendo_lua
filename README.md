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

### Organização do repositório:

| Pasta | Tema |
|-------|------|
| `basics/` | Primeiros passos, tipos, strings, operadores e formatação |
| `control_flow/` | Condicionais, switch e goto |
| `functions/` | Funções, closures, varargs e memoização |
| `tables/` | Tabelas, arrays, pilhas, listas e iteradores |
| `oop/` | Classes, herança, polimorfismo e interfaces |
| `metatables/` | Metatables, metamétodos, proxies e tabelas read-only |
| `gc/` | Garbage collection e weak tables |
| `coroutines/` | Guias e exemplos de corrotinas |
| `errors/` | error, assert, pcall, xpcall e try/except |
| `modules/` | require, dofile, loadfile e rockspec |
| `io/` | Leitura e escrita de arquivos |
| `oslib/` | Data e hora, clock, delays e números aleatórios |
| `database/` | Integração com SQLite via CLI |
| `patterns/` | Padrões de projeto: factory, observer, decorator, strategy, facade, MVC, FSM |
| `solid/` | Princípios SOLID, um arquivo por princípio |
| `testing/` | Framework de teste unitário e exemplos de testes |
| `projects/` | Projetos completos: `pluralizer/`, `json/`, `crew/` |
| `docs/` | Guia de estudo, roadmap, paradigmas e convenções |

A trilha completa de estudo está em `docs/lua_roadmap.yml` e `docs/study_guide.md`.

## Como executar:

Os exemplos têm como alvo o **Lua 5.4**. Cada arquivo é independente — execute a partir do diretório em que ele está:

```sh
lua5.4 basics/hello_world.lua
cd projects/json && lua5.4 main.lua
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
