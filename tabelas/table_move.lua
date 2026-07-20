-- table_move.lua

-- Define as tabelas de origem e de destino:
local origem = { 1, 2, 3, 4 }
local destino = { "a", "b", "c", "d" }

-- Move os elementos da tabela de origem para a de destino:
table.move(origem, 1, #origem, 2, destino)

-- Imprime a tabela de destino com os elementos movidos:
print(table.concat(destino, ", ")) --> a, 1, 2, 3, 4
assert(table.concat(destino, ", ") == "a, 1, 2, 3, 4")

-- A origem permanece intacta:
assert(table.concat(origem, ", ") == "1, 2, 3, 4")
