void setup() {
    size(800, 600);
    smooth();

    // strokeJoin(ROUND);
    // strokeCap(ROUND);
}

void draw() {
    background(0, 200, 255);
    fill(250, 100, 0);
    // stroke(250, 200, 100);

    starTest();
    // beginShape();
    // curveVertex(0.3 * width, 0.3 * height);
    // curveVertex(0.7 * width, 0.3 * height);
    // curveVertex(0.7 * width, 0.7 * height);
    // curveVertex(0.3 * width, 0.7 * height);
    // curveVertex(0.3 * width, 0.3 * height);
    // curveVertex(0.7 * width, 0.3 * height);
    // curveVertex(0.7 * width, 0.7 * height);

    // endShape();
}


// -----------------------------------------------Regular Polygeon Begin--------------------------------------------


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


// -----------------------------------------------Regular Polygeon End--------------------------------------------


// --------------------------------------------------Triangle Begin------------------------------------------------


void triangleTest() {
    // triangleStrip(width / 2, height / 2, 100, 150, 30, -150, 15);
    triangleFan(width / 2, height / 2, 100, 0, -320, 15);
}

// TRIANGLE_STRIP 每连续的三个vertex构成一个三角形
void triangleStrip(float x, float y, float innerRadius, float outerRadius, float startAngle, float endAngle, int segments) {
    beginShape(TRIANGLE_STRIP);

    // 对角度进行模操作
    startAngle = radians(startAngle % 360.001);
    endAngle = radians(endAngle % 360.001);
    float maxAngle = max(startAngle, endAngle);
    float minAngle = min(startAngle, endAngle);
    if ((maxAngle - minAngle) == 0){
        maxAngle = minAngle + TWO_PI;
    }
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
void triangleFan(float x, float y, float radius, float startAngle, float endAngle, int segments) {
    beginShape(TRIANGLE_FAN);
    vertex(x, y);
    startAngle = radians(startAngle % 360);
    endAngle = radians(endAngle % 360);
    float maxAngle = max(startAngle, endAngle);
    float minAngle = min(startAngle, endAngle);
    if ((maxAngle - minAngle) == 0){
        maxAngle = minAngle + TWO_PI;
    }
    float unitAngle = (maxAngle - minAngle) / segments;

    for (float angle = minAngle; angle <= maxAngle; angle += unitAngle) {
        float pointX = x + radius * cos(angle);
        float pointY = y + radius * sin(angle);
        vertex(pointX, pointY);
    }
    endShape();
}


// --------------------------------------------------Triangle End------------------------------------------------


// --------------------------------------------------Star Begin------------------------------------------------

void starTest(){
    translate(width / 2, height / 2);
    // rotate(TWO_PI * (frameCount / frameRate) * 0.03);

    // star(width / 2, height / 2, 50, 150, 0, 360, 6);
    // singleStarGrow(width / 2, height / 2, 50, 200, 0, 360, 3);
    multiStarGrow(0, 0, 50, 200, 3, 12);
}

// curve star
void star(float x, float y, float innerRadius, float outerRadius, float startAngle, float endAngle, float npoints) {
    beginShape();

    // 对角度进行模操作
    startAngle = radians(startAngle % 360);
    endAngle = radians(endAngle % 360);
    float maxAngle = max(startAngle, endAngle);
    float minAngle = min(startAngle, endAngle);
    if ((maxAngle - minAngle) == 0){
        maxAngle = minAngle + TWO_PI;
    }
    float unitAngle = (maxAngle - minAngle) / npoints;

    for (float angle = minAngle; angle <= maxAngle; angle += unitAngle) {
        float pointX = x + innerRadius * cos(angle - 0.5 * unitAngle);
        float pointY = y + innerRadius * sin(angle - 0.5 * unitAngle);
        curveVertex(pointX, pointY);

        pointX = x + outerRadius * cos(angle);
        pointY = y + outerRadius * sin(angle);
        curveVertex(pointX, pointY);
    }

    // 注意curve曲线的前四个点中，第一个点是控制点，真正开始绘制从第二个点，所以走一圈也要回到这个点闭合才能绘制出完成闭合的效果
    float endX = x + outerRadius * cos(minAngle);
    float endY = y + outerRadius * sin(minAngle);
    curveVertex(endX, endY);
    endShape(CLOSE);
}


float growScale = 0;
float currentGrowTime = 0;
float growDuration = 2;
float growInterval = 1;
float lastAngleCount = 0;

void multiStarGrow(float x, float y, float innerRadius, float outerRadius, int startCount, int endCount) {
    currentGrowTime = (1 / frameRate) * frameCount;
    int npoints = startCount + floor(currentGrowTime / (growDuration + growInterval));            
    npoints = min(npoints, endCount);
    if (lastAngleCount != npoints){
        lastAngleCount = npoints;
        growScale = 0;
        currentGrowTime = 0;
    }
    fill(50 + 100 * growScale, 255 * norm(npoints, startCount, endCount), 225);
    singleStarGrow(x, y, innerRadius, outerRadius, 0, 360, npoints);
    println(npoints);
}

void singleStarGrow(float x, float y, float innerRadius, float outerRadius, float startAngle, float endAngle, int npoints) {
    beginShape();

    // 对角度进行模操作
    startAngle = radians(startAngle % 360);
    endAngle = radians(endAngle % 360);
    float maxAngle = max(startAngle, endAngle);
    float minAngle = min(startAngle, endAngle);
    if ((maxAngle - minAngle) == 0){
        maxAngle = minAngle + TWO_PI;
    }
    float unitAngle = (maxAngle - minAngle) / npoints;
    growScale += (1 / frameRate) / growDuration;
    growScale = min(growScale, 1);
    float targetPoints = npoints + 1;
    float targetUnitAngle = (maxAngle - minAngle) / (npoints + 1);
    float growRadius = lerp(innerRadius, outerRadius, growScale);

    for (float i = 0; i <= targetPoints; i++) {
        float index = i % targetPoints;
        float angle = minAngle + unitAngle * (index - 1);
        float angle1 = angle - 0.5 * unitAngle;
        float angle2 = angle;
        float radius1 = innerRadius;
        float radius2 = outerRadius;

        if (index == 0) {
            angle1 = angle1 + unitAngle;
            angle2 = angle2 + unitAngle;
        }else if (index % targetPoints == 1) {
            angle1 = angle1 + 0.75 * unitAngle;
            angle2 = angle2 + 0.5 * unitAngle;
            radius2 = growRadius;
        }else if (index % targetPoints == 2) {
            angle1 = angle1 + 0.25 * unitAngle;
        }

        float targetAngle = minAngle + targetUnitAngle * index;
        float targetAngle1 = targetAngle - 0.5 * targetUnitAngle;
        float targetAngle2 = targetAngle;
        angle1 = lerp(angle1, targetAngle1, growScale);
        angle2 = lerp(angle2, targetAngle2, growScale);

        float pointX1 = x + radius1 * cos(angle1);
        float pointY1 = y + radius1 * sin(angle1);
        float pointX2 = x + radius2 * cos(angle2);
        float pointY2 = y + radius2 * sin(angle2);
        curveVertex(pointX1, pointY1);
        curveVertex(pointX2, pointY2);
        // circle(pointX1, pointY1, 10);
        // circle(pointX2, pointY2, 10);
    }

    float endX = x + outerRadius * cos(minAngle);
    float endY = y + outerRadius * sin(minAngle);
    curveVertex(endX, endY);
    endShape(CLOSE);
}

// --------------------------------------------------Star End------------------------------------------------
