"""
    AbstractFilteringProblem

Abstract type for a filtering problem.
"""
abstract type AbstractFilteringProblem end

function state_model(::AbstractFilteringProblem) end
function obs_model(::AbstractFilteringProblem) end

state_space(prob::AbstractFilteringProblem) = state_space(state_model(prob))
obs_space(prob::AbstractFilteringProblem)   = obs_space(obs_model(prob))

#function product(::AbstractFilteringProblem, ::AbstractFilteringProblem) end
