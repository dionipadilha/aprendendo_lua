-- prototipo.lua

-- Padrão Prototype (GoF): criar objetos novos CLONANDO um objeto
-- exemplar (o protótipo), em vez de instanciar a partir de uma classe.
--
-- Nota didática: este é o modelo NATURAL de Lua. A linguagem não tem
-- classes; a "herança" de poo/prototipo.lua já é uma cadeia de
-- protótipos via metatables (delegação com __index). Aquele arquivo
-- mostra a DELEGAÇÃO (o clone consulta o protótipo quando não tem o
-- campo); este mostra a CÓPIA (o clone nasce com os próprios campos e
-- fica independente do exemplar).

--------------------------------------------------------------------------------
-- O protótipo: um objeto exemplar, já configurado.

local Nave = {
  casco = 100,
  velocidade = 7,
  armas = { "laser" }
}

-- clonar: copia os campos (inclusive tabelas aninhadas, recursivamente)
-- para um objeto novo e independente.
-- Limitações (suficiente para este exemplo): não copia metatabelas e
-- entra em recursão infinita se houver ciclos (t.x = t).
local function clonar(original)
  local copia = {}
  for chave, valor in pairs(original) do
    if type(valor) == "table" then
      copia[chave] = clonar(valor) -- cópia profunda: sem tabelas compartilhadas
    else
      copia[chave] = valor
    end
  end
  return copia
end

--------------------------------------------------------------------------------
-- Uso: novos objetos nascem prontos, clonados do exemplar,
-- e cada clone pode ser ajustado sem afetar os demais.

local caca = clonar(Nave)
caca.velocidade = 9

local cargueiro = clonar(Nave)
cargueiro.casco = 250
table.insert(cargueiro.armas, "torreta")

-- cada clone partiu da mesma configuração...
assert(caca.casco == 100 and cargueiro.velocidade == 7)

-- ...mas os ajustes de um não vazam para o outro nem para o protótipo:
assert(caca.velocidade == 9 and Nave.velocidade == 7)
assert(cargueiro.casco == 250 and Nave.casco == 100)
assert(#cargueiro.armas == 2 and #Nave.armas == 1 and #caca.armas == 1,
  "a cópia profunda deve isolar as tabelas aninhadas")

print("Prototype: clones independentes criados a partir do exemplar.")
