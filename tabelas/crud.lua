-- Define a classe de banco de dados
local BancoDeDados = {
  registros = {}
}

-- Construtor do banco de dados
function BancoDeDados:novo(objeto)
  objeto = objeto or {}
  self.__index = self
  return setmetatable(objeto, self)
end

-- Método para criar um novo registro
function BancoDeDados:criar(id, dados)
  assert(self.registros[id] == nil, "Já existe um registro com o ID informado.")
  assert(dados ~= nil and dados ~= "", "Dados de registro inválidos.")
  self.registros[id] = dados
  return true
end

-- Método para ler um registro pelo ID
function BancoDeDados:ler(id)
  assert(self.registros[id] ~= nil, "Registro não encontrado.")
  return self.registros[id]
end

-- Método para atualizar um registro existente
function BancoDeDados:atualizar(id, novosDados)
  assert(self.registros[id] ~= nil, "Registro não encontrado.")
  assert(novosDados ~= nil and novosDados ~= "", "Dados de registro inválidos.")
  self.registros[id] = novosDados
  return self.registros[id]
end

-- Método para excluir um registro
function BancoDeDados:excluir(id)
  assert(self.registros[id] ~= nil, "Registro não encontrado.")
  self.registros[id] = nil
  return true
end

-- Exemplo de uso
local function principal()
  local bd = BancoDeDados:novo {}

  bd:criar(1, { nome = "John Doe", idade = 42 })

  local registro = bd:ler(1)
  print(registro.nome, registro.idade) --> John Doe 42

  bd:atualizar(1, { nome = "Jane Doe", idade = 31 })
  registro = bd:ler(1)
  print(registro.nome, registro.idade) --> Jane Doe 31

  print(bd:excluir(1))            --> true
  local status, erro = pcall(function() return bd:ler(1) end)
  print(status, erro) --> false   crud.lua:23: Registro não encontrado.
end

principal()
