final int COLOR_OF_GAME_BACKGROUND = #A6F0F7;
final int TEXT_SIZE_BIG = 100;
final int TEXT_SIZE_SMALL = 30;
StickFigure stickFigure;
Stage stage;

void setup() {
    size(800, 700);
    smooth();
    stickFigure = new StickFigure(width / 2.0 - 100.0, height * 2.0 / 3.0);
    stage = new Stage(stickFigure.getUnderFootCoordY());
    stickFigure.setStage(stage);
}

void draw() {
    if (stickFigure.isGoal() == true) {
        displayMessage("GOAL!!", "PRESS ANY KEY TO CLOSE", #D6F920);
        return;
    }
    if (stickFigure.isFallen() == true) {
        displayMessage("FAILED...", "PRESS ENTER TO RETRY,\nOTHERS TO CLOSE");
        return;
    }
    background(COLOR_OF_GAME_BACKGROUND);
    displayManual();
    stickFigure.action();
    stage.draw();
    stickFigure.draw();
}

void keyPressed() {
    if (stickFigure.isGoal() == true) {
        exit();
    }
    if (stickFigure.isFallen() == true) {
        if (key != CODED && key == ENTER) {
            setup();
        } else {
            exit();
        }
        return;
    }
    if (key != CODED && key == ' ') {
        stickFigure.jump();
    } else if (key == CODED) {
        switch(keyCode) {
            case LEFT:
                stickFigure.moveLeft();
                break;
            case RIGHT:
                stickFigure.moveRight();
                break;
            case DOWN:
                stickFigure.stop();
                break;
        }
    }
}

void displayMessage(String title, String message, int...hexColorCode) {
    if (hexColorCode.length == 1) {
        background(hexColorCode[0]);
    }
    textAlign(CENTER, CENTER);
    textSize(TEXT_SIZE_BIG);
    fill(0);
    text(title, width / 2, height / 2 - TEXT_SIZE_BIG * 0.7);
    textSize(TEXT_SIZE_SMALL);
    text(message, width / 2, height / 2 + TEXT_SIZE_BIG * 0.5);
    return;
}

void displayManual() {
    textAlign(CENTER, CENTER);
    textSize(TEXT_SIZE_SMALL);
    fill(0);
    text("←:running to the left", width / 2, 10);
    text("→:running to the right", width / 2, 40);
    text("↑:stop running", width / 2, 70);
    text("SPACE:running to the left", width / 2, 100);
}
