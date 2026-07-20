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
-- o \n final importa: arquivo_acrescentar.lua ACRESCENTA linhas a este
-- mesmo arquivo, e sem a quebra de linha a primeira linha acrescentada
-- grudaria em "torrada!" (arquivos-texto devem terminar em \n).
arquivo:write("torrada!\n")
assert(arquivo:close())

-- abre um arquivo para leitura:
arquivo = assert(io.open("arquivo_demo.txt"))
local primeiraLinha = arquivo:read() -- read() devolve a linha SEM o \n
print(primeiraLinha) --> torrada!
assert(primeiraLinha == "torrada!")
assert(arquivo:close())
