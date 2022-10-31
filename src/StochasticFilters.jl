module StochasticFilters

using Distributions

include("sfilter.jl")
export StochasticFilter, DiscreteTimeFilter, ContinuousTimeFilter
export sfilter

include("recording.jl")
export Recording, recorded_data, Sfilter

end # module
