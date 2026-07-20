-- biblioteca_de_tabelas.lua

-- PAPEL deste arquivo: tour da biblioteca padrão `table` — pack/unpack,
-- insert, remove, move, sort e concat, cada função em ação uma vez.
-- Para as operações básicas de array (acesso, percurso, matrizes), veja
-- vetores.lua; para a lista como TAD com operações nomeadas, lista.lua.

-- Criando listas:
local meusAmigos = { "ana", "bob", "charlie" }
print(meusAmigos) --> table: endereco_de_memoria

-- table.pack e table.unpack:
local meusTios = table.pack("clark", "lois")
print(table.unpack(meusTios)) --> clark	lois
assert(meusTios.n == 2 and meusTios[1] == "clark" and meusTios[2] == "lois")

-- Construindo uma lista com base em transformações:
local quadradosBasicos = {}
for n = 1, 3 do table.insert(quadradosBasicos, n ^ 2) end
print(table.unpack(quadradosBasicos)) --> 1.0	4.0	9.0
assert(quadradosBasicos[1] == 1.0 and quadradosBasicos[2] == 4.0 and quadradosBasicos[3] == 9.0)
assert(math.type(quadradosBasicos[1]) == "float") -- `^` sempre produz float

-- A indexação começa em 1:
print(meusAmigos[1]) --> ana
assert(meusAmigos[1] == "ana")

-- Modificando elementos em posições específicas:
meusAmigos[2] = "robert"
print(table.unpack(meusAmigos)) --> ana	robert	charlie
assert(table.concat(meusAmigos, " ") == "ana robert charlie")

-- Adicionando elementos à lista:
table.insert(meusAmigos, "david")
table.insert(meusAmigos, 2, "eduard")
print(table.unpack(meusAmigos)) --> ana	eduard	robert	charlie	david
assert(table.concat(meusAmigos, " ") == "ana eduard robert charlie david")

-- Removendo elementos de uma lista:
table.remove(meusAmigos)
table.remove(meusAmigos, 1)
print(table.unpack(meusAmigos)) --> eduard	robert	charlie
assert(table.concat(meusAmigos, " ") == "eduard robert charlie")

-- Combinando várias listas em uma:
table.move(meusTios, 1, #meusTios, #meusAmigos + 1, meusAmigos)
print(table.unpack(meusAmigos)) --> eduard	robert	charlie	clark	lois
assert(table.concat(meusAmigos, " ") == "eduard robert charlie clark lois")

-- Ordena os elementos da lista:
table.sort(meusAmigos)
print(table.unpack(meusAmigos)) --> charlie	clark	eduard	lois	robert
assert(table.concat(meusAmigos, " ") == "charlie clark eduard lois robert")

-- Ordena os elementos pelo tamanho:
-- (para tamanhos iguais, a ordem relativa não é garantida — sort não é estável)
local porTamanho = function(a, b) return #a < #b end
table.sort(meusAmigos, porTamanho)
print(table.unpack(meusAmigos)) --> lois	clark	robert	eduard	charlie
assert(#meusAmigos[1] == 4 and #meusAmigos[2] == 5 and #meusAmigos[5] == 7)
assert(meusAmigos[1] == "lois" and meusAmigos[5] == "charlie")

-- Aplicando uma função a cada elemento de uma lista:
for i, numero in ipairs(quadradosBasicos) do
  print(numero + i) --> 2.0, 6.0, 12.0
end

-- Selecionar elementos por critério NÃO faz parte da API table —
-- para um filtro genérico com validação e testes, veja selecionar_onde.lua.

-- Concatena todos os elementos em uma string:
print(table.concat(meusAmigos, "&")) --> lois&clark&robert&eduard&charlie
assert(table.concat(meusAmigos, "&") == "lois&clark&robert&eduard&charlie")

-- CUIDADO: `t = {}` NÃO "exclui os elementos" — cria uma tabela NOVA e
-- faz a variável apontar para ela; a antiga continua viva para quem
-- guardar outra referência (atribuição cria apelido, não cópia — veja
-- referencias_e_copias.lua):
local apelido = meusAmigos
meusAmigos = {}
assert(#meusAmigos == 0) -- a variável enxerga a tabela nova, vazia...
assert(#apelido == 5)    -- ...mas a antiga segue intacta pelo apelido

-- Para ESVAZIAR a tabela preservando a identidade, remova cada chave:
for k in pairs(apelido) do apelido[k] = nil end
assert(next(apelido) == nil)

-- `t = nil` tampouco "exclui a tabela": apenas remove UMA referência.
-- Quando não restar nenhuma, o coletor de lixo a recolhe sozinho —
-- chamar collectgarbage() manualmente é desnecessário em código normal
-- (veja o diretório gc/):
meusAmigos = nil
apelido = nil
