# Equipe: agentes com ferramentas

Exemplo de estruturação de um programa em módulos, inspirado em arcabouços
de agentes: agentes com papel, objetivo e história usam ferramentas para
executar tarefas, e um registrador anota as ações.

| Arquivo | Papel |
|---------|-------|
| `classe.lua` | Classe base minimalista (construtor com metatabela) |
| `ferramenta.lua` | Contrato de uma ferramenta: nome, descrição e `executar` |
| `ferramentas_basicas.lua` | Ferramentas prontas: somador, subtrator, multiplicador e divisor |
| `agente.lua` | O agente: só executa ferramentas que possui |
| `registrador.lua` | Registro de mensagens, com lista por instância |
| `principal.lua` | Junta tudo: cria uma ferramenta própria, monta os agentes e registra as ações |

Execute a partir deste diretório (os `require` são relativos a ele):

```sh
lua5.4 principal.lua
```
