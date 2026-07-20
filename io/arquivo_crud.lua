-- arquivo_crud.lua

local nome_do_arquivo = "crud.txt"
local conteudo_inicial = "ana"
local conteudo_atualizado = "bob"

-- criando e escrevendo conteúdo em um arquivo:
do
  local arquivo = assert(io.open(nome_do_arquivo, "w"))
  arquivo:write(conteudo_inicial)
  assert(arquivo:close())
end

-- lendo o conteúdo de um arquivo
do
  local arquivo = assert(io.open(nome_do_arquivo, "r"))
  local conteudo = arquivo:read("*a")
  assert(conteudo == conteudo_inicial)
  assert(arquivo:close())
end

-- atualizando o conteúdo do arquivo:
do
  local arquivo = assert(io.open(nome_do_arquivo, "w+"))
  arquivo:write(conteudo_atualizado)
  assert(arquivo:close())

  -- verificando a atualização
  arquivo = assert(io.open(nome_do_arquivo, "r"))
  local conteudo = arquivo:read("*a")
  assert(conteudo == conteudo_atualizado)
  assert(arquivo:close())
end

-- excluindo o arquivo:
do
  os.remove(nome_do_arquivo)

  -- verificando a exclusão
  local arquivo = io.open(nome_do_arquivo)
  assert(arquivo == nil)
end
