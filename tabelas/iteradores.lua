-- iteradores.lua

-------------------------------------------------------
-- retorna o próximo valor da tabela:
local function iterador_de_lista(t)
  local i = 0
  local n = #t
  return function()
    i = i + 1
    if i <= n then return t[i] end
  end
end

-------------------------------------------------------
local frutas = { "maçã", "banana", "cereja" }
local proxima_fruta = iterador_de_lista(frutas)
print(proxima_fruta()) --> maçã
print(proxima_fruta()) --> banana
print(proxima_fruta()) --> cereja
print(proxima_fruta()) -->

-------------------------------------------------------
local estudantes = { "ana", "bob", "charlie" }
local proximo_estudante = iterador_de_lista(estudantes)
local estudante = proximo_estudante()
while estudante do
  print(estudante)
  estudante = proximo_estudante()
end

-------------------------------------------------------
local nomes = { "ana", "bob", "charlie" }
for nome in iterador_de_lista(nomes) do print(nome) end

-------------------------------------------------------
-- Verificação: o iterador percorre em ordem e termina com nil
local letras = { "a", "b", "c" }
local proximaLetra = iterador_de_lista(letras)
assert(proximaLetra() == "a")
assert(proximaLetra() == "b")
assert(proximaLetra() == "c")
assert(proximaLetra() == nil)
