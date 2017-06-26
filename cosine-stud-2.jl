# Example usage of emd
using WAV
using Plots
include("emd.jl")
include("mhs.jl")

N = 100
alphas = logspace(-2, 2, N)
betas = linspace(0, 1, N)

xgrid = repmat(alphas', N, 1)
ygrid = repmat(betas, 1, N)
x = linspace(0, 2, 1000)

omega = 2*pi

z = zeros(N, N)
for i in 1:N
  for j in 1:N
    alpha = alphas[i]
    beta = betas[j]
    s1 = sin(omega*x)
    s2 = alpha*sin(beta*omega*x)
    signal = s1 + s2
    IMF, residule = emd(signal, 1)
    # Performance measure 1
    c = norm(IMF'-s1) / norm(s2)
    z[i:i,j:j] = c
  end
end

fig = figure()
surf = plot_surface(xgrid, ygrid, z, rstride=1, cstride=1, linewidth=0, antialiased=false, cmap="coolwarm")
zlim(0,30)
ax = gca()

xlabel("log_10 a")
ylabel("f")
title("Surface Plot")
# fig[:colorbar](surf)
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
