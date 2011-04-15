
import sdl

## import any one of the 4 modules for different scenarios
#import thin_forest
#import thin_termites
#import thin_lumberjacks
import thin_termites_jack

class ForestUi
    var forest : Forest
    var tf : ThinForest 
    
    init( f : Forest )
    do
        forest = f
        tf = new ThinForest.from_new_forest( f )
    end
    
    fun run( imgs : HashMap[String,Image] )
    do
        var display : SDLDisplay = new SDLDisplay( 1024, 640 )
        
        var skip_to : Int = 1
        var turn : nullable GameTurn[ Forest ] = null
        
        while turn == null or turn.tick < 100000
        do
            while turn == null or skip_to > turn.tick
            do
                turn = forest.do_turn
            
                tf.integrate_turn( turn )
                tf.do_local_turn
                
            end
            
            tf.draw( display, imgs )
	        display.flip
	          
            print "tick: {turn.tick}, {turn.game.trees.length} trees present, {turn.game.total_tree_count} trees total, {turn.events.length} events"
            skip_to = turn.tick + 1
    
	        for e in display.events do
	            if e isa KeyboardEvent and not e.down
	            then
	                if e.key_name == "q"
	                then
	                    break label end_game
	                else if e.key_name == "s"
	                then
	                    skip_to = skip_to + 1000
	                end
	            end
	        end
        end label end_game
        
        display.destroy

    end
end

var img_dir = "PWD".to_symbol.environ + "/art/images/"
var images = new HashMap[String,Image]

images[ "trunk" ] = new Image.from_file( img_dir + "trunk.png" )
images[ "grown" ] = new Image.from_file( img_dir + "grown-tree.png" )
images[ "teen" ] = new Image.from_file( img_dir + "teen-tree.png" )
images[ "dead" ] = new Image.from_file( img_dir + "dead-tree.png" )
images[ "young" ] = new Image.from_file( img_dir + "small-tree.png" )
images[ "lumberjack" ] = new Image.from_file( img_dir + "lumberjack.png" )

for i in [ 1 .. 8 ] do
    images[ "termites{i}" ] = new Image.from_file( img_dir + "termites{i}.png" )
end

var f = new Forest
var ui = new ForestUi( f )

ui.run( images )

