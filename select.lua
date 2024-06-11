local list = { "a", "b", "c" }

-- returns all arguments after arg index:
print(select(1, table.unpack(list)))  --> a b c
print(select(2, table.unpack(list)))  --> b c
print(select(3, table.unpack(list)))  --> c
print(select(-1, table.unpack(list))) --> c

-- returns the total number of extra arguments it received:
print(select("#"))                     --> 0
print(select("#", list))               --> 1
print(select("#", table.unpack(list))) --> 3
print(#list)                           --> 3
