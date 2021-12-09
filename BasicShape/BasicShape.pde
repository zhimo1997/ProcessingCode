void setup() {
    size(800, 600);
    smooth();
    // noStroke();
}

void draw() {
    background(0, 200, 255);
    fill(250, 100, 0);
    stroke(250, 200, 100);
    triangleStrip(width / 2, height / 2, 100, 150, 30, -150, 15);
    triangleFan(width / 2, height / 2, 100, 30, -150, 15);
}

// 这里提取了起始角度作为动态变量，还可以对半径等变量做一些动态修改
void polygeonTest(){
    float offset = (1.0 / frameRate * TWO_PI) * frameCount * 0.3;
    regularPolygeon(width / 2, height / 2, 100, 6, offset);
}

// Regular Polygeon
void regularPolygeon(float x, float y, float radius, int npoints, float offset) {
    beginShape();
    float unitAngle = TWO_PI / npoints;
    // 重新计算起点，第一个点的位置从X轴正方向逆时针
    float offsetAngle = offset + HALF_PI - unitAngle * 0.5 * ((npoints + 1) % 2);
    for (float angle = offsetAngle; angle < offsetAngle + TWO_PI; angle += unitAngle) {
        float pointX = x + radius * cos(angle);
        float pointY = y + radius * sin(angle);
        vertex(pointX, pointY);
    }
    endShape(CLOSE);
}

// TRIANGLE_STRIP 每连续的三个vertex构成一个三角形
void triangleStrip(float x, float y, float innerRadius, float outerRadius, float startAngle, float endAngle, int segments) {
    beginShape(TRIANGLE_STRIP);

    // 对角度进行模操作
    startAngle = radians(startAngle % 360);
    endAngle = radians(endAngle % 360);
    float maxAngle = max(startAngle, endAngle);
    float minAngle = min(startAngle, endAngle);
    float unitAngle = (maxAngle - minAngle) / segments;

    for (float angle = minAngle; angle <= maxAngle; angle += unitAngle) {
        float pointX = x + innerRadius * cos(angle);
        float pointY = y + innerRadius * sin(angle);
        vertex(pointX, pointY);

        pointX = x + outerRadius * cos(angle);
        pointY = y + outerRadius * sin(angle);
        vertex(pointX, pointY);
    }
    endShape();
}

// TRIANGLE_FAN 以第一个顶点为锚点，每两个顶点和锚点构成三角形
void triangleFan(float x, float y, float radius, float startAngle, float endAngle, float segments) {
    beginShape(TRIANGLE_FAN);
    vertex(x, y);
    startAngle = radians(startAngle % 360);
    endAngle = radians(endAngle % 360);
    float maxAngle = max(startAngle, endAngle);
    float minAngle = min(startAngle, endAngle);
    float unitAngle = (maxAngle - minAngle) / segments;
    for (float angle = minAngle; angle <= maxAngle; angle += unitAngle) {
        float pointX = x + radius * cos(angle);
        float pointY = y + radius * sin(angle);
        vertex(pointX, pointY);
    }
    endShape();
}
