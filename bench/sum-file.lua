local N = tonumber(arg and arg[1]) or 0
lines = io.lines()

local sum = 0

for i = 1,N do
  for line in lines do
    sum = sum + line
  end
end

io.write(sum, "\n")
