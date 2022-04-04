module StochasticFiltering

using Distributions
using MatrixEquations: lyapc

include("filter.jl")
export StochasticFilter, DiscreteTimeFilter, ContinuousTimeFilter
export stochasticfilter

end # module
