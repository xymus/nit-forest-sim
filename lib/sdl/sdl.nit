
module sdl

universal SDLDisplay special Pointer
#	var readable Image _screen

	new ( w, h : Int) is extern # force initialisation at instanciation?

	#fun quit is extern
    fun destroy is extern
    
	fun flip is extern
	fun blit( img : Image, x : Int, y : Int ) is extern 
    fun blit_centered( img : Image, x : Int, y : Int )
    do
    	x = x - img.width / 2
    	y = y - img.height / 2
    	blit( img, x, y )
    end
    fun clear( r, g, b : Int ) is extern
    
    fun width : Int is extern
    fun height : Int is extern
	#fun blit_resize( img : Image, dest : Rectangle ) is extern 
	
	#fun load_image( path : String ) : Image is extern
	
	fun events : Sequence[ Event ]
	do
		var new_event : nullable Object = null
		var events = new List[ Event ]
		loop do
			new_event = poll_event
			if new_event isa Event then # new_event != null then
				events.add( new_event )
			else
				break
			end
		end
		return events
	end
	
	private fun poll_event : nullable Event is extern import KeyboardEvent, MouseEvent, String::from_cstring, MouseEvent as (nullable Event), KeyboardEvent as (nullable Event)
	
	fun spacebar_is_pressed : Bool is extern
end

universal Image special Pointer
    new from_file( path : String ) is extern import String::to_cstring
    new partial( original : Image, clip : Rectangle ) is extern
    new copy_of( image : Image ) is extern
    #new ( w : Int, h : Int ) is extern
    #new rotated( original : Image, angle : Float ) is extern
    
    fun blit( img : Image, x : Int, y : Int ) is extern
    fun blit_centered( img : Image, x : Int, y : Int )
    do
    	x = x - img.width / 2
    	y = y - img.height / 2
    	blit( img, x, y )
    end
    fun save_to_file( path : String ) is extern import String::to_cstring
    fun clear( c : Float ) is extern
    
    fun destroy is extern
    
    fun width : Int is extern
    fun height : Int is extern
    
    
    #fun get_subimage( clip : Rectangle ) : Image is extern
end

universal Rectangle special Pointer
	new ( x : Int, y : Int, w : Int, h : Int ) is extern
	#new is extern

	#readable writable var _x, _y : int16 is extern
	#readable writable var _w, _h : uint16 is extern
	fun x=( v : Int ) is extern
	fun x : Int is extern

	fun y=( v : Int ) is extern
	fun y : Int is extern

	fun w=( v : Int ) is extern
	fun w : Int is extern

	fun h=( v : Int ) is extern
	fun h : Int is extern
    
    fun destroy is extern
end

#universal Point special Pointer
#	new ( x : Int, y : Int ) is extern
	#new is extern

    #readable writable var _x, _y : Int is extern
#	fun x=( v : Int ) is extern
#	fun x : Int is extern

#	fun y=( v : Int ) is extern
#	fun y : Int is extern
    
#    fun destroy is extern
#end

# valid but unused
#class Point
#	readable var _x : Int
#	readable var _y : Int
#	
#	init ( x : Int, y : Int )
#	do
#		_x = x
#		_y = y
#	end
#end


class Event
	#fun isa_mouse_event : Bool is extern
	#fun isa_keyboard_event : Bool is extern
end

class MouseEvent special Event
	readable var _x : Int
	readable var _y : Int
	readable var _button : Int
	readable var _down : Bool
	fun up : Bool do return not down
	
	init ( x : Int, y : Int, button : Int, down : Bool )
	do
		_x = x
		_y = y
		_button = button
		_down = down
	end
	
	redef fun to_s
	do
		if down then
			return "MouseEvent button {button} down at {x}, {y}"
		else
			return "MouseEvent button {button} up at {x}, {y}"
		end
	end
	
	#init centered_to( x : Int, y : Int )
end

class KeyboardEvent special Event
	readable var _key_name : String
	readable var _down : Bool
	fun up : Bool do return not down
	
	init ( key_name : String, down : Bool )
	do
		_key_name = key_name
		_down = down
	end
	
	redef fun to_s
	do
		if down then
			return "KeyboardEvent key {key_name} down"
		else
			return "KeyboardEvent key {key_name} up"
		end
	end
end


#universal Event special Pointer
	#fun isa_mouse_event : Bool is extern
	#fun isa_keyboard_event : Bool is extern
#end

#universal MouseEvent special Event
#	fun x : Int is extern
#	fun y : Int is extern
#	fun button : Int is extern
#	fun down : Bool is extern
	
#	redef fun to_s
#	do
#		if down then
#			return "MouseEvent button {button} down at {x}, {y}"
#		else
#			return "MouseEvent button {button} up at {x}, {y}"
#		end
#	end
#end

#universal KeyboardEvent special Event
#	fun key_name : String is extern import String::from_cstring
#	fun down : Bool is extern
#	fun up : Bool do return not down
#	
#	redef fun to_s
#	do
#		if down then
#			return "KeyboardEvent key {key_name} down"
#		else
#			return "KeyboardEvent key {key_name} up"
#		end
#	end
#end

#universal SDL

# test

var display : SDLDisplay = new SDLDisplay( 640, 480 )

var imgBackground = new Image.from_file( "/home/xymus/projects/xit/maitrise/code/misc/nit/sdl/data/background0.png" )
var imgFighter = new Image.from_file( "/home/xymus/projects/xit/pyfl/trunk/src/client/imgs/ships/human-fighter.png" )

# display.initialize()

var tick : Int = 0
while tick < 300 do

	display.blit( imgBackground, 0, 0 )
	display.blit( imgFighter, tick, 100 )
	display.flip()
	
	#if display.spacebar_is_pressed then print "is spacebar!!!"
	for event in display.events do
	end

	tick = tick + 1
	#print "doing turn" 
end

imgBackground.destroy
imgFighter.destroy
display.destroy

