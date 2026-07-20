# Functions concepts

**Functions:**

- **Definition:** Blocks of code that perform specific tasks and can be reused.
- **Declaration:** `local function function_name(parameters) ... end`
- **Calling:** `function_name(arguments)`

**Multiple Return Values:**

- Functions can return multiple values, separated by commas.
- Example: `sum, product = sumProduct(2, 3)`

**Optional Arguments:**

- Arguments that can be omitted when calling a function.
- Default values can be specified using `=`.
- Example: `greet("Bob", "Hi")` or `greet("Bob")`

**Named Arguments:**

- Arguments passed as a table with keys matching parameter names.
- Order doesn't matter.
- Example: `greet{name = "Bob", greeting = "Hi"}`

**Variable Number of Arguments:**

- Functions can accept any number of arguments using `...`.
- Example: `greet("Ana", "Bob", "Carlos")`

**Anonymous Functions:**

- Functions defined without a name, often used as callbacks or for temporary use.
- Example: `local greet = function(name) ... end`

**First-Class Functions:**

- Functions can be treated like any other value (assigned to variables, passed as arguments, returned from other functions).
- Example: `local greetAna = greet("Ana")`

**Higher-Order Functions:**

- Functions that take other functions as arguments or return functions.
- Example: `greet("Bob", print)`

**Closures:**

- Functions that "remember" their surrounding environment, even when executed elsewhere.
- Example: `local count = counter()`

**Recursion:**

- Functions that call themselves to solve problems, often for tasks involving repetition or breaking down a problem into smaller parts.
- Example: `factorial(5)`

**Tail Recursion:**

- A special form of recursion where the recursive call is the last operation in the function, potentially optimizing for memory usage.
- Example: `factorial(5, 1)`

**Memoization:**

- Caching results of function calls to avoid redundant computations for the same inputs.
- Example: `memo = {}`

**Currying:**

- Transforming a function that takes multiple arguments into a sequence of functions, each taking a single argument.
- Example: `add2 = add(2)`

**Partial Application:**

- Creating a new function by pre-filling some of the arguments of an existing function.
- Example: `add2 = function(y) return add(2, y) end`

**Composition:**

- Combining multiple functions into a new function, where the output of one function becomes the input of the next.
- Example: `add2ThenMul3 = compose(mul3, add2)`

**Pipe:**

- A way to chain multiple functions together, passing the output of one function as the input to the next.
- Example: `add2ThenMul3 = pipe(add2, mul3)`

**Error Handling:**

- Using `pcall` to protect code from errors and handle them gracefully.
- Example: `status, result = pcall(function() error("Some error") end)`
