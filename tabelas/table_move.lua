-- table_move.lua

-- Define as tabelas de origem e de destino:
local origem = { 1, 2, 3, 4 }
local destino = { "a", "b", "c", "d" }

-- Move os elementos da tabela de origem para a de destino:
table.move(origem, 1, #origem, 2, destino)

-- Imprime a tabela de destino com os elementos movidos:
print(table.concat(destino, ", ")) --> a, 1, 2, 3, 4
assert(table.concat(destino, ", ") == "a, 1, 2, 3, 4")

-- Apesar do nome, "move" na verdade COPIA — a origem permanece intacta:
assert(table.concat(origem, ", ") == "1, 2, 3, 4")

-- table.move devolve a tabela de DESTINO, o que permite criar e povoar
-- a cópia numa expressão só:
local copia = table.move(origem, 1, #origem, 1, {})
assert(table.concat(copia, ", ") == "1, 2, 3, 4")
assert(copia ~= origem) -- tabela nova, não outra referência à origem

-------------------------------------------------------------------
-- Sobreposição dentro da MESMA tabela é segura: o manual garante o
-- resultado "como se" os elementos fossem copiados para fora e de
-- volta — é assim que se abre ou se fecha espaço sem laço manual.

-- ABRIR espaço: desloca t[2..#t] uma posição à direita e libera o
-- índice 2 para um elemento novo:
local t = { "a", "b", "c", "d" }
table.move(t, 2, #t, 3)
t[2] = "novo"
assert(table.concat(t, ", ") == "a, novo, b, c, d")

-- FECHAR espaço: desloca t[3..#t] uma posição à esquerda, apagando
-- t[2]; como move copia, o último índice fica duplicado — limpe-o:
table.move(t, 3, #t, 2)
t[#t] = nil
assert(table.concat(t, ", ") == "a, b, c, d")
