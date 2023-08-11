import java.util.HashSet;

public class StickFigure  {
    
    private final float HEAD_DIAMETER = 40;
    private final float NECK_LENGTH = 18;
    private final float DISTANCE_FROM_CHEST_TO_INSEAM = 45;
    private final float DISTANCE_FROM_INSEAM_TO_FOOT = 50;
    private final float MOVE_SPEED = 5;
    private final float HITBOX_WIDTH = 60;
    private Stage stage;
    private float chest_x;
    private float chest_y;
    private float initial_chest_y;
    private StickFigureStatus status;
    private float velocity_y = 0;
    private float velocity_x = 0;
    private float scrolled_x = 0;
    private float gravity = 0.5;
    private float initial_jump_velocity_y = -15;
    private float minAngle = 0.2 * PI;
    private float maxAngle = 0.8 * PI;
    private float arm_r_deg, arm_l_deg, leg_r_deg, leg_l_deg;
    private float arm_length = 40;
    private float leg_length = 50;
    private float angular_velocity = 2.0;
    
    public StickFigure(float chest_x, float chest_y) {
        this.chest_x = chest_x;
        this.chest_y = chest_y;
        this.initial_chest_y = chest_y;
        this.status = StickFigureStatus.STOPPED;
    }
    
    public void setStage(Stage stage) {
        this.stage = stage;
    }
    
    public float getUnderFootCoordY() {
        return chest_y + DISTANCE_FROM_CHEST_TO_INSEAM + DISTANCE_FROM_INSEAM_TO_FOOT;
    }
    
    public boolean isGoal() {
        return(chest_x - HITBOX_WIDTH / 2) > stage.GOAL_FLAG_X;
    }
    
    public boolean isFallen() {
        float head_top_y = chest_y - NECK_LENGTH - HEAD_DIAMETER;
        return head_top_y > height;
    }
    
    public void changeActionByKey(ActionButton actBtn) {
        if (status == StickFigureStatus.JUMPING
            || status == StickFigureStatus.FALLING) {
            return;
        }
        switch(actBtn) {
            case LEFT_ARROW:
                moveLeft();
                break;	
            case RIGHT_ARROW:
                moveRight();
                break;	
            case DOWN_ARROW:
                stop();
                break;	
            case SPACE:
                jump();
                break;	
        }
    }
    
    private void moveLeft() {
        velocity_x = MOVE_SPEED;
        velocity_y = 0;
        chest_y = initial_chest_y;
        status = StickFigureStatus.RUNNING_LEFT;
        setInitialRunningArmDegree();
    }
    
    private void moveRight() {
        velocity_x = -1 * MOVE_SPEED;
        velocity_y = 0;
        chest_y = initial_chest_y;
        status = StickFigureStatus.RUNNING_RIGHT;
        setInitialRunningArmDegree();
    }
    
    private void jump() {
        velocity_y = initial_jump_velocity_y;
        status = StickFigureStatus.JUMPING;
    }
    
    private void stop() {
        velocity_x = 0;
        velocity_y = 0;
        chest_y = initial_chest_y;
        status = StickFigureStatus.STOPPED;
    }
    
    private void fall() {
        velocity_x = 0;
        velocity_y = gravity;
        status = StickFigureStatus.FALLING;
    }
    
    private void setInitialRunningArmDegree() {
        arm_r_deg = 70;
        arm_l_deg = 90 + (90 - arm_r_deg);
        leg_r_deg = 70;
        leg_l_deg = 90 + (90 - leg_r_deg);
    }
    
    private void freefall() {
        if (status == StickFigureStatus.JUMPING
            && chest_y + velocity_y > initial_chest_y
            && stage.isHoleX(chest_x) == false) {
            if (velocity_x > 0) { // jumping to the left
                moveLeft();
            } else if (velocity_x < 0) { // jumping to the right
                moveRight();
            } else {
                stop();
            }
            return;
        }
        velocity_y += gravity;
        chest_y += velocity_y;
    }
    
    private void moveSideways() {
        if (doPassStartWall() == true || doPassHoleWall() == true) {
            if (status != StickFigureStatus.JUMPING) {
                stop();
            }
            return;
        }
        if ((status == StickFigureStatus.RUNNING_LEFT 
            || status == StickFigureStatus.RUNNING_RIGHT)
            && isOnHole() == true) {
            fall();
            return;
        }
        scrolled_x += velocity_x;
        chest_x += (velocity_x * - 1);
    }
    
    private boolean isOnHole() {
        return stage.isHoleX(chest_x) && chest_y >= initial_chest_y;
    }
    
    private boolean doPassStartWall() {
        float future_body_left_edge_x = chest_x - HITBOX_WIDTH / 2 + (velocity_x * - 1);
        float start_wall_right_edge_x = stage.START_WALL_X + stage.START_WALL_WIDTH;
        return future_body_left_edge_x <= start_wall_right_edge_x;
    }
    
    private boolean doPassHoleWall() {
        if (chest_y <= initial_chest_y) {
            return false;
        }
        float future_body_left_edge_x = chest_x - HITBOX_WIDTH / 2 + (abs(velocity_x) * - 1);
        float future_body_right_edge_x = chest_x + HITBOX_WIDTH / 2 + abs(velocity_x);
        return stage.isHoleX(future_body_left_edge_x) == true
            || stage.isHoleX(future_body_right_edge_x) == true;
    }
    
    public void action() {
        println("status:" + stickFigure.status + ", vy:" + velocity_y);
        if (status == StickFigureStatus.JUMPING) {
            freefall();
            moveSideways();
        } else if (status == StickFigureStatus.FALLING) {
            freefall();
        } else if (status == StickFigureStatus.STOPPED) {
            // do nothing
        } else if (status == StickFigureStatus.RUNNING_LEFT
            || status == StickFigureStatus.RUNNING_RIGHT) {
            moveSideways();
        }
        translate(scrolled_x, 0);
    }
    
    public void draw() {
        switch(status) {
            case STOPPED :
                arm_r_deg = 70;
                leg_r_deg = 70;
                drawSymmetricalBody();
                break;
            case RUNNING_LEFT:
            case RUNNING_RIGHT:
                arm_r_deg += angular_velocity;
                leg_r_deg += angular_velocity;
                if (radians(arm_r_deg) > maxAngle
                    || radians(arm_r_deg) < minAngle) {
                    angular_velocity *= -1;
                }
                drawSymmetricalBody();
                break;	
            case JUMPING:
                if (velocity_x > 0) { // running to the left
                    arm_r_deg = 90 - 70;
                    arm_l_deg = 180 + 40;
                    leg_r_deg = 90 - 50;
                    leg_l_deg = 180 + 10;
                    drawAsymmetricalBody();
                } else if (velocity_x < 0) { // running to the right
                    arm_r_deg = 0 - 40;
                    arm_l_deg = 90 + 70;
                    leg_r_deg = 0 + 10;
                    leg_l_deg = 90 + 50;
                    drawAsymmetricalBody();
                } else { // stopping
                    arm_r_deg = 80;
                    leg_r_deg = 85;
                    drawSymmetricalBody();
                }
                break;
            case FALLING:
                arm_r_deg = -40;
                leg_r_deg = 50;
                drawSymmetricalBody();
                break;
        }
    }
    
    private void drawSymmetricalBody() {
        arm_l_deg = 90 + (90 - arm_r_deg);
        leg_l_deg = 90 + (90 - leg_r_deg);
        drawAsymmetricalBody();
    }
    
    private void drawAsymmetricalBody() {
        float head_x = chest_x;
        float head_y = chest_y - NECK_LENGTH - HEAD_DIAMETER * 0.5;
        float inseam_x = chest_x;
        float inseam_y = chest_y + DISTANCE_FROM_CHEST_TO_INSEAM;
        // draw head
        fill(255);
        ellipseMode(CENTER);
        ellipse(head_x, head_y, HEAD_DIAMETER, HEAD_DIAMETER);
        // draw neck
        strokeWeight(2);
        line(chest_x, chest_y, chest_x, chest_y - NECK_LENGTH);
        // draw arms
        float hand_r_x = chest_x + arm_length * cos(radians(arm_r_deg));
        float hand_r_y = chest_y + arm_length * sin(radians(arm_r_deg));
        float hand_l_x = chest_x + arm_length * cos(radians(arm_l_deg));
        float hand_l_y = chest_y + arm_length * sin(radians(arm_l_deg));
        line(chest_x, chest_y, hand_r_x, hand_r_y);
        line(chest_x, chest_y, hand_l_x, hand_l_y);
        // draw torso
        line(chest_x, chest_y, inseam_x, inseam_y);
        // draw legs
        float foot_r_x = inseam_x + leg_length * cos(radians(leg_r_deg));
        float foot_r_y = inseam_y + leg_length * sin(radians(leg_r_deg));
        float foot_l_x = inseam_x + leg_length * cos(radians(leg_l_deg));
        float foot_l_y = inseam_y + leg_length * sin(radians(leg_l_deg));
        line(inseam_x, inseam_y, foot_r_x, foot_r_y);
        line(inseam_x, inseam_y, foot_l_x, foot_l_y);
    }
}

public class Stage {
    
    private final int COLOR_OF_STAGE = #BA5039;
    private final int COLOR_OF_HOLE = #DACCB5;
    private final int COLOR_OF_FLAG = #F84157;
    private final int COLOR_OF_WALL = #BBA1A4;
    private final float STAGE_WIDTH = 2000;
    private final float HOLE_WIDTH = 200;
    final float START_WALL_WIDTH = 20;
    private final float START_WALL_HEIGHT = height * 3.0 / 5.0;
    private final float GOAL_FLAG_HEIGHT = height * 3.0 / 5.0;
    final float START_WALL_X = 50;
    final float GOAL_FLAG_X = STAGE_WIDTH - 150;
    private float SURFACE_HEIGHT;
    private final ArrayList<Float> HOLE_LEFT_EDGE_X_LIST = new ArrayList<Float>() {
        {
            add(600.0);
            add(1100.0);
            add(1400.0);
        }
    };
    private final HashSet<Integer> HOLE_X_SET = new HashSet<>();
    
    public Stage(final float underfoot_y) {
        SURFACE_HEIGHT = height - underfoot_y;
        for (float holeLeftEdge : HOLE_LEFT_EDGE_X_LIST) {
            for (int diff_x = 0; diff_x <= HOLE_WIDTH; diff_x++) {
                HOLE_X_SET.add((int)holeLeftEdge + diff_x);
            }
        }
    }
    
    public boolean isHoleX(float x) {
        return HOLE_X_SET.contains(int(x));
    }
    
    public void draw() {
        // DRAW WHOLE STAGE
        fill(COLOR_OF_STAGE);
        rect(0, height - SURFACE_HEIGHT, STAGE_WIDTH, SURFACE_HEIGHT);
        // DRAW HOLES
        fill(COLOR_OF_HOLE);
        stroke(COLOR_OF_HOLE);
        for (float holeLeftEdgeX : HOLE_LEFT_EDGE_X_LIST) {
            rect(holeLeftEdgeX, height - SURFACE_HEIGHT, HOLE_WIDTH, SURFACE_HEIGHT);
            line(holeLeftEdgeX, height - SURFACE_HEIGHT, holeLeftEdgeX + HOLE_WIDTH, height - SURFACE_HEIGHT);
        }
        stroke(0);
        // DRAW START WALL
        fill(COLOR_OF_WALL);
        rect(START_WALL_X, height - SURFACE_HEIGHT - GOAL_FLAG_HEIGHT, START_WALL_WIDTH, GOAL_FLAG_HEIGHT);
        // DRAW GOAL FLAG
        fill(COLOR_OF_FLAG);
        final float top_of_flag = height - SURFACE_HEIGHT - GOAL_FLAG_HEIGHT;
        line(GOAL_FLAG_X, height - SURFACE_HEIGHT, GOAL_FLAG_X, top_of_flag);
        triangle(GOAL_FLAG_X, top_of_flag, GOAL_FLAG_X, top_of_flag + 30, GOAL_FLAG_X + 50, top_of_flag + 15);
    }
}

public enum ActionButton {
    LEFT_ARROW,
    RIGHT_ARROW,
    DOWN_ARROW,
    SPACE;
}

public enum StickFigureStatus {
    STOPPED,
    RUNNING_LEFT,
    RUNNING_RIGHT,
    JUMPING,
    FALLING;
}

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
        displayMessage("GOAL!!", "PRESS ANY KEY TO CLOSE", color(214, 249, 32));
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
        stickFigure.changeActionByKey(ActionButton.SPACE);
    } else if (key == CODED) {
        switch(keyCode) {
            case LEFT:
                stickFigure.changeActionByKey(ActionButton.LEFT_ARROW);
                break;
            case RIGHT:
                stickFigure.changeActionByKey(ActionButton.RIGHT_ARROW);
                break;
            case DOWN:
                stickFigure.changeActionByKey(ActionButton.DOWN_ARROW);
                break;
        }
    }
}

void displayMessage(String title, String message, color...backGroundColor) {
    if (backGroundColor.length != 0) {
        background(backGroundColor[0]);
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
    text("LEFT_ARROW:running to the left", width / 2, 10);
    text("RIGHT_ARROW:running to the right", width / 2, 40);
    text("DOWN_ARROW:stop running", width / 2, 70);
    text("SPACE:running to the left", width / 2, 100);
}
