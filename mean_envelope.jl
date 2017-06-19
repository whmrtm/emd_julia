using PyPlot
include("emd.jl")
include("mhs.jl")

x = linspace(0, 8, 1000)
signal = 0.5*cos(2*pi*x) + 2*cos(0.1*pi*x) + 0.8*cos(0.5*pi*x);
signal_pp = -2*pi^2*cos(2*pi*x) - 0.02*pi^2*cos(0.1*pi*x) - 0.2*pi^2*cos(0.5*pi*x)

mean_ev, min_ev, max_ev = mean_env(signal)


fig, ax = subplots(1,2)

ax[1][:plot](x, signal, label="signal")
ax[1][:plot](x, max_ev, label="max_envelope")
ax[1][:plot](x, min_ev, label="min_envelope")
ax[1][:plot](x, mean_ev, label="mean_envelope")
ax[1][:set_title]("Classical EMD")
ax[1][:legend]()

ax[2][:plot](x, signal, label="signal")
ax[2][:plot](x, signal+0.005*signal_pp, label="mean_envelope")
ax[2][:set_title]("Old PDE-EMD")
ax[2][:legend]()
