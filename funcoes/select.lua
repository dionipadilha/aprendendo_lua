local lista = { "a", "b", "c" }

-- retorna todos os argumentos após o índice informado:
print(select(1, table.unpack(lista)))  --> a b c
print(select(2, table.unpack(lista)))  --> b c
print(select(3, table.unpack(lista)))  --> c
print(select(-1, table.unpack(lista))) --> c

-- retorna o número total de argumentos extras que recebeu:
print(select("#"))                      --> 0
print(select("#", lista))               --> 1
print(select("#", table.unpack(lista))) --> 3
print(#lista)                           --> 3
