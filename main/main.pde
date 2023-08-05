void setup() {
    size(800, 700);
    smooth();
    background(136, 185, 197, 100);
}

void draw() {
    final int x = 250;
    final int y = 250;
    StickFigure sf = new StickFigure(width / 2 - 100, height * 2 / 3);
    sf.draw();
}
