struct DiscreteTimeRecording{TF <: DiscreteTimeFilter, Tf, To} <: DiscreteTimeFilter
    F::TF
    f::Tf
    out::To
end

struct ContinuousTimeRecording{TF <: ContinuousTimeFilter, Tf, To} <: ContinuousTimeFilter
    F::TF
    f::Tf
    out::To
end

AnyRecording = Union{DiscreteTimeRecording, ContinuousTimeRecording}

Recording(F) = Recording(F, identity)

function Recording(F, f)
    g(args...) = f(first(args))
    return Recording(F, g, [deepcopy(g(F))])
end

Recording(F::DiscreteTimeFilter, f, out) = DiscreteTimeRecording(F, f, out)
Recording(F::ContinuousTimeFilter, f, out) = ContinuousTimeRecording(F, f, out)

function (RF::AnyRecording)(args...)
    RF.F(args...)
    o = deepcopy(RF.f(RF.F, args...))
    push!(RF.out, o)
    return RF
end

recorded_data(RF::AnyRecording) = RF.out

Sfilter(Y, F::DiscreteTimeFilter) = Sfilter(Y, Recording(F))
Sfilter(Y, U, F::DiscreteTimeFilter) = Sfilter(Y, U, Recording(F))
Sfilter(Y, dt, F::ContinuousTimeFilter) = Sfilter(Y, dt, Recording(F))
Sfilter(Y, dt, U, F::ContinuousTimeFilter) = Sfilter(Y, dt, U, Recording(F))

function Sfilter(Y_traj, RF::AnyRecording)
    sfilter(Y_traj, RF)
    return recorded_data(RF)
end

function enhance(f)
    function g(args...)
        try
            return f(args...)
        catch
            return g(Base.front(args)...)
        end
    end
    g() = nothing
    return g
end
