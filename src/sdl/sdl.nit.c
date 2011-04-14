/* file generated by nits for module sdl */
/* TODO: rename this file to sdl.nit.c and implement the following methods. */



#include "sdl.nit.h"

/*
C implementation of sdl::SDLDisplay::init
*/
SDLDisplay new_SDLDisplay___impl( long int w, long int h )
{
	SDL_Init(SDL_INIT_VIDEO);
	return SDL_SetVideoMode( w, h, 24, SDL_HWSURFACE );
}

/*
C implementation of sdl::SDLDisplay::destroy
*/
void SDLDisplay_destroy___impl( SDLDisplay recv )
{
	if ( SDL_WasInit( SDL_INIT_VIDEO ) )
		SDL_Quit();
}

/*
C implementation of sdl::SDLDisplay::flip
*/
void SDLDisplay_flip___impl( SDLDisplay recv )
{
	SDL_Flip( recv );
}

/*
C implementation of sdl::SDLDisplay::blit
*/
void SDLDisplay_blit___impl( SDLDisplay recv, Image img, long int x, long int y )
{
	SDL_Rect dst; /* [ x, y, 0, 0 ); */
	dst.x = x;
	dst.y = y;
	dst.w = 0;
	dst.h = 0;

	SDL_BlitSurface( img, NULL, recv, &dst );
}

void SDLDisplay_clear___impl( SDLDisplay recv, long int r, long int g, long int b )
{
    SDL_FillRect( recv, NULL, SDL_MapRGB(recv->format,r,g,b) ); 
}

/*
C implementation of sdl::SDLDisplay::width
*/
long int SDLDisplay_width___impl( SDLDisplay recv )
{
	return recv->w;
}

/*
C implementation of sdl::SDLDisplay::height
*/
long int SDLDisplay_height___impl( SDLDisplay recv )
{
	return recv->h;
}

/*
C implementation of sdl::SDLDisplay::poll_event

Imported methods signatures:
	KeyboardEvent new_KeyboardEvent( String key_name, int down ) for sdl::KeyboardEvent::init
	MouseEvent new_MouseEvent( long int x, long int y, long int button, int down ) for sdl::MouseEvent::init for sdl::MouseEvent::init
	String new_String_from_cstring( char* str ) for string::String::from_cstring
*/
nullable_Event SDLDisplay_poll_event___impl( SDLDisplay recv )
{
    SDL_Event event;

    if ( SDL_PollEvent(&event) )
    {
        switch (event.type ) {
        case SDL_KEYDOWN:
		case SDL_KEYUP:
            printf("The \"%s\" key was pressed!\n",
                   SDL_GetKeyName(event.key.keysym.sym));
			/*if ( event.key.keysym.sym == SDLK_SPACE )*/
			return KeyboardEvent_as_nullable_Event( new_KeyboardEvent( new_String_from_cstring( SDL_GetKeyName(event.key.keysym.sym) ),
									  event.type==SDL_KEYDOWN ) );
			/*break;*/
			
	/*	case SDL_MOUSEMOTION:
			printf("Mouse moved by %d,%d to (%d,%d)\n", 
				   event.motion.xrel, event.motion.yrel,
				   event.motion.x, event.motion.y);
			break;*/
			
		case SDL_MOUSEBUTTONDOWN:
		case SDL_MOUSEBUTTONUP:
			printf("Mouse button \"%d\" pressed at (%d,%d)\n",
				   event.button.button, event.button.x, event.button.y);
			return MouseEvent_as_nullable_Event( new_MouseEvent( event.button.x, event.button.y, 
								   event.button.button,
								   event.type == SDL_MOUSEBUTTONDOWN ) );
			/*break;*/
			
		case SDL_QUIT:
			break;
        }
    }
    
    return null_Event();
}

/*
C implementation of sdl::SDLDisplay::spacebar_is_pressed
*/
int SDLDisplay_spacebar_is_pressed___impl( SDLDisplay recv )
{
    SDL_Event event;

    while ( SDL_PollEvent(&event) ) {
        switch (event.type) {
        case SDL_KEYDOWN:
            printf("The %s key was pressed!\n",
                   SDL_GetKeyName(event.key.keysym.sym));
                   if ( event.key.keysym.sym == SDLK_SPACE )
                   	  return true;
            break;
        }
    }
    return false;
}

/*
C implementation of sdl::Image::from_file

Imported methods signatures:
	char* String_to_cstring( String recv ) for string::String::to_cstring
*/
Image new_Image_from_file___impl( String path )
{
	/*printf( "from native: %s\n", Nit_String_extract_native( env, path ) ); */
	SDL_Surface *image = IMG_Load( String_to_cstring( path ) );
	/*printf( "img -> %i\n", image );*/
	return image;
}

/*
C implementation of sdl::Image::partial
*/
Image new_Image_partial___impl( Image original, Rectangle clip )
{
	return NULL;
}

/*
C implementation of sdl::Image::copy_of
*/
Image new_Image_copy_of___impl( Image image )
{
	SDL_Surface *new_image = SDL_CreateRGBSurface( image->flags, image->w, image->h, 24,
						  0, 0, 0, 0 );
	/*SDL_Surface *new_image = (SDL_Surface*)malloc(sizeof(SDL_Surface));
	memcpy(new_image, image, sizeof(SDL_Surface));
	new_image->refcount++;*/
	
	SDL_Rect dst; /* [ x, y, 0, 0 ); */
	dst.x = 0;
	dst.y = 0;
	dst.w = image->w;
	dst.h = image->h;
	SDL_BlitSurface( image, NULL, new_image, &dst );
	
	return new_image;
}

