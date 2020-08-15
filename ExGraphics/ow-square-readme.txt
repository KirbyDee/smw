Files are as follows:
	ow-square-demo.bps
		A hack containing a demo overworld that I put frankly way too
		much work into. This has all the animations set up, and the
		layer 1 tiles arranged properly (if you try to use SMW's the
		map will be covered in garbage). You should *probably* look
		at this. It should give a decent idea how everything works
		in practice.

	ExGfxA0.bin: FG1
		Terrain tiles for grass, stone, and light grass.
	ExGfxA1.bin: FG2
		Path tiles for grass, stone, and light grass.
	ExGfxA2.bin: FG3
		A bunch of miscellaneous tiles for layer 2.
		This file is laid out to make room for animations as well.
	ExGfxA3.bin: FG4
		Layer 1 tiles.
	ExGfxA4.bin: FG5
		Terrain tiles for snow, colored stone, and deserts.

	Note: In order to enable these slots, make sure you go into the Extra Options
	and check the box that says Merge GFX slots at the bottom.
	ExGfxA5.bin: FG6
		Path tiles for snow, colored stone, and deserts.
	ExGfxA6.bin: FG5
		Terrain tiles for colored stone and giant castles.
		Think of this as a replacement for ExGfxA4: you trade snow
		and deserts for a big castle.
		Basically, this is designed for your classic Bowser submap,
		but you could also put the giant castle on grass for like,
		Peach's castle or something.
		The castle tiles are kind of complex but if you are making a
		simple one you can pretty much just copy it from the demo map.
	ExGfxAF.bin: AN2
		Animated tiles.
	ow-square.pal + ow-square.palmask
		A palette which works with all of the graphics in the tileset.
		This palette should work for pretty basic "Mario-y" stuff
		on a main map. You can look at the demo map for some other
		palettes and ideas, but there's just so many ways to do
		overworld palettes that there's no sense including them all.

Palette layout:
	A palette row is, in order:
		0   transparency
		1   white
		2   black
		3-6 terrain
		7   water
		8-C walls
		D-F accessory colors (used for switch palaces, flowers, etc.)
	Palette 7 is used for most Layer 1 tiles.
	It follows most of the same rules as the other palettes,
	except that color E is the red glow and color F is the yellow glow.

Notes:
	- As shown in the demo map, the palette layout works with the
	lightning from the Valley of Bowser, but it doesn't work with
	the original level dot glow, so you should disable that.
	- These graphics do NOT work with the original layer 1 tiles,
	so you should copy most of them from the demo map.
	- The demo map has events so if you want to see how paths work,
	switch to event mode and hold Page Up for a while.
	- A few tiles are duplicated to keep the layout consistent
	between the terrain files so you don't go insane. I hope the mods
	don't kill me on this one.
	- If you wanna use the demo map in your hack or something that's fine
