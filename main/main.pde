final int COLOR_OF_GAME_BACKGROUND = #A6F0F7;
StickFigure stickFigure;
Stage stage;
int goal_time_seconds = -1;

void setup() {
    size(800, 700);
    smooth();
    stickFigure = new StickFigure(width / 2.0 - 100.0, height * 2.0 / 3.0);
    stage = new Stage(stickFigure.getUnderFootCoordY());
    stickFigure.updateObjectCoord(stage.GOAL_FLAG_X, stage.START_WALL_X + stage.START_WALL_WIDTH);
}

void draw() {
    if (stickFigure.isGoal() == true) {
        if (goal_time_seconds == -1) {
            goal_time_seconds = millis();
            return;
        }
        if (millis() - goal_time_seconds <= 1000) {
            background(220);
            textAlign(CENTER, CENTER);
            textSize(100);
            fill(0);
            text("GOAL!!", width / 2, height / 2);
        } else {
            exit();
        }
        return;
    }
    background(COLOR_OF_GAME_BACKGROUND);
    stickFigure.draw();
    stage.draw();
}

void keyPressed() {
    if (goal_time_seconds != -1) {
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
