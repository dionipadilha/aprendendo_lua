# O gerador do site

Esta pasta contém o gerador do site estático do repositório —
**escrito em Lua 5.4 puro, sem dependências**, no espírito do resto do
material: o gerador é, ele mesmo, uma lição de manipulação de strings,
padrões e organização de um programa maior.

Site publicado: https://dionipadilha.github.io/aprendendo_lua/

## Arquitetura

| Arquivo | Papel |
|---|---|
| [`markdown.lua`](markdown.lua) | converte o subset de Markdown usado pelo repositório em HTML |
| [`realce.lua`](realce.lua) | realce de sintaxe Lua (comentários, strings, palavras-chave, números) |
| [`gerar.lua`](gerar.lua) | varre as pastas de conteúdo e monta as páginas, os índices e a inicial |
| [`testar_markdown.lua`](testar_markdown.lua) | testes do conversor e do realce, executados pela suíte |

Decisões de projeto:

- **A estrutura de pastas é preservada na saída** — assim os links
  relativos dos `.md` continuam válidos; o gerador só reescreve a
  extensão (`.md`/`.lua` → `.html`) e cria um `index.html` por
  diretório, para que URLs de pasta (`../projetos/`) funcionem.
- **Nenhum asset externo**: o CSS vai embutido em cada página, com tema
  claro/escuro via `prefers-color-scheme`.
- **A geração é o teste**: `gerar.lua` termina com asserts de sanidade
  (número de páginas, páginas-chave existem e têm conteúdo) e roda na
  suíte da CI como qualquer `.lua` — se um `.md` novo usar sintaxe que
  o conversor não conhece, a quebra aparece na CI, não em produção.

## Como rodar localmente

```sh
cd site
lua5.4 gerar.lua      # gera tudo em site/_saida/ (gitignorada)
```

Abra `_saida/index.html` no navegador. Em sistemas sem `find` (POSIX),
como o Windows, o gerador avisa e encerra sem erro — a publicação é
feita pela CI Linux (`.github/workflows/pages.yml`), a cada push no
`main`.

## Limitações conhecidas

- O conversor de Markdown cobre o subset que o repositório usa (ver o
  cabeçalho de `markdown.lua`); HTML embutido é escapado como texto.
- O realce não interpreta strings longas com níveis (`[==[...]==]`).
- Links para arquivos não publicados apontam para a fonte no GitHub.
