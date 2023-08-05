final float ACTION_DIPLAY_X = 570;
final float ACTION_DIPLAY_Y = 30;
final float ACTION_DIPLAY_WIDTH = 200;
final float ACTION_DIPLAY_HEIGHT = 150;
StickFigure stickFigure;

void setup() {
    size(800, 700);
    smooth();
    background(136, 185, 197, 100);
}

void draw() {
    final int x = 250;
    final int y = 250;
    stickFigure = new StickFigure(width / 2 - 100, height * 2 / 3);
    stickFigure.draw();
    diplayActionFrame();
}

void keyPressed() {
    if (key != CODED && key == ' ') {
        diplayActionFigure(ActionButton.SPACE);
    } else if (key == CODED) {
        switch(keyCode) {
            case LEFT:
                diplayActionFigure(ActionButton.LEFT_ARROW);
                break;
            case RIGHT:
                diplayActionFigure(ActionButton.RIGHT_ARROW);
                break;
        }
    }
}

void diplayActionFrame() {
    rectMode(CORNER);
    fill(136, 185, 197);
    rect(ACTION_DIPLAY_X, ACTION_DIPLAY_Y, ACTION_DIPLAY_WIDTH, ACTION_DIPLAY_HEIGHT);
}

void diplayActionFigure(ActionButton actBtn) {
    rectMode(CORNER);
    fill(153);
    switch(actBtn) {
        case LEFT_ARROW:
            triangle(ACTION_DIPLAY_X + 150, ACTION_DIPLAY_Y + 20, ACTION_DIPLAY_X + 150, ACTION_DIPLAY_Y + 120, ACTION_DIPLAY_X + 50, ACTION_DIPLAY_Y + 70);
            break;
        case RIGHT_ARROW:
            triangle(ACTION_DIPLAY_X + 50, ACTION_DIPLAY_Y + 20, ACTION_DIPLAY_X + 50, ACTION_DIPLAY_Y + 120, ACTION_DIPLAY_X + 150, ACTION_DIPLAY_Y + 70);
            break;
        case SPACE:
            triangle(ACTION_DIPLAY_X + ACTION_DIPLAY_WIDTH / 2.0, ACTION_DIPLAY_Y + 20, ACTION_DIPLAY_X + 50, ACTION_DIPLAY_Y + 120, ACTION_DIPLAY_X + 150, ACTION_DIPLAY_Y + 120);
            break;
    }
}
