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
  local function codificarValor(v)
    if type(v) == "table" then
      local ehVetor = true
      local indiceMaximo = 0
      for k in pairs(v) do
        if type(k) ~= "number" or k < 1 or math.floor(k) ~= k then
          ehVetor = false
          break
        end
        if k > indiceMaximo then indiceMaximo = k end
      end

      if ehVetor then
        local itens = {}
        for i = 1, indiceMaximo do
          table.insert(itens, codificarValor(v[i]))
        end
        return "[" .. table.concat(itens, ",") .. "]"
      else
        local itens = {}
        for k, item in pairs(v) do
          table.insert(itens, '"' .. escaparString(tostring(k)) .. '":' .. codificarValor(item))
        end
        return "{" .. table.concat(itens, ",") .. "}"
      end
    elseif type(v) == "string" then
      return '"' .. escaparString(v) .. '"'
    elseif type(v) == "number" or type(v) == "boolean" then
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
