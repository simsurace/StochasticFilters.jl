@testset "recording.jl" begin
    @testset "DiscreteTimeRecording" begin
        struct Foo{T} <: DiscreteTimeFilter
            s::T
        end
        function (F::Foo)(Y)
            F.s .+= Y
        end
        state(F::Foo) = F.s
        Y = [rand(2) for i in 1:5]

        @testset "Recording without function argument" begin
            @testset "sfilter" begin
                F = Foo(zeros(2))
                RF = Recording(F)
                sfilter(Y, RF)
                @test length(recorded_data(RF)) == length(Y) + 1
                @test state(first(recorded_data(RF))) ≈ zeros(2)
                @test state.(recorded_data(RF)[2:end]) ≈ cumsum(Y)
            end

            @testset "Sfilter" begin
                F = Foo(zeros(2))
                RF = Recording(F)
                result = Sfilter(Y, RF)
                @test length(result) == length(Y) + 1
                @test state(first(result)) ≈ zeros(2)
                @test state.(result[2:end]) ≈ cumsum(Y)
            end
        end

        @testset "Recording with function argument" begin
            @testset "sfilter" begin
                F = Foo(zeros(2))
                RF = Recording(F, state)
                sfilter(Y, RF)
                @test length(recorded_data(RF)) == length(Y) + 1
                @test first(recorded_data(RF)) ≈ zeros(2)
                @test recorded_data(RF)[2:end] ≈ cumsum(Y)
            end

            @testset "Sfilter" begin
                F = Foo(zeros(2))
                RF = Recording(F, state)
                result = Sfilter(Y, RF)
                @test length(result) == length(Y) + 1
                @test first(result) ≈ zeros(2)
                @test result[2:end] ≈ cumsum(Y)
            end
        end

        @testset "With control variable" begin
            function (F::Foo)(Y, U)
                F.s .+= U .* Y
            end

            U = rand(5)
            F = Foo(zeros(2))
            RF = Recording(F, state)
            sfilter(Y, U, RF)
            @test length(recorded_data(RF)) == length(Y) + 1
            @test first(recorded_data(RF)) ≈ zeros(2)
            @test recorded_data(RF)[2:end] ≈ cumsum(U .* Y)
        end
    end
end
