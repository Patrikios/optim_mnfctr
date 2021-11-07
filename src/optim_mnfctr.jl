module optim_mnfctr

export run_sequential, run_threaded

include("./misc.jl")

# functionality definitons

"""
    pairing(sequence::Union{Array{T, 1}, UnitRange{T}}) where T <: Integer

The function returns a vector of tuples of 2 integers that present a more suitable representation for matrix indexing with `matrix[elt...]`

Return `Array{Tuple{T, T}} where T <: Integer`

# Arguments
- `sequence::Union{Array{T, 1}, UnitRange{T}}`: A vector that that should e turned into sequence of consequitive tuples packaged in a vector.

# Examples
```jldoctest
julia> a = [1, 2, 3, 4]
4-element Vector{Int64}:
 1
 2
 3
 4
julia> pairing(a)
3-element Vector{Tuple{Int64, Int64}}:
 (1, 2)
 (2, 3)
 (3, 4)
```
"""
function pairing(sequence::Union{Array{T, 1}, UnitRange{T}})::Array{Tuple{T, T}} where T <: Integer
    L = []
    for s in 1:(length(sequence)-1)
        @inbounds push!(L, (sequence[s], sequence[s+1]))
    end
    return L
end


"""
run_sequential(matrix)

Return the minimum path sum from the available cost matrix and the path sequence that leads to the minimum sum, calculated sequentially.
"""
function run_sequential(matrix)

    @info "Started finding the minimal sequence of production orders"

    #global MIN, MIN_SEQUENCE, vec_

    x = size(matrix, 1) #given the matrix has the same number of rows and colums
    vec_ = 1:x
    perms = permutations(vec_)
    l = length(perms)

    @info "The number of permutations to calculate is $l"

    MIN = 99999999 # or Inf
    MIN_SEQUENCE = Int64[]

    #@floop ThreadedEx() for i in 1:l
        #global MIN, MIN_SEQUENCE, vec_
    #@threads for i in 1:l
    for i in 1:l #perms

        nthp = nthperm(vec_, i)
        p = pairing(nthp)

        #@debug @sprintf "Permutation %s" p

        s = Int64(0)
        #s = Threads.Atomic{Int}(0)

        for j in p
            @debug @sprintf "The j iterator value within the J loop is %s " j
            #println("Cost: ", matrix[j...])
            @inbounds s += matrix[j...]
            #println("Sum: ", s)
        end

        @debug println("s: $s")

        if s < MIN
            MIN = s
            MIN_SEQUENCE = nthp
            @debug "Resetting MIN to s: new min is $MIN"
        end
        @debug "s < MIN: s=$s, MIN=$MIN"
        @debug "#-----#"
    end
    return (MIN, MIN_SEQUENCE)
end

function run_threaded_with_simd(matrix)

    @info "Started finding the minimal sequence of production orders"

    #global MIN, MIN_SEQUENCE, vec_

    x = size(matrix, 1) #given the matrix has the same number of rows and colums

    @info "matrix has the size $x x $x"

    vec_ = 1:x
    perms = permutations(vec_)
    l = length(perms)
    MIN = 99999999 # or Inf
    MIN_SEQUENCE = Int64[]

    #@floop ThreadedEx() for i in 1:l
        #global MIN, MIN_SEQUENCE, vec_
    @threads for i in 1:l
#    for i in 1:l #perms
        nthp = nthperm(vec_, i)
        p = pairing(nthp)

        #@debug @sprintf "Permutation %s" p

        s = Int64(0)
        #s = Threads.Atomic{Int}(0)

        @simd for j in p
            @debug @sprintf "The j iterator value within the J loop is %s " j
            #println("Cost: ", matrix[j...])
            @inbounds s += matrix[j...]
            #println("Sum: ", s)
        end

        @debug println("s: $s")

        if s < MIN
            MIN = s
            MIN_SEQUENCE = nthp
            @debug "Resetting MIN to s: new min is $MIN"
        end
        @debug "s < MIN: s=$s, MIN=$MIN"
        @debug "#-----#"
    end
    return (MIN, MIN_SEQUENCE)
end

"""
    run_threaded(matrix)

Return the minimum path sum from the available cost matrix and the path sequence that leads to the minimum sum, calculated using multiple threads.
"""
function run_threaded(matrix)

    @info "Started the process of finding the minimal sequence of production orders"

    #global MIN, MIN_SEQUENCE, vec_

    x = size(matrix, 1) #given the matrix has the same number of rows and colums

    @info "matrix has the size $x x $x"

    vec_ = 1:x
    perms = permutations(vec_)
    l = length(perms)

    @info "The number of permutations to calculate is $l"

    MIN = 99999999 # or Inf
    MIN_SEQUENCE = Int64[]

    #@floop ThreadedEx() for i in 1:l
        #global MIN, MIN_SEQUENCE, vec_

    @threads for i in 1:l
#    for i in 1:l #perms
        nthp = nthperm(vec_, i)
        p = pairing(nthp)

        #@debug @sprintf "Permutation %s" p

        s = Int64(0)
        #s = Threads.Atomic{Int}(0)

        for j in p
            @debug @sprintf "The j iterator value within the J loop is %s " j
            #println("Cost: ", matrix[j...])
            @inbounds s += matrix[j...]
            #println("Sum: ", s)
        end

        @debug println("s: $s")

        if s < MIN
            MIN = s
            MIN_SEQUENCE = nthp
            @debug "Resetting MIN to s: new min is $MIN"
        end
        @debug "s < MIN: s=$s, MIN=$MIN"
        @debug "#-----#"
    end
    return (MIN, MIN_SEQUENCE)
end


end #of module
