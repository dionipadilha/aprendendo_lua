-- memento.lua

-- Padrão Memento: capturar o estado de um objeto em uma "lembrança"
-- opaca, para restaurá-lo depois — a base de desfazer/refazer.
-- (comando.lua desfaz RECOMPUTANDO a operação inversa; o memento
-- desfaz GUARDANDO o estado anterior. Os dois se complementam.)

--------------------------------------------------------------------------------
-- O originador: um editor de texto minúsculo.

local Editor = {}
Editor.__index = Editor

function Editor.novo()
  return setmetatable({ texto = "" }, Editor)
end

function Editor:digitar(pedaco)
  self.texto = self.texto .. pedaco
end

-- cria o memento: uma CÓPIA do estado, não uma referência viva.
function Editor:salvar()
  return { texto = self.texto }
end

function Editor:restaurar(memento)
  self.texto = memento.texto
end

--------------------------------------------------------------------------------
-- O zelador (caretaker): guarda mementos sem olhar dentro deles.

local Historico = {}
Historico.__index = Historico

function Historico.novo()
  return setmetatable({ pilha = {} }, Historico)
end

function Historico:guardar(memento)
  table.insert(self.pilha, memento)
end

function Historico:desfazer()
  return table.remove(self.pilha) -- o memento mais recente
end

--------------------------------------------------------------------------------

local editor = Editor.novo()
local historico = Historico.novo()

historico:guardar(editor:salvar()) -- retrato: ""
editor:digitar("Olá")
historico:guardar(editor:salvar()) -- retrato: "Olá"
editor:digitar(", mundo!")
assert(editor.texto == "Olá, mundo!")

-- desfazer volta estado a estado, na ordem inversa:
editor:restaurar(historico:desfazer())
assert(editor.texto == "Olá")
editor:restaurar(historico:desfazer())
assert(editor.texto == "")

-- o memento é um retrato do passado, não uma referência viva:
local retrato = editor:salvar()
editor:digitar("depois do retrato")
assert(retrato.texto == "")

print("Memento: estados salvos e restaurados na ordem inversa.")
