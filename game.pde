float[][] keys = {
	{
		0, 0.8, -1.5
	},
	{
		0.8, -0.8, -3.5
	},
	{-0.8, -0.8, -2.5
	}
};
int currentKey = 0;

float t = 0;

float eyeX = 0, eyeY = 0, eyeZ = 0, centerX = 0, centerY = 0, centerZ = -0.5, upX = 0, upY = 1, upZ = 0;
int curr = 0;
boolean perspective = false;
PImage back;
PShape globe;
PImage[] textures = new PImage[100];
void setup() {
	size(1000, 1000, P3D);
	colorMode(RGB);
	final float CHEK = 0.2;

	for (float zf = -7; zf<-1.1; zf += CHEK) {
		path = new ArrayList < float[][] >();

		for (float xf = -1.5; xf < 1.5; xf += CHEK) {
			float[][] temp = {
				{
					xf, -1, zf
				},
				{
					xf + CHEK, -1, zf
				},
				{
					xf + CHEK, -1, zf + CHEK
				},
				{
					xf, -1, zf + CHEK
				}
			};
			path.add(temp);
		}

		row.add(path);
	}
	//hint(DISABLE_OPTIMIZED_STROKE);
	textureMode(NORMAL); // you want this!
	textures[0] = loadImage("assets/lava.png");
	textures[1] = loadImage("assets/green.png");
	textures[2] = loadImage("assets/circle.png");
	textures[3] = loadImage("assets/orange.png");
	textures[4] = loadImage("assets/wood.png");
	textures[5] = loadImage("assets/triangle.png");
	textures[6] = loadImage("assets/sphere.jpg");
	textures[7] = loadImage("assets/background.png");
	back = loadImage("assets/space.jpg");
	back.resize(1000, 1000);
	// if this isn't set, the textures will clamp (by default): try it
	textureWrap(REPEAT);

}


boolean loop = true;

ArrayList < float[][] > path, rs;
ArrayList < ArrayList<float[][] > > row = new ArrayList < ArrayList<float[][] >>();

int count = 0;
boolean one = true;
boolean check = true, flg = true;
float rockX = 0.0 f, rockY = -0.99 f, rockZ = -1.25 f;
void draw() {
	clear();
	resetMatrix();
	background(back);
	fill(255, 0, 0);
	//stroke(255);
	noStroke();

	if (perspective) {
		frustum(-1, 1, 1, -1, 1, 8);
		camera(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ);
		println("Hello");
	} else {
		ortho(-1, 1, 1, -1, 1, 8);
		camera(0.2, 2, -1.25 + eyeZ, 0.2, 0.4, -1.25 + centerZ, 0, 1, -1);
		//frustum(-1, 1, 1, -1, 1, 8);
		//camera(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ);
	}

	if (flg) {
		rockZ = rockZ - 0.02; //<>//
		eyeZ = eyeZ - 0.02;
		centerZ = centerZ - 0.02;
		curr++;
	}

	if (curr % 10 == 0) {
		rs = row.remove(row.size() - 1);
		ArrayList < float[][] > ls = new ArrayList < float[][] >();

		for (int i = 0; i < rs.size(); i++) {
			float temp[][] = rs.get(i);
			temp[0][2] += -6;
			temp[1][2] += -6;
			temp[2][2] += -6;
			temp[3][2] += -6;
			ls.add(temp);
		}

		row.add(0, ls);
	}

	path_finder(row);
	angle += 0.1;
	pushMatrix();
	translate(rockX, rockY, rockZ);
	rotateY(1.57);

	if (!flg) {
		rotateX(angle);
	}

	drawShape();
	popMatrix();

	if (random(1)<0.05) {
		check = true;
	}

	for (int d = 0; d < asd.size(); d++) {
		obstacle pass = asd.get(d);
		pushMatrix();
		translate(pass.A, pass.B, pass.C);
		scale(0.1, 0.4, 0.1);
		drawCube(textures[7]);
		popMatrix();

		if (-0.3 + rockZ < pass.C + 0.1 && -0.3 + rockZ > pass.C - 0.1) {
			if (rockY > -1 && rockY < -0.6) {
				if (rockX < pass.A + 0.1 && rockX > pass.A - 0.1)
					flg = false;
			} else {
				flg = true;
			}
		}

		if (pass.C > eyeZ) {
			asd.remove(d);
		}
	}

	for (int d = 0; d < asdf.size(); d++) {
		obstacle pb = asdf.get(d);
		pushMatrix();
		translate(pb.A, pb.B, pb.C);
		scale(0.1, 0.1, 0.1);
		fill(231, 76, 60);
		sphere(1.0 f);
		popMatrix();

		if (-0.3 + rockZ < pb.C + 0.1 && -0.3 + rockZ > pb.C - 0.1) {
			if (rockY > -1 && rockY < -0.8) {
				if (rockX < pb.A + 0.1 && rockX > pb.A - 0.1)
					flg = false;
			} else {
				flg = true;
			}
		}

		if (pb.C > eyeZ) {
			asdf.remove(d);
		}
	}

	for (int d = 0; d < jkl.size(); d++) {
		obstacle pb = jkl.get(d);
		pushMatrix();
		translate(pb.A, pb.B + 0.1, pb.C);
		scale(0.1, 0.1, 0.1);
		rotateX(radians(270));
		rotate(ang);
		drawTri(textures[5]);
		popMatrix();

		if (-0.3 + rockZ < pb.C + 0.1 && -0.3 + rockZ > pb.C - 0.1) {
			if (rockY > -1 && rockY < -0.8) {
				if (rockX < pb.A + 0.1 && rockX > pb.A - 0.1)
					flg = false;
			} else {
				flg = true;
			}
		}

		if (pb.C > eyeZ) {
			jkl.remove(d);
		}
	}

	ang += 0.01;
}
float ang = 0.0;

