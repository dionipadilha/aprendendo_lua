-- goto.lua

-- Lua NÃO tem a instrução `continue` de outras linguagens.
-- O idioma padrão para "pular para a próxima iteração" é usar `goto continue`
-- com o rótulo `::continue::` no fim do corpo do laço.

-- Soma apenas os números pares de 1 a 10, pulando os ímpares:
local somaDosPares = 0
for i = 1, 10 do
  if i % 2 ~= 0 then
    goto continue -- pula o restante do corpo, como um `continue`
  end
  somaDosPares = somaDosPares + i
  print("somando " .. i) --> somando 2, somando 4, ..., somando 10
  ::continue::
end

print(somaDosPares) --> 30
assert(somaDosPares == 30) -- 2 + 4 + 6 + 8 + 10

-- A restrição do goto que realmente morde: um goto NÃO pode saltar para
-- dentro do escopo de um local declarado no caminho — o salto pularia a
-- declaração e a variável ficaria sem inicializar. Rótulo no FIM do
-- bloco é a exceção permitida pela regra (rótulos são comandos vazios,
-- e o escopo de um local termina no último comando útil do bloco) — é
-- ela que garante que o idioma `goto continue` sempre compile:
local invalido = [[
  for i = 1, 3 do
    goto continue
    local x = i
    ::continue::
    print(x) -- o comando após o rótulo tira-o do fim do bloco...
  end
]]
local funcao, mensagem = load(invalido)
-- ...e o salto para dentro do escopo de x vira erro de COMPILAÇÃO:
assert(funcao == nil and mensagem:find("jumps into the scope"))

-- De volta ao fim do bloco, o rótulo convive com o mesmo local:
assert(load("for i = 1, 3 do goto continue local x = i ::continue:: end") ~= nil)

-- goto também permite construir um laço manualmente com um rótulo
-- (uso bem menos comum; prefira for/while/repeat):
local contagem = 0
::inicio::
contagem = contagem + 1
if contagem < 10 then
  goto inicio
end

print(contagem) --> 10
assert(contagem == 10)
