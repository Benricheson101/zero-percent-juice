---@class Base
---@field x integer
local Base = {}
Base.__index = Base

function Base:new()
  local o = setmetatable({}, self)
  o.x = 5
  return o
end

function Base:print()
  print("Base: x =", self.x)
end

-- extending Base class

---@class Child : Base
local Child = {}
setmetatable(Child, {__index = Base})
Child.__index = Child

function Child:new()
  local o = setmetatable({}, self)
  o.x = 12
  return o
end

function Child:print()
  print("Child: x =", self.x)
end

local b = Base:new()
b:print()

local c = Child:new()
c:print()