PImage p = textures[0];

void path_finder(ArrayList < ArrayList<float[][] >> row) {
	float[][] temp;
	fill(255, 0, 0);

	for (int i = 0; i < row.size(); i++) {
		ArrayList < float[][] > tempa = row.get(i);

		for (int j = 0; j < tempa.size(); j++) {
			temp = tempa.get(j);

			if (j % 5 == 1) {
				p = textures[1];
			} else if (j % 5 == 2) {
				p = textures[2];
			} else if (j % 5 == 3) {
				p = textures[3];
			} else if (j % 5 == 0) {
				p = textures[0];
			} else if (j % 5 == 4) {
				p = textures[4];
			}

			beginShape(QUADS);
			texture(p);
			vertex(temp[0][0], temp[0][1], temp[0][2], 0, 1);
			vertex(temp[1][0], temp[1][1], temp[1][2], 1, 1);
			vertex(temp[2][0], temp[2][1], temp[2][2], 1, 0);
			vertex(temp[3][0], temp[3][1], temp[3][2], 0, 0);
			endShape();

			if (flg) {
				if (j == (int) random(14) && i == (int) random(30)) {
					if (check) {
						a = (temp[0][0] + temp[1][0] + temp[2][0] + temp[3][0]) / 4;
						b = (temp[0][1] + temp[1][1] + temp[2][1] + temp[3][1]) / 4;
						c = (temp[0][2] + temp[1][2] + temp[2][2] + temp[3][2]) / 4;

						if (random(1)<0.3) {
							ob = new obstacle(a, b, c);
							asd.add(ob);
						} else {
							if (random(1)<0.5) {
								ob = new obstacle(a, 0.1 + b, c);
								asdf.add(ob);
							} else {
								ob = new obstacle(a, b, c);
								jkl.add(ob);
							}
						}
					}

					check = false;
				}
			}
		}
	}

}


ArrayList<obstacle> asd = new ArrayList<obstacle>();
ArrayList<obstacle> asdf = new ArrayList<obstacle>();
ArrayList<obstacle> jkl = new ArrayList<obstacle>();
float a = 0, b = 0, c = 0;
obstacle ob;
boolean check2 = false;
void keyPressed() {

	switch (key) {
		case ' ':
			perspective = !perspective;
			break;
	}

	if (keyCode == RIGHT && rockX  <  1.5) {
		rockX += 0.2;
		flg = true;
	}

	if (keyCode == LEFT && rockX > -1.5) {
		rockX -= 0.2;
		flg = true;
	}

	if (keyCode == UP && rockY < -0.3) {
		rockY += 0.05;
	}

	if (keyCode == DOWN && rockY > -0.99) {
		rockY -= 0.05;
	}

	println("\n");
	println("eye    = (", eyeX + ",", eyeY + ",", eyeZ + ",", ")");
	println("center = (", centerX + ",", centerY + ",", centerZ + ",", ")");
	println("up     = (", upX + ",", upY + ",", upZ + ",", ")");

}


