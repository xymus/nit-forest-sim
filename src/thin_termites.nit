
import termites
import thin_forest

redef class Case
    var termite_count : Int writable = 0
    
    redef fun to_s
    do
        var s = super
        
        if termite_count > 0
        then
            return "\e[0;31m{s}\e[0m"
        else
            return s
        end
    end
    
    redef fun draw( display : SDLDisplay, imgs : HashMap[String,Image], 
              x, y : Int )
    do
        super
        
        if termite_count > 0
        then
            var c : Int = 8
            if termite_count < c
            then
                c = termite_count
            end
            
            display.blit( imgs["termites{c}"], x, y )
        end
    end
end

redef class ThinForest
    redef fun react_to_event( e )
    do
        if e isa ThinTermiteEvent
        then
            if e isa ThinTermiteMoveEvent
            then
               #print "move from {e.from} to {e.to}"
                if in_sight( e.from )
                then
                    local_case_for( e.from ).termite_count -= 1
                end
                if in_sight( e.to )
                then
                    local_case_for( e.to ).termite_count += 1
                end
            else if e isa ThinTermiteBirthEvent
            then
                var p = e.pos
               #print "t birth at {p}"
                if in_sight( p )
                then
                    local_case_for( p ).termite_count += 1
                end
            else if e isa ThinTermiteDeathEvent
            then
                var p = e.pos
               #print "t death at {p}"
                if in_sight( p )
                then
                    local_case_for( p ).termite_count -= 1
                end
            end
        else
            super( e )
        end
    end
end


class ThinTermiteEvent
special GameEvent
end

class ThinTermiteBirthEvent
special ThinTermiteEvent
special ThinPositionEvent
end

class ThinTermiteDeathEvent
special ThinTermiteEvent
special ThinPositionEvent
end

class ThinTermiteMoveEvent
special ThinTermiteEvent
special ThinMoveEvent
    init ( f : Point, t : Point )
    do
        from = f
        to = t
    end
end

class ThinTermiteAppearanceEvent
special ThinTermiteEvent
special ThinPositionEvent
end

