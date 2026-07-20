-- arquivo_crud.lua

local nomeDoArquivo = "crud.txt"
local conteudoInicial = "ana"
local conteudoAtualizado = "bob"

-- criando e escrevendo conteúdo em um arquivo:
do
  local arquivo = assert(io.open(nomeDoArquivo, "w"))
  arquivo:write(conteudoInicial)
  assert(arquivo:close())
end

-- lendo o conteúdo de um arquivo
do
  local arquivo = assert(io.open(nomeDoArquivo, "r"))
  local conteudo = arquivo:read("*a")
  assert(conteudo == conteudoInicial)
  assert(arquivo:close())
end

-- atualizando o conteúdo do arquivo:
do
  local arquivo = assert(io.open(nomeDoArquivo, "w+"))
  arquivo:write(conteudoAtualizado)
  assert(arquivo:close())

  -- verificando a atualização
  arquivo = assert(io.open(nomeDoArquivo, "r"))
  local conteudo = arquivo:read("*a")
  assert(conteudo == conteudoAtualizado)
  assert(arquivo:close())
end

-- excluindo o arquivo:
do
  os.remove(nomeDoArquivo)

  -- verificando a exclusão
  local arquivo = io.open(nomeDoArquivo)
  assert(arquivo == nil)
end
