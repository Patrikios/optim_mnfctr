using optim_mnfctr
using Test

@testset "optim_mnfctr.jl" begin
    @test greet_me("Patrik") === "Hello there Patrik !"
    @test greet() === "Hello there!"
end
