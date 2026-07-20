-- stack.lua

-------------------------------------------
-- Basic stack data structure

-- Create an stack Class:
local Stack = {
  elements = {}
}

-- Constructor:
function Stack.new(self, object)
  object = object or {}
  self.__index = self
  return setmetatable(object, self)
end

-- Adds an element to the top of the stack:
function Stack.push(self, value)
  return table.insert(self.elements, value)
end

-- Removes the element at the top of the stack:
function Stack.pop(self)
  return table.remove(self.elements)
end

-- Returns the element at the top without removing it:
function Stack.peek(self)
  return self.elements[#self.elements]
end

-- Clear the stack:
function Stack.clear(self)
  self.elements = {}
  return true
end

-------------------------------------------
-- Usage stack LIFO (Last In, First Out)

-- Create a stack object:
local stack = Stack:new()

-- Push some values onto the stack:
stack:push("ana")
stack:push("bob")

-- Peek value at the top of the stack:
print(stack:peek()) --> bob

-- Pop values from the stack:
print(stack:pop()) --> bob
print(stack:pop()) --> ana

-- Try get values from the empty stack:
print(stack:pop())  --> nil
print(stack:peek()) --> nil

-- Clearing the stack:
stack:push("bob")
stack:clear()
print(stack:peek()) --> nil
