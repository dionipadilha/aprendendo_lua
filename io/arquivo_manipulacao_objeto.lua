-- arquivo_manipulacao_objeto.lua

-- Abordagem #2: Manipulador de Arquivo Orientado a Objetos

-- Define o protótipo ManipuladorDeArquivo
local ManipuladorDeArquivo = {}
ManipuladorDeArquivo.__index = ManipuladorDeArquivo

-- Construtor do ManipuladorDeArquivo
function ManipuladorDeArquivo.novo(nomeDoArquivo)
  local self = setmetatable({}, ManipuladorDeArquivo)
  self.nomeDoArquivo = nomeDoArquivo
  return self
end

-- Método para escrever em um arquivo
function ManipuladorDeArquivo:escrever(conteudo)
  local arquivoDeEscrita = io.open(self.nomeDoArquivo, "w")
  if arquivoDeEscrita then
    arquivoDeEscrita:write(conteudo)
    arquivoDeEscrita:close()
  else
    print("Erro ao abrir o arquivo para escrita.")
  end
end

-- Método para ler de um arquivo
function ManipuladorDeArquivo:ler()
  local arquivoDeLeitura = io.open(self.nomeDoArquivo, "r")
  local conteudo = nil
  if arquivoDeLeitura then
    conteudo = arquivoDeLeitura:read("a")
    arquivoDeLeitura:close()
    return conteudo
  else
    print("Erro ao abrir o arquivo para leitura.")
    return nil
  end
end

-- Uso
local manipuladorDeArquivo = ManipuladorDeArquivo.novo("teste.txt")
manipuladorDeArquivo:escrever("Olá, Lua!")
local conteudo = manipuladorDeArquivo:ler()

if conteudo then
  print("Conteúdo do arquivo: " .. conteudo)
else
  print("Nenhum conteúdo lido do arquivo.")
end
assert(conteudo == "Olá, Lua!")
