# Repositório de Tutoriais de Programação Lua

[![CI](https://github.com/dionipadilha/aprendendo_lua/actions/workflows/ci.yml/badge.svg)](https://github.com/dionipadilha/aprendendo_lua/actions/workflows/ci.yml)
[![Versão](https://img.shields.io/github/v/tag/dionipadilha/aprendendo_lua?label=vers%C3%A3o&color=blue)](https://github.com/dionipadilha/aprendendo_lua/tags)
[![Lua 5.4](https://img.shields.io/badge/Lua-5.4-blue)](https://www.lua.org/manual/5.4/)
[![Licença MIT](https://img.shields.io/badge/licen%C3%A7a-MIT-green)](LICENSE)
[![pt-BR](https://img.shields.io/badge/idioma-pt--BR-yellow)](#convenções-de-idioma)
[![Site](https://img.shields.io/badge/site-github.io-8A2BE2)](https://dionipadilha.github.io/aprendendo_lua/)

**Versão navegável:** todo o material também está publicado como site em
[dionipadilha.github.io/aprendendo_lua](https://dionipadilha.github.io/aprendendo_lua/) —
gerado por [um script Lua deste próprio repositório](site/).

Este repositório oferece guias para a linguagem de programação Lua, abrangendo diversos conceitos.
O material aqui apresentado é fruto de meu estudo e desenvolvimento, e visa auxiliar programadores em diferentes níveis de experiência.

> **Novo por aqui?** Comece pelo roteiro guiado de 3 dias:
> [`documentacao/comece_aqui.md`](documentacao/comece_aqui.md).

## Objetivo:

Este repositório tem como objetivo contribuir para a comunidade de programadores.

## Conteúdo:

- **Explicações claras e concisas:** Conceitos básicos da linguagem de programação são expostos de forma didática e objetiva.
- **Exemplos práticos e soluções:** Diversos exemplos demonstram a aplicação prática dos conceitos, além de oferecer soluções para desafios comuns em programação.
- **Cobertura:** Os guias abrangem a instalação da linguagem, tópicos básicos e tópicos mais avançados.
- **Códigos revisados:** Todos os scripts são executados automaticamente pela CI (veja `executar_testes.sh`).

### Organização do repositório:

As pastas na **ordem de estudo sugerida** (a mesma de `documentacao/guia_de_estudos.md`):

| Pasta | Tema |
|-------|------|
| `basico/` | Primeiros passos, tipos, cadeias de texto, operadores e formatação |
| `controle_de_fluxo/` | Condicionais, laços, break, switch e goto |
| `funcoes/` | Funções, clausuras, varargs, múltiplos retornos e memoização |
| `tabelas/` | Tabelas, vetores, pilhas, listas, iteradores, buracos/#, cópias e serialização |
| `metatabelas/` | Metatabelas, metamétodos, proxies e tabelas somente leitura |
| `poo/` | Classes, herança, polimorfismo, mixins e interfaces |
| `modulos/` | require, dofile, loadfile, ambientes (_ENV) e empacotamento com LuaRocks |
| `erros/` | error, assert, pcall, xpcall e try/except |
| `io/` | Leitura e escrita de arquivos, em texto e binário |
| `sistema/` | Data e hora, relógio, esperas, aleatórios e linha de comando |
| `gc/` | Coleta de lixo e tabelas fracas |
| `desempenho/` | Medição de desempenho: cronometrar antes de otimizar |
| `depuracao/` | Biblioteca debug: introspecção da pilha e ganchos de execução |
| `testes/` | Framework de teste unitário e exemplos de testes |
| `padroes/` | Padrões de projeto, da fábrica ao MVC e à máquina de estados |
| `solid/` | Princípios SOLID, um arquivo por princípio |
| `corrotinas/` | Guias e exemplos de corrotinas |
| `banco_de_dados/` | Integração com SQLite via CLI |
| `capi/` | API C: embutir Lua em C e módulos C carregáveis via require |
| `projetos/` | Projetos completos (pluralizador, json, equipe) e soluções dos exercícios |
| `documentacao/` | Guia de estudos, roteiro, paradigmas, convenções, guias de instalação, LuaJIT/versões e enunciados de projetos |
| `site/` | Gerador do site estático em arquitetura hexagonal — estudo de caso de portas e adaptadores |

Esta tabela é espelho de [`site/trilha.lua`](site/trilha.lua) — a fonte única, legível
por máquina, da ordem das pastas e das lições (o site e o verificador
`site/verificar_trilha.lua` a consomem; ao mudar uma, mude a outra).
A trilha completa de estudo está em `documentacao/roteiro_de_estudos.yml` e `documentacao/guia_de_estudos.md`.

### Destaques:

Quatro exemplos que mostram o espírito do repositório — executáveis, autoverificados e honestos sobre limitações:

- **[`projetos/json/`](projetos/json/)** — codificador e decodificador de JSON do zero, com testes de roundtrip e uma seção de limitações conhecidas que diz a verdade (`null`, Unicode, ciclos).
- **[`corrotinas/jogo_com_corrotinas.lua`](corrotinas/jogo_com_corrotinas.lua)** — um mini-jogo de perseguição jogável no terminal que ensina a troca de valores entre `resume` e `yield`.
- **[`solid/`](solid/)** — cada princípio SOLID com a violação e o redesenho lado a lado, no mesmo arquivo, verificados por asserts.
- **[`tabelas/buracos_e_comprimento.lua`](tabelas/buracos_e_comprimento.lua)** — a pegadinha mais famosa de Lua (`#` com buracos) demonstrada em vez de apenas descrita.

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

Contribuições são bem-vindas — as convenções e o passo a passo estão em
[`CONTRIBUTING.md`](CONTRIBUTING.md).

## Links:
- [Manual de referência do Lua 5.4](https://www.lua.org/manual/5.4/)
- [Programming in Lua (livro dos autores da linguagem)](https://www.lua.org/pil/)
- [Guia rápido da comunidade (gist)](https://gist.github.com/oatmealine/655c9e64599d0f0dd47687c1186de99f)

**Espero que este material seja útil para o meu/seu aprendizado!**
