-- maquina_de_estados_estendida.lua

------------------------------------------------------------------------
-- Contexto da Máquina de Estados

local maquina_de_estados = {}

------------------------------------------------------------------------
-- Configuração da Máquina de Estados

maquina_de_estados.estados = { "amarelo", "vermelho", "verde" }

maquina_de_estados.transicoes = {
  amarelo  = { vermelho = "tempo_esgotado" },
  vermelho = { verde = "carro_passou" },
  verde    = { amarelo = "tempo_esgotado" }
}

maquina_de_estados.gatilhos = {
  tempo_esgotado = function(parametros)
    print("Tempo esgotado...")
    return true
  end,
  carro_passou = function(parametros)
    print("Carro passou...")
    return true
  end
}

------------------------------------------------------------------------
-- Laço da Máquina de Estados

function maquina_de_estados:atualizar(estado_atual, parametros)
  local transicoes_possiveis = self.transicoes[estado_atual]
  if transicoes_possiveis then
    for proximo_estado, gatilho in pairs(transicoes_possiveis) do
      print("Transição de", estado_atual, "para", proximo_estado)
      if self.gatilhos[gatilho](parametros) then
        estado_atual = proximo_estado
        -- Execute as ações de saída do estado aqui
        return estado_atual
      end
    end
  else
    print("Nenhuma transição possível a partir do estado:", estado_atual)
  end
  return estado_atual
end

------------------------------------------------------------------------
-- Principal da Máquina de Estados

function maquina_de_estados:executar()
  local estado_atual = self.estados[1] -- Estado inicial
  local parametros = {}                -- Parâmetros para as funções de gatilho
  for _, estado in ipairs(self.estados) do
    estado_atual = self:atualizar(estado_atual, parametros)
  end
end

------------------------------------------------------------------------
-- Sugestões Adicionais Aplicadas:

-- Tratamento de Erros
function maquina_de_estados:validar()
  for estado, transicoes in pairs(self.transicoes) do
    for proximo_estado, gatilho in pairs(transicoes) do
      if not self.gatilhos[gatilho] then
        error("Gatilho inválido para a transição de " .. estado .. " para " .. proximo_estado)
      end
    end
  end
end

-- Ações de Entrada e Saída de Estado
function maquina_de_estados:ao_entrar_no_estado(estado)
  print("Entrando no estado:", estado)
  -- Adicione as ações de entrada aqui
end

function maquina_de_estados:ao_sair_do_estado(estado)
  print("Saindo do estado:", estado)
  -- Adicione as ações de saída aqui
end

-- Estados Hierárquicos
-- Implemente conforme necessário

-- Histórico de Estados
function maquina_de_estados:atualizar_historico_de_estados(estado_atual, historico)
  table.insert(historico, estado_atual)
end

function maquina_de_estados:executar_com_historico()
  local estado_atual = self.estados[1] -- Estado inicial
  local parametros = {}                -- Parâmetros para as funções de gatilho
  local historico = {}                 -- Rastreia o histórico de estados
  for _, estado in ipairs(self.estados) do
    self:ao_entrar_no_estado(estado)
    estado_atual = self:atualizar(estado_atual, parametros)
    self:ao_sair_do_estado(estado)
    self:atualizar_historico_de_estados(estado_atual, historico)
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
maquina_de_estados:validar()

-- Executa a máquina de estados
maquina_de_estados:executar()

-- Executa a máquina de estados com rastreamento de histórico
local historico = maquina_de_estados:executar_com_historico()
print("Histórico de estados:", table.concat(historico, " -> "))