boolean check1 = false;
float[][] rocket = {
	{
		0, 0, -0.1
	},
	{
		0, 0, 0.1
	},
	{
		0.3, 0, 0
	},
	{
		0, 0, 0.1
	},
	{-0.02, 0.05, 0.03
	},
	{
		0.3, 0, 0
	},
	{
		0, 0, -0.1
	},
	{-0.02, 0.05, -0.03
	},
	{
		0.3, 0, 0
	},
	{-0.04, 0.1, 0
	},
	{-0.02, 0.05, -0.03
	},
	{
		0.3, 0, 0
	},
	{-0.04, 0.1, 0
	},
	{-0.02, 0.05, 0.03
	},
	{
		0.3, 0, 0
	},
	{-0.04, 0.1, 0
	},
	{-0.02, 0.05, 0.03
	},
	{-0.02, 0.05, -0.03
	},
	{
		0, 0, 0.1
	},
	{-0.02, 0.05, 0.03
	},
	{-0.02, 0.05, -0.03
	},
	{
		0, 0, -0.1
	},
	{
		0, 0, 0.1
	},
	{-0.02, 0.05, -0.03
	}
};

void drawShape() {
	stroke(0);
	strokeWeight(1.5);
	beginShape(TRIANGLES);

	for (int i = 0; i < rocket.length; i++) {
		if (i < 6 && i > 2 || i > 5 && i  <  9) {
			fill(0, 21, 170);
		} else {
			fill(255, 227, 51);
		}

		vertex(rocket[i][0], rocket[i][1], rocket[i][2]);
	}

	endShape();
	noStroke();
}


void drawCube(PImage ad) {
	beginShape(QUADS);
	texture(ad);
	vertex(-1, -1, 1, 0, 1);
	vertex(-1, 1, 1, 1, 1);
	vertex(1, 1, 1, 1, 0);
	vertex(1, -1, 1, 0, 0);

	vertex(1, -1, 1, 0, 1);
	vertex(1, -1, -1, 1, 1);
	vertex(1, 1, -1, 1, 0);
	vertex(1, 1, 1, 0, 0);

	vertex(1, -1, -1, 0, 1);
	vertex(-1, -1, -1, 1, 1);
	vertex(-1, 1, -1, 1, 0);
	vertex(1, 1, -1, 0, 0);

	vertex(-1, -1, -1, 0, 1);
	vertex(-1, -1, 1, 1, 1);
	vertex(-1, 1, 1, 1, 0);
	vertex(-1, 1, -1, 0, 0);

	vertex(-1, 1, 1, 0, 1);
	vertex(1, 1, 1, 1, 1);
	vertex(1, 1, -1, 1, 0);
	vertex(-1, 1, -1, 0, 0);

	vertex(1, -1, 1, 0, 1);
	vertex(-1, -1, 1, 1, 1);
	vertex(-1, -1, -1, 1, 0);
	vertex(1, -1, -1, 0, 0);
	endShape();
}


float angle = 0;
void Axis() {
	//1
	stroke(255, 0, 0);
	strokeWeight(1.5);
	line(0, 0, 0, 1, 0, 0);
	//2
	stroke(0, 255, 0);
	strokeWeight(1.5);
	line(0, 0, 0, -1, 0, 0);
	//3
	stroke(0, 0, 255);
	strokeWeight(1.5);
	line(0, 0, 0, 0, 1, 0);
	//4
	stroke(255, 255, 0);
	strokeWeight(1.5);
	line(0, 0, 0, 0, -1, 0);
	//5
	stroke(255, 0, 255);
	strokeWeight(1.5);
	line(0, 0, 0, 0, 0, 1);
	//6
	stroke(0, 255, 255);
	strokeWeight(1.5);
	line(0, 0, 0, 0, 0, -1);
}
void keyReleased() {
	//check = false;
}


public class obstacle {

	float A;
	float B;
	float C;

	public obstacle(float a, float b, float c) {
		A = a;
		B = b;
		C = c;
	}

}


void drawTri(PImage p) {
	beginShape(TRIANGLES);
	texture(p);
	vertex(-1, -1, -1, 0, 1);
	vertex(1, -1, -1, 1, 1);
	vertex(0, 0, 1, 1, 0);

	vertex(1, -1, -1, 0, 1);
	vertex(1, 1, -1, 1, 1);
	vertex(0, 0, 1, 1, 0);

	vertex(1, 1, -1, 0, 1);
	vertex(-1, 1, -1, 1, 1);
	vertex(0, 0, 1, 1, 0);

	vertex(-1, 1, -1, 0, 1);
	vertex(-1, -1, -1, 1, 1);
	vertex(0, 0, 1, 1, 0);
	endShape();
}