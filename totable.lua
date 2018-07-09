local file = io.open('output.dmp', 'rb')
local elements = {}

local dump = file:read('*a'):gsub("\\", "z")
file:close()

local strings = {}
for word in dump:gmatch(('.'):rep(21)) do 
  if elements[word] then
    error(word) -- Duplicates are bad. 
  else
    strings[#strings + 1] = word
    elements[word] = true
  end
end

print('["' .. table.concat(strings, '","') .. '"]')
