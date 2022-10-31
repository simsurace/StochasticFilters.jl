# StochasticFiltering

[![Build Status](https://travis-ci.com/simsurace/StochasticFiltering.jl.svg?branch=master)](https://travis-ci.com/simsurace/StochasticFiltering.jl)
[![Coverage](https://codecov.io/gh/simsurace/StochasticFiltering.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/simsurace/StochasticFiltering.jl)

The StochasticFiltering.jl package provides high-level abstractions for simulating and deploying stochastic filters. As such, it is primarily targeted at developers or researchers of specific stochastic filtering algorithms. It also comes with concrete types for the most common hidden state and observation models.

## Installation

Within Julia 1.6.0+, press `]` to use the built-in package manager, then type

```
pkg> add https://github.com/simsurace/StochasticFiltering.jl
```

## Usage

User API is in development.

Some planned features:

* Defining filtering problems as well as combining signal and observation models in various ways (adding new observations, stacking, etc.)
* Simulating hidden states, observations, and the filter in order to assess performance
* Deploying the filter as a standalone object
* Comparing different filters side-by-side (in parallel)
