# Padrões de projeto

Padrões clássicos (GoF e vizinhos) adaptados a Lua, com tabelas,
metatabelas e clausuras no lugar de classes e interfaces formais. Cada
arquivo é independente e termina em asserts que testam a propriedade
central do padrão. As subpastas `estrategia/`, `fachada/` e `mvc/` são
exemplos multiarquivo: execute o `principal.lua` de dentro da subpasta.

Criação:

| Arquivo | Tema |
|---------|------|
| `singleton.lua` | Uma única instância, guardada como upvalue |
| `fabrica.lua` | Factory Method: uma função criadora decide o tipo concreto pelo nome |
| `fabrica_abstrata.lua` | Fábrica Abstrata: famílias de componentes compatíveis |
| `construtor.lua` | Builder: montar um objeto complexo passo a passo, imutável após `montar()` |
| `prototipo.lua` | Prototype por CÓPIA (clonar um exemplar); a DELEGAÇÃO está em `../poo/prototipo.lua` |

Estrutura:

| Arquivo | Tema |
|---------|------|
| `adaptador.lua` | Adapter: converter uma interface existente para a que o cliente espera |
| `composto.lua` | Composite: folhas e agrupamentos tratados pela mesma interface, formando árvores |
| `decorador.lua` | Decorator: acrescentar comportamento sem modificar o existente (função e objeto) |
| `fachada/` | Facade: um home theater esconde a orquestração dos subsistemas atrás de duas operações |

Comportamento:

| Arquivo | Tema |
|---------|------|
| `observador.lua` | Observer: um sujeito notifica múltiplos observadores |
| `estrategia/` | Strategy: formas de pagamento intercambiáveis atrás de um mesmo contrato |
| `comando.lua` | Command: a requisição como objeto, com histórico e desfazer |
| `memento.lua` | Memento: um retrato opaco do estado para restaurar depois |
| `metodo_modelo.lua` | Template Method: o esqueleto do algoritmo na base, os passos nas subclasses |
| `maquina_de_estados.lua` | Máquina de estados: um semáforo com transições explícitas por estado |
| `maquina_de_estados_estendida.lua` | Máquina de estados com tabelas de transições e gatilhos separadas |
| `mvc/` | MVC: modelo, visão e controlador em módulos separados |
