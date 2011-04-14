
import forest

## import any one of the 4 modules for different scenarios
import thin_forest
#import thin_termites
#import thin_lumberjacks
import thin_termites_jack # resolve conflicts between termites and lumberjack

var f = new Forest
var tf = new ThinForest.from_new_forest( f )

for i in [ 0 .. 10000 [
do
    var turn : nullable GameTurn[Forest] = null
    for j in [ 0 .. 1 [
    do
        turn = f.do_turn
        
        tf.integrate_turn( turn )
        tf.do_local_turn
    end
    
    var t = tf.to_s
    system( "sleep 0.005" )
    t += "tick: {turn.tick}, {turn.game.trees.length} trees present, {turn.game.total_tree_count} trees total, {turn.events.length} events"
    print t
    #print turn.tick
end

