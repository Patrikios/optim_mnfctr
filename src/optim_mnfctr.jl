module optim_mnfctr

include("misc.jl")
using Combinatorics
using Logging

logger = ConsoleLogger(stdout, Logging.Info) # Warn or Info or Debug
global_logger(logger)
disable_logging(LogLevel(-100000))

@info ("Running script test_gen_query2.jl...")





function pairing(sequence)
    L = []
    for s in 1:(length(sequence)-1)
        push!(L, (sequence[s], sequence[s+1]))
    end
    return L
end

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

print(m)

function run_(x)
    @info "Started"

    perms = permutations(x)
    l = length(perms)
    MIN = 99999999
    MIN_SEQUENCE = []

    for i in perms
        @debug println(i)
        p = pairing(i)
        @debug println(p)

        s = Int64(0)

        for j in p
            @debug println(j)
            @debug println("Cost: ", m[j...])
            s += m[j...]
            @debug println("Sum: ", s)
        end

        @debug println("s: $s")

        if s < MIN
            MIN = s
            MIN_SEQUENCE = i
            @debug println("Resetting MIN to s: new min is $MIN")
        end
        @debug println("s < MIN: s=$s, MIN=$MIN")
        @debug println("#-----#")
    end
    return (MIN, MIN_SEQUENCE)
end

@time min_, min_sequence = run_(1:11)



export greet
export greet_me

end
