-- arquivo_manipulacao_basica.lua

-- Abordagem #1:

-- Escrevendo em um arquivo
local arquivoDeEscrita = io.open("teste.txt", "w")
if arquivoDeEscrita then
  arquivoDeEscrita:write("Olá, Lua!")
  arquivoDeEscrita:close()
else
  print("Erro ao abrir o arquivo para escrita.")
end

-- Lendo de um arquivo
local arquivoDeLeitura = io.open("teste.txt", "r")
local conteudo = nil
if arquivoDeLeitura then
  conteudo = arquivoDeLeitura:read("a")
  arquivoDeLeitura:close()
else
  print("Erro ao abrir o arquivo para leitura.")
end

if conteudo then
  print("Conteúdo do arquivo: " .. conteudo)
else
  print("Nenhum conteúdo lido do arquivo.")
end
assert(conteudo == "Olá, Lua!")

-- Abordagem #2:

-- cria um arquivo se ele não existir:
local arquivo = assert(io.open("arquivo_demo.txt", "w"))
arquivo:write("torrada!")
assert(arquivo:close())

-- abre um arquivo para leitura:
arquivo = assert(io.open("arquivo_demo.txt"))
local primeiraLinha = arquivo:read()
print(primeiraLinha) --> torrada!
assert(primeiraLinha == "torrada!")
assert(arquivo:close())
