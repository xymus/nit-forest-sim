
import sockets
import serialize

import thin_termites_jack

import client_comm

import config

redef class ThinForest
    init do prepare
    
    fun sync( s : DeserializationStream )
    do
       #print "syncing"
        # trees
        for x in [ 0 .. w [ do for y in [ 0 .. h [
        do
            #print "{x} {y}"
            var case = grid[ x ][ y ]
            case.termite_count = 0
            case.lumberjack_count = 0
            case.worked_on_count = 0
        
            #print "{x} {y} {s.peak( 4 )}"
            var has_tree = s.read_bool
            
            if has_tree
            then
                var size = s.read_float
                var grown = s.read_bool
                var growth_rate = s.read_float
                var dead = s.read_bool
                case.tree = new ThinTree( size, grown, growth_rate, dead )
            else
                case.tree = null
            end
        end
        
        # termites
        var t_count = s.read_int
       #print "{t_count} termites"
        for t in [ 0 .. t_count [
        do
            var p = new Point( s.read_int, s.read_int )
            
            local_case_for( p ).termite_count += 1
        end
        
        # lumberjack
        var l_count = s.read_int
       #print "{l_count} lumberjacks"
        for l in [ 0 .. l_count [
        do
            var p = new Point( s.read_int, s.read_int )
            
            local_case_for( p ).lumberjack_count += 1
        end
        
        # worked on by lumberjacks
        var w_count = s.read_int
       #print "{w_count} worked on"
        for wo in [ 0 .. w_count [
        do
            var p = new Point( s.read_int, s.read_int )
            
            local_case_for( p ).worked_on_count += 1
        end
    end
end

var img_dir =  "PWD".to_symbol.environ + "/art/images/"
var imgs = new HashMap[String,Image]

imgs[ "trunk" ] = new Image.from_file( img_dir + "trunk.png" )
imgs[ "grown" ] = new Image.from_file( img_dir + "grown-tree.png" )
imgs[ "teen" ] = new Image.from_file( img_dir + "teen-tree.png" )
imgs[ "dead" ] = new Image.from_file( img_dir + "dead-tree.png" )
imgs[ "young" ] = new Image.from_file( img_dir + "small-tree.png" )
imgs[ "lumberjack" ] = new Image.from_file( img_dir + "lumberjack.png" )

for i in [ 1 .. 8 ] do
    imgs[ "termites{i}" ] = new Image.from_file( img_dir + "termites{i}.png" )
end

var s = new CommunicationSocket.connect_to( address, port )

var tf = new ThinForest

var handshake = new Buffer
(tf.w/-2).dump_to( handshake )
(tf.w).dump_to( handshake )
(tf.h/-2).dump_to( handshake )
(tf.h).dump_to( handshake )

print "sending handshake {handshake.to_s}"
s.write( handshake.to_s )
print "sent handshake {handshake.to_s}"

# receiving sync
var stream = new  SocketDeserializationStream( s )
print "syncing"
tf.sync( stream )
print "synced"

# display
var display : SDLDisplay = new SDLDisplay( 1024, 640 )

var quitting = false

while not quitting
do
    # receive updates
   #print "receiving"
    var turn = new ThinGameTurn[Forest].deserialize( stream )
   #print "received"
    
    # integrate
   #print "integrating"
    tf.integrate_turn( turn )
    tf.do_local_turn
   #print "integrated"
    
    # collect inputs
    var shutdown = false
    var moving = false
    for e in display.events do
        if e isa KeyboardEvent and not e.down
        then
            if e.key_name == "q"
            then
                quitting = true
            else if e.key_name == "s"
            then
                shutdown = true
            else if e.key_name == "up"
            then
                moving = true
                tf.y -= 4
            else if e.key_name == "down"
            then
                moving = true
                tf.y += 4
            else if e.key_name == "left"
            then
                moving = true
                tf.x -= 4
            else if e.key_name == "right"
            then
                moving = true
                tf.x += 4
            end
        end
    end
    
    # send inputs to server
    var b = new Buffer
    if quitting
    then
        "quit".dump_to( b )
    else if shutdown
    then
        "shutdown".dump_to( b )
    else if moving
    then
        "move".dump_to( b )
    else
        "ok".dump_to( b )
    end
    s.write( b.to_s )
    
    # act on inputs locally
    if quitting or shutdown
    then
    #    break label end_game
    else if moving
    then
        b = new Buffer
        
        (tf.x - tf.w/2).dump_to( b )
        (tf.w).dump_to( b )
        (tf.y - tf.h/2).dump_to( b )
        (tf.h).dump_to( b )
        
        s.write( b.to_s )
        
       #print "coord sent"
        
        tf.sync( stream )
    end
    
    # ui
   #print "drawing"
    tf.draw( display, imgs )
    display.flip
   #print "drawn"
   
   if not quitting then quitting = stream.read_bool
    
end label end_game

display.destroy
    
s.close

