-- Sequências de escape exigidas pelo JSON: barra invertida, aspas duplas
-- e caracteres de controle têm formas próprias; os demais controles
-- (ex.: \v) viram a forma genérica \u00XX.
local escapes = {
  ['"'] = '\\"',
  ["\\"] = "\\\\",
  ["\b"] = "\\b",
  ["\f"] = "\\f",
  ["\n"] = "\\n",
  ["\r"] = "\\r",
  ["\t"] = "\\t"
}

local function escaparString(texto)
  -- %c casa qualquer caractere de controle; " e \ também precisam de escape.
  return (texto:gsub('[%c"\\]', function(caractere)
    return escapes[caractere] or string.format("\\u%04x", caractere:byte())
  end))
end

local function jsonCodificar(valor)
  -- tabelas em codificação na pilha atual: se uma tabela reaparecer
  -- dentro de si mesma, há um ciclo — sem esta checagem a recursão
  -- estouraria a pilha (stack overflow) com uma mensagem obscura.
  local emCodificacao = {}

  local function codificarValor(v)
    if type(v) == "table" then
      if emCodificacao[v] then
        error("JSON não representa ciclos: a tabela referencia a si mesma")
      end
      emCodificacao[v] = true

      local ehVetor = true
      local indiceMaximo = 0
      for k in pairs(v) do
        if type(k) ~= "number" or k < 1 or math.floor(k) ~= k then
          ehVetor = false
          break
        end
        if k > indiceMaximo then indiceMaximo = k end
      end

      local resultado
      if ehVetor then
        local itens = {}
        for i = 1, indiceMaximo do
          table.insert(itens, codificarValor(v[i]))
        end
        resultado = "[" .. table.concat(itens, ",") .. "]"
      else
        local itens = {}
        for k, item in pairs(v) do
          table.insert(itens, '"' .. escaparString(tostring(k)) .. '":' .. codificarValor(item))
        end
        resultado = "{" .. table.concat(itens, ",") .. "}"
      end

      emCodificacao[v] = nil
      return resultado
    elseif type(v) == "string" then
      return '"' .. escaparString(v) .. '"'
    elseif type(v) == "number" then
      -- NaN e ±infinito não existem em JSON: melhor falhar com uma
      -- mensagem clara do que emitir "nan"/"inf", que nenhum parser aceita.
      if v ~= v or v == math.huge or v == -math.huge then
        error("JSON não representa NaN nem infinito: " .. tostring(v))
      end
      return tostring(v)
    elseif type(v) == "boolean" then
      return tostring(v)
    elseif v == nil then
      return "null"
    else
      error("Tipo de valor não suportado: " .. type(v))
    end
  end

  return codificarValor(valor)
end

return jsonCodificar
