"""
    StochasticFilter

This is the abstract supertype that defines the interface for stochastic filters.
If `F` is a `StochasticFilter`, it is expected to be a stateful callable object that takes
an observation, potentially modifies its internal state, and returns itself.

There are two abstract subtypes `DiscreteTimeFilter` and `ContinuousTimeFilter` that differ
by signature:
- A `DiscreteTimeFilter` must take an observation and optionally a control input, i.e.
  `F(Y)` or `F(Y, U)`.
- A `ContinuousTimeFilter` must take an observation and a time step, and optionally a
  control input, i.e. `F(dY, dt)` or `F(dY, dt, U)`.

Since F is a 'stochastic' filter, it represents a distribution. Thus it is expected that
`distribution(F)` returns a `Distribution` object.

# Methods
Provided the interface above is fully implemented, the following methods come for free:
- `sfilter` filters an entire trajectory of observations and returns the final filter state.
- `Sfilter` filters an entire trajectory of observations and retunrs the  complete
  trajectory of filter states.
"""
abstract type StochasticFilter end

abstract type DiscreteTimeFilter <: StochasticFilter end
abstract type ContinuousTimeFilter <: StochasticFilter end

function (F::DiscreteTimeFilter)(Y) end
function (F::DiscreteTimeFilter)(Y, U)
    error("A method `F(Y, U)` for control input is not implemented for filter $(F).")
end

function sfilter(Y_traj, F::DiscreteTimeFilter)
    for Y in Y_traj
        F(Y)
    end
    return F
end

function sfilter(Y::AbstractMatrix, F::DiscreteTimeFilter)
    return sfilter(eachcol(Y), F)
end

function sfilter(Y_traj, U_traj, F::DiscreteTimeFilter)
    for (Y, U) in zip(Y_traj, U_traj)
        F(Y, U)
    end
    return F
end

function sfilter(Y::AbstractMatrix, U, F::DiscreteTimeFilter)
    return sfilter(eachcol(Y), U, F)
end

function sfilter(Y, U::AbstractMatrix, F::DiscreteTimeFilter)
    return sfilter(Y, eachcol(U), F)
end

function sfilter(Y::AbstractMatrix, U::AbstractMatrix, F::DiscreteTimeFilter)
    return sfilter(eachcol(Y), eachcol(U), F)
end




function (F::ContinuousTimeFilter)(dY, dt) end
function (F::ContinuousTimeFilter)(dY, dt, U)
    error("A method `F(dY, dt, U)` for control input is not implemented for filter $(F).")
end

function sfilter(dY_traj, dt::Real, F::ContinuousTimeFilter)
    for dY in dY_traj
        F(dY, dt)
    end
    return F
end

function sfilter(dY_traj, dt_traj, F::ContinuousTimeFilter)
    for (dY, dt) in zip(dY_traj, dt_traj)
        F(dY, dt)
    end
    return F
end

function sfilter(dY::AbstractMatrix, dt::Real, F::ContinuousTimeFilter)
    return sfilter(eachcol(dY), dt, F)
end

function sfilter(dY_traj, dt::Real, U_traj, F::ContinuousTimeFilter)
    for (dY, U) in zip(dY_traj, U_traj)
        F(dY, dt, U)
    end
    return F
end

function sfilter(dY_traj, dt_traj, U_traj, F::ContinuousTimeFilter)
    for (dY, dt, U) in zip(dY_traj, dt_traj, U_traj)
        F(dY, dt, U)
    end
    return F
end

function sfilter(dY::AbstractMatrix, dt::Real, U, F::ContinuousTimeFilter)
    return sfilter(eachcol(dY), dt, U, F)
end

function sfilter(dY, dt::Real, U::AbstractMatrix, F::ContinuousTimeFilter)
    return sfilter(dY, dt, eachcol(U), F)
end

function sfilter(dY::AbstractMatrix, dt::Real, U::AbstractMatrix, F::ContinuousTimeFilter)
    return sfilter(eachcol(dY), dt, eachcol(U), F)
end
