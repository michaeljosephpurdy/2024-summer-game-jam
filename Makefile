all:
	love ./

images:
	aseprite -b --layer "normal" --frame-tag "idle" assets/player.aseprite --save-as assets/player.png
	aseprite -b --layer "carrying" --frame-tag "idle" assets/player.aseprite --save-as assets/player-carrying.png
	aseprite -b assets/player-truck.aseprite --save-as assets/player-truck.png

serve:
	rm -rf makelove-build
	makelove lovejs
	unzip -o "makelove-build/lovejs/2024-summer-game-jam-lovejs" -d makelove-build/html/
	echo "http://localhost:8000/makelove-build/html/2024-summer-game-jam/"
	python3 -m http.server
