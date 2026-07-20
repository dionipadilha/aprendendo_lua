-- arquivo_acrescentar.lua

-- acrescentando um conteúdo aleatório:
do
  local textoAleatorio = "Agora o arquivo tem mais conteúdo: %f\n"
  for i = 1, 3 do
    local arquivo = assert(io.open("arquivo_demo.txt", "a"))
    arquivo:write(textoAleatorio:format(math.random()))
    assert(arquivo:close())
  end
end

-- lendo as linhas do arquivo:
do
  local arquivo = assert(io.open("arquivo_demo.txt"))
  local linhas = {}
  for linha in arquivo:lines() do table.insert(linhas, linha) end
  assert(arquivo:close())

  -- faz algum processamento:
  table.sort(linhas)

  -- imprime as linhas processadas:
  for _, linha in ipairs(linhas) do print(linha) end

  -- propriedade: as 3 linhas recém-acrescentadas estão no arquivo
  -- (o arquivo persiste entre execuções, então pode haver mais linhas):
  local acrescentadas = 0
  for _, linha in ipairs(linhas) do
    if linha:match("mais conteúdo: %d") then acrescentadas = acrescentadas + 1 end
  end
  assert(acrescentadas >= 3)
end
