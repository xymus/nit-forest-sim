
## import any one of the 4 modules for different scenarios
#import forest
#import termites
#import lumberjacks
import termites_jack_ex

import opts

var opts = new OptionContext
var verbose_opt = new OptionCount( "Prints forest data, is more frequent if repeated", "--verbose", "-v" )
var turns_opt = new OptionInt( "Number of turns to simulate", 1000, "--turns", "-t" )
var seed_opt = new OptionInt( "Seed for random number generation, -1 for random (the default)", -1, "--seed", "-s" )
var help_opt = new OptionBool( "Prints help message", "--help", "-h" )
opts.add_option( verbose_opt )
opts.add_option( turns_opt )
opts.add_option( seed_opt )
opts.add_option( help_opt )

opts.parse( args )
if not opts.rest.is_empty or help_opt.value then
	print "Usage: {program_name} [options]"
	print "Options:"
	opts.usage
	exit( 1 )
end

if seed_opt.value != -1 then
	srand_from( seed_opt.value )
else
	srand
end

var f = new Forest

var verbose = verbose_opt.value > 0
var verbose_period = 0
if verbose then
	if verbose_opt.value < 3 then
		verbose_period = 1000 / (10.0.pow(verbose_opt.value.to_f)).to_i
	else
		verbose_period = 1
	end
end

# simulate
for i in [ 0 .. turns_opt.value [ do
    var turn : GameTurn[Forest] = f.do_turn

	# print infos, once every 10 turns
	if verbose and i%verbose_period==0 then
		print "turn {i}: {f.trees.length} trees out of {f.total_tree_count} total, {f.termites.length} termites and {f.lumberjacks.length} lumberjacks"
	end
end

