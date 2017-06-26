using WAV
using PyPlot
include("emd_v2.jl")
include("mhs.jl")

N  = 1000
L = 2
x = linspace(0, L, N)
# Try differnet signals
signal = sin(4*pi*x) + 0.5*sin(10*pi*x)
indMin, indMax = find_extreme(signal)

# println(indMin)
# println(indMax)
ind_smallest_dist = abs(indMin[1] - indMax[1])

for ind1 in indMin
  for ind2 in indMax
    if abs(ind1 - ind2) < ind_smallest_dist
      ind_smallest_dist = abs(ind1 - ind2)
    end
  end
end

shortest_dist = ind_smallest_dist ./ N * L
println(shortest_dist)

estimated_omega_max = pi ./ shortest_dist
println(estimated_omega_max./ pi)

figure()
plot(x, signal)
scatter(x[indMin], signal[indMin])
scatter(x[indMax], signal[indMax])
