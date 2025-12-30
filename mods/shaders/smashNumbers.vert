#pragma header

attribute float alpha;
attribute vec4 colorMultiplier;
attribute vec4 colorOffset;
uniform bool hasColorTransform;

//attribute float vertexXOffset;

uniform float iTime;

void main(void)
{
    openfl_Alphav = openfl_Alpha;
	openfl_TextureCoordv = openfl_TextureCoord;
    
    openfl_Alphav = openfl_Alpha * alpha;
    
    if (hasColorTransform)
    {
        openfl_ColorOffsetv = colorOffset / 255.0;
        openfl_ColorMultiplierv = colorMultiplier;
    }
	vec4 pos = openfl_Position;

    pos.x += cos(iTime*50.0)*iTime*120.0;
    pos.y += sin(iTime*50.0)*iTime*80.0;

	gl_Position = openfl_Matrix * pos;
}