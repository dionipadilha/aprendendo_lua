-- tablelib.lua

-- Creating lists:
local myFriends = { "ana", "bob", "charlie" }
print(myFriends) --> table: memory_address

-- Table pack and unpack:
local myUncles = table.pack("clark", "lois")
print(table.unpack(myUncles)) --> clark lois

-- Constructing a list based on transformations:
local basicSquares = {}
for n = 1, 3 do table.insert(basicSquares, n ^ 2) end
print(table.unpack(basicSquares)) --> 1.0 4.0 9.0

-- Indexing starts from 1:
print(myFriends[1]) --> ana

-- Modifying elements at specific positions:
myFriends[2] = "robert"
print(table.unpack(myFriends)) --> ana robert charlie

-- Adding elements to the list:
table.insert(myFriends, "david")
table.insert(myFriends, 2, "eduard")
print(table.unpack(myFriends)) --> ana, eduard, robert, charlie, david

-- Removing elements from a list:
table.remove(myFriends)
table.remove(myFriends, 1)
print(table.unpack(myFriends)) --> eduard, robert, charlie

-- Combining multiple lists into one:
table.move(myUncles, 1, #myUncles, #myFriends + 1, myFriends)
print(table.unpack(myFriends)) --> eduard robert charlie clark lois

-- Sorts the elements of list:
table.sort(myFriends)
print(table.unpack(myFriends)) --> charlie clark eduard lois robert

-- Sorts the elements by length:
local byLength = function(a, b) return #a < #b end
table.sort(myFriends, byLength)
print(table.unpack(myFriends)) --> lois clark robert eduard charlie

-- Applying a function to each element of a list:
for i, number in ipairs(basicSquares) do
    print(number + i) --> 2.0, 6.0, 12.0
end

-- Selecting elements based on certain criteria:
local function startWith_c(str)
    return str:sub(1, 1) == "c"
end

local function selectBy(list, criteria)
    local selecteds = {}
    for _, item in ipairs(list) do
        if criteria(item) then table.insert(selecteds, item) end
    end
    return selecteds
end

local myBestFriends = selectBy(myFriends, startWith_c)
print(table.unpack(myBestFriends)) --> clark charlie

-- Concatenate all elements into a string:
print(table.concat(myBestFriends, "&")) --> clark&charlie

-- Delete a all elements in a table:
myBestFriends = {}
print(#myBestFriends) --> 0

-- Delete a table:
myBestFriends = nil
collectgarbage()
