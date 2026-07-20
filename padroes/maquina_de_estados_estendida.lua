-- maquina_de_estados_estendida.lua

------------------------------------------------------------------------
-- Contexto da Máquina de Estados

local maquinaDeEstados = {}

------------------------------------------------------------------------
-- Configuração da Máquina de Estados

maquinaDeEstados.estados = { "amarelo", "vermelho", "verde" }

maquinaDeEstados.transicoes = {
  amarelo  = { vermelho = "tempoEsgotado" },
  vermelho = { verde = "carroPassou" },
  verde    = { amarelo = "tempoEsgotado" }
}

maquinaDeEstados.gatilhos = {
  tempoEsgotado = function(parametros)
    print("Tempo esgotado...")
    return true
  end,
  carroPassou = function(parametros)
    print("Carro passou...")
    return true
  end
}

------------------------------------------------------------------------
-- Laço da Máquina de Estados

function maquinaDeEstados:atualizar(estadoAtual, parametros)
  local transicoesPossiveis = self.transicoes[estadoAtual]
  if transicoesPossiveis then
    for proximoEstado, gatilho in pairs(transicoesPossiveis) do
      -- Só anuncia e executa os ganchos DEPOIS que o gatilho autoriza
      -- a transição; os ganchos recebem os estados reais envolvidos.
      if self.gatilhos[gatilho](parametros) then
        print("Transição de", estadoAtual, "para", proximoEstado)
        self:aoSairDoEstado(estadoAtual)
        self:aoEntrarNoEstado(proximoEstado)
        return proximoEstado
      end
    end
  else
    print("Nenhuma transição possível a partir do estado:", estadoAtual)
  end
  return estadoAtual
end

------------------------------------------------------------------------
-- Principal da Máquina de Estados

function maquinaDeEstados:executar()
  local estadoAtual = self.estados[1] -- Estado inicial
  local parametros = {}               -- Parâmetros para as funções de gatilho
  for _ = 1, #self.estados do         -- Um passo por estado configurado
    estadoAtual = self:atualizar(estadoAtual, parametros)
  end
  return estadoAtual
end

------------------------------------------------------------------------
-- Sugestões Adicionais Aplicadas:

-- Tratamento de Erros
function maquinaDeEstados:validar()
  for estado, transicoes in pairs(self.transicoes) do
    for proximoEstado, gatilho in pairs(transicoes) do
      if not self.gatilhos[gatilho] then
        error("Gatilho inválido para a transição de " .. estado .. " para " .. proximoEstado)
      end
    end
  end
  return true
end

-- Ações de Entrada e Saída de Estado
function maquinaDeEstados:aoEntrarNoEstado(estado)
  print("Entrando no estado:", estado)
  -- Adicione as ações de entrada aqui
end

function maquinaDeEstados:aoSairDoEstado(estado)
  print("Saindo do estado:", estado)
  -- Adicione as ações de saída aqui
end

-- Estados Hierárquicos
-- Implemente conforme necessário

-- Histórico de Estados
function maquinaDeEstados:atualizarHistoricoDeEstados(estadoAtual, historico)
  table.insert(historico, estadoAtual)
end

function maquinaDeEstados:executarComHistorico()
  local estadoAtual = self.estados[1] -- Estado inicial
  local parametros = {}               -- Parâmetros para as funções de gatilho
  local historico = {}                -- Rastreia o histórico de estados
  for _ = 1, #self.estados do         -- Um passo por estado configurado
    estadoAtual = self:atualizar(estadoAtual, parametros)
    self:atualizarHistoricoDeEstados(estadoAtual, historico)
  end
  return historico
end

-- Transições Assíncronas
-- Implemente conforme necessário

-- Configuração Externa
-- Implemente o carregamento da configuração da máquina de estados de uma fonte externa

-- Visualização
-- Crie uma representação visual da máquina de estados

-- Testes Unitários
-- Escreva testes unitários para a funcionalidade da máquina de estados

-- Documentação
-- Documente funções, parâmetros e uso

------------------------------------------------------------------------

-- Valida a configuração da máquina de estados
assert(maquinaDeEstados:validar())

-- Executa a máquina de estados: amarelo -> vermelho -> verde -> amarelo
assert(maquinaDeEstados:executar() == "amarelo")

-- Executa a máquina de estados com rastreamento de histórico
local historico = maquinaDeEstados:executarComHistorico()
assert(table.concat(historico, " -> ") == "vermelho -> verde -> amarelo")
print("Histórico de estados:", table.concat(historico, " -> "))
