module StochasticFilters

using Distributions

include("filter.jl")
export StochasticFilter, DiscreteTimeFilter, ContinuousTimeFilter
export stochasticfilter

end # module
