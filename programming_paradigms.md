### Study Guide on Programming Paradigms with Lua Examples

#### Objective
This study guide aims to provide a comprehensive overview of different programming paradigms, specifically procedural programming, object-oriented programming, functional programming, data-driven programming, and data description, using Lua programming language examples. It will explain the core concepts, principles, and applications of each paradigm, structured in a way that allows for future expansion.

#### General Overview
Programming paradigms are approaches or styles of programming that provide distinct ways to conceptualize and solve problems. Each paradigm offers unique principles and methodologies, influencing how programmers design, write, and manage code. Lua, being a versatile and lightweight scripting language, supports multiple paradigms effectively.

#### Procedural Programming
Procedural programming is a paradigm that is based on the concept of procedure calls, where code is organized into procedures, also known as routines, subroutines, or functions. This paradigm emphasizes a sequence of steps to be executed, making it straightforward and easy to understand.

In Lua, procedural programming is natural and simple. Here is an example:

```lua
function greet(name)
    print("Hello, " .. name)
end

function main()
    greet("World")
    greet("Lua")
end

main()
```

In this example, the program defines a procedure `greet` to print a greeting message and then calls this procedure from the `main` function.

#### Object-Oriented Programming
Object-oriented programming (OOP) revolves around the concept of "objects," which are instances of classes. Classes define the structure and behavior of objects, encapsulating data and functions that operate on the data. Lua supports OOP through metatables and the `:` syntax for method calls.

Here’s an OOP example in Lua:

```lua
Account = {}
Account.__index = Account

function Account:new(name, balance)
    local obj = {name = name, balance = balance}
    setmetatable(obj, Account)
    return obj
end

function Account:deposit(amount)
    self.balance = self.balance + amount
end

function Account:withdraw(amount)
    if self.balance >= amount then
        self.balance = self.balance - amount
    else
        print("Insufficient funds")
    end
end

function Account:getBalance()
    return self.balance
end

local myAccount = Account:new("John Doe", 1000)
myAccount:deposit(500)
myAccount:withdraw(200)
print(myAccount:getBalance())  -- Output: 1300
```

This example demonstrates how to create a simple `Account` class with methods to deposit, withdraw, and check the balance.

#### Functional Programming
Functional programming is a paradigm that treats computation as the evaluation of mathematical functions and avoids changing state and mutable data. It emphasizes the application of functions, immutability, and higher-order functions.

In Lua, functions are first-class citizens. Here is a functional programming example:

```lua
function factorial(n)
    if n == 0 then
        return 1
    else
        return n * factorial(n - 1)
    end
end

function map(array, func)
    local new_array = {}
    for i, v in ipairs(array) do
        new_array[i] = func(v)
    end
    return new_array
end

local numbers = {1, 2, 3, 4, 5}
local squares = map(numbers, function(x) return x * x end)

for i, v in ipairs(squares) do
    print(v)
end
```

In this example, `factorial` is a recursive function, and `map` is a higher-order function that applies another function to each element in an array.

#### Data-Driven Programming
Data-driven programming is a paradigm where the program's behavior is controlled by data, rather than hard-coded logic. This approach separates the data and the processing logic, allowing for more flexible and adaptable programs.

Lua’s table structure is suitable for this paradigm. Here’s an example:

```lua
local actions = {
    greet = function(name) print("Hello, " .. name) end,
    farewell = function(name) print("Goodbye, " .. name) end
}

local function performAction(action, name)
    if actions[action] then
        actions[action](name)
    else
        print("Action not found")
    end
end

performAction("greet", "Lua")     -- Output: Hello, Lua
performAction("farewell", "Lua")  -- Output: Goodbye, Lua
```

In this example, actions are defined in a table, and the `performAction` function executes the appropriate action based on the provided data.

#### Data Description
Data description is a paradigm focused on defining and describing the structure and meaning of data. It is used to specify data formats, schemas, and constraints, often in the context of data exchange and storage.

In Lua, tables can be used to describe data structures. Here’s an example:

```lua
local person = {
    name = "John Doe",
    age = 30,
    address = {
        street = "123 Main St",
        city = "Anytown",
        state = "CA",
        zip = "12345"
    }
}

function printPerson(p)
    print("Name: " .. p.name)
    print("Age: " .. p.age)
    print("Address: " .. p.address.street .. ", " .. p.address.city .. ", " .. p.address.state .. " " .. p.address.zip)
end

printPerson(person)
```

In this example, the `person` table describes a person's details, including a nested `address` table.

#### Conclusion
Understanding different programming paradigms is essential for selecting the appropriate approach to problem-solving in software development. Each paradigm offers unique strengths and is suited to different types of tasks and applications. By mastering multiple paradigms, programmers can become more versatile and effective in their coding practices. Lua, with its simplicity and flexibility, is a great language to explore and apply these paradigms.
