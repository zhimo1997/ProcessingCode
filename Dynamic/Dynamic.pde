void setup() {
    size(800, 600);

    fill(255, 125, 125, 100);
    strokeWeight(2);
    smooth();
    drawBand(200, 100, 4, 5);
}

void draw() {
    // drawDynamicBand(200, 100, 4, 5);
}

void drawDynamicBand(float bandWidth, float bandHeight, float xCrestCount, float yCrestCount) {
    float angle = frameCount / frameRate;
    if (angle > TWO_PI) {
        noLoop();
    }
    float x = width * 0.5 + bandWidth * cos((xCrestCount - 1) * frameCount / frameRate);
    float y = height * 0.5 + bandHeight * sin((yCrestCount - 1) * frameCount / frameRate);
    point(x, y);
}

void drawBand(float bandWidth, float bandHeight, float xCrestCount, float yCrestCount) {
    beginShape();
    for (int i = 0; i <= xCrestCount * yCrestCount + 2; i++) {
        float offsetAngle = TWO_PI * (1.0 / (xCrestCount * yCrestCount)) * i;
        float x = width * 0.5 + bandWidth * cos((xCrestCount - 1) * offsetAngle);
        float y = height * 0.5 + bandHeight * sin((yCrestCount - 1) * offsetAngle);
        curveVertex(x, y);
    }
    endShape(CLOSE);
}