# imports
#using FLoops # did not work, was reporting some warnings
using Base.Threads: @spawn, @threads, nthreads, threadid
using Statistics
using Combinatorics
using Logging
using Printf: @sprintf
using BenchmarkTools

# Add another 2 packages for exact and heuristics solving
# https://github.com/ericphanson/TravelingSalesmanExact.jl
# and heuristics 

# globals
const LOGGING_LEVEL = Logging.Info

# Logging set up
logger = ConsoleLogger(stdout, LOGGING_LEVEL)
@sprintf "Setting logging level is  '%s'" logger.min_level
global_logger(logger)

@error "Will report Error"
@warn "Will report Warn"
@info "Will report Info"
@debug "Will report debug"
# disable_logging(LogLevel(-100000))

# starting message
# should start julia with several threads enabled, for instance `julia --threads 4`
@info @sprintf "running julia with %s threads." nthreads()
@warn "Switching the debug mode on will cause heavy load on the process when the matrix is too big, use with caution and for debugging reasons set matrix to smallest possible size"

