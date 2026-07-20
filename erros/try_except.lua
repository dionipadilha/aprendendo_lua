-- try_except.lua

-- Lua não tem try/except/finally nativo, mas a abstração pode ser
-- construída sobre pcall:
--   * blocos.tentar     → o código protegido;
--   * blocos.capturar   → trata o erro, se houver;
--   * blocos.finalmente → SEMPRE executa (com ou sem erro) — ideal para limpeza.
--
-- Limitações desta abstração didática (um try/finally de verdade, como
-- o de Python, cobre esses casos):
--   * no sucesso, o segundo retorno é o 1º valor devolvido por tentar
--     (o pcall devolve os retornos do bloco), não um erro;
--   * capturar e finalmente NÃO são protegidos: um erro dentro deles
--     escapa — e, se capturar lançar, finalmente não chega a rodar.

local function tentar(blocos)
  local ok, erro = pcall(blocos.tentar)
  if not ok and blocos.capturar then blocos.capturar(erro) end
  if blocos.finalmente then blocos.finalmente() end
  return ok, erro
end

--------------------------------------------
-- Caso #1: sucesso — capturar NÃO roda; finalmente roda.

local registro = {}
local ok1 = tentar {
  tentar = function() registro[#registro + 1] = "tentou" end,
  capturar = function(_) registro[#registro + 1] = "capturou" end,
  finalmente = function() registro[#registro + 1] = "limpou" end,
}
assert(ok1)
assert(table.concat(registro, ",") == "tentou,limpou")

--------------------------------------------
-- Caso #2: falha — capturar recebe o erro; finalmente roda mesmo assim.

local capturado
registro = {}
local ok2 = tentar {
  tentar = function() error("recurso indisponível", 0) end,
  capturar = function(erro)
    capturado = erro
    registro[#registro + 1] = "capturou"
  end,
  finalmente = function() registro[#registro + 1] = "limpou" end,
}
assert(not ok2)
assert(capturado == "recurso indisponível")
assert(table.concat(registro, ",") == "capturou,limpou")

print("finalmente sempre executa: limpeza garantida com ou sem erro.")

--------------------------------------------
-- Veja também: pcall, xpcall, objetos_de_erro
