-- comando.lua

-- Padrão Command (Comando): encapsular uma requisição como um OBJETO,
-- com tudo de que ela precisa para ser executada — e desfeita. Isso
-- permite enfileirar, registrar e reverter operações (undo).
--
-- Cenário: um editor de texto em que cada ação é um comando com
-- `executar` e `desfazer`, e o invocador guarda o histórico.

--------------------------------------------------------------------------------
-- O receptor: quem realmente faz o trabalho.

local documento = { texto = "" }

--------------------------------------------------------------------------------
-- Os comandos: cada um sabe executar E desfazer a própria ação.

local ComandoEscrever = {}
ComandoEscrever.__index = ComandoEscrever

function ComandoEscrever.novo(doc, trecho)
  return setmetatable({ documento = doc, trecho = trecho }, ComandoEscrever)
end

function ComandoEscrever:executar()
  self.documento.texto = self.documento.texto .. self.trecho
end

function ComandoEscrever:desfazer()
  self.documento.texto = self.documento.texto:sub(1, -#self.trecho - 1)
end

--------------------------------------------------------------------------------
-- O invocador: dispara comandos sem conhecer seus detalhes e mantém o
-- histórico para desfazer na ordem inversa.

local Editor = {}
Editor.__index = Editor

function Editor.novo()
  return setmetatable({ historico = {} }, Editor)
end

function Editor:executar(comando)
  comando:executar()
  table.insert(self.historico, comando)
end

function Editor:desfazerUltimo()
  local comando = table.remove(self.historico) -- o mais recente
  assert(comando, "não há nada para desfazer")
  comando:desfazer()
end

--------------------------------------------------------------------------------
-- Uso: ações viram objetos; o invocador executa e desfaz sem saber
-- o que cada comando faz por dentro.

local editor = Editor.novo()

editor:executar(ComandoEscrever.novo(documento, "Olá"))
editor:executar(ComandoEscrever.novo(documento, ", mundo!"))
assert(documento.texto == "Olá, mundo!")

editor:desfazerUltimo()
assert(documento.texto == "Olá", "desfazer deve reverter apenas o último comando")

editor:desfazerUltimo()
assert(documento.texto == "")

-- desfazer com o histórico vazio é um erro detectável:
local ok = pcall(function() editor:desfazerUltimo() end)
assert(not ok)

print("Command: ações encapsuladas, executadas e desfeitas pelo histórico.")
