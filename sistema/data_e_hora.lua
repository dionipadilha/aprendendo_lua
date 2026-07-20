-- data_e_hora.lua

-- Obtendo os timestamps de época (epoch):
local agora = os.time()
local hoje = os.time({ year = 2024, month = 05, day = 07, hour = 00 })
local amanha = os.time({ year = 2024, month = 05, day = 08, hour = 00 })
print(agora)  --> 1784549331
print(hoje)   --> 1715040000
print(amanha) --> 1715126400

-- Calcula a diferença entre dois timestamps:
local um_dia = os.difftime(amanha, hoje)
print(um_dia) --> 86400.0 (24*60*60 = 86400 segundos)

-- Formata um timestamp em uma string de data e hora:
local data_e_hora = "%d/%m/%Y %X"
print(os.date(data_e_hora, agora))          --> 20/07/2026 12:08:51
print(os.date(data_e_hora, agora + um_dia)) --> 21/07/2026 12:08:51
print(os.date(data_e_hora, hoje))           --> 07/05/2024 00:00:00
print(os.date(data_e_hora, amanha))         --> 08/05/2024 00:00:00

-- Formata um timestamp em uma string de data personalizada:
local data_personalizada = "%A, %d de %B de %Y"
print(os.date(data_personalizada, hoje))   --> Tuesday, 07 de May de 2024
print(os.date(data_personalizada, amanha)) --> Wednesday, 08 de May de 2024

-- Extraindo os componentes de data e hora:
local data_e_hora = os.date("*t", agora)
print(data_e_hora.year)  --> 2026
print(data_e_hora.month) --> 7
print(data_e_hora.day)   --> 20
print(data_e_hora.hour)  --> 12
print(data_e_hora.min)   --> 8
print(data_e_hora.sec)   --> 51
