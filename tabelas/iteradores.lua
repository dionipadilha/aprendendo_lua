-- iteradores.lua

-------------------------------------------------------
-- retorna o próximo valor da tabela:
local function iteradorDeLista(t)
  local i = 0
  local n = #t
  return function()
    i = i + 1
    if i <= n then return t[i] end
  end
end

-------------------------------------------------------
local frutas = { "maçã", "banana", "cereja" }
local proximaFruta = iteradorDeLista(frutas)
print(proximaFruta()) --> maçã
print(proximaFruta()) --> banana
print(proximaFruta()) --> cereja
print(proximaFruta()) -->

-------------------------------------------------------
local estudantes = { "ana", "bob", "charlie" }
local proximoEstudante = iteradorDeLista(estudantes)
local estudante = proximoEstudante()
while estudante do
  print(estudante)
  estudante = proximoEstudante()
end

-------------------------------------------------------
local nomes = { "ana", "bob", "charlie" }
for nome in iteradorDeLista(nomes) do print(nome) end

-------------------------------------------------------
-- Verificação: o iterador percorre em ordem e termina com nil
local letras = { "a", "b", "c" }
local proximaLetra = iteradorDeLista(letras)
assert(proximaLetra() == "a")
assert(proximaLetra() == "b")
assert(proximaLetra() == "c")
assert(proximaLetra() == nil)
