-- data_e_hora.lua

-- Obtendo os timestamps de época (epoch):
local agora = os.time()
local hoje = os.time({ year = 2024, month = 05, day = 07, hour = 00 })
local amanha = os.time({ year = 2024, month = 05, day = 08, hour = 00 })
print(agora)  --> 1784549331 (varia: é o momento da execução)
-- os.time{...} interpreta a tabela como hora LOCAL, então o timestamp
-- varia com o fuso; os valores abaixo são os obtidos com TZ=UTC:
print(hoje)   --> 1715040000 (com TZ=UTC)
print(amanha) --> 1715126400 (com TZ=UTC)

-- Propriedades: época em segundos, com hoje < amanha:
assert(math.type(agora) == "integer")
assert(hoje < amanha)

-- Calcula a diferença entre dois timestamps:
local umDia = os.difftime(amanha, hoje)
print(umDia) --> 86400.0 (24*60*60 = 86400 segundos)
assert(umDia == 86400)

-- Formata um timestamp em uma string de data e hora:
-- %X é "a hora no formato do LOCALE do processo". O interpretador lua
-- inicia sempre no locale C, onde %X é hh:mm:ss — por isso os asserts
-- abaixo podem fixar o formato (em en_US, por exemplo, %X teria AM/PM).
local formatoDataEHora = "%d/%m/%Y %X"
print(os.date(formatoDataEHora, agora))         --> 20/07/2026 12:08:51 (varia)
print(os.date(formatoDataEHora, agora + umDia)) --> 21/07/2026 12:08:51 (varia)
print(os.date(formatoDataEHora, hoje))          --> 07/05/2024 00:00:00
print(os.date(formatoDataEHora, amanha))        --> 08/05/2024 00:00:00
assert(os.date(formatoDataEHora, hoje) == "07/05/2024 00:00:00")
assert(os.date(formatoDataEHora, amanha) == "08/05/2024 00:00:00")

-- Formata um timestamp em uma string de data personalizada:
-- %A (dia da semana) e %B (mês) também dependem do LOCALE — no locale C
-- os nomes saem em INGLÊS, e é isso que as saídas anotadas mostram.
-- os.setlocale("pt_BR.UTF-8", "time") traduziria os nomes, mas exigiria
-- esse locale instalado na máquina; o repositório não depende dele para
-- que os exemplos rodem iguais em qualquer ambiente (portabilidade/CI).
local dataPersonalizada = "%A, %d de %B de %Y"
print(os.date(dataPersonalizada, hoje))   --> Tuesday, 07 de May de 2024 (nomes em inglês: locale C)
print(os.date(dataPersonalizada, amanha)) --> Wednesday, 08 de May de 2024 (nomes em inglês: locale C)

-- Extraindo os componentes de data e hora:
local componentes = os.date("*t", agora)
print(componentes.year)  --> 2026 (varia)
print(componentes.month) --> 7 (varia)
print(componentes.day)   --> 20 (varia)
print(componentes.hour)  --> 12 (varia)
print(componentes.min)   --> 8 (varia)
print(componentes.sec)   --> 51 (varia)

-- Propriedades dos componentes (faixas válidas):
assert(componentes.year >= 2024)
assert(componentes.month >= 1 and componentes.month <= 12)
assert(componentes.day >= 1 and componentes.day <= 31)
assert(componentes.hour >= 0 and componentes.hour <= 23)
assert(componentes.min >= 0 and componentes.min <= 59)
assert(componentes.sec >= 0 and componentes.sec <= 61) -- 60/61: segundos bissextos
