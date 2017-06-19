using PyPlot
using Dierckx

function emd(signal, numIMF)
  # Do emepirical mode decomposition
  L = length(signal)
  IMF = zeros(numIMF, L)
  residule = signal

  for i = 1:numIMF
    IMF[i,:], residule = Single_IMF(residule)
    # println("IMF $i")
    # println(IMF[i,:])
    end
  return IMF, residule
end

function Single_IMF(signal, maxIter = 70, threshold = 0.1)
  # Find the single IMF of a signal

  L = length(signal)
  samples = linspace(1, L ,L)

  # Find zeros count
  zeros_count = 0
  for i in 1:L
    if signal[i] == 0
      zeros_count = zeros_count + 1
    end
  end

  IMF = zeros(L)
  IMF = signal

  for i in 1:maxIter
    # println("-----Iteration: $i ------")
    min_ind, max_ind = find_extreme(IMF)
    if length(min_ind) == 0
      break
    end

    min_ind = [1;min_ind;L]
    max_ind = [1;max_ind;L]
    min_values = IMF[min_ind]
    max_values = IMF[max_ind]

    # println(size(min_ind), size(max_values))
    if length(min_ind) > 3
      itp_env_min = Spline1D(min_ind, min_values)
      env_min = itp_env_min(samples)
    elseif length(min_ind) == 3
      itp_env_min = Spline1D(min_ind, min_values; k = 2)
      env_min = itp_env_min(samples)
    elseif length(min_ind) == 2
      itp_env_min = Spline1D(min_ind, min_values; k = 1)
      env_min = itp_env_min(samples)
    else
      env_min = min_values[1]*samples
    end

    # println(size(max_ind), size(max_values))
    if length(max_ind) > 3
      itp_env_max = Spline1D(max_ind, max_values)
      env_max = itp_env_max(samples)
    elseif length(max_ind) == 3
      itp_env_max = Spline1D(max_ind, max_values; k = 2)
      env_max = itp_env_max(samples)
    elseif length(max_ind) == 2
      itp_env_max = Spline1D(max_ind, max_values; k = 1)
      env_max = itp_env_max(samples)
    else
      env_max = max_values[1]*samples
    end

    env_mean = (env_min + env_max) ./ 2.0
    # println(env_mean)
    IMF = IMF - env_mean
    # println(i)
    # println(IMF)
    max_env_mean = abs(maximum(env_mean))
    min_env_mean = abs(minimum(env_mean))

    if max_env_mean < threshold && min_env_mean < threshold
      break
    end
  end

  # println(size(IMF_fun))
  residual = signal - IMF
  return IMF, residual
end


function find_extreme(signal)
  # Find the indexes of emtremes
  s = signal
  s_diff = s - [s[end]; s[1:end-1]]
  s_diff = s_diff[2:end]
  L = length(s_diff)
  d1 = s_diff[1:L-1]
  d2 = s_diff[2:L]
  indMin = find((d1.*d2.<0) & (d1.<0)) + 1
  indMax = find((d1.*d2.<0) & (d1.>0)) + 1
  # return [indMin s[indMin]], [indMax s[indMax]]
  return indMin, indMax
end



function plot_IMF(IMF, residule)
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
end



function mean_env(signal)
  # Find mean envelope, min envelope and max envelope
  L = length(signal)
  samples = linspace(1, L ,L)

  min_ind, max_ind = find_extreme(signal)
  min_ind = [1;min_ind;L]
  max_ind = [1;max_ind;L]

  min_values = signal[min_ind]
  max_values = signal[max_ind]

  if length(min_ind) > 3
    itp_env_min = Spline1D(min_ind, min_values)
    env_min = itp_env_min(samples)
  elseif length(min_ind) == 3
    itp_env_min = Spline1D(min_ind, min_values; k = 2)
    env_min = itp_env_min(samples)
  elseif length(min_ind) == 2
    itp_env_min = Spline1D(min_ind, min_values; k = 1)
    env_min = itp_env_min(samples)
  else
    env_min = min_values[1]*samples
  end

  # println(size(max_ind), size(max_values))
  if length(max_ind) > 3
    itp_env_max = Spline1D(max_ind, max_values)
    env_max = itp_env_max(samples)
  elseif length(max_ind) == 3
    itp_env_max = Spline1D(max_ind, max_values; k = 2)
    env_max = itp_env_max(samples)
  elseif length(max_ind) == 2
    itp_env_max = Spline1D(max_ind, max_values; k = 1)
    env_max = itp_env_max(samples)
  else
    env_max = max_values[1]*samples
  end

  env_mean = (env_min + env_max) ./ 2.0

  return env_mean, env_max, env_min
end
