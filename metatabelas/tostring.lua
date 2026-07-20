-- Definição da Classe Pessoa:

local Pessoa = {
  nome = "",
  sobrenome = "",
  idade = 0
}

function Pessoa:novo(objeto)
  objeto = objeto or {}
  setmetatable(objeto, self)
  self.__index = self
  return objeto
end

function Pessoa:__tostring()
  return table.concat({
    "Nome: " .. self.nome,
    "Sobrenome: " .. self.sobrenome,
    "Idade: " .. self.idade
  }, ", ")
end

local pessoa1 = Pessoa:novo { nome = "John", sobrenome = "Doe", idade = 30 }
local pessoa2 = Pessoa:novo { nome = "Jane", sobrenome = "Smith", idade = 25 }

print(pessoa1) --> Nome: John, Sobrenome: Doe, Idade: 30
print(pessoa2) --> Nome: Jane, Sobrenome: Smith, Idade: 25

assert(tostring(pessoa1) == "Nome: John, Sobrenome: Doe, Idade: 30")
assert(tostring(pessoa2) == "Nome: Jane, Sobrenome: Smith, Idade: 25")
