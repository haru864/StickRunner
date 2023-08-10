void setup() {
    size(800, 800);
    background(255);
    for (int deg = 0; deg <= 360; deg++) {
        float rad = radians(deg);
        println("deg:" + deg + ", rad:" + rad + ", " + (PI == rad));
    }
}

void draw() {
}
