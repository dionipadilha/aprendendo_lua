# Programação Orientadas a Objetos em Lua

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
```

- Um método construtor cria instâncias da classe.

```lua
-- Método construtor
function Pessoa:new(nome, idade)
   local pessoa = {
        _nome = nome or "indefinido",
        _idade = idade or 0,
    }
    setmetatable(pessoa, self)
    self.__index = self
    return pessoa
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

- Objetos são criados chamando o método construtor da classse.

```lua
-- Criando objetos
local pessoa1 = Pessoa:new("Ana", 21)
local pessoa2 = Pessoa:new("Bob", 42)
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
setmetatable(Estudante, Pessoa) -- Herança da classe Pessoa

-- Método construtor da subclasse
function Estudante:new(nome, idade, curso)
    local estudante = Pessoa:new(nome, idade)
    estudante._curso = curso or "indefinido"
    setmetatable(estudante, self)
    self.__index = self
    return estudante
end
```

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

- O polimorfismo permite que métodos com o mesmo nome sejam implementados de forma diferente em diferentes classes.

```lua
-- Sobrecarga do método apresentar
function Estudante:comer()
    return "Comendo um lanche na cantina."
end
```

**Criando Objetos da Subclasse:**

- Objetos da subclasse são criados chamando o método construtor da subclasse.

```lua
-- Criando objetos da subclasse
local estudante1 = Estudante:new("Carlos", 22, "Engenharia")
local estudante2 = Estudante:new("Davi", 37, "Geografia")
```

- Objetos da subclasse podem chamar métodos herdadados, sobrecarregados e específicos .

```lua
-- Chamando métodos herdadados
print(estudante1:apresentarNome()) --> Olá, meu nome é Carlos.

-- Chamando métodos sobrecarregados
print(estudante1:comer()) --> Comendo um lanche na cantina.

-- Chamando métodos específicos
print(estudante1:estudar()) --> Estudando no curso de Engenharia.
```

## Conceitos complementares

- Metatabelas: utilizadas para controlar o comportamento de uma tabela.

- Metamétodo `__index`: define o que acontece quando um índice não é encontrado em uma tabela.

- Argumentos Opcionais: definidos com valores padrão.

- Encapsulamento: embora não seja imposto em Lua, mas é uma boa prática usar a convensão do prefixo `_` para indicar propriedades privadas.

- Uso de `self`: utilizada para se referir à instância atual da classe.

- Herança Múltipla: é possível implementar herança múltipla em Lua.
