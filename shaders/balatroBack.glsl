extern number time;

#define SPIN_ROTATION -2.0
#define SPIN_SPEED 7.0
#define OFFSET vec2(0.0)
#define COLOUR_1 vec4(0.921, 0.568, 0, 1.0)
#define COLOUR_2 vec4(0.0, 0.921, 0.568, 1.0)
#define COLOUR_3 vec4(0.568, 0, 0.921, 1.0)
#define CONTRAST 3.5
#define LIGTHING 0.4
#define SPIN_AMOUNT 0.25
#define PIXEL_FILTER 360.0
#define SPIN_EASE 1.0
#define PI 3.14159265359
#define IS_ROTATE false

vec4 effect(vec4 color, Image img, vec2 texcoord, vec2 screen_coords)
{
    vec2 screenSize = love_ScreenSize.xy;
    float pixel_size = length(screenSize) / PIXEL_FILTER;

    // pixelated UV
    vec2 uv = (floor(screen_coords / pixel_size) * pixel_size - 0.5 * screenSize) / length(screenSize) - OFFSET;
    float uv_len = length(uv);

    float speed = SPIN_ROTATION * SPIN_EASE * 0.2;
    if(IS_ROTATE){
        speed = time * speed;
    }
    speed += 302.2;

    float new_pixel_angle = atan(uv.y, uv.x) + speed - SPIN_EASE * 20.0 * (SPIN_AMOUNT * uv_len + (1.0 - SPIN_AMOUNT));

    vec2 mid = (screenSize / length(screenSize)) / 2.0;
    uv = vec2(
        uv_len * cos(new_pixel_angle) + mid.x,
        uv_len * sin(new_pixel_angle) + mid.y
    ) - mid;

    uv *= 30.0;
    speed = time * SPIN_SPEED;

    vec2 uv2 = vec2(uv.x + uv.y, uv.x + uv.y);

    // Loop with temporary variables for component-wise operations
    for(int i = 0; i < 5; i++) {
        float tmp_sin = sin(max(uv.x, uv.y));
        uv2.x += tmp_sin + uv.x;
        uv2.y += tmp_sin + uv.y;

        float tmp_cos = cos(5.1123314 + 0.353 * uv2.y + speed * 0.131121);
        float tmp_sin2 = sin(uv2.x - 0.113 * speed);
        uv.x += 0.5 * tmp_cos;
        uv.y += 0.5 * tmp_sin2;

        float tmp3 = cos(uv.x + uv.y) - sin(uv.x * 0.711 - uv.y);
        uv -= vec2(tmp3, tmp3);
    }

    float contrast_mod = 0.25 * CONTRAST + 0.5 * SPIN_AMOUNT + 1.2;
    float paint_res = clamp(length(uv) * 0.035 * contrast_mod, 0.0, 2.0);
    float c1p = max(0.0, 1.0 - contrast_mod * abs(1.0 - paint_res));
    float c2p = max(0.0, 1.0 - contrast_mod * abs(paint_res));
    float c3p = 1.0 - min(1.0, c1p + c2p);

    float light = (LIGTHING - 0.2) * max(c1p * 5.0 - 4.0, 0.0) + 
                  LIGTHING * max(c2p * 5.0 - 4.0, 0.0);

    vec4 final_color = (0.3 / CONTRAST) * COLOUR_1 +
                       (1.0 - 0.3 / CONTRAST) * (
                            COLOUR_1 * c1p + 
                            COLOUR_2 * c2p + 
                            vec4(c3p * COLOUR_3.rgb, c3p * COLOUR_1.a)
                       ) + light;

    return final_color * color; // multiply by input color for LOVE2D
}
