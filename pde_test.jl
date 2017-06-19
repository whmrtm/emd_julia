using PyPlot
N = 1000
t = linspace(0, 1, N)
x = sin(10*pi*t)+sin(5*pi*t)
delta = N/40

x_upper = zeros(length(x),1)
x_lower = zeros(length(x),1)

for i in 1:N
  new_x_range = []
  for j in 1:N
    if abs(i-j) <= delta
      new_x_range = [new_x_range; j]
    end
  end
  # println(new_x_range)
  x_upper[i] = maximum(x[new_x_range])
  x_lower[i] = minimum(x[new_x_range])
end

plot(x)
plot(x_upper)
plot(x_lower)
plot(x-(x_upper+x_lower)/2)
