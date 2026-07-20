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
