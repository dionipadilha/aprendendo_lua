# O gerador do site — um estudo de caso de arquitetura hexagonal

Esta pasta contém o gerador do site estático do repositório —
**escrito em Lua 5.4 puro, sem dependências** — organizado em
**arquitetura hexagonal** (portas e adaptadores). Depois dos princípios
(`../solid/`) e dos padrões (`../padroes/`), este é o degrau seguinte
da trilha: uma *arquitetura* aplicada a um programa real que você pode
executar, ler e testar.

Site publicado: https://dionipadilha.github.io/aprendendo_lua/

## O hexágono

```
                     ┌─────────────────────────┐
     PORTA de        │        NÚCLEO           │       PORTA de
     leitura   ────▶ │      nucleo.lua         │ ────▶ escrita
                     │                         │
  listar(pasta)      │  o DOMÍNIO, puro:       │   preparar()
  ler(caminho)       │  o que publicar,        │   escrever(caminho,
                     │  títulos, links,        │            conteudo)
                     │  índices, template      │
                     └─────────────────────────┘
                        ▲                   ▲
        implementam a mesma porta, cada um no seu mundo
                        │                   │
          adaptador_arquivos.lua   adaptador_memoria.lua
          (find, io, mkdir — POSIX)  (tabelas Lua — qualquer SO)
```

A regra que organiza tudo: **o núcleo não sabe de onde vêm os arquivos
nem para onde vão as páginas**. Ele conhece apenas os *contratos* das
duas portas; quem os cumpre são os adaptadores, injetados pela raiz de
composição (`gerar.lua`). Em Lua não há interfaces formais — cada porta
é uma tabela de funções com o contrato documentado, a mesma técnica de
`../poo/interface/`.

## Mapa de leitura

1. **[`gerar.lua`](gerar.lua)** — comece aqui: a raiz de composição
   conta a história inteira (configuração → adaptador → núcleo) e é
   chata de propósito. Raiz de composição boa não tem lógica.
2. **[`nucleo.lua`](nucleo.lua)** — o domínio. Repare no que NÃO existe
   aqui: nenhum `io.*`, `os.*` ou `find`. É essa ausência que o torna
   testável em qualquer plataforma.
3. **[`adaptador_arquivos.lua`](adaptador_arquivos.lua)** e
   **[`adaptador_memoria.lua`](adaptador_memoria.lua)** — os dois
   mundos que cumprem as mesmas portas: o disco (POSIX) e as tabelas
   (testes).
4. **[`testar_nucleo.lua`](testar_nucleo.lua)** — a arquitetura pagando
   a conta: um repositório fictício entra, páginas saem, asserts
   verificam — sem tocar o disco.
5. **[`markdown.lua`](markdown.lua)** e **[`realce.lua`](realce.lua)** —
   serviços puros usados pelo núcleo (testados por
   [`testar_markdown.lua`](testar_markdown.lua)).
6. **[`trilha.lua`](trilha.lua)** — a fonte única de verdade da
   organização do repositório: pastas na ordem pedagógica, tema de cada
   uma e as lições com descrição. É espelho da tabela do
   [`README.md`](../README.md) da raiz, e dois verificadores guardam o
   conjunto: [`verificar_trilha.lua`](verificar_trilha.lua) (trilha ↔
   disco ↔ README sincronizados) e
   [`verificar_saida.lua`](verificar_saida.lua) (o site gerado tem HTML
   bem formado e links íntegros).

## Por que hexagonal aqui — e quando não usar

**O ganho concreto neste projeto:** o gerador dependia de `find`
(POSIX) e por isso era inteiramente pulado no Windows. Separado o
domínio da E/S, só o *adaptador de arquivos* é POSIX — o núcleo passou
a ser testado **também no job Windows da CI**, via adaptador de
memória. A arquitetura não está aqui só para ser exibida: ela comprou
cobertura de teste real.

**Onde resistimos à abstração:** `markdown.lua` e `realce.lua` são
puros e não têm segunda implementação plausível — então **não** ganham
porta. Porta sem variação real é indireção sem retorno. A regra
prática: *conte os implementadores; se a resposta é "um, para sempre",
você não precisa de uma porta.*

**A honestidade de sempre:** num script descartável de 300 linhas,
hexagonal costuma ser cerimônia. Ela paga quando (a) existe E/S com
mais de uma implementação real (disco/memória, produção/teste), ou
(b) o domínio merece testes que não dependam do ambiente. Este gerador
cruza os dois critérios — muitos scripts não cruzam nenhum.

## Como rodar localmente

```sh
cd site
lua5.4 testar_nucleo.lua      # testa o núcleo (qualquer plataforma)
lua5.4 testar_markdown.lua    # testa o conversor e o realce
lua5.4 gerar.lua              # gera tudo em site/_saida/ (POSIX)
lua5.4 verificar_trilha.lua   # trilha, disco e README em sincronia
lua5.4 verificar_saida.lua    # HTML e links do site gerado íntegros
```

Abra `_saida/index.html` no navegador. No Windows, `gerar.lua` avisa e
encerra sem erro (o adaptador de disco usa `find`); a publicação é
feita pela CI Linux (`.github/workflows/pages.yml`) a cada push no
`main`.

## Limitações conhecidas

- O conversor de Markdown cobre o subset que o repositório usa (ver o
  cabeçalho de `markdown.lua`); HTML embutido é escapado como texto.
- O realce não interpreta strings longas com níveis (`[==[...]==]`).
- Links para arquivos não publicados apontam para a fonte no GitHub.
