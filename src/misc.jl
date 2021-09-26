# https://github.com/ericphanson/TravelingSalesmanExact.jl
#
using Base.Threads: @spawn, @threads, nthreads, threadid
#using FLoops
using Statistics
using Combinatorics
using Logging
using Printf: @sprintf
using BenchmarkTools
#
logger = ConsoleLogger(stdout, Logging.Info) # Warn or Info or Debug
global_logger(logger)
disable_logging(LogLevel(-100000))
#
@info @sprintf "running julia with %s threads." nthreads()
