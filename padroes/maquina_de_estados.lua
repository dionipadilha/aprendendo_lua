-- maquina_de_estados.lua

------------------------------------------------------------------------
-- contexto da máquina de estados

local maquina_de_estados = {}

------------------------------------------------------------------------
-- configuração da máquina de estados:

maquina_de_estados.estados = { "amarelo", "vermelho", "verde" }

maquina_de_estados.transicoes = {
  amarelo  = { vermelho = "tempo_esgotado" },
  vermelho = { verde = "carro_passou" },
  verde    = { amarelo = "tempo_esgotado" }
}

maquina_de_estados.gatilhos = {
  tempo_esgotado = function()
    print("Tempo esgotado...")
    return true
  end,
  carro_passou = function()
    print("Carro passou...")
    return true
  end
}

------------------------------------------------------------------------
-- laço da máquina de estados:

function maquina_de_estados:atualizar(estado_atual)
  local transicoes_possiveis = self.transicoes[estado_atual]
  if transicoes_possiveis then
    for proximo_estado, gatilho in pairs(transicoes_possiveis) do
      print("Transição de", estado_atual, "para", proximo_estado)
      if self.gatilhos[gatilho]() then
        estado_atual = proximo_estado
        return
      end
    end
  else
    print("Nenhuma transição possível a partir do estado:", estado_atual)
  end
end

------------------------------------------------------------------------
-- principal da máquina de estados:

function maquina_de_estados:executar()
  for _, estado in ipairs(self.estados) do self:atualizar(estado) end
end

maquina_de_estados:executar()
------------------------------------------------------------------------
