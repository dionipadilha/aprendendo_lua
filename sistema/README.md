# Sistema operacional

A biblioteca `os` conversa com o sistema: data e hora (`os.time`,
`os.date`), medição de tempo (`os.clock`, `os.difftime`), comandos
externos (`os.execute`) e o processo (`os.exit`, `os.getenv`). O fio
condutor da pasta é a diferença entre tempo de CPU e tempo de parede —
confundi-los é um erro clássico.

| Arquivo | Tema |
|---------|------|
| `data_e_hora.lua` | `os.time` e `os.date`: época (epoch), tabelas de data e formatação |
| `relogio.lua` | Relógio de parede: `os.time` e `os.difftime` entre dois instantes |
| `cronometro.lua` | Cronômetro de tempo de parede (resolução de 1 segundo) |
| `fonte_de_tempo.lua` | Interface FonteDeTempo com duas implementações intercambiáveis (relógio do sistema e sincronização NTP simulada) |
| `cpu_vs_parede.lua` | `os.clock` (CPU) vs `os.time` (parede): quando usar cada um |
| `espera.lua` | Espera OCUPADA (busy-wait): prende a CPU em um laço, medido com `os.clock` |
| `dormir.lua` | Espera OCIOSA portátil: delega ao sistema (`sleep` no POSIX, ping no Windows) |
| `tempo_limite.lua` | `definirTempoLimite` (setTimeout) com corrotinas |
| `aleatorios.lua` | `math.randomseed` e `math.random`: semeadura e propriedades verificáveis |
| `linha_de_comando.lua` | Lua como linguagem de scripts: tabela `arg`, `os.exit`, `os.getenv` e os três canais padrão |

Os exemplos de tempo e aleatoriedade verificam PROPRIEDADES (tipo,
faixa, monotonicidade) em vez de valores exatos, para rodarem de forma
estável na suíte de testes.
