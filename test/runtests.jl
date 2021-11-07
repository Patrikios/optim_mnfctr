using optim_mnfctr
using Test
const project_size = "small"

l = [0 3 3 2 1 1 2 3 2 1 2 3;
     1 0 2 1 1 2 3 4 2 3 4 1;
     1 2 0 2 1 2 3 4 4 3 1 6;
     1 2 3 0 2 1 2 3 2 5 8 4;
     1 2 3 4 0 2 3 4 3 6 8 4;
     1 2 3 4 5 0 1 2 4 5 6 9;
     1 2 3 4 5 6 0 3 4 5 6 5;
     1 2 3 4 5 6 7 0 4 5 6 7;
     1 2 3 4 5 0 1 2 0 5 6 3;
     1 2 3 4 5 6 0 3 4 0 6 2;
     1 2 3 4 5 6 7 0 4 5 0 4;
     2 3 4 5 6 7 8 9 1 2 3 4]

m = [0 3 3 2 1 1 2 3 2 1 2;
     1 0 2 1 1 2 3 4 2 3 4;
     1 2 0 2 1 2 3 4 4 3 1;
     1 2 3 0 2 1 2 3 2 5 8;
     1 2 3 4 0 2 3 4 3 6 8;
     1 2 3 4 5 0 1 2 4 5 6;
     1 2 3 4 5 6 0 3 4 5 6;
     1 2 3 4 5 6 7 0 4 5 6;
     1 2 3 4 5 0 1 2 0 5 6;
     1 2 3 4 5 6 0 3 4 0 6;
     1 2 3 4 5 6 7 0 4 5 0]

n = [0 3 3 2 1 2 4 3 2;
     1 0 2 1 1 0 10 4 3;
     1 2 0 2 1 2 2 2 5;
     1 2 3 0 2 1 4 5 4;
     1 2 3 4 0 3 5 6 5;
     1 2 3 4 5 6 7 3 4;
     2 3 4 5 6 7 8 3 4;
     3 4 5 6 7 8 9 8 7;
     1 2 3 4 5 6 7 8 9]



matrix = project_size == "big" ? l : project_size == "medium" ? m : n;
@info "Runnning tests on project_size $project_size with the folowwing matrix:" matrix

@testset "optim_mnfctr test 1" begin

    # min_threaded, min_sequence_threaded = @btime run_threaded($n)
    min_threaded, min_sequence_threaded = run_threaded(n)

    # min_sequential, min_sequence_sequential = @btime run_sequential($n)
    min_sequential, min_sequence_sequential = run_sequential(n)

    # @assert min_threaded == min_sequential && min_sequence_threaded == min_sequence_sequential
    @test min_threaded == min_sequential && min_sequence_threaded == min_sequence_sequential

    if min_threaded == min_sequential
     @info @show min_threaded == min_sequential
    end

    # min_threaded_no_simd, min_sequence_threaded_no_simd = @btime run_threaded_no_simd(m)
    # min_threaded, min_sequence_threaded = @btime run_threaded(m)
    # min_threaded, min_sequence_threaded = @btime run_threaded(l)

    #print(min_)
    #print(min_sequence)

end

#=
To DO
- compare solutions with package TravellingsalesemanExact 
- add heuristucs for non-exact solution (n > 13)
=#
