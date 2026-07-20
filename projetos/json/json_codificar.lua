local function json_codificar(valor)
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
          table.insert(itens, '"' .. k .. '":' .. codificarValor(item))
        end
        return "{" .. table.concat(itens, ",") .. "}"
      end
    elseif type(v) == "string" then
      return '"' .. v:gsub('"', '\\"') .. '"'
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

return json_codificar
