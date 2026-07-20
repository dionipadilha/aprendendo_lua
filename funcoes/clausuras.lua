-- clausuras.lua

-- Cria funções que mantêm estado entre as chamadas.
local novoContador = function(n)
  local i = 0
  return function()
    i = i + 1
    return i <= n and i or nil
  end
end

-- Cria um contador separado com seu próprio ambiente:
local c1 = novoContador(3)
local c2 = novoContador(5)

print(c1()) --> 1
print(c1()) --> 2
print(c2()) --> 1

print(c1()) --> 3
print(c2()) --> 2

print(c1()) --> nil
print(c2()) --> 3

print(c1()) --> nil
print(c2()) --> 4

print(c1()) --> nil
print(c2()) --> 5

print(c1()) --> nil
print(c2()) --> nil

-- Verificação: contadores novos são independentes e terminam em nil
local v1 = novoContador(2)
local v2 = novoContador(3)
assert(v1() == 1 and v1() == 2 and v1() == nil)
assert(v2() == 1 and v2() == 2 and v2() == 3 and v2() == nil)
