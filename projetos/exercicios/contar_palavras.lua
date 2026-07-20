-- contar_palavras.lua

-- Exercício 3 de documentacao/comece_aqui.md: quantas palavras há numa
-- frase separada por espaços. Tente resolver sozinho antes de ler!

local function contarPalavras(frase)
  assert(type(frase) == "string", "a entrada deve ser uma string")
  local quantidade = 0
  -- %S+ casa sequências de caracteres que NÃO são espaço:
  for _ in frase:gmatch("%S+") do
    quantidade = quantidade + 1
  end
  return quantidade
end

-- Verificação:
assert(contarPalavras("aprendendo lua com exercicios") == 4)
assert(contarPalavras("uma") == 1)
assert(contarPalavras("") == 0)
assert(contarPalavras("   espacos   extras   ") == 2) -- espaços repetidos não criam palavras

print("contar palavras: solução verificada!")
