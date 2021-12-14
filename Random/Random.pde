
void setup() {
    size(800, 600);
    stroke(100, 150, 200);
    // fill(100, 150, 200);
    noFill();
    strokeWeight(4);

    // frameRate(5);
    // noiseGraph_1D();
    // noiseGraph_2D();
    // drawNoiseCircle(width * 0.5, height * 0.5, 200);

    // background(0);
    // colorMode(HSB);
    // centerY = height * 0.5;
}

void draw() {
    background(0);
    drawNoiseCircle(width * 0.5, height * 0.5, 200, 0.2 * frameCount);

    // drawNoiseCircle_Dynamic(150, 500);
    // background(100, 100, 100, 255);
    // noiseSeed(frameCount);
    // noiseGraph_1D_Close();
}


// 注意采样间隔影响采样结果的平滑性，越小越平缓
void noiseGraph_1D() {
    float sampleInterval = 0.02;
    PVector lastPoint = new PVector(0.0, noise(0) * height);
    PVector currentPoint = new PVector(0.0, 0.0);
    
    for(int i = 2; i <= width; i+=2) {
        currentPoint.x = i;
        currentPoint.y = noise(currentPoint.x * sampleInterval) * height;
        line(lastPoint.x, lastPoint.y, currentPoint.x, currentPoint.y);
        lastPoint.x = currentPoint.x;
        lastPoint.y = currentPoint.y;
    }
}

void noiseGraph_1D_Close() {
    beginShape();
    float sampleInterval = 0.02;
    
    vertex(0, height);
    for(int i = 0; i <= width; i+=2) {
        vertex(i, noise(i * sampleInterval) * height);
    }
    vertex(width, height);
    endShape(CLOSE);
}


void noiseGraph_2D() {
    float sampleInterval = 0.02;
    loadPixels();
    float pixelCount = pixels.length;
    
    // 第一种循环方式
    // for (int i = 0; i < pixelCount; i++) {
    //     float row = floor(i / width);
    //     float column = i % width;
    //     pixels[i] = color(255 * noise(row * sampleInterval, column * sampleInterval), 0, 255);
    // }

    // 第二种遍历方式
    for (int i = 0; i < width; i++) {
        for (int j = 0; j < height; j++) {
            pixels[i + j * width] = color(255 * noise(i * sampleInterval, j * sampleInterval), 0, 255);
        }
    }
    updatePixels();
}

void drawNoiseCircle(float centerX, float centerY, float radius, float sampleOffset) {
    float sampleInterval = 0.01;
    float unitAngle =  TWO_PI / 360;
    beginShape();
    for (float angle = 0; angle <= TWO_PI; angle += unitAngle * 4 ) {
        float x = centerX + radius * cos(angle * sampleInterval);
        float y = centerY + radius * sin(angle * sampleInterval);
        float noise_radius = map(noise(x + sampleOffset, y + sampleOffset), 0, 1, 0.4, 1) * radius;
        float pointX = centerX + noise_radius * cos(angle);
        float pointY = centerY + noise_radius * sin(angle);
        vertex(pointX, pointY);
        strokeWeight(2);
        line(centerX, centerY, pointX, pointY);
    }
    strokeWeight(4);
    endShape(CLOSE);
}


float xOffset = 0;
float yOffset = 0;
float centerX;
float centerY;

void drawNoiseCircle_Dynamic(float radius, int npts) {
    stroke(frameCount % 255, 128, 255, 64);

    beginShape();
    for (int i = 0; i < npts; i++){
        float angle = i * TWO_PI / npts;
        PVector p = new PVector(cos(angle), sin(angle));
        float noise_radius = radius * noise(xOffset + p.x, yOffset + p.y);
        p.mult(noise_radius);
        vertex(centerX + p.x, centerY + p.y);
    }
    endShape(CLOSE);

    xOffset += 0.006;
    yOffset += 0.006;

    centerX++;
    if (centerX > width) {
        background(0);
        centerX = 0;
    }
}
