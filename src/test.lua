cmd = torch.CmdLine()
cmd:text('Options')
cmd:option('-alpha', 0.0, 'alpha')

local params = cmd:parse(arg)

print("Options: ")
for key, val in pairs(params) do
   print("-" .. key  .. "\t: " .. tostring(val))
end