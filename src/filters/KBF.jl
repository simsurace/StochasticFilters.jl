struct KBF{
    T <: AbstractMvNormal, 
    Ta <: AbstractMatrix,
    Tb <: AbstractMatrix,
    Tc <: AbstractMatrix,
    Tcc <: AbstractMatrix
} <: ContinuousTimeFilter
    state::T
    A::Ta
    BB::Tb
    C::Tc
    CC::Tcc
end

function KBF(A::AbstractMatrix, B::AbstractMatrix, C::AbstractMatrix)
    n = size(A, 1)
    BB = B * B'
    CC = C' * C
    μ = zeros(n)
    # Try to solve continuous Lyapunov equation
    # A * Σ + Σ * A' + BB = 0
    # to obtain the stationary variance
    try
        Σ = lyapc(A, BB)
    catch
        Σ = zeros(n, n)
    end
    return KBF(MvNormal(μ, Σ), A, BB, C, CC)
end

KBF(A::Real, B::Real, C::Real) = KBF1D(A, B, C)

function (F::KBF)(dY, dt)
    μ = F.state.μ
    Σ = F.state.Σ
    A = F.A
    BB = F.BB
    C = F.C
    CC = F.CC
    
    μ2 = μ + dt * A * μ + Σ * C' * (dY - C * μ * dt)
    Σ2 = Σ + dt * (BB + A * Σ + Σ * A' - Σ * CC * Σ)

    μ .= μ2
    Σ .= Σ2
    return F
end

function (F::KBF)(::Nothing, dt)
    μ = F.state.μ
    Σ = F.state.Σ
    A = F.A
    BB = F.BB
    
    μ2 = μ + dt * A * μ
    Σ2 = Σ + dt * (BB + A * Σ + Σ * A')
            
    μ .= μ2
    Σ .= Σ2
    return F
end

distribution(F::KBF) = F.state
