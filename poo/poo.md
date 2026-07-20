# Programação Orientada a Objetos em Lua

A Programação Orientada a Objetos (POO) é um paradigma de organização de código que utiliza objetos como unidades básicas. Cada objeto possui seus próprios dados e comportamentos, o que torna o código mais modular, reutilizável e fácil de manter.

O código apresentado ilustra os conceitos básicos da POO em Lua, utilizando tabelas e metatabelas. É importante ressaltar que este é um método manual e que existem bibliotecas e frameworks em Lua que oferecem funcionalidades mais avançadas para POO.

## Exemplo

**Boas Práticas Gerais**

- Utilizar PascalCase para classes.
- Utilizar camelCase para métodos e atributos.
- Atributos privados são nomeados com `_` como prefixo.
- Evitar acoplamento excessivo entre classes e métodos.

**Definindo uma Classe:**

- Uma classe é definida como uma tabela em Lua.

```lua
-- Definindo a classe
Pessoa = {}
Pessoa.__index = Pessoa
```

- O `__index` é definido junto da declaração da classe (e não dentro do
  construtor): assim a classe já está pronta para servir de base a
  subclasses antes mesmo de a primeira instância ser criada.

- Um método construtor cria instâncias da classe.

```lua
-- Método construtor
function Pessoa:novo(nome, idade)
  local pessoa = {
    _nome = nome or "indefinido",
    _idade = idade or 0,
  }
  return setmetatable(pessoa, self)
end
```

- Métodos de acesso permitem acessar atributos encapsulados.

```lua
-- Métodos de acesso da classe
function Pessoa:getNome()
  return self._nome
end

function Pessoa:setNome(nome)
  self._nome = nome
end

function Pessoa:getIdade()
  return self._idade
end

function Pessoa:setIdade(idade)
  self._idade = idade
end
```

- Outros métodos definem métodos específicos para a classe.

```lua
-- Outros métodos da classe
function Pessoa:apresentarNome()
  return string.format("Olá, meu nome é %s.", self:getNome())
end

function Pessoa:apresentarIdade()
  return string.format("Eu tenho %d anos.", self:getIdade())
end

function Pessoa:comer()
  return "Comendo uma bela refeição."
end
```

**Criando Objetos:**

- Objetos são criados chamando o método construtor da classe.

```lua
-- Criando objetos
local pessoa1 = Pessoa:novo("Ana", 21)
local pessoa2 = Pessoa:novo("Bob", 42)
```

- Objetos podem acessar métodos definidos na classe.

```lua
-- Chamando métodos
print(pessoa1:apresentarNome()) --> Olá, meu nome é Ana.
print(pessoa1:apresentarIdade()) --> Eu tenho 21 anos.
print(pessoa1:comer()) --> Comendo uma bela refeição.
```

- Métodos de acesso podem modificar atributos informados no método construtor.

```lua
-- Acessando e modificando atributos
pessoa1:setNome("Ana Clara")
print(pessoa1:getNome()) --> Ana Clara

pessoa2:setIdade(43)
print(pessoa2:getIdade()) --> 43
```

**Herança:**

- A herança permite que uma subclasse herde os atributos e métodos da classe base.

```lua
-- Definindo a subclasse Estudante
Estudante = {}
Estudante.__index = Estudante
setmetatable(Estudante, Pessoa) -- Herança: busca em Pessoa o que faltar

-- Método construtor da subclasse
function Estudante:novo(nome, idade, curso)
  local estudante = Pessoa:novo(nome, idade)
  estudante._curso = curso or "indefinido"
  return setmetatable(estudante, self)
end
```

- A herança funciona porque `Pessoa.__index = Pessoa` já foi definido na
  declaração da classe: quando um método não existe em `Estudante`, Lua
  consulta a metatabela (`Pessoa`) e segue pelo `__index` dela.

- Criando métodos específicos para a subclasse.

```lua
-- Métodos de acesso
function Estudante:getCurso()
  return self._curso
end

function Estudante:setCurso(curso)
  self._curso = curso
end

-- Outros métodos
function Estudante:estudar()
    return string.format("Estudando no curso de %s.", self:getCurso())
end
```

**Polimorfismo:**

- O polimorfismo permite que métodos com o mesmo nome sejam implementados de forma diferente em diferentes classes. Em Lua isso é feito por **sobrescrita** (override): a subclasse redefine o método herdado. Lua não tem sobrecarga (overloading) de métodos.

```lua
-- Sobrescrita do método comer
function Estudante:comer()
    return "Comendo um lanche na cantina."
end
```

**Criando Objetos da Subclasse:**

- Objetos da subclasse são criados chamando o método construtor da subclasse.

```lua
-- Criando objetos da subclasse
local estudante1 = Estudante:novo("Carlos", 22, "Engenharia")
local estudante2 = Estudante:novo("Davi", 37, "Geografia")
```

- Objetos da subclasse podem chamar métodos herdados, sobrescritos e específicos.

```lua
-- Chamando métodos herdados
print(estudante1:apresentarNome()) --> Olá, meu nome é Carlos.

-- Chamando métodos sobrescritos
print(estudante1:comer()) --> Comendo um lanche na cantina.

-- Chamando métodos específicos
print(estudante1:estudar()) --> Estudando no curso de Engenharia.
```

## Conceitos complementares

- Metatabelas: utilizadas para controlar o comportamento de uma tabela.

- Metamétodo `__index`: define o que acontece quando um índice não é encontrado em uma tabela.

- Argumentos Opcionais: definidos com valores padrão.

- Encapsulamento: embora não seja imposto em Lua, mas é uma boa prática usar a convenção do prefixo `_` para indicar propriedades privadas.

- Uso de `self`: utilizada para se referir à instância atual da classe.

- Herança Múltipla: é possível implementar herança múltipla em Lua.
