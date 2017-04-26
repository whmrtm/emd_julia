# Plot the marginal hilbert spectrum using IMF computed

using DSP
using PyPlot



# function unwrap(v, inplace=false)
#   # Unwrap the phase information
#   unwrapped = inplace ? v : copy(v)
#   for i in 2:length(v)
#     while unwrapped[i] - unwrapped[i-1] >= pi
#       unwrapped[i] -= 2pi
#     end
#     while unwrapped[i] - unwrapped[i-1] <= -pi
#       unwrapped[i] += 2pi
#     end
#   end
#   return unwrapped
# end

function mydiff(s)
  # Helper function to substitute the np.diff
  s_shift = [s[end]; s[1:end-1]]
  diff = s - s_shift
  return diff[2:end]
end

function mhs(IMF, Fs)
  # Plot the marginal speectrum
  N = size(IMF, 1)
  L = size(IMF, 2)
  t = linspace(0, L./Fs, L-1)

  IF = zeros(L-1)
  for i in 1:N
    myIMF = IMF[i,:]
    theta = unwrap(angle(hilbert(myIMF)))
    IF += mydiff(theta)*Fs./(2.*pi)
  end

  # In time-frequency domain
  # figure()
  # plot(t, IF)


  # Normalize parameter
  IF_max = maximum(IF)
  IF_min = minimum(IF)
  lambda = 1.0 ./ (IF_max - IF_min)

  normalized_IF = lambda.*IF
  L_F = 256
  normalized_F = linspace(0, 1, L_F)
  m_power = zeros(L_F)
  bin_space = 1 ./ (L_F-1)

  for norm_if in normalized_IF
    for i in 1:L_F
      if abs(norm_if - normalized_F[i]) < bin_space ./ 2
        m_power[i] = m_power[i] + 1
        break
      end
    end
  end



  # Marginal spectrum
  figure()
  plot(normalized_F, m_power)
  xlabel("Normalized frequency")
  ylabel("Energy ")
  # ylim(ymin = -30)
end
