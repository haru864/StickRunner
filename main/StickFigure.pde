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
    
    private float duration = 50;
    private float deg = duration * 0.3;
    private float minAngle = 0.2 * PI;
    private float maxAngle = 0.8 * PI;
    private float length = 40;
    
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
                // RUNNING_RIGHTと同じ処理
                // フォールスルーだとフォーマッタがcase文を壊すので2回記載
                arm_r_deg += angular_velocity;
                leg_r_deg += angular_velocity;
                if (radians(arm_r_deg) > maxAngle
                    || radians(arm_r_deg) < minAngle) {
                    angular_velocity *= -1;
                }
                drawSymmetricalBody();
                break;
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
