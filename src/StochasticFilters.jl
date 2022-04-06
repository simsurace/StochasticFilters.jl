module StochasticFilters

using Distributions

include("sfilter.jl")
export StochasticFilter, DiscreteTimeFilter, ContinuousTimeFilter
export sfilter

end # module
