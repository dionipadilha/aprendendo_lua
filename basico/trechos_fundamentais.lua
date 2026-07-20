-- Olá Mundo:
print("Olá Mundo!")

-- Operações Aritméticas Básicas
local soma = 1 + 1
local diferenca = 10 - 4
local produto = 7 * 6
local quociente = 20 / 5
local resto = 10 % 3

-- Funções:
local function maisUm(x) return x + 1 end
local function somar(a, b) return a + b end
local dobro = function(x) return 2 * x end

-- Tipos de Dados:
local pessoa = {                  -- tabela (dicionário)
  amigos = { "Ana", "Charlie" },  -- tabela (lista)
  nome = "Bob",                   -- string
  idade = 42,                     -- número (inteiro)
  altura = 1.82,                  -- número (float)
  ehAdulto = true,                -- booleano
  comer = function(comida) end    -- função
}

-- Notação de Ponto:
function pessoa:digaOi() return ("Oi, meu nome é " .. self.nome) end -- função

-- Condicional:
if pessoa.idade > 18 then pessoa.ehAdulto = true end

-- Laços:
for i = 1, #pessoa.amigos do print(pessoa.amigos[i]) end

for _, amigo in ipairs(pessoa.amigos) do print(amigo) end

for chave, valor in pairs(pessoa) do print(chave, valor) end

pessoa.idade = 1
while pessoa.idade < 18 do
  pessoa.ehAdulto = false
  pessoa.idade = pessoa.idade + 1
end
pessoa.ehAdulto = true

pessoa.idade = 1
repeat
  pessoa.ehAdulto = false
  pessoa.idade = pessoa.idade + 1
until pessoa.idade > 18
pessoa.ehAdulto = true

-- Listas
local amigos = table.pack("Charlie", "Ana")
table.insert(amigos, "Bob")
table.insert(amigos, 2, "Alex")
table.sort(amigos)
table.remove(amigos)
table.remove(amigos, 1)
print(table.concat(amigos, ", "))
local a, b, c = table.unpack(amigos)
print(b)

-- Tratamento de Exceções
local function entrada(pessoa)
  assert(pessoa.ehAdulto, "Acesso negado")
end
local sucesso, erro = pcall(entrada, pessoa)
if not sucesso then
  print(sucesso, erro)
else
  print(sucesso, "Acesso permitido")
end

-- Manipulação de Arquivos
local arquivo = assert(io.open("arquivo_demo.txt", "w"))
arquivo:write("torrada!")
assert(arquivo:close())

arquivo = assert(io.open("arquivo_demo.txt"))
print(arquivo:read())
assert(arquivo:close())
