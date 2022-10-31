# StochasticFilters

[![Build Status](https://travis-ci.com/simsurace/StochasticFilters.jl.svg?branch=master)](https://travis-ci.com/simsurace/StochasticFilters.jl)
[![Coverage](https://codecov.io/gh/simsurace/StochasticFilters.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/simsurace/StochasticFilters.jl)

This is a light-weight package for defining and deploying stochastic filters.
It provides implementations of some well-known stochastic filters, but is mainly a place to define a common interface for more specialized packages, such as [FeedbackParticleFilters.jl](https://github.com/simsurace/FeedbackParticleFilters.jl).

## Installation

Within Julia 1.6.0+, press `]` to use the built-in package manager, then type

```julia
pkg> add StochasticFilters
```

## Basic Usage

A `StochasticFilter` in its most basic form is a callable object `F` which takes an observation `Y` and returns itself:

```julia
F(Y) -> F
```

This transforms the internal state of `F` such that it now represents the belief after making the observation `Y`, whereas before the call it represented the prior belief.

Typically, the belief is over some hidden variable and making an observation implies that the hidden variable has changed in the meantime. All of this detail is abstracted away once `F` has been constructed, and thus `F` can be deployed as a stand-alone object.

The most basic high-level use of `F` is to filter a complete observation trajectory.
For this, the package provides the function `sfilter`:
```julia
sfilter(Y_traj, F)
```
which returns the filter after running through the complete trajectory.
In order to get the vector of all intermediate filter states (including the initial one), use `Sfilter(Y_traj, F)`.

## Advanced Usage
### Recordings
A `StochasticFilter` will normally advance its state and forget its previous state. 
In order to record a trajectory of the complete filter state, the filter can be wrapped with `Recording` and then deployed normally:
```julia
F_rec = Recording(F)
sfilter(dY, F_ad)
```
The recorded data can then be retrieved via `recorded_data(F_rec)`.
It is an array of length `length(dY) + 1` (assuming that `sfilter` has been called only once), where the first entry is the initial state of the filter (before seeing any observations), and the remaining elements are the states after seeing each of the observations (i.e. the state is recorded after advancing the filter state).

In fact, the operation
```julia
sfilter(Y, Recording(F)) |> recorded_data
```
is equivalent to `Sfilter(Y, F)`.

Recording the full filter state is sometimes not desired or takes up too much memory.
In this case, one can pass a recording function, e.g. to record only the mean of the posterior distribution:
```julia
F_rec = Recording(F, mean)
```
`Recording` also supports functions that depend on the observation, although there still needs to be a method for a single argument for initialization:
```julia
rec(F) = 0.
rec(F, Y) = likelihood(Y, F)
F_rec = Recording(F, rec)
```
Likewise, for functions depending on the control variable:
```julia
rec(F) = var(F) / 2
rec(F, Y, U) = U^2 + var(F) / 2
F_rec = Recording(F, rec)
```
In order to directly obtain the trajectory of the recorded quantity, call
```julia
Sfilter(Y, Recording(F, rec))
```
