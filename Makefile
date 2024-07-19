all:
	love ./

images:
	# not carrying
	aseprite -b --layer "feet" --layer "legs" --layer "arms-normal"   --layer "head" --frame-tag "idle" assets/player.aseprite --save-as assets/player-idle.png
	aseprite -b --layer "feet" --layer "legs" --layer "arms-normal"   --layer "head" --frame-tag "walking" assets/player.aseprite --save-as assets/player-walking-1.png
	# carrying
	aseprite -b --layer "feet" --layer "legs" --layer "arms-carrying" --layer "head" --frame-tag "idle" assets/player.aseprite --save-as assets/player-carrying-idle.png
	aseprite -b --layer "feet" --layer "legs" --layer "arms-carrying" --layer "head" --frame-tag "walking" assets/player.aseprite --save-as assets/player-carrying-walking-1.png
	aseprite -b --layer "normal" assets/box.aseprite --save-as assets/box.png
	aseprite -b --layer "crushed" assets/box.aseprite --save-as assets/box-crushed.png
	aseprite -b assets/delivery-stop.aseprite --save-as assets/delivery-stop.png
	aseprite -b assets/player-truck.aseprite --save-as assets/player-truck.png
	aseprite -b --layer "normal" assets/stop-sign.aseprite --save-as assets/stop-sign.png
	aseprite -b --layer "crushed" assets/stop-sign.aseprite --save-as assets/stop-sign-crushed.png
	aseprite -b assets/indicator.aseprite --save-as assets/indicator.png

serve:
	rm -rf makelove-build
	makelove lovejs
	unzip -o "makelove-build/lovejs/2024-summer-game-jam-lovejs" -d makelove-build/html/
	echo "http://localhost:8000/makelove-build/html/2024-summer-game-jam/"
	python3 -m http.server
