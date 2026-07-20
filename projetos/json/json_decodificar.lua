local function json_decodificar(valor)
  local posicao = 1

  local function decodificarValor()
    local function pularEspacos()
      while string.match(valor:sub(posicao, posicao), "%s") do
        posicao = posicao + 1
      end
    end

    local function decodificarString()
      local inicio = posicao + 1
      posicao = inicio
      while posicao <= #valor do
        local caractere = valor:sub(posicao, posicao)
        if caractere == '"' then
          local texto = valor:sub(inicio, posicao - 1)
          posicao = posicao + 1
          return texto
        elseif caractere == "\\" then
          posicao = posicao + 1
        end
        posicao = posicao + 1
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
        elseif valor:sub(posicao, posicao) ~= '}' then
          error("Esperado ',' ou '}'")
        end
        pularEspacos()
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
        elseif valor:sub(posicao, posicao) ~= ']' then
          error("Esperado ',' ou ']'")
        end
        pularEspacos()
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

  return decodificarValor()
end

return json_decodificar
