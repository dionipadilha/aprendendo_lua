-- json_decodificar.lua

-- Escapes básicos do JSON e o caractere que cada um representa.
-- Limitação documentada no README.md: \uXXXX não é suportado.
local escapes = {
  ['"'] = '"',
  ["\\"] = "\\",
  ["/"] = "/",
  ["n"] = "\n",
  ["t"] = "\t",
  ["r"] = "\r",
  ["b"] = "\b",
  ["f"] = "\f"
}

local function jsonDecodificar(valor)
  if type(valor) ~= "string" then
    error("jsonDecodificar espera uma string, recebeu " .. type(valor))
  end

  local posicao = 1

  local function decodificarValor()
    local function pularEspacos()
      while string.match(valor:sub(posicao, posicao), "%s") do
        posicao = posicao + 1
      end
    end

    local function decodificarString()
      posicao = posicao + 1 -- pula a aspa de abertura
      local partes = {}
      while posicao <= #valor do
        local caractere = valor:sub(posicao, posicao)
        if caractere == '"' then
          posicao = posicao + 1
          return table.concat(partes)
        elseif caractere == "\\" then
          -- interpreta a sequência de escape (\" \\ \/ \n \t \r \b \f)
          local marcador = valor:sub(posicao + 1, posicao + 1)
          local traduzido = escapes[marcador]
          if not traduzido then
            error("Sequência de escape não suportada: \\" .. marcador)
          end
          table.insert(partes, traduzido)
          posicao = posicao + 2
        else
          table.insert(partes, caractere)
          posicao = posicao + 1
        end
      end
      error("String não terminada")
    end

    local function decodificarNumero()
      local inicio = posicao
      while string.match(valor:sub(posicao, posicao), "[%d%.%-eE+]") do
        posicao = posicao + 1
      end
      local textoDoNumero = valor:sub(inicio, posicao - 1)
      local numero = tonumber(textoDoNumero)
      if numero then
        return numero
      else
        error("Número inválido: " .. textoDoNumero)
      end
    end

    local function decodificarLiteral(literal, resultado)
      if valor:sub(posicao, posicao + #literal - 1) == literal then
        posicao = posicao + #literal
        return resultado
      end
      error("Literal inválido: " .. literal)
    end

    pularEspacos()

    local caractere = valor:sub(posicao, posicao)
    if caractere == '"' then
      return decodificarString()
    elseif caractere == '{' then
      posicao = posicao + 1
      local objeto = {}
      pularEspacos()
      while valor:sub(posicao, posicao) ~= '}' do
        pularEspacos()
        if valor:sub(posicao, posicao) ~= '"' then
          error("Chave de objeto deve ser uma string entre aspas")
        end
        local chave = decodificarString()
        pularEspacos()
        if valor:sub(posicao, posicao) ~= ':' then
          error("Esperado ':' após a chave")
        end
        posicao = posicao + 1
        local v = decodificarValor()
        objeto[chave] = v
        pularEspacos()
        if valor:sub(posicao, posicao) == ',' then
          posicao = posicao + 1
          pularEspacos()
          -- vírgula final, como em {"a":1,}, é JSON inválido:
          if valor:sub(posicao, posicao) == '}' then
            error("Vírgula final não é permitida em objetos")
          end
        elseif valor:sub(posicao, posicao) ~= '}' then
          error("Esperado ',' ou '}'")
        end
      end
      posicao = posicao + 1
      return objeto
    elseif caractere == '[' then
      posicao = posicao + 1
      local vetor = {}
      pularEspacos()
      while valor:sub(posicao, posicao) ~= ']' do
        local v = decodificarValor()
        table.insert(vetor, v)
        pularEspacos()
        if valor:sub(posicao, posicao) == ',' then
          posicao = posicao + 1
          pularEspacos()
          -- vírgula final, como em [1,2,], é JSON inválido:
          if valor:sub(posicao, posicao) == ']' then
            error("Vírgula final não é permitida em vetores")
          end
        elseif valor:sub(posicao, posicao) ~= ']' then
          error("Esperado ',' ou ']'")
        end
      end
      posicao = posicao + 1
      return vetor
    elseif string.match(caractere, "[%d%-]") then
      return decodificarNumero()
    elseif caractere == 't' then
      return decodificarLiteral("true", true)
    elseif caractere == 'f' then
      return decodificarLiteral("false", false)
    elseif caractere == 'n' then
      return decodificarLiteral("null", nil)
    else
      error("Caractere inesperado: " .. caractere)
    end
  end

  local resultado = decodificarValor()

  -- Rejeita sobras após o valor: "123abc" ou '{"a":1} lixo' são inválidos.
  while string.match(valor:sub(posicao, posicao), "%s") do
    posicao = posicao + 1
  end
  if posicao <= #valor then
    error("Conteúdo inesperado após o fim do JSON: " .. valor:sub(posicao))
  end

  return resultado
end

return jsonDecodificar
