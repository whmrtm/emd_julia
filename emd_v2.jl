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

function Single_IMF(signal, maxIter = 70, threshold = 0.02)
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
    min_values = IMF[min_ind]
    max_values = IMF[max_ind]

    N_min = length(min_ind)
    N_max = length(max_ind)

    if N_min > N_max
      mean_points_ind = zeros(N_min)
      mean_points_val = zeros(N_min)

      for i in 1:N_max
        mean_points_ind[i] = (min_ind[i] + max_ind[i])/2
        mean_points_val[i] = (min_values[i] + max_values[i])/2
      end
      # Then use last point of maximals
      for i in N_max+1:N_min
        mean_points_ind[i] = (min_ind[i] + max_ind[N_max])/2
        mean_points_val[i] = (min_values[i] + max_values[N_max])/2
      end
    else
      mean_points_ind = zeros(N_max)
      mean_points_val = zeros(N_max)

      for i in 1:N_min
        mean_points_ind[i] = (min_ind[i] + max_ind[i])/2
        mean_points_val[i] = (min_values[i] + max_values[i])/2
      end
      # Then use last point of maximals
      for i in N_min+1:N_max
        mean_points_ind[i] = (min_ind[N_min] + max_ind[i])/2
        mean_points_val[i] = (min_values[N_min] + max_values[i])/2
      end
    end



    if length(mean_points_ind) > 3
      itp_env = Spline1D(mean_points_ind, mean_points_val)
      env_mean = itp_env(samples)
    elseif length(mean_points_ind) == 3
      itp_env = Spline1D(mean_points_ind, mean_points_val; k=2)
      env_mean = itp_env(samples)
    elseif length(mean_points_ind) == 2
      itp_env = Spline1D(mean_points_ind, mean_points_val; k=1)
      env_mean = itp_env(samples)
    else
      env_mean = mean_points_val[1]*samples
    end

    # println(env_mean)
    IMF = IMF - env_mean
    # println(i)
    # println(IMF)

    # Determine whether meet the IMF condition
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
