
function mysplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

print("build dataset")
dataset = {}

local matfile = io.open("train.txt", "r")
for line in matfile:lines() do
    local input = {}
    local output = {}

    local t = mysplit(line, " ")
    for i = 1, #t - 1 do
        local tt = mysplit(t[i], ":")
        local index = tonumber(tt[1])
        local value = tonumber(tt[2])
        input[#input+1] = {index, value}
    end

    local ttt = mysplit(t[#t], ".")
    local rating = tonumber(ttt[3])
    output[#output+1] = rating

    dataset[#dataset+1] = {torch.Tensor(input), torch.Tensor(output)}
end


print("build network")
require "nn"

mlp = nn.Sequential();
inputs = 3952+6040; outputs = 1; HUs = 2048;
mlp:add(nn.SparseLinear(inputs, HUs))
mlp:add(nn.Tanh())
mlp:add(nn.Linear(HUs, outputs))


print("train network")
criterion = nn.MSECriterion()
trainer = nn.StochasticGradient(mlp, criterion)
trainer.learningRate = 0.01
trainer:train(dataset)



local err = 0
local cnt = 0

local matfile = io.open("test.txt", "r")
for line in matfile:lines() do
    local input = {}
    local output = {}

    local t = mysplit(line, " ")
    for i = 1, #t - 1 do
        local tt = mysplit(t[i], ":")
        local index = tonumber(tt[1])
        local value = tonumber(tt[2])
        input[#input+1] = {index, value}
    end

    local ttt = mysplit(t[#t], ".")
    local rating = tonumber(ttt[3])
    output[#output+1] = rating

    input = torch.Tensor(input)
    output = torch.Tensor(output)
    local _output = mlp:forward(input)

    err = err + (_output[0]-output[0]) * (_output[0]-output[0])
    cnt = cnt + 1
end

err = math.sqrt(err / cnt)
print(err)





