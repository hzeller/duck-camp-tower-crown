all : tower.stl

%.stl: %.scad
	openscad -o $@ -d $@.deps $<
