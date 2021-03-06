
## import any one of the 4 modules for different scenarios
#import forest
#import termites
#import lumberjacks
import termites_jack_ex
import bucket

import sockets
import serialize
import server_comm

import config

class RemoteClient
    var connection : CommunicationSocket
    var stream : SocketDeserializationStream

    # view params
    var l : Int = 0
    var w : Int = 0
    var t : Int = 0
    var h : Int = 0
    
    init ( s : CommunicationSocket )
    do
        connection = s
        stream = new SocketDeserializationStream( s )
        
    end
    
    fun filter( turn : GameTurn[Forest] ) : ThinGameTurn[Forest]
    do
        var client_turn = new ThinGameTurn[Forest]( turn.tick )
        
        for e in turn.events
        do
            if e isa PositionEvent
            then
                if in_sight( e.pos )
                then
                    client_turn.events.add( e )
                end
            else if e isa MoveEvent
            then
                if in_sight( e.to ) or in_sight( e.from )
                then
                    client_turn.events.add( e )
                end
            end
        end
        
        return client_turn
    end
    
    fun sync( game : Forest )
    do  
       #print "syncing"
        l = stream.read_int
        w = stream.read_int
        t = stream.read_int
        h = stream.read_int
       #print "got coord"
        
        var b = new Buffer
                
        # trees
        #print "{w} {h}"
        for x in [ l .. l+w [ do for y in [ t .. t+h [
        do
            var case = game.grid[ new Point( x, y ) ]
            
            (case.e != null).dump_to( b )
                
            if case.e != null
            then
                case.e.size_at( game.tick ).dump_to( b ) # float
                (case.e.stage >= 2).dump_to( b ) # grown
                case.e.growth_rate.dump_to( b ) # float
                (case.e.stage >= 3).dump_to( b ) # dead
                
                # print b.to_s
            end
        end
        
        # termites
        var termites_in_sight = new List[ Termite ]
        for t in game.termites
        do
            if in_sight( t.ground.position )
            then
                termites_in_sight.add( t )
            end
        end
        
        termites_in_sight.length.dump_to( b )
        for t in termites_in_sight
        do
            t.ground.position.x.dump_to( b )
            t.ground.position.y.dump_to( b )
        end
        
        # lumberjacks
        var lumberjacks_in_sight = new List[ Lumberjack ]
        var worked_on_in_sight = new List[ Tree ]
        for l in game.lumberjacks
        do
            if in_sight( l.ground.position )
            then
                lumberjacks_in_sight.add( l )
            end
            
            var target = l.working_on
            if target != null and in_sight( target.ground.position )
            then
                worked_on_in_sight.add( target )
                #print "wo: {target.ground.position}"
            end
        end
        
        lumberjacks_in_sight.length.dump_to( b )
        for l in lumberjacks_in_sight
        do
            l.ground.position.x.dump_to( b )
            l.ground.position.y.dump_to( b )
        end
        
        worked_on_in_sight.length.dump_to( b )
        for w in worked_on_in_sight
        do
            w.ground.position.x.dump_to( b )
            w.ground.position.y.dump_to( b )
        end
        
       #print "sync: {b.to_s}"
        connection.write( b.to_s )
    end
    
    fun send( turn : ThinGameTurn[Forest] )
    do
        var buffer = new Buffer
        
        turn.tick.dump_to( buffer )
        turn.events.dump_to( buffer )
        
       #print "turn: {buffer.to_s}"
        connection.write( buffer.to_s )
    end
    
    fun in_sight( p : Point ) : Bool
    do
       #print "{p} in {l} {w} {t} {h} {p.x >= l and p.x < l+w and p.y >= t and p.y < t+h}"
        return p.x >= l and p.x < l+w and
               p.y >= t and p.y < t+h
    end
    
    fun get_input : String
    do
        var input = stream.read_string
        
        if input == "move"
        then
            #var new_l = stream.read_int
            #var new_w = stream.read_int
            #var new_t = stream.read_int
            #var new_h = stream.read_int
            
            #l = new_l
            #w = new_w
            #t = new_t
            #h = new_h
        end
        
        return input
    end
end

# opening port and waiting for connection
var listening_socket = new ListeningSocket.bind_to( address, port )

# client list
var clients = new List[ RemoteClient ]

# game
var f = new Forest

# shutdown command
var shutdown = false

# begin play
while not shutdown
do
	var clock = new Clock
	
    # accept new clients
    var comm_socket : nullable CommunicationSocket = null
   #print "accepting"
    comm_socket = listening_socket.accept
    if comm_socket != null
    then
        var new_client = new RemoteClient( comm_socket )
        new_client.sync( f )
        clients.add( new_client )
       #print "accepted"
    end
    
    # do game logic
    #print "doing turn"
    var turn : GameTurn[Forest] = f.do_turn
    #print "done turn"
    
    
    # do clients
    var clients_to_remove = new List[ RemoteClient ]
    for client in clients
    do
        # send turn
        ## filter events
        #print "filtering"
        var ct = client.filter( turn )
        #print "filter done"
        
        ## actually send turn
        #print "sending"
        client.send( ct )
        #print "sent"
        
        # receive input
        #print "reading"
        var r = client.get_input
        #print "read"
        if r != null
        then
            if r == "quit"
            then
                #print "client {client} qutting"
                clients_to_remove.add( client )
            else if r == "shutdown"
            then
                shutdown = true
            else if r == "move"
            then
                client.sync( f )
            end
        end
    end
    
    # remove disconnecting clients
    for client in clients_to_remove
    do
        clients.remove( client )
        client.connection.close
    end
    
    # notify if shutting down
    for client in clients
    do
        var b = new Buffer
        shutdown.dump_to( b )
        
        client.connection.write( b.to_s )
    end
    
    # sleep to regulate turn time
	var ens = clock.elapsed_nanosec
	var left = 33333-ens
	if left > 0 then left.nanosleep
end     

listening_socket.close

