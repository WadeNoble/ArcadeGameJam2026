shader_type canvas_item;

uniform float scroll_speed = .1;

void vertex() {
	// Called for every vertex the material is visible on.
	UV.x += TIME * scroll_speed;
	UV.y += TIME * scroll_speed*.5;
}
