-- tipos.lua

-- number:
print(type(42))   --> number
print(type(3.14)) --> number
assert(type(42) == "number" and type(3.14) == "number")

-- string:
print(type("a"))   --> string
print(type("bob")) --> string
assert(type("a") == "string" and type("bob") == "string")

-- boolean:
print(type(true))  --> boolean
print(type(false)) --> boolean
assert(type(true) == "boolean" and type(false) == "boolean")

-- table:
print(type({ "bob", 42 }))                --> table
print(type({ nome = "bob", idade = 42 })) --> table
assert(type({}) == "table")

-- nil:
print(type(nil))   --> nil
print(true or nil) --> true
assert(type(nil) == "nil")
assert((true or nil) == true)

-- function:
print(type(print))      --> function
local quadratica = function(x) return x ^ 2 end
print(type(quadratica)) --> function
assert(type(print) == "function" and type(quadratica) == "function")

-- thread
local co = coroutine.create(quadratica)
print(type(co)) --> thread
assert(type(co) == "thread")

-- userdata:
-- dados gerenciados por código C; a própria biblioteca io demonstra o
-- tipo — arquivos abertos (como a saída padrão io.stdout) são userdata:
print(type(io.stdout)) --> userdata
assert(type(io.stdout) == "userdata")

--------------------------------------------------------------------------------
-- Inteiro vs float (Lua 5.4)

-- O tipo number tem duas representações internas: integer e float.
-- type() devolve "number" para ambas; math.type() é quem as distingue
-- (e devolve nil quando o valor não é um número):
print(math.type(42))    --> integer
print(math.type(3.14))  --> float
print(math.type("oi"))  --> nil
assert(math.type(42) == "integer")
assert(math.type(3.14) == "float")
assert(math.type("oi") == nil)

-- A divisão `/` e a exponenciação `^` SEMPRE produzem float,
-- mesmo entre inteiros e mesmo quando o resultado é exato:
print(4 / 2) --> 2.0
print(2 ^ 3) --> 8.0
assert(4 / 2 == 2.0 and math.type(4 / 2) == "float")
assert(2 ^ 3 == 8.0 and math.type(2 ^ 3) == "float")

-- Já a divisão inteira `//` preserva o subtipo:
-- inteiro // inteiro produz inteiro (arredondando para baixo);
-- se um dos operandos for float, o resultado é float:
print(7 // 2)   --> 3
print(7.0 // 2) --> 3.0
assert(7 // 2 == 3 and math.type(7 // 2) == "integer")
assert(7.0 // 2 == 3.0 and math.type(7.0 // 2) == "float")

-- math.tointeger converte um float de valor inteiro para o subtipo integer;
-- para valores com parte fracionária, devolve nil:
print(math.tointeger(2.0)) --> 2
print(math.tointeger(2.5)) --> nil
assert(math.tointeger(2.0) == 2)
assert(math.type(math.tointeger(2.0)) == "integer")
assert(math.tointeger(2.5) == nil)

-- Na comparação, inteiro e float de mesmo valor matemático são iguais,
-- embora tenham subtipos diferentes:
assert(2 == 2.0)
assert(math.type(2) ~= math.type(2.0))
