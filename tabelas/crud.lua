-- Define a classe de banco de dados
local BancoDeDados = {}

-- Construtor do banco de dados
function BancoDeDados:novo(objeto)
  objeto = objeto or {}
  -- Estado mutável inicializado POR INSTÂNCIA:
  -- se `registros` ficasse na tabela da classe, todos os bancos
  -- de dados compartilhariam os mesmos registros.
  objeto.registros = objeto.registros or {}
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
  print(registro.nome, registro.idade) --> John Doe	42
  assert(registro.nome == "John Doe" and registro.idade == 42)

  bd:atualizar(1, { nome = "Jane Doe", idade = 31 })
  registro = bd:ler(1)
  print(registro.nome, registro.idade) --> Jane Doe	31
  assert(registro.nome == "Jane Doe" and registro.idade == 31)

  print(bd:excluir(1)) --> true
  -- assert (como error) prefixa a posição "arquivo:linha" à mensagem:
  local status, erro = pcall(function() return bd:ler(1) end)
  print(status, erro) --> false	crud.lua:25: Registro não encontrado.
  assert(status == false)
  assert(string.find(erro, "crud%.lua:%d+: Registro não encontrado%."))
end

principal()

-- Duas instâncias de banco de dados são independentes:
local function testarInstanciasIndependentes()
  local bd1 = BancoDeDados:novo()
  local bd2 = BancoDeDados:novo()

  bd1:criar(1, { nome = "Ana" })

  -- bd1 tem o registro; bd2 não foi contaminado:
  assert(bd1:ler(1).nome == "Ana")
  assert(not pcall(bd2.ler, bd2, 1))       -- bd2 não conhece o id 1
  assert(bd1.registros ~= bd2.registros)   -- tabelas de registros distintas

  -- bd2 pode criar o MESMO id sem conflitar com bd1:
  bd2:criar(1, { nome = "Bob" })
  assert(bd1:ler(1).nome == "Ana")
  assert(bd2:ler(1).nome == "Bob")

  print("Instâncias de BancoDeDados independentes: ok")
end

testarInstanciasIndependentes()
