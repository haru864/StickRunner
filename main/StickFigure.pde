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
    private float velocity_y = 0; // 垂直方向の移動速度
    private float velocity_x = 0;
    private float scrolled_x = 0;
    private float gravity = 0.5; // 重力
    private float initial_jump_velocity_y = -15; // ジャンプ時の初速度
    float duration = 50;
    float deg = duration * 0.3;
    float minAngle = 0.2 * PI;
    float maxAngle = 0.8 * PI;
    float length = 40;
    
    public StickFigure(float chest_x, float chest_y) {
        this.chest_x = chest_x;
        this.chest_y = chest_y;
        this.initial_chest_y = chest_y;
        this.status = StickFigureStatus.STOPPED;
    }
    
    public void setStage(Stage stage) {
        this.stage = stage;
    }
    
    public boolean isGoal() {
        return(chest_x - HITBOX_WIDTH / 2) > stage.GOAL_FLAG_X;
    }
    
    public void moveLeft() {
        if (status == StickFigureStatus.JUMPING) {
            return;
        }
        status = StickFigureStatus.RUNNING_LEFT;
        velocity_x = MOVE_SPEED;
        velocity_y = 0;
    }
    
    public void moveRight() {
        if (status == StickFigureStatus.JUMPING) {
            return;
        }
        status = StickFigureStatus.RUNNING_RIGHT;
        velocity_x = -1 * MOVE_SPEED;
        velocity_y = 0;
    }
    
    public void jump() {
        if (status == StickFigureStatus.JUMPING) {
            return;
        }
        status = StickFigureStatus.JUMPING;
        velocity_y = initial_jump_velocity_y;
    }
    
    public void stop() {
        if (status == StickFigureStatus.JUMPING) {
            return;
        }
        status = StickFigureStatus.STOPPED;
        velocity_x = 0;
        velocity_y = 0;
    }
    
    private void freefall() {
        if (isOnHole() == false) {
            return;
        }
        status = StickFigureStatus.FALLING;
        velocity_y += gravity;
        chest_y += velocity_y;
    }
    
    public float getChestCoordX() {
        return chest_x;
    }
    
    public float getUnderFootCoordY() {
        return chest_y + DISTANCE_FROM_CHEST_TO_INSEAM + DISTANCE_FROM_INSEAM_TO_FOOT;
    }
    
    public float getTopOfHeadCoordY() {
        return chest_y - NECK_LENGTH - HEAD_DIAMETER;
    }
    
    public boolean isOnHole() {
        return stage.isHoleX(chest_x) && chest_y >= initial_chest_y;
    }
    
    public boolean doPassStartWall() {
        float future_body_left_edge_x = chest_x - HITBOX_WIDTH / 2 + (velocity_x * - 1);
        float start_wall_right_edge_x = stage.START_WALL_X + stage.START_WALL_WIDTH;
        return future_body_left_edge_x <= start_wall_right_edge_x;
    }
    
    public boolean doPassHoleWall() {
        if (chest_y <= initial_chest_y) {
            return false;
        }
        float future_body_left_edge_x = chest_x - HITBOX_WIDTH / 2 + (abs(velocity_x) * - 1);
        float future_body_right_edge_x = chest_x + HITBOX_WIDTH / 2 + abs(velocity_x);
        return stage.isHoleX(future_body_left_edge_x) == true
            || stage.isHoleX(future_body_right_edge_x) == true;
    }
    
    public boolean isFallen() {
        return getTopOfHeadCoordY() > height;
    }
    
    public void action() {
        println("status:" + stickFigure.status + ", vy:" + velocity_y);
        if (status == StickFigureStatus.JUMPING) {
            if (doPassStartWall() == false && doPassHoleWall() == false) {
                scrolled_x += velocity_x;
                chest_x += (velocity_x * - 1);
            }
            chest_y += velocity_y;
            velocity_y += gravity;
            if (chest_y >= initial_chest_y && isOnHole() == false) {
                if (velocity_x > 0) {
                    status = StickFigureStatus.RUNNING_LEFT;
                    moveLeft();
                } else if (velocity_x < 0) {
                    status = StickFigureStatus.RUNNING_RIGHT;
                    moveRight();
                } else if (isOnHole() == true) {
                    status = StickFigureStatus.FALLING;
                } else {
                    status = StickFigureStatus.STOPPED;
                    stop();
                }
            }
        } else if (status == StickFigureStatus.FALLING) {
            freefall();
        } else if (status == StickFigureStatus.STOPPED) {
            freefall();
        } else if (status == StickFigureStatus.RUNNING_LEFT
            || status == StickFigureStatus.RUNNING_RIGHT) {
            freefall();
            if (chest_x - HITBOX_WIDTH / 2 + (velocity_x * - 1)
                > stage.START_WALL_X + stage.START_WALL_WIDTH) {
                scrolled_x += velocity_x;
                chest_x += (velocity_x * - 1);
            } else {
                stop();
            }
        }
        translate(scrolled_x, 0);
    }
    
    public void draw() {
        switch(status) {
            case STOPPED :
                drawStoppedBody();
                break;
            case RUNNING_LEFT :
                drawRunningBody();
                break;	
            case RUNNING_RIGHT :
                drawRunningBody();
                break;	
            case JUMPING :
                drawJumpingBody();
                break;
            case FALLING :
                drawFallingBody();
                break;
        }
    }
    
    private void drawStoppedBody() {
        final float head_x = chest_x;
        final float head_y = chest_y - NECK_LENGTH - HEAD_DIAMETER * 0.5;
        final float inseam_x = chest_x;
        final float inseam_y = chest_y + DISTANCE_FROM_CHEST_TO_INSEAM;
        // DRAW HEAD
        fill(255);
        ellipseMode(CENTER);
        ellipse(head_x, head_y, HEAD_DIAMETER, HEAD_DIAMETER);
        // DRAW NECK
        strokeWeight(2);
        line(chest_x, chest_y, head_x, chest_y - NECK_LENGTH);
        // DRAW ARMS
        line(chest_x, chest_y, chest_x - 30, chest_y + 30);
        line(chest_x, chest_y, chest_x + 30, chest_y + 30);
        // DRAW Torso
        line(chest_x, chest_y, inseam_x, inseam_y);
        // DRAW LEGS
        line(inseam_x, inseam_y, inseam_x - 35, inseam_y + DISTANCE_FROM_INSEAM_TO_FOOT);
        line(inseam_x, inseam_y, inseam_x + 35, inseam_y + DISTANCE_FROM_INSEAM_TO_FOOT);
    }
    
    private void drawRunningBody() {
        final float head_x = chest_x;
        final float head_y = chest_y - NECK_LENGTH - HEAD_DIAMETER * 0.5;
        final float inseam_x = chest_x;
        final float inseam_y = chest_y + DISTANCE_FROM_CHEST_TO_INSEAM;
        // DRAW HEAD
        fill(255);
        ellipseMode(CENTER);
        ellipse(head_x, head_y, HEAD_DIAMETER, HEAD_DIAMETER);
        // DRAW NECK
        strokeWeight(2);
        line(chest_x, chest_y, head_x, chest_y - NECK_LENGTH);
        
        // DRAW ARMS
        float percentage_left = abs(deg) / duration;
        float angle_left = map(percentage_left, 0, 1, minAngle, maxAngle);
        deg--;
        if (deg < - 1 * duration) {
            deg = duration;
        }
        float x_left = length * cos(angle_left);
        float y_left = length * sin(angle_left);
        float x_right = length * cos(angle_left + PI);
        float y_right = length * sin(angle_left + PI);
        line(chest_x, chest_y, x_left + chest_x, abs(y_left) + chest_y);
        line(chest_x, chest_y, x_right + chest_x, abs(y_right) + chest_y);
        // DRAW Torso
        line(chest_x, chest_y, inseam_x, inseam_y);
        // DRAW LEGS
        line(inseam_x, inseam_y, x_left * 1.2 + inseam_x, abs(y_left) * 1.2 + inseam_y);
        line(inseam_x, inseam_y, x_right * 1.2 + inseam_x, abs(y_right) * 1.2 + inseam_y);
    }
    
    private void drawJumpingBody() {
        if (velocity_x == 0) {
            drawFallingBody();
        }
        final float directionalCorrection = -1 * velocity_x  / abs(velocity_x);
        final float head_x = chest_x;
        final float head_y = chest_y - NECK_LENGTH - HEAD_DIAMETER * 0.5;
        final float inseam_x = chest_x;
        final float inseam_y = chest_y + DISTANCE_FROM_CHEST_TO_INSEAM;
        // DRAW HEAD
        fill(255);
        ellipseMode(CENTER);
        ellipse(head_x, head_y, HEAD_DIAMETER, HEAD_DIAMETER);
        // DRAW NECK
        strokeWeight(2);
        line(chest_x, chest_y, head_x, chest_y - NECK_LENGTH);
        // DRAW ARMS
        float front_elbow_x = chest_x + 15 * directionalCorrection;
        float front_elbow_y = chest_y + 10;
        float front_hand_x = chest_x + 30 * directionalCorrection;
        float front_hand_y = chest_y - 10;
        float back_elbow_x = chest_x - 15 * directionalCorrection;
        float back_elbow_y = chest_y - 10;
        float back_hand_x = chest_x - 30 * directionalCorrection;
        float back_hand_y = chest_y + 10;
        line(chest_x, chest_y, front_elbow_x, front_elbow_y);
        line(front_elbow_x, front_elbow_y, front_hand_x, front_hand_y);
        line(chest_x, chest_y, back_elbow_x, back_elbow_y);
        line(back_elbow_x, back_elbow_y, back_hand_x, back_hand_y);
        // DRAW Torso
        line(chest_x, chest_y, inseam_x, inseam_y);
        // DRAW LEGS
        float front_knee_x = inseam_x + 20 * directionalCorrection;
        float front_knee_y = inseam_y - 10;
        float front_toes_x = inseam_x + 35 * directionalCorrection;
        float front_toes_y = inseam_y + 15;
        float back_knee_x = inseam_x - 10 * directionalCorrection;
        float back_knee_y = inseam_y + 15;
        float back_toes_x = inseam_x - 35 * directionalCorrection;
        float back_toes_y = inseam_y + 5;
        line(inseam_x, inseam_y, front_knee_x, front_knee_y);
        line(front_knee_x, front_knee_y, front_toes_x, front_toes_y);
        line(inseam_x, inseam_y, back_knee_x, back_knee_y);
        line(back_knee_x, back_knee_y, back_toes_x, back_toes_y);
    }
    
    private void drawFallingBody() {
        final float head_x = chest_x;
        final float head_y = chest_y - NECK_LENGTH - HEAD_DIAMETER * 0.5;
        final float inseam_x = chest_x;
        final float inseam_y = chest_y + DISTANCE_FROM_CHEST_TO_INSEAM;
        // DRAW HEAD
        fill(255);
        ellipseMode(CENTER);
        ellipse(head_x, head_y, HEAD_DIAMETER, HEAD_DIAMETER);
        // DRAW NECK
        strokeWeight(2);
        line(chest_x, chest_y, head_x, chest_y - NECK_LENGTH);
        // DRAW ARMS
        line(chest_x, chest_y, chest_x - 30, chest_y - 30);
        line(chest_x, chest_y, chest_x + 30, chest_y - 30);
        // DRAW Torso
        line(chest_x, chest_y, inseam_x, inseam_y);
        // DRAW LEGS
        line(inseam_x, inseam_y, inseam_x - 35, inseam_y + DISTANCE_FROM_INSEAM_TO_FOOT);
        line(inseam_x, inseam_y, inseam_x + 35, inseam_y + DISTANCE_FROM_INSEAM_TO_FOOT);
    }
}
