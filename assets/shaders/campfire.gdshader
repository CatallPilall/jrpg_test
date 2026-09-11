shader_type canvas_item;

const float tile_size = 16.0;

// Stärke des Flammen-Wackelns
uniform float wave_speed : hint_range(0.0, 20.0) = 8.0;
uniform float wave_intensity : hint_range(0.0, 0.1) = 0.03;

// Glut-Glühen
uniform float glow_speed : hint_range(0.0, 10.0) = 4.0;
uniform vec4 glow_color : source_color = vec4(1.0, 0.4, 0.1, 1.0); // Orange/Rot

void fragment() {
    // 1. Lokale UVs für genau dieses Tile berechnen (0.0 bis 1.0 innerhalb des Tiles)
    // DFRAGCOORD oder custom UVs: Wir nutzen die Ableitung für kachelinterne Koordinaten
    vec2 tile_uv = fract(UV * (1.0 / TEXTURE_PIXEL_SIZE) / vec2(tile_size)); // Ersetze 32.0 durch deine Tile-Größe in Pixeln!
	
	ivec2 pixel_coord = ivec2(floor(tile_uv * tile_size));

	vec4 tex_color = texture(TEXTURE, UV);

	if //(	(pixel_coord.y <= 11 && pixel_coord.x >= 4 && pixel_coord.x <= 10)
		//||	(pixel_coord.y <= 10 && pixel_coord.x >= 3 && pixel_coord.x <= 11))
		(pixel_coord.y <= 9 && pixel_coord.x >= 6 && pixel_coord.x <= 14)
		{
	    // 2. Welle für die Spitze der Flammen (Verzerrung nach oben hin stärker)
	    // (1.0 - tile_uv.y) bewirkt, dass es unten fest steht und oben wackelt
	    float wave = sin(TIME * wave_speed + tile_uv.y * 10.0) * wave_intensity * (1.0 - tile_uv.y);
	    
	    // 3. Textur mit leicht verschobener UV auslesen
	    vec2 distorted_uv = UV + vec2(wave, 0.0);
	    tex_color = texture(TEXTURE, distorted_uv);

	    // 4. Glut-Effekt: Pulsierendes Glühen im unteren/mittleren Bereich
	    float glow = (sin(TIME * glow_speed) * 0.5 + 0.5); // Wert zwischen 0.0 und 1.0
	    
	    // Nur sichtbare Pixel zum Glühen bringen
	    if (tex_color.a > 0.1 && tile_uv.y > 0.3) {
	        // Mische etwas orange/rotes Licht rein
	        tex_color.rgb += glow_color.rgb * glow * 0.3 * (1.0 - tile_uv.y);
	    }
	}
    COLOR = tex_color;
}