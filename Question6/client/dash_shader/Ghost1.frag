uniform sampler2D u_Tex0;
varying vec2 v_TexCoord;

void main()
{
	vec4 col = texture2D(u_Tex0, v_TexCoord);	
	if (col.a > 0.8) {
	  col.a = 0.8;
	}
	gl_FragColor = col;
}