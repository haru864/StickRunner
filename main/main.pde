final float ACTION_DIPLAY_X = 570;
final float ACTION_DIPLAY_Y = 30;
final float ACTION_DIPLAY_WIDTH = 200;
final float ACTION_DIPLAY_HEIGHT = 150;
StickFigure stickFigure;
Stage stage;
int goal_time_seconds = -1;

void setup() {
    size(800, 700);
    smooth();
    stickFigure = new StickFigure(width / 2.0 - 100.0, height * 2.0 / 3.0);
    stage = new Stage(stickFigure.getUnderFootCoordY());
}

void draw() {
    if (stage.doGoal(stickFigure)) {
        if (goal_time_seconds == -1) {
            goal_time_seconds = millis();
            return;
        }
        if (millis() - goal_time_seconds <= 2000) {
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
    background(136, 185, 197, 100);
    diplayActionFrame();
    stickFigure.draw();
    stage.draw();
}

void keyPressed() {
    if (goal_time_seconds != -1) {
        return;
    }
    if (key != CODED && key == ' ') {
        diplayActionFigure(ActionButton.SPACE);
    } else if (key == CODED) {
        switch(keyCode) {
            case LEFT:
                diplayActionFigure(ActionButton.LEFT_ARROW);
                stage.moveStage(ActionButton.LEFT_ARROW);
                break;
            case RIGHT:
                diplayActionFigure(ActionButton.RIGHT_ARROW);
                stage.moveStage(ActionButton.RIGHT_ARROW);
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
