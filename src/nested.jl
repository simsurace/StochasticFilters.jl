struct NestedFilter{T1, T2, T3} <: DiscreteTimeFilter
    F_inner::T1
    F_outer::T2
    link::T3
end

NestedFilter(F_inner, F_outer) = NestedFilter(F_inner, F_outer, identity)

function (NF::NestedFilter)(args...)
    NF.F_outer(NF.link(NF.F_inner), Base.tail(args)...)
    NF.F_inner(args...)
    return NF
end



# examples:

struct Foo{T} <: DiscreteTimeFilter
    s::T
end
function (F::Foo)(Y)
    F.s .+= Y
    return F
end
state(F::Foo) = F.s

struct Bar{T} <: DiscreteTimeFilter
    s::T
end
function (F::Bar)(Y)
    F.s .= exp.(Y)
    return F
end

F1 = Foo([0.])
F2 = Bar([0.])

NF = NestedFilter(F1, F2, state)
