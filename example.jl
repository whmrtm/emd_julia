# Example usage of emd
using WAV
using PyPlot
include("emd.jl")
include("mhs.jl")


# filename = "/home/heming/MEGA/Research/sounds/ocean.wav"
# filename = "/home/heming/MEGA/Research/sounds/chirp-150-190-linear.wav"
filename = "/home/heming/MEGA/Research/sounds/piano.wav"
# filename = "/home/heming/MEGA/Research/sounds/bendir.wav"


s, fs = wavread(filename)

signal = s[2001:4000]
IMF, residule = emd(signal, 5)



# Plot the IMFs
IMF_num = size(IMF, 1)

N = IMF_num + 2
figure()
subplot(N, 1, 1)
plot(signal)
title("Signal")

for i in 2:IMF_num+1
  subplot(N, 1, i)
  plot(IMF[i-1, :])
  title("IMF $(i-1)")
end
subplot(N,1,N)
plot(residule)
title("Residule")


# Plot the marginal spectrum
mhs(IMF, fs)


# Compute the orthogonality

IO = 0
IMF = [IMF; residule']

for i in 1:IMF_num+1
  for j in 1:IMF_num+1
    if i != j
      IO = IO + IMF[i,:].*IMF[j,:]
    end
    # println(IO)
  end
end

IO = IO ./ signal.^2
println("Orthogonality")
println(sum(IO))


# IMF 1 and IMF 2
println(sum( (IMF[1,:].*IMF[2,:]) ./ (IMF[1,:].^2 + IMF[2,:].^2) ))
