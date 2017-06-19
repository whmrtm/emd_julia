using DifferentialEquations
using Plots
f(t,x,u)  = -.5u
u0_func(x) = zeros(size(x,1))
tspan = (0.0,1.0)
dx = 1.0./2^(3)
dt = 1.0./2^(7)
mesh = parabolic_squaremesh([0 1 0 1],dx,dt,tspan,:neumann)
u0 = u0_func(mesh.node)
prob = HeatProblem(u0,f,mesh)
sol = solve(prob,FEMDiffEqHeatImplicitEuler())



plot(sol)
gui()
