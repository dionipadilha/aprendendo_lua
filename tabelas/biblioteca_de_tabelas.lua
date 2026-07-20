-- biblioteca_de_tabelas.lua

-- Criando listas:
local meusAmigos = { "ana", "bob", "charlie" }
print(meusAmigos) --> table: endereco_de_memoria

-- table.pack e table.unpack:
local meusTios = table.pack("clark", "lois")
print(table.unpack(meusTios)) --> clark lois

-- Construindo uma lista com base em transformações:
local quadradosBasicos = {}
for n = 1, 3 do table.insert(quadradosBasicos, n ^ 2) end
print(table.unpack(quadradosBasicos)) --> 1.0 4.0 9.0

-- A indexação começa em 1:
print(meusAmigos[1]) --> ana

-- Modificando elementos em posições específicas:
meusAmigos[2] = "robert"
print(table.unpack(meusAmigos)) --> ana robert charlie

-- Adicionando elementos à lista:
table.insert(meusAmigos, "david")
table.insert(meusAmigos, 2, "eduard")
print(table.unpack(meusAmigos)) --> ana, eduard, robert, charlie, david

-- Removendo elementos de uma lista:
table.remove(meusAmigos)
table.remove(meusAmigos, 1)
print(table.unpack(meusAmigos)) --> eduard, robert, charlie

-- Combinando várias listas em uma:
table.move(meusTios, 1, #meusTios, #meusAmigos + 1, meusAmigos)
print(table.unpack(meusAmigos)) --> eduard robert charlie clark lois

-- Ordena os elementos da lista:
table.sort(meusAmigos)
print(table.unpack(meusAmigos)) --> charlie clark eduard lois robert

-- Ordena os elementos pelo tamanho:
local porTamanho = function(a, b) return #a < #b end
table.sort(meusAmigos, porTamanho)
print(table.unpack(meusAmigos)) --> lois clark robert eduard charlie

-- Aplicando uma função a cada elemento de uma lista:
for i, numero in ipairs(quadradosBasicos) do
    print(numero + i) --> 2.0, 6.0, 12.0
end

-- Selecionando elementos com base em certos critérios:
local function comecaCom_c(texto)
    return texto:sub(1, 1) == "c"
end

local function selecionarPor(lista, criterio)
    local selecionados = {}
    for _, item in ipairs(lista) do
        if criterio(item) then table.insert(selecionados, item) end
    end
    return selecionados
end

local meusMelhoresAmigos = selecionarPor(meusAmigos, comecaCom_c)
print(table.unpack(meusMelhoresAmigos)) --> clark charlie

-- Concatena todos os elementos em uma string:
print(table.concat(meusMelhoresAmigos, "&")) --> clark&charlie

-- Exclui todos os elementos de uma tabela:
meusMelhoresAmigos = {}
print(#meusMelhoresAmigos) --> 0

-- Exclui uma tabela:
meusMelhoresAmigos = nil
collectgarbage()
