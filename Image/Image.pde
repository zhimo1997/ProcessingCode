void setup() {
    size(800, 600);

    fill(255, 125, 125, 100);
    strokeWeight(2);
    smooth();
}

void draw() {
    // imgFilterTest();
}

void imgFilterTest(){
    // PImage testImage = loadImage("Triangle.png");
    // image(testImage, 0, 0);

    // loadPixels();
    // for (int i = 0; i < pixels.length; i++) {
    //     for (int j = 0; j < pixels[i].length; j++) {
    //         pixels[[]]]
    //     }
    // }
    // updatePixels();

    PImage testImage = loadImage("TS01.jpg");
    testImage.filter(BLUR, 5);
    image(testImage, 0, 0);
}