/*
C implementation of sdl::Image::init
*//*
Image new_Image___impl( long int w, long int h )
{
	SDL_CreateRGBSurface( 0, w, h, 24 );
}*/

/*
C implementation of sdl::Image::blit
*/
void Image_blit___impl( Image recv, Image img, long int x, long int y )
{
	SDL_Rect dst; /* [ x, y, 0, 0 ); */
	dst.x = x;
	dst.y = y;
	dst.w = 0;
	dst.h = 0;

	SDL_BlitSurface( img, NULL, recv, &dst );
}

/*
C implementation of sdl::Image::save_to_file

Imported methods signatures:
	char* String_to_cstring( String recv ) for string::String::to_cstring
*/
void Image_save_to_file___impl( Image recv, String path )
{
}

/*
C implementation of sdl::Image::clear
*/
void Image_clear___impl( Image recv, float c )
{
}

/*
C implementation of sdl::Image::destroy
*/
void Image_destroy___impl( Image recv )
{
	SDL_FreeSurface( recv );
}

/*
C implementation of sdl::Image::width
*/
long int Image_width___impl( Image recv )
{
	return recv->w;
}

/*
C implementation of sdl::Image::height
*/
long int Image_height___impl( Image recv )
{
	return recv->h;
}

/*
C implementation of sdl::Rectangle::init
*/
Rectangle new_Rectangle___impl( long int x, long int y, long int w, long int h )
{
	SDL_Rect *rect = malloc( sizeof( SDL_Rect ) );
	rect->x = (Sint16)x;
	rect->y = (Sint16)y;
	rect->w = (Uint16)w;
	rect->h = (Uint16)h;
	return rect;
}

/*
C implementation of sdl::Rectangle::x=
*/
void Rectangle_x__eq___impl( Rectangle recv, long int v )
{
	recv->x = (Sint16)v;
}

/*
C implementation of sdl::Rectangle::x
*/
long int Rectangle_x___impl( Rectangle recv )
{
	return recv->x;
}

/*
C implementation of sdl::Rectangle::y=
*/
void Rectangle_y__eq___impl( Rectangle recv, long int v )
{
	recv->y = (Sint16)v;
}

/*
C implementation of sdl::Rectangle::y
*/
long int Rectangle_y___impl( Rectangle recv )
{
	return recv->y;
}

/*
C implementation of sdl::Rectangle::w=
*/
void Rectangle_w__eq___impl( Rectangle recv, long int v )
{
	recv->w = (Uint16)v;
}

/*
C implementation of sdl::Rectangle::w
*/
long int Rectangle_w___impl( Rectangle recv )
{
	return recv->w;
}

/*
C implementation of sdl::Rectangle::h=
*/
void Rectangle_h__eq___impl( Rectangle recv, long int v )
{
	recv->h = (Uint16)v;
}

/*
C implementation of sdl::Rectangle::h
*/
long int Rectangle_h___impl( Rectangle recv )
{
	return recv->h;
}

/*
C implementation of sdl::Rectangle::destroy
*/
void Rectangle_destroy___impl( Rectangle recv )
{
}

/*
C implementation of sdl::Point::init

Point new_Point___impl( long int x, long int y )
{
	SDL_Rect *rect = malloc( sizeof( SDL_Rect ) );
	rect->x = (Sint16)x;
	rect->y = (Sint16)y;
	return rect;
}*/

/*
C implementation of sdl::Point::x=

void Point_xeq___impl( Point recv, long int v )
{
	/ *recv->x = (Sint16)v;* /
}
*/
/*
C implementation of sdl::Point::x

long int Point_x___impl( Point recv )
{
	return 0; / *recv->x;* /
}
*/
/*
C implementation of sdl::Point::y=

void Point_yeq___impl( Point recv, long int v )
{
	/ *recv->y = (Sint16)v;* 
}
*/
/*
C implementation of sdl::Point::y

long int Point_y___impl( Point recv )
{
	return 0; / *recv->y;* /
}
*/
/*
C implementation of sdl::Point::destroy

void Point_destroy___impl( Point recv )
{
}
*/
/*
C implementation of sdl::Event::isa_mouse_event
* /
int Event_isa_mouse_event___impl( Event recv )
{
	return recv->type == SDL_MOUSEBUTTONDOWN;
}

/ *
C implementation of sdl::Event::isa_keyboard_event
* /
int Event_isa_keyboard_event___impl( Event recv )
{
	return recv->type == SDL_KEYDOWN;
}

/ *
C implementation of sdl::MouseEvent::x
* /
long int MouseEvent_x___impl( MouseEvent recv )
{
	return recv->button.x;
}

/ *
C implementation of sdl::MouseEvent::y
* /
long int MouseEvent_y___impl( MouseEvent recv )
{
	return recv->button.y;
}

/ *
C implementation of sdl::MouseEvent::button
* /
long int MouseEvent_button___impl( MouseEvent recv )
{
	return recv->button.button;
}

/ *
C implementation of sdl::MouseEvent::down
* /
int MouseEvent_down___impl( MouseEvent recv )
{
	return recv->button.type == SDL_KEYDOWN;
}

/ *
C implementation of sdl::KeyboardEvent::key_name

Imported methods signatures:
	char* String_to_cstring( String recv ) for string::String::to_cstring
* /
String KeyboardEvent_key_name___impl( KeyboardEvent recv )
{
	return String_to_cstring( SDL_GetKeyName(recv->key.keysym.sym) );
}

/ *
C implementation of sdl::KeyboardEvent::down
* /
int KeyboardEvent_down___impl( KeyboardEvent recv )
{
	return recv->key.type == SDL_KEYDOWN;
}
*/
