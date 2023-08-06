public class StickFigure  {
    
    private final float HEAD_DIAMETER = 40;
    private final float NECK_LENGTH = 18;
    private final float DISTANCE_FROM_CHEST_TO_INSEAM = 45;
    private final float DISTANCE_FROM_INSEAM_TO_FOOT = 50;
    private float chest_x;
    private float chest_y;
    private float not_jumping_chest_y;
    private StickFigureStatus status;
    private int last_moved_seconds = -1;
    private float jump_velocity_y = 0; // オブジェクトの垂直方向の速度
    private float jump_velocity_x = 5; // オブジェクトの水平方向の移動速度
    private float gravity = 0.5; // 重力
    private float initial_jump_velocity = -15; // ジャンプ時の初速度
    private int jump_direction = 0; // ジャンプの方向: -1 = 左, 1 = 右, 0 = 静止
    
    public StickFigure(float chest_x, float chest_y) {
        this.chest_x = chest_x;
        this.chest_y = chest_y;
        this.not_jumping_chest_y = chest_y;
        this.status = StickFigureStatus.STOPPED;
    }
    
    public void action() {
        println("status: " + stickFigure.status + ",  chest_y: " + chest_y);
        if (status != StickFigureStatus.JUMPING
            && millis() - last_moved_seconds > 100) {
            status = StickFigureStatus.STOPPED;
            last_moved_seconds = -1;
        }
        if (status == StickFigureStatus.JUMPING) {
            if (chest_y > not_jumping_chest_y) {
                chest_y = not_jumping_chest_y;
                jump_velocity_y = 0;
                jump_direction = 0;
                status = StickFigureStatus.STOPPED;
            } else {
                jump_velocity_y += gravity;
                chest_y += jump_velocity_y;
                chest_x += jump_direction * jump_velocity_x;
            }
        }
    }
    
    public void changeAction(ActionButton actBtn) {
        if (actBtn == ActionButton.LEFT_ARROW) {
            status = StickFigureStatus.RUNNING_LEFT;
            last_moved_seconds = millis();
        }
        if (actBtn == ActionButton.RIGHT_ARROW) {
            status = StickFigureStatus.RUNNING_RIGHT;
            last_moved_seconds = millis();
        }
        if (actBtn == ActionButton.SPACE) {
            if (status == StickFigureStatus.RUNNING_LEFT) {
                jump_direction = -1;
            } else if (status == StickFigureStatus.RUNNING_RIGHT) {
                jump_direction = 1;
            } else if (status == StickFigureStatus.STOPPED) {
                jump_direction = 0;
            }
            status = StickFigureStatus.JUMPING;
            jump_velocity_y = initial_jump_velocity;
        }
    }
    
    public float getChestCoordX() {
        return chest_x;
    }
    
    public float getUnderFootCoordY() {
        return chest_y + DISTANCE_FROM_CHEST_TO_INSEAM + DISTANCE_FROM_INSEAM_TO_FOOT;
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
        drawStoppedBody();
    }
    
    private void drawJumpingBody() {
        drawStoppedBody();
    }
}
