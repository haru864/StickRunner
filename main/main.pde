final int COLOR_OF_GAME_BACKGROUND = #A6F0F7;
final int TEXT_SIZE_BIG = 100;
final int TEXT_SIZE_SMALL = 30;
StickFigure stickFigure;
Stage stage;
int goal_time_seconds = -1;

void setup() {
    size(800, 700);
    smooth();
    stickFigure = new StickFigure(width / 2.0 - 100.0, height * 2.0 / 3.0);
    stage = new Stage(stickFigure.getUnderFootCoordY());
    stickFigure.setStage(stage);
}

int x = 0;
int vx = -3;
void draw() {
    if (stickFigure.isGoal() == true) {
        if (goal_time_seconds == -1) {
            goal_time_seconds = millis();
        }
        if (millis() - goal_time_seconds <= 1000) {
            background(220);
            textAlign(CENTER, CENTER);
            textSize(TEXT_SIZE_BIG);
            fill(0);
            text("GOAL!!", width / 2, height / 2);
        } else {
            exit();
        }
        return;
    }
    if (stickFigure.isFallen() == true) {
        textAlign(CENTER, CENTER);
        textSize(TEXT_SIZE_BIG);
        fill(0);
        text("FAILED...", width / 2, height / 2 - TEXT_SIZE_BIG * 0.7);
        textSize(TEXT_SIZE_SMALL);
        text("PRESS ENTER TO RETRY,\nOTHERS TO CLOSE", width / 2, height / 2 + TEXT_SIZE_BIG * 0.5);
        return;
    }
    stickFigure.action();
    background(COLOR_OF_GAME_BACKGROUND);
    stage.draw();
    stickFigure.draw();
}

void keyPressed() {
    if (stickFigure.isGoal() == true) {
        return;
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
