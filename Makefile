all:
	love ./

images:
	# not carrying
	aseprite -b --layer "feet" --layer "legs" --layer "arms-normal"   --layer "head" --frame-tag "idle" assets/player.aseprite --save-as assets/player-idle.png
	aseprite -b --layer "feet" --layer "legs" --layer "arms-normal"   --layer "head" --frame-tag "walking" assets/player.aseprite --save-as assets/player-walking-1.png
	# carrying
	aseprite -b --layer "feet" --layer "legs" --layer "arms-carrying" --layer "head" --frame-tag "idle" assets/player.aseprite --save-as assets/player-carrying-idle.png
	aseprite -b --layer "feet" --layer "legs" --layer "arms-carrying" --layer "head" --frame-tag "walking" assets/player.aseprite --save-as assets/player-carrying-walking-1.png
	# NPCS
	aseprite -b --layer "feet" --layer "legs" --layer "arms-normal-1" --layer "head-npc-1" --frame-tag "idle" assets/player.aseprite --save-as assets/npc-1-idle.png
	aseprite -b --layer "feet" --layer "legs" --layer "arms-normal-1" --layer "head-npc-1" --frame-tag "walking" assets/player.aseprite --save-as assets/npc-1-walking-1.png
	aseprite -b --layer "blood" --layer "feet" --layer "legs" --layer "arms-normal-1" --layer "head-npc-1" --frame-tag "dead" assets/player.aseprite --save-as assets/npc-1-dead.png
	aseprite -b --layer "feet" --layer "legs" --layer "arms-normal-2" --layer "head-npc-2" --frame-tag "idle" assets/player.aseprite --save-as assets/npc-2-idle.png
	aseprite -b --layer "feet" --layer "legs" --layer "arms-normal-2" --layer "head-npc-2" --frame-tag "walking" assets/player.aseprite --save-as assets/npc-2-walking-1.png
	aseprite -b --layer "blood" --layer "feet" --layer "legs" --layer "arms-normal-2" --layer "head-npc-2" --frame-tag "dead" assets/player.aseprite --save-as assets/npc-2-dead.png
	# box
	aseprite -b --layer "normal" assets/box.aseprite --save-as assets/box.png
	aseprite -b --layer "crushed" assets/box.aseprite --save-as assets/box-crushed.png
	aseprite -b assets/delivery-stop.aseprite --save-as assets/delivery-stop.png
	# car
	aseprite -b --layer "normal" assets/car.aseprite --save-as assets/car-normal.png
	aseprite -b --layer "trunk-open" assets/car.aseprite --save-as assets/car-open-trunk.png
	aseprite -b --layer "passenger-door-open" assets/car.aseprite --save-as assets/car-open-passenger.png
	aseprite -b --layer "driver-door-open" assets/car.aseprite --save-as assets/car-open-driver.png
	# truck
	aseprite -b --layer "normal" assets/player-truck.aseprite --save-as assets/player-truck-normal.png
	aseprite -b --layer "trunk-open" assets/player-truck.aseprite --save-as assets/player-truck-open-trunk.png
	aseprite -b --layer "passenger-door-open" assets/player-truck.aseprite --save-as assets/player-truck-open-passenger.png
	aseprite -b --layer "driver-door-open" assets/player-truck.aseprite --save-as assets/player-truck-open-driver.png
	# stop sign
	aseprite -b --layer "normal" assets/stop-sign.aseprite --save-as assets/stop-sign.png
	aseprite -b --layer "crushed" assets/stop-sign.aseprite --save-as assets/stop-sign-crushed.png

serve:
	rm -rf makelove-build
	makelove lovejs
	unzip -o "makelove-build/lovejs/2024-summer-game-jam-lovejs" -d makelove-build/html/
	echo "http://localhost:8000/makelove-build/html/2024-summer-game-jam/"
	python3 -m http.server
