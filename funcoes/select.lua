local lista = { "a", "b", "c" }

-- retorna todos os argumentos a partir do índice informado, inclusive:
print(select(1, table.unpack(lista)))  --> a	b	c
print(select(2, table.unpack(lista)))  --> b	c
print(select(3, table.unpack(lista)))  --> c
print(select(-1, table.unpack(lista))) --> c
assert(select(1, table.unpack(lista)) == "a")  -- primeiro valor retornado
assert(select(2, table.unpack(lista)) == "b")
assert(select(3, table.unpack(lista)) == "c")
assert(select(-1, table.unpack(lista)) == "c")

-- retorna o número total de argumentos extras que recebeu:
print(select("#"))                      --> 0
print(select("#", lista))               --> 1
print(select("#", table.unpack(lista))) --> 3
print(#lista)                           --> 3
assert(select("#") == 0)
assert(select("#", lista) == 1)
assert(select("#", table.unpack(lista)) == 3)
assert(#lista == 3)
