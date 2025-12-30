#pragma header

#define ASPECT 1.5;
#define PI 3.14159265359

attribute float alpha;
attribute vec4 colorMultiplier;
attribute vec4 colorOffset;
uniform bool hasColorTransform;

uniform mat4 perspectiveMatrix;
uniform mat4 viewMatrix;
uniform float zOffset;

attribute float vertexXOffset;
attribute float vertexYOffset;
attribute float vertexZOffset;

void main(void)
{
    #pragma body
    
    openfl_Alphav = openfl_Alpha * alpha;
    
    if (hasColorTransform)
    {
        openfl_ColorOffsetv = colorOffset / 255.0;
        openfl_ColorMultiplierv = colorMultiplier;
    }

	vec4 pos = openfl_Position;

	pos.x += vertexXOffset;
	pos.y += vertexYOffset;
	pos = openfl_Matrix * pos;
	pos.z = ((zOffset + vertexZOffset) * 0.001 * 1.5); //need to apply z after so it looks right
	gl_Position = perspectiveMatrix * viewMatrix * pos;
}