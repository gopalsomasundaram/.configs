-- this is a comment in lua


--[[this 
is a multiline ccomment]]--

--------------------
--1. Variables and flow control
--------------------

num = 42 --this is a 64 bit double var 52 bits are used for soring int

s = 'walternate' --this is a immutable string var (like python)

t = "double quotes are the same as well"

u = [[ Double brackets 
	start and end multi - line strings ]] 
-- everything between the brackets is part of string

t = nil --undefines t; Lua has garbage collecion


--blocks are denoted with keywords like do / end:

while num < 50 do
	num = num + 1 --No ++ or += like in cpp
end

-- do denotes the start of code block and end the end 
--ifs 

if num > 40 then
	print('over 40')
elseif s ~= 'walternate' then -- ~= is not equals
	-- equality check is ==
	io.write('not over 40\n')--stdout
else
	--vars are global by default
	thisIsGlobal = 5

	--making a local variable
	local line = io.read() -- reads next stdin line

	--string concatenation uses the .. operator:	
	print('Winter is coming, ' .. line)
end
--btw lua is not indent sensitive

--seems if use then-end for code blocks and while uses do-end

--undefined variables return nil 
foo = anUnKnownVariable --Now foo = nil

aBoolVal = false

--only nil and false are falsy; 0 and '' are true!
if not aBoolVal then print('twas false') end
--not is used to invert truth

-- 'or' and 'and' are short circuited.
-- This is similar to the a?b:c operator in c/js
ans = aBoolVal and 'yes' or 'no' --> this will result in 'no'

karlSum = 0
for i = 1, 100 do --range includes both ends
	karlSum = karlSum + i
end

--Use 100, 1 ,-1 to count down
fredSum = 0
for j = 100 , 1, -1 do fredSum = fredSum + j end

--In general the range is begin, end [,step]

--another loop construct (kinda similar to do while):
repeat
	print('the way of the future'..num)
	num = num -1
until num == 0

--------------------
--2.Functions
--------------------

function fib(n)
	if n < 2 then return 1 end
	return fib(n-2)+fib(n-1)
end

--closures and anonymous functions are ok
function adder(x)
	--the returned function is created when adder is called, 
	-- and remembers the value of x:
	return function (y) return x + y end 
end

a1 = adder(9)
a2 = adder(36)
print(a1(16))
print(a2(64))


--returns, function calls, and assigments all work
--with lists that may be mismatched in length

--Unmatched receivers are nil
--unmateched senders are discarded
x,y,z = 1,2,3,4
--x = 1, y = 2, z = 3 and 4 is thrown away

function bar(a,b,c)
	print(a,b,c)
	return 4,8,15,16,23,42
end

x,y = bar('zaphod') -->prints "zaphod nil nil"
--Now x = 4, y = 8, balues 15,16,23,42 are discarded

--functions are first class that is they can be treated
--like any other variable, they maybe global or local
--these are the same:
function f(x) return x * x end
f = function (x) return x * x end

--and so are these
local function g(x) return math.sin(x) end
local g;g = function (x) return math.sin(x) end
--the 'local g' decl makes g self references ok

--trigonometry function work in radians

--calls with one string params dont need parens:
print 'hello there' --works fine

--------------------
--3.Tables
--------------------
--tables are luas only compound data structure
--they are hash look up dicts that can also be used as lists


--Using tables as dictionaries
--dicts literals have string keys by default
t = {key1 = 'value1',key2 = false}

--string keys can use js like dot notation
print(t.key1)--> prints value1
t.newKey = {} -->adds new key / value pair
t.key2 = nil -->removes key2 from table

--literal notation for any (non nill) values and key:
u = {['@!#']  ='qbert',[{}] = 1729, [6.28] = 'tau'}
print(u[6.28]) --> prints tau

--keymatching is by values for numbers and strings but by
--identity for tables
a= u['@!#'] --> now a = 'qbert'
b = u[{}] --> might expect 1729 but its nil:
--b = nill since lookup fails. it fails because the key
--we used is not the same object as the one used to store the original value
--so strings and numbers are better keys

--a one table param function call needs no parenthesis
function h(x) print(x.key1) end --> x is the passed dict which does 
--not have a variable outside of the function

h{key1 = 'Somni~451'}--> prints "Somni~451"
--what we are doing in the above problem is pass a dict to func h()
--the func h()

for key , val in pairs(u) do --table iteration
	print(key,val)
end

-- _G is a special table that has all global variables
print(_G['_G']==_G)

--using tables as lists/arrays:

--list literals implicitly set up int keys:
v = {'value1','value2',1.21,'gigawatts'}
for i = 1, #v do -- #v is the size of v for lists
	print(v[i]) -- indices start at 1!!!
end
--a 'list' is not a real type. v is just a table with consecutive
-- integer keys, trates as a list

--------------------
--3.1 Metatables and metamethods
--------------------

--A table can have metatable that five the table operator overloading behaviour

f1 = {a=1,b=2} --represents the fraction a / b
f1 = {a=2,b=3}

metafraction = {}
function metafraction.__add(f1,f2)
	sum = {}
	sum.b = f1.b * f2.b
	sum.a = f1.a*f2.b*f2.a*f1.b
	return sum
end

setmetatable(f1 , metafraction)
setmetatable(f2 , metafraction)

--an __index on a metatable overloads dot lookup
sefaultFavs = {'guru',food = "donuts"}
myFavs = {food = "pizza"}
setmetatable(myFavs,{__index = defulatFavs})
