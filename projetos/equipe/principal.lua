-- principal.lua

--------------------------------------------------------------------------------
-- nº 1: Criar ferramentas
-- As ferramentas de uso comum já vêm prontas em ferramentas_basicas.lua;
-- aqui criamos apenas uma ferramenta nova, específica deste programa.

local Ferramenta = require "ferramenta"
local basicas = require "ferramentas_basicas"

local somador = basicas.somador
local subtrator = basicas.subtrator
local multiplicador = basicas.multiplicador
local divisor = basicas.divisor

local potencia = Ferramenta:novo {
  nome = "potencia",
  descricao = "eleva o primeiro número ao segundo",
  executar = function(self, base, expoente)
    assert(type(base) == "number", "As entradas devem ser números.")
    assert(type(expoente) == "number", "As entradas devem ser números.")
    return base ^ expoente
  end
}
assert(potencia:executar(2, 3) == 8.0) -- ^ devolve sempre float

--------------------------------------------------------------------------------
-- nº 2: Criar Agentes

local Agente = require "agente"

local Ana = Agente:novo {
  papel = "Exploradora Generalista",
  objetivo = "Descobrir novas fórmulas matemáticas",
  historia = [[Outrora matemática em uma universidade renomada,
  Ana agora explora territórios inexplorados de números e equações.]],
  ferramentas = { somador, multiplicador, potencia }
}
assert(Ana.papel == "Exploradora Generalista")

local Bob = Agente:novo {
  papel = "Explorador Especialista em Subtração",
  objetivo = "Manipular números negativos",
  historia = [[Outrora matemático em uma universidade renomada,
  Bob agora explora territórios inexplorados de números negativos.]],
  ferramentas = { subtrator, divisor }
}
assert(Bob.papel == "Explorador Especialista em Subtração")

--------------------------------------------------------------------------------
-- nº 3: Agentes usando Ferramentas

local Aplicativo = {
  tentar = function()
    assert(Ana:usar(somador, 2, 3) == 5)
    assert(Ana:usar(multiplicador, 2, 3) == 6)
    assert(Ana:usar(potencia, 2, 3) == 8.0)
    assert(Bob:usar(subtrator, 2, 3) == -1)
    assert(Bob:usar(divisor, 6, 3) == 2.0) -- / devolve sempre float
  end,

  capturar = function(excecao)
    print("Erro: " .. excecao)
  end
}

local finalmente = xpcall(Aplicativo.tentar, Aplicativo.capturar)
print(finalmente and "Todas as ações foram executadas com sucesso!")

-- assert de topo: o xpcall acima não afeta o código de saída, então
-- garantimos aqui que nenhuma ação falhou.
assert(finalmente, "alguma ação dos agentes falhou")

-- um agente não pode usar uma ferramenta que não possui:
assert(Bob:usar(somador, 2, 3) == nil)

--------------------------------------------------------------------------------
-- nº 4: Registrar as ações da equipe

local Registrador = require "registrador"

local diario = Registrador:novo {}
diario:registrar(("%s calculou %s"):format(Ana.papel, Ana:usar(somador, 2, 3)))
diario:registrar(("%s calculou %s"):format(Bob.papel, Bob:usar(subtrator, 2, 3)))

assert(#diario.registros == 2)
diario:imprimirRegistros()
--> Exploradora Generalista calculou 5
--> Explorador Especialista em Subtração calculou -1
