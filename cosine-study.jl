# Example usage of emd
using WAV
using PyPlot
include("emd_v2.jl")
include("mhs.jl")

alpha = 0.01
beta = 0.1

omega1 = 20*2*pi
omega2 = omega1*alpha

A1 = 1.0
A2 = A1*beta


t = linspace(0, 1, 1000)
s1 = A1*cos(omega1*t)
s2 = A2*cos(omega2*t)
signal = s1 + s2
IMF, residule = emd(signal, 1)



# Plot the IMFs
# plot_IMF(IMF, residule)

# Plot the signals
# figure()
# subplot(5,1,1)
# plot(t, signal)
# ylim(-2.0, 2.0)
# title("signal")
#
#
# subplot(5,1,2)
# plot(t, s1)
# ylim(-2.0, 2.0)
# title("s1")
#
#
# subplot(5,1,3)
# plot(t, s2)
# ylim(-2.0, 2.0)
# title("s2")
#
#
# subplot(5,1,4)
# plot(t, IMF')
# ylim(-2.0, 2.0)
# title("IMF1")
#
#
# subplot(5,1,5)
# plot(t, residule)
# ylim(-2.0, 2.0)
# title("residule")

# Compute the orthogonality
c = sqrt(vecdot(IMF'-s1, IMF'-s1) / vecdot(s2, s2))
println(c)
