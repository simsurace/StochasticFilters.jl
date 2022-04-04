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

## Usage

User API is in development.

Some planned features:

* Defining filtering problems as well as combining signal and observation models in various ways (adding new observations, stacking, etc.)
* Simulating hidden states, observations, and the filter in order to assess performance
* Deploying the filter as a standalone object
* Comparing different filters side-by-side (in parallel)
