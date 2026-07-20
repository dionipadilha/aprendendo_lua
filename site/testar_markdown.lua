-- testar_markdown.lua

-- Testes do conversor de Markdown (markdown.lua) e do realce de
-- sintaxe (realce.lua). Cada caso verifica que a construção gera o
-- HTML esperado; a conversão dos .md REAIS do repositório acontece em
-- gerar.lua, que roda na CI.

local markdown = require "markdown"
local realcar = require "realce"

-- utilitário: o HTML gerado contém o trecho esperado (busca literal)?
-- As quebras de linha entre os fragmentos emitidos são removidas antes
-- da comparação — elas não têm significado estrutural no HTML.
local function contem(html, trecho)
  return (html:gsub("\n", "")):find((trecho:gsub("\n", "")), 1, true) ~= nil
end

--------------------------------------------------------------------------------
-- blocos básicos

local html = markdown.converter("# Título\n\nUm parágrafo.")
assert(contem(html, "<h1>Título</h1>"))
assert(contem(html, "<p>Um parágrafo.</p>"))

html = markdown.converter("### Subseção")
assert(contem(html, "<h3>Subseção</h3>"))

html = markdown.converter("linha um\nlinha dois\n\noutro parágrafo")
assert(contem(html, "<p>linha um linha dois</p>")) -- linhas contíguas se juntam
assert(contem(html, "<p>outro parágrafo</p>"))

html = markdown.converter("antes\n\n---\n\ndepois")
assert(contem(html, "<hr>"))

--------------------------------------------------------------------------------
-- marcas embutidas

html = markdown.converter("Um `codigo` e **forte** e *enfase*.")
assert(contem(html, "<code>codigo</code>"))
assert(contem(html, "<strong>forte</strong>"))
assert(contem(html, "<em>enfase</em>"))

-- asteriscos dentro de código NÃO viram ênfase:
html = markdown.converter("veja `a * b` e `x ** y`")
assert(contem(html, "<code>a * b</code>"))
assert(contem(html, "<code>x ** y</code>"))
assert(not contem(html, "<em>"))

-- links e imagens (inclusive imagem dentro de link, como os badges):
html = markdown.converter("[texto](https://exemplo.com/pagina)")
assert(contem(html, '<a href="https://exemplo.com/pagina">texto</a>'))

html = markdown.converter("[![CI](https://exemplo.com/badge.svg)](https://exemplo.com/acao)")
assert(contem(html, '<img src="https://exemplo.com/badge.svg" alt="CI">'))
assert(contem(html, '<a href="https://exemplo.com/acao">'))

-- HTML embutido é escapado como texto (limitação documentada):
html = markdown.converter("um <div> qualquer & tal")
assert(contem(html, "&lt;div&gt;"))
assert(contem(html, "&amp; tal"))

--------------------------------------------------------------------------------
-- cercas de código

html = markdown.converter("```lua\nlocal x = 1 < 2\n```")
assert(contem(html, 'class="linguagem-lua"'))
assert(contem(html, "local x = 1 &lt; 2")) -- escapado

html = markdown.converter("```\ntexto cru\n```")
assert(contem(html, 'class="linguagem-texto"'))

-- marcas de markdown dentro da cerca NÃO são interpretadas:
html = markdown.converter("```sh\n# isto é comentário, não título\n```")
assert(not contem(html, "<h1>"))

--------------------------------------------------------------------------------
-- listas

html = markdown.converter("- um\n- dois\n- três")
assert(contem(html, "<ul><li>um</li><li>dois</li><li>três</li></ul>"))

html = markdown.converter("1. primeiro\n2. segundo")
assert(contem(html, "<ol><li>primeiro</li><li>segundo</li></ol>"))

-- lista aninhada por indentação:
html = markdown.converter("- pai\n  - filho\n- irmão")
assert(contem(html, "<li>pai<ul><li>filho</li></ul></li><li>irmão</li>"))

-- item numerado com sublista (o padrão de instalacao_lua_win10.md):
html = markdown.converter("1. **Passo**:\n   - detalhe do passo")
assert(contem(html, "<ol><li><strong>Passo</strong>:"))
assert(contem(html, "<li>detalhe do passo</li>"))

-- cerca de código dentro de um item (o padrão de comece_aqui.md):
html = markdown.converter("1. Rode:\n\n   ```sh\n   lua5.4 -v\n   ```\n\n   E confira.")
assert(contem(html, "<li>Rode:"))
assert(contem(html, "lua5.4 -v"))
assert(contem(html, "<p>E confira.</p>"))
assert(html:find("</ol>") > html:find("E confira.", 1, true)) -- a lista fecha depois

--------------------------------------------------------------------------------
-- citações e tabelas

html = markdown.converter("> **Nota:** algo importante\n> em duas linhas.")
assert(contem(html, "<blockquote>"))
assert(contem(html, "<strong>Nota:</strong>"))

html = markdown.converter("| Pasta | Tema |\n|-------|------|\n| `a/` | conteúdo A |")
assert(contem(html, "<th>Pasta</th>"))
assert(contem(html, "<td><code>a/</code></td>"))
assert(contem(html, "<td>conteúdo A</td>"))

--------------------------------------------------------------------------------
-- realce de sintaxe Lua

local codigo = realcar('local x = 42 -- resposta\nprint("olá")')
assert(contem(codigo, '<span class="palavra-chave">local</span>'))
assert(contem(codigo, '<span class="numero">42</span>'))
assert(contem(codigo, '<span class="comentario">-- resposta</span>'))
assert(contem(codigo, '<span class="texto-lua">')) -- a string foi marcada
assert(contem(codigo, "print")) -- identificador comum fica sem span

-- comentário longo e string com escape:
codigo = realcar('--[[ bloco ]] local s = "com \\" aspas"')
assert(contem(codigo, '<span class="comentario">--[[ bloco ]]</span>'))
assert(contem(codigo, "aspas"))

-- o conteúdo realçado continua com HTML escapado:
codigo = realcar("if a < b then end")
assert(contem(codigo, "&lt;"))

-- integração: cerca lua com realce ligado
html = markdown.converter("```lua\nlocal n = 1\n```", { realcarLua = realcar })
assert(contem(html, '<span class="palavra-chave">local</span>'))

print("conversor de markdown e realce verificados!")
