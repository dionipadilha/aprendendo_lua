-- realce.lua

-- Realce de sintaxe Lua minimalista para o site: comentários, strings,
-- palavras-chave e números viram <span>s com classes de CSS. A entrada
-- é código-fonte cru; a saída já vem com o HTML escapado.
--
-- Limitações conhecidas: não interpreta níveis de strings longas
-- ([==[...]==] com sinais de igual) nem realça chamadas de função ou
-- campos — quatro categorias bastam para leitura confortável.

local palavrasChave = {}
for palavra in ([[and break do else elseif end false for function goto if
in local nil not or repeat return then true until while]]):gmatch("%S+") do
  palavrasChave[palavra] = true
end

local function escaparHtml(texto)
  return (texto:gsub("[&<>]", { ["&"] = "&amp;", ["<"] = "&lt;", [">"] = "&gt;" }))
end

local function marcar(classe, trecho)
  return '<span class="' .. classe .. '">' .. escaparHtml(trecho) .. "</span>"
end

local function realcar(codigo)
  local saida = {}
  local posicao = 1
  local tamanho = #codigo

  while posicao <= tamanho do
    local resto = codigo:sub(posicao)

    -- comentário longo --[[ ... ]] (deve vir antes do comentário de linha):
    local comentarioLongo = resto:match("^%-%-%[%[.-%]%]")
      or (resto:match("^%-%-%[%[") and resto) -- não fechado: vai até o fim
    -- comentário de linha:
    local comentarioDeLinha = resto:match("^%-%-[^\n]*")
    -- string longa [[ ... ]]:
    local stringLonga = resto:match("^%[%[.-%]%]")
    -- strings com aspas (com escapes \" e \'):
    local stringDupla = resto:match('^"[^"\\]*\\?[^"]*"') and resto:match('^(".-[^\\]")') or resto:match('^("")')
    local stringSimples = resto:match("^'[^'\\]*\\?[^']*'") and resto:match("^('.-[^\\]')") or resto:match("^('')")
    -- número (inteiro, decimal, científico ou hexadecimal):
    local numero = resto:match("^0[xX]%x+") or resto:match("^%d+%.?%d*[eE]?[%+%-]?%d*")
    -- identificador ou palavra-chave:
    local identificador = resto:match("^[%a_][%w_]*")

    if comentarioLongo then
      table.insert(saida, marcar("comentario", comentarioLongo))
      posicao = posicao + #comentarioLongo
    elseif comentarioDeLinha then
      table.insert(saida, marcar("comentario", comentarioDeLinha))
      posicao = posicao + #comentarioDeLinha
    elseif stringLonga then
      table.insert(saida, marcar("texto-lua", stringLonga))
      posicao = posicao + #stringLonga
    elseif stringDupla then
      table.insert(saida, marcar("texto-lua", stringDupla))
      posicao = posicao + #stringDupla
    elseif stringSimples then
      table.insert(saida, marcar("texto-lua", stringSimples))
      posicao = posicao + #stringSimples
    elseif identificador then
      if palavrasChave[identificador] then
        table.insert(saida, marcar("palavra-chave", identificador))
      else
        table.insert(saida, escaparHtml(identificador))
      end
      posicao = posicao + #identificador
    elseif numero and #numero > 0 then
      table.insert(saida, marcar("numero", numero))
      posicao = posicao + #numero
    else
      table.insert(saida, escaparHtml(codigo:sub(posicao, posicao)))
      posicao = posicao + 1
    end
  end

  return table.concat(saida)
end

return realcar
