-- maquina_de_estados.lua

-- Um semáforo como máquina de estados: cada estado conhece suas
-- transições e o gatilho que as autoriza.

------------------------------------------------------------------------
-- contexto da máquina de estados

local maquinaDeEstados = {}

------------------------------------------------------------------------
-- configuração da máquina de estados:

maquinaDeEstados.estadoInicial = "verde"

maquinaDeEstados.transicoes = {
  amarelo  = { vermelho = "tempoEsgotado" },
  vermelho = { verde = "carroPassou" },
  verde    = { amarelo = "tempoEsgotado" }
}

maquinaDeEstados.gatilhos = {
  tempoEsgotado = function()
    print("Tempo esgotado...")
    return true
  end,
  carroPassou = function()
    print("Carro passou...")
    return true
  end
}

------------------------------------------------------------------------
-- laço da máquina de estados:

-- Devolve o próximo estado (ou nil se não houver transição possível).
-- Numa versão anterior, o novo estado era atribuído a uma variável
-- local e descartado com um `return` nu — a máquina nunca saía do lugar.
function maquinaDeEstados:atualizar(estadoAtual)
  local transicoesPossiveis = self.transicoes[estadoAtual]
  if not transicoesPossiveis then
    print("Nenhuma transição possível a partir do estado:", estadoAtual)
    return nil
  end
  for proximoEstado, gatilho in pairs(transicoesPossiveis) do
    print("Transição de", estadoAtual, "para", proximoEstado)
    if self.gatilhos[gatilho]() then
      return proximoEstado
    end
  end
  return nil
end

------------------------------------------------------------------------
-- principal da máquina de estados:

-- Segue as transições DE FATO, a partir do estado inicial, por até
-- `passos` atualizações (o semáforo é cíclico, então limitamos o número
-- de passos). Devolve o caminho percorrido.
function maquinaDeEstados:executar(estadoInicial, passos)
  local estadoAtual = estadoInicial or self.estadoInicial
  local caminho = { estadoAtual }
  for _ = 1, passos do
    local proximoEstado = self:atualizar(estadoAtual)
    if not proximoEstado then break end
    estadoAtual = proximoEstado
    table.insert(caminho, estadoAtual)
  end
  return caminho
end

local caminho = maquinaDeEstados:executar("verde", 3)

-- a máquina percorreu o ciclo completo do semáforo:
assert(table.concat(caminho, " -> ") == "verde -> amarelo -> vermelho -> verde")
print("Caminho percorrido:", table.concat(caminho, " -> "))

-- estados desconhecidos não têm transição e encerram a execução:
assert(#maquinaDeEstados:executar("piscando", 3) == 1)
------------------------------------------------------------------------
