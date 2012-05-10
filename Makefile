default: ascii ui test art client server

bin-dir:
	mkdir -p bin

ascii: bin-dir # unlogical, still may be of interest
	nitc -o bin/ascii src/ascii.nit -I lib --cc-lib-name SDL --cc-lib-name SDL_image --cc-lib-name SDL_ttf --cc-header-path /usr/include/SDL

test: bin-dir
	nitc -o bin/test src/test.nit

ui: bin-dir
	nitc src/ui.nit -o bin/ui -I lib --cc-lib-name SDL --cc-lib-name SDL_image --cc-lib-name SDL_ttf --cc-header-path /usr/include/SDL

client: bin-dir
	nitc src/client.nit -o bin/client -I lib --cc-lib-name SDL --cc-lib-name SDL_image --cc-lib-name SDL_ttf --cc-header-path /usr/include/SDL

server: bin-dir
	nitc src/server.nit -o bin/server -I lib

sdl: bin-dir
	nitc src/sdl/sdl.nit -o bin/sdl-test -I lib --cc-lib-name SDL --cc-lib-name SDL_image --cc-lib-name SDL_ttf --cc-header-path /usr/include/SDL

art:
	mkdir -p art/images
	tools/export.sh art/src/cases.svg art/images/

.PHONY: art

