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

The package also has implementations of a few well-known discrete- and continuous-time filters:
- Discrete-time Kalman filter
- Kalman-Bucy filter `KBF`, `KBF1D`, and with control `KBFC`
- Gaussian assumed-density filter for linear stochastic system with Poisson observations `GADFP`, `GADFP1D`

Please use the documentation for information on how to use these.
For continuous-time weighted and unweighted particle filters, take a look at [FeedbackParticleFilters.jl](https://github.com/simsurace/FeedbackParticleFilters.jl), which builds on `StochasticFilters.jl`.

## Advanced Usage
### Learning stochastic filters from observation data
The package provides a high-level API for learning filters from observation data. 
The following example performs offline maximum-likelihood learning of a 2d Kalman-Bucy filter on two-dimensional observation data `dY`:
```julia
using LinearAlgebra: I
dY = randn(2, 100) # a series of 100 2d observations
F = KBF(-Matrix(I, 2, 2), Matrix(I, 2, 2), Matrix(I, 2, 2)
learn!(F, dY)
```
which will modify `F` and return the trained filter.
The trained filter will have parameters that maximize the marginal likelihood of the observation trajectory `dY`.

In order to perform online maximum-likelihood training,
the filter can be wrapped with `Adaptive` and then deployed using `sfilter` as follows:
```julia
F_ad = Adaptive(F)
sfilter(dY, F_ad)
```
which will continuously adapt the filter parameters.

### Recordings
A `StochasticFilter` will normally advance its state and forget its previous state. 
In order to record a trajectory of the complete filter state, the filter can be wrapped with `Recording` and then deployed normally:
```julia
F_rec = Recording(F)
sfilter(dY, F_ad)
```
The recorded data can then be retrieved via `recorded_data(F_rec)`. 
It is an array of length `length(dY) + 1` (assuming that `sfilter` has been called only once), where the first entry is the initial state of the filter (before seeing any observations), and the remaining elements are the states after seeing each of the observations (i.e. the state is recorded after advancing the filter state).

Recording the full filter state is sometimes not desired or takes up too much memory.
In this case, one can pass a recording function, e.g. to record only the mean of the posterior distribution:
```julia
rec(F) = mean(F)
F_rec = Recording(F, rec)
```
Or if the function depends on the observation as well,
```julia
rec(F, Y) = likelihood(Y, F)
F_rec = Recording(F, rec)
```
In order to show the versatiliy of this approach, suppose that we know the ground truth of the latent trajectory `X_traj` and want to compute the mean-squared error of the filter.
We can define
```julia
struct MSE{T1, T2} <: DiscreteTimeFilter
    s::T1
    n::T2
end
MSE() = MSE([0.], [0])
function (mse::MSE)(F, X)
    mse.s .+= (X - mean(F))^2
    mse.n .+= 1
end
evaluate(mse::MSE) = first(mse.s) / first(mse.n)

```
