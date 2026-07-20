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
  local conteudo = arquivo:read("a")
  assert(conteudo == conteudoInicial)
  assert(arquivo:close())
end

-- atualizando o conteúdo do arquivo:
-- o modo de ATUALIZAÇÃO é "r+": abre para ler E escrever preservando o
-- conteúdo existente (cursor no início). Cuidado com os parentes:
--   "w+" também lê e escreve, mas TRUNCA o arquivo ao abrir (como "w");
--   "a+" preserva, porém toda escrita vai para o FIM (como "a").
do
  local arquivo = assert(io.open(nomeDoArquivo, "r+"))

  -- o "+" permite ler pelo MESMO handle antes de escrever:
  assert(arquivo:read("a") == conteudoInicial)

  -- volta o cursor ao início e sobrescreve; como o conteúdo novo tem o
  -- mesmo tamanho do antigo, nada do valor anterior sobra no arquivo
  -- ("r+" não trunca: um conteúdo novo mais curto deixaria um resto).
  arquivo:seek("set")
  arquivo:write(conteudoAtualizado)
  assert(arquivo:close())

  -- verificando a atualização
  arquivo = assert(io.open(nomeDoArquivo, "r"))
  local conteudo = arquivo:read("a")
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
