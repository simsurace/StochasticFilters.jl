"""
    FilterRepresentation
Abstract type for representing the conditional/posterior distribution over the hidden state.
"""
abstract type FilterRepresentation end

"""
    mean(::FilterRepresentation)
Find the conditional/posterior mean.

    mean(f, ::FilterRepresentation)
Find the conditional/posterior mean of the function `f`.
"""
function mean(::FilterRepresentation) end
function mean(f, ::FilterRepresentation) end

"""
    var(::FilterRepresentation)
Find the conditional/posterior variance.
"""
function var(::FilterRepresentation) end

"""
    cov(::FilterRepresentation)
Find the conditional/posterior covariance matrix.
"""
function cov(::FilterRepresentation) end


"""
    ParametricRepresentation <: FilterRepresentation
Abstract type for representing the conditional distribution using a parametric
family of distributions.
"""
abstract type ParametricRepresentation <: FilterRepresentation end

"""
    pdf(::ParametricRepresentation, x)
Compute the probability density of the parametric representation at x.
See also: logpdf
"""
function pdf(::ParametricRepresentation) end

"""
    logpdf(::ParametricRepresentation, x)
Compute the logarithm of the probability density of the parametric representation at x.
"""
function logpdf(::ParametricRepresentation) end


"""
    ParticleRepresentation <: FilterRepresentation
Abstract type for representing the conditional distribution using an ensemble of
particles/samples.
"""
abstract type ParticleRepresentation <: FilterRepresentation end

"""
    samplesize(::ParticleRepresentation)
Find the number of samples of the particle ensemble.
"""
function samplesize(::ParticleRepresentation) end

"""
    resample!(::ParticleRepresentation)
Resample the particle positions by drawing a (weighted) sample with replacement, 
then reset the weights to be equal.
"""
function resample!(::ParticleRepresentation) end


"""
    UnweightedRepresentation <: FilterRepresentation
Abstract type for representing the conditional distribution using an ensemble of
equally weighted particles.
"""
abstract type UnweightedRepresentation <: ParticleRepresentation end


"""
    WeightedRepresentation
Abstract type for representing the conditional distribution using an ensemble of
weighted particles.
"""
abstract type WeightedRepresentation <: ParticleRepresentation end

"""
    samplesize(::WeightedParticleRepresentation)
Find the effective number of samples of the particle ensemble.
"""
function eff_samplesize(ensemble::WeightedParticleRepresentation) end
