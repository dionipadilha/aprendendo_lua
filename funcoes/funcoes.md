# Conceitos de funções

**Funções:**

- **Definição:** Blocos de código que executam tarefas específicas e podem ser reutilizados.
- **Declaração:** `local function nome_da_funcao(parametros) ... end`
- **Chamada:** `nome_da_funcao(argumentos)`

**Múltiplos Valores de Retorno:**

- Funções podem retornar múltiplos valores, separados por vírgulas.
- Exemplo: `soma, produto = somaProduto(2, 3)`

**Argumentos Opcionais:**

- Argumentos que podem ser omitidos ao chamar uma função (chegam como `nil`).
- Lua **não tem** sintaxe de valor padrão na declaração; o idioma é atribuir dentro da função: `saudacao = saudacao or "Olá"` (veja `funcoes.lua`).
- Exemplo: `saudar("Bob", "Oi")` ou `saudar("Bob")`

**Argumentos Nomeados:**

- Argumentos passados como uma tabela com chaves correspondentes aos nomes dos parâmetros.
- A ordem não importa.
- Exemplo: `saudar{nome = "Bob", saudacao = "Oi"}`

**Número Variável de Argumentos:**

- Funções podem aceitar qualquer número de argumentos usando `...`.
- Exemplo: `saudar("Ana", "Bob", "Carlos")`

**Funções Anônimas:**

- Funções definidas sem nome, frequentemente usadas como callbacks ou para uso temporário.
- Exemplo: `local saudar = function(nome) ... end`

**Funções de Primeira Classe:**

- Funções podem ser tratadas como qualquer outro valor (atribuídas a variáveis, passadas como argumentos, retornadas por outras funções).
- Exemplo: `local saudarAna = saudar("Ana")`

**Funções de Ordem Superior:**

- Funções que recebem outras funções como argumentos ou retornam funções.
- Exemplo: `saudar("Bob", print)`

**Clausuras (Closures):**

- Funções que "lembram" o ambiente ao seu redor, mesmo quando executadas em outro lugar.
- Exemplo: `local contar = contador()`

**Recursão:**

- Funções que chamam a si mesmas para resolver problemas, geralmente em tarefas que envolvem repetição ou a divisão de um problema em partes menores.
- Exemplo: `fatorial(5)`

**Recursão de Cauda:**

- Uma forma especial de recursão em que a chamada recursiva é a última operação da função. Lua **garante** a eliminação de chamadas de cauda: a pilha não cresce, permitindo recursão ilimitada (veja `multiplos_retornos.lua`).
- Exemplo: `fatorial(5, 1)`

**Memoização:**

- Armazenar em cache os resultados de chamadas de função para evitar cálculos redundantes para as mesmas entradas.
- Exemplo: `memo = {}`

**Currying:**

- Transformar uma função que recebe múltiplos argumentos em uma sequência de funções, cada uma recebendo um único argumento.
- Exemplo: `somar2 = somar(2)`

**Aplicação Parcial:**

- Criar uma nova função preenchendo previamente alguns dos argumentos de uma função existente.
- Exemplo: `somar2 = function(y) return somar(2, y) end`

**Composição:**

- Combinar múltiplas funções em uma nova função, em que a saída de uma função se torna a entrada da próxima.
- Exemplo: `somar2DepoisMult3 = compor(mult3, somar2)`

**Pipe:**

- Uma forma de encadear múltiplas funções, passando a saída de uma função como entrada da próxima.
- Exemplo: `somar2DepoisMult3 = pipe(somar2, mult3)`

**Tratamento de Erros:**

- Usar `pcall` para proteger o código contra erros e tratá-los de forma adequada.
- Exemplo: `status, resultado = pcall(function() error("Algum erro") end)`
