@testset "filter.jl" begin
    @testset "DiscreteTimeFilter" begin
        struct Foo{T} <: DiscreteTimeFilter
            s::T
        end
        function (F::Foo)(Y)
            F.s .+= Y
        end
        function (F::Foo)(Y, U)
            F.s .+= U .* Y
        end

        @testset "stochasticfilter" begin
            Y1 = [rand(2) for i in 1:5]
            Y2 = hcat(Y1...)
            U1 = [rand(2) for i in 1:5]
            U2 = hcat(U1...)

            @testset "typeof(Y) = $(typeof(Y))" for Y in (Y1, Y2)
                F = Foo(zeros(2))
                stochasticfilter(Y, F)
                @test F.s ≈ sum(Y1)

                @testset "typeof(U) = $(typeof(U))" for U in (U1, U2)
                    F = Foo(zeros(2))
                    stochasticfilter(Y, U, F)
                    @test F.s ≈ sum(Y2 .* U2, dims = 2)
                end
            end
        end
    end
    @testset "ContinuousTimeFilter" begin
        struct Bar{T} <: ContinuousTimeFilter
            s::T
        end
        function (F::Bar)(dY, dt)
            F.s .+= dY .- F.s .* dt
        end
        function (F::Bar)(dY, dt, U)
            F.s .+= U .* (dY .- F.s .* dt)
        end

        @testset "stochasticfilter" begin
            Y1 = [rand(2) for i in 1:5]
            Y2 = hcat(Y1...)
            U1 = [rand(2) for i in 1:5]
            U2 = hcat(U1...)

            F = Bar(zeros(2))
            stochasticfilter(Y1, 0.01, F)
            F1 = deepcopy(F)

            F = Bar(zeros(2))
            stochasticfilter(Y1, 0.01, U1, F)
            F2 = deepcopy(F)

            @testset "typeof(Y) = $(typeof(Y))" for Y in (Y1, Y2)
                F = Bar(zeros(2))
                stochasticfilter(Y, 0.01, F)
                @test F.s ≈ F1.s

                @testset "typeof(U) = $(typeof(U))" for U in (U1, U2)
                    F = Bar(zeros(2))
                    stochasticfilter(Y, 0.01, U, F)
                    @test F.s ≈ F2.s
                end
            end
        end
    end
end
