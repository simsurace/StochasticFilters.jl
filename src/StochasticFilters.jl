module StochasticFilters

using Distributions

include("filter.jl")
export StochasticFilter, DiscreteTimeFilter, ContinuousTimeFilter
export sfilter

end # module
