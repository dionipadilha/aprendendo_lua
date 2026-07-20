-- markdown.lua

-- Conversor de Markdown para HTML em Lua 5.4 puro, sem dependências.
-- Cobre o SUBSET que os arquivos .md deste repositório usam:
--   títulos (#..######), parágrafos, listas (-, * e numeradas, com
--   aninhamento por indentação), cercas de código (``` com linguagem),
--   código embutido (`...`), negrito (**), itálico (*), links, imagens,
--   citações (>), tabelas (| a | b |) e linhas horizontais (---).
--
-- Limitações conhecidas (de propósito — ver o padrão do repositório):
--   * não interpreta HTML embutido (é escapado como texto);
--   * sem notas de rodapé, listas de tarefas ou títulos "Setext" (===);
--   * ênfase não atravessa colchetes nem outras ênfases (sem **a *b**).
-- O teste da suíte (testar_markdown.lua) exercita cada construção, e o
-- gerador (gerar.lua) converte TODOS os .md reais a cada execução —
-- sintaxe nova não suportada quebra a CI visivelmente.

local M = {}

local function escaparHtml(texto)
  return (texto:gsub("[&<>]", { ["&"] = "&amp;", ["<"] = "&lt;", [">"] = "&gt;" }))
end
M.escaparHtml = escaparHtml

--------------------------------------------------------------------------------
-- Conversão das marcas EMBUTIDAS (dentro de uma linha).
-- Spans de código são protegidos primeiro (com marcadores \1n\1) para
-- que asteriscos e colchetes dentro deles não virem ênfase ou link.

local function converterEmbutidos(texto)
  local protegidos = {}
  texto = texto:gsub("`([^`]+)`", function(codigo)
    table.insert(protegidos, "<code>" .. escaparHtml(codigo) .. "</code>")
    return "\1" .. #protegidos .. "\1"
  end)

  texto = escaparHtml(texto)

  -- imagens antes de links (a sintaxe de imagem contém a de link):
  texto = texto:gsub("!%[([^%]]*)%]%(([^%)%s]+)%)", '<img src="%2" alt="%1">')
  texto = texto:gsub("%[([^%]]+)%]%(([^%)%s]+)%)", '<a href="%2">%1</a>')

  texto = texto:gsub("%*%*([^*]+)%*%*", "<strong>%1</strong>")
  texto = texto:gsub("%*([^*\n]+)%*", "<em>%1</em>")

  texto = texto:gsub("\1(%d+)\1", function(n)
    return protegidos[tonumber(n)]
  end)
  return texto
end
M.converterEmbutidos = converterEmbutidos

--------------------------------------------------------------------------------
-- Conversão dos BLOCOS (linha a linha, com uma pilha para listas).

-- nível de aninhamento a partir da indentação (0-1 espaços = nível 1;
-- cada ~2 espaços adicionais aprofundam um nível, até o limite 4):
local function nivelDaIndentacao(indentacao)
  return 1 + math.min(math.floor(#indentacao / 2), 3)
end

function M.converter(texto, opcoes)
  opcoes = opcoes or {}
  local saida = {}
  local paragrafo = {}   -- linhas do parágrafo em construção
  local listas = {}      -- pilha: { tag = "ul"/"ol", nivel = n }

  local function emitir(html) table.insert(saida, html) end

  local function despejarParagrafo()
    if #paragrafo > 0 then
      emitir("<p>" .. converterEmbutidos(table.concat(paragrafo, " ")) .. "</p>")
      paragrafo = {}
    end
  end

  local function fecharListasAte(nivel)
    while #listas > 0 and listas[#listas].nivel > nivel do
      local lista = table.remove(listas)
      emitir("</li></" .. lista.tag .. ">")
    end
  end

  local function fecharTodasAsListas()
    despejarParagrafo()
    fecharListasAte(0)
  end

  local linhas = {}
  for linha in (texto .. "\n"):gmatch("(.-)\r?\n") do
    table.insert(linhas, linha)
  end

  local i = 1
  while i <= #linhas do
    local linha = linhas[i]
    local indentacaoDaCerca, linguagem = linha:match("^(%s*)```(%S*)%s*$")
    local indentacaoDaLista, marcador, textoDoItem =
      linha:match("^(%s*)([-*])%s+(.*)$")
    local indentacaoNumerada, textoNumerado = linha:match("^(%s*)%d+%.%s+(.*)$")

    if indentacaoDaCerca then
      -- cerca de código: no nível zero encerra as listas abertas; se
      -- estiver indentada, o bloco pertence ao item de lista corrente.
      despejarParagrafo()
      if #indentacaoDaCerca == 0 then fecharListasAte(0) end
      local corpo = {}
      i = i + 1
      while i <= #linhas and not linhas[i]:match("^%s*```%s*$") do
        -- remove a indentação da cerca do corpo, preservando a relativa:
        table.insert(corpo, (linhas[i]:gsub("^" .. indentacaoDaCerca, "")))
        i = i + 1
      end
      local codigo = table.concat(corpo, "\n")
      local htmlDoCodigo
      if linguagem == "lua" and opcoes.realcarLua then
        htmlDoCodigo = opcoes.realcarLua(codigo)
      else
        htmlDoCodigo = escaparHtml(codigo)
      end
      emitir('<pre><code class="linguagem-' .. (linguagem == "" and "texto" or linguagem)
        .. '">' .. htmlDoCodigo .. "\n</code></pre>")

    elseif linha:match("^#+%s") then
      fecharTodasAsListas()
      local cerquilhas, titulo = linha:match("^(#+)%s+(.*)$")
      local nivel = math.min(#cerquilhas, 6)
      emitir("<h" .. nivel .. ">" .. converterEmbutidos(titulo) .. "</h" .. nivel .. ">")

    elseif linha:match("^%-%-%-+%s*$") then
      fecharTodasAsListas()
      emitir("<hr>")

    elseif linha:match("^>") then
      -- citação: junta as linhas consecutivas, remove o prefixo e
      -- converte o interior RECURSIVAMENTE (citações podem conter
      -- parágrafos e cercas de código):
      fecharTodasAsListas()
      local interior = {}
      while i <= #linhas and linhas[i]:match("^>") do
        table.insert(interior, (linhas[i]:gsub("^>%s?", "")))
        i = i + 1
      end
      i = i - 1
      emitir("<blockquote>" .. M.converter(table.concat(interior, "\n"), opcoes) .. "</blockquote>")

    elseif linha:match("^|.*|%s*$") and linhas[i + 1] and linhas[i + 1]:match("^|[%s:|%-]+|%s*$") then
      -- tabela: linha de cabeçalho + separadora + corpo
      fecharTodasAsListas()
      local function celulas(linhaDaTabela)
        local resultado = {}
        for celula in linhaDaTabela:gmatch("|([^|]*)") do
          table.insert(resultado, (celula:gsub("^%s+", ""):gsub("%s+$", "")))
        end
        -- a divisão em "|" gera uma célula vazia final (após o | de fechamento):
        if resultado[#resultado] == "" then table.remove(resultado) end
        return resultado
      end
      local cabecalho = celulas(linha)
      local tabela = { "<table><thead><tr>" }
      for _, celula in ipairs(cabecalho) do
        table.insert(tabela, "<th>" .. converterEmbutidos(celula) .. "</th>")
      end
      table.insert(tabela, "</tr></thead><tbody>")
      i = i + 2
      while i <= #linhas and linhas[i]:match("^|.*|%s*$") do
        table.insert(tabela, "<tr>")
        for _, celula in ipairs(celulas(linhas[i])) do
          table.insert(tabela, "<td>" .. converterEmbutidos(celula) .. "</td>")
        end
        table.insert(tabela, "</tr>")
        i = i + 1
      end
      i = i - 1
      table.insert(tabela, "</tbody></table>")
      emitir(table.concat(tabela))

    elseif indentacaoDaLista or indentacaoNumerada then
      despejarParagrafo()
      local indentacao = indentacaoDaLista or indentacaoNumerada
      local item = indentacaoDaLista and textoDoItem or textoNumerado
      local tag = indentacaoDaLista and "ul" or "ol"
      local _ = marcador -- o marcador (- ou *) não muda o HTML
      local nivel = nivelDaIndentacao(indentacao)
      fecharListasAte(nivel)
      local topo = listas[#listas]
      if topo and topo.nivel == nivel and topo.tag == tag then
        emitir("</li><li>" .. converterEmbutidos(item))
      elseif topo and topo.nivel == nivel then
        -- mesmo nível, tipo diferente: troca a lista
        table.remove(listas)
        emitir("</li></" .. topo.tag .. "><" .. tag .. "><li>" .. converterEmbutidos(item))
        table.insert(listas, { tag = tag, nivel = nivel })
      else
        emitir("<" .. tag .. "><li>" .. converterEmbutidos(item))
        table.insert(listas, { tag = tag, nivel = nivel })
      end

    elseif linha:match("^%s*$") then
      despejarParagrafo()

    elseif #listas > 0 and linha:match("^%s") then
      -- linha indentada dentro de uma lista: continuação do item
      table.insert(paragrafo, (linha:gsub("^%s+", "")))

    else
      if #listas > 0 then fecharTodasAsListas() end
      table.insert(paragrafo, linha)
    end
    i = i + 1
  end

  fecharTodasAsListas()
  return table.concat(saida, "\n")
end

return M
