public class StickFigure  {
    
    private final float HEAD_DIAMETER = 40;
    private final float NECK_LENGTH = 18;
    private final float DISTANCE_FROM_CHEST_TO_INSEAM = 45;
    private final float DISTANCE_FROM_INSEAM_TO_FOOT = 50;
    private float chest_x;
    private float chest_y;
    private StickFigureStatus status;
    
    public StickFigure(float chest_x, float chest_y) {
        this.chest_x = chest_x;
        this.chest_y = chest_y;
        this.status = StickFigureStatus.STOPPED;
    }
    
    public float getChestCoordX() {
        return this.chest_x;
    }
    
    public float getUnderFootCoordY() {
        return this.chest_y + DISTANCE_FROM_CHEST_TO_INSEAM + DISTANCE_FROM_INSEAM_TO_FOOT;
    }
    
    public void draw() {
        switch(status) {
            case STOPPED :
                this.drawStoppedBody();
                break;
            case RUNNING :
                break;	
            case JUMPING :
                break;
        }
    }
    
    private void drawStoppedBody() {
        final float head_x = this.chest_x;
        final float head_y = this.chest_y - NECK_LENGTH - HEAD_DIAMETER * 0.5;
        final float inseam_x = this.chest_x;
        final float inseam_y = this.chest_y + DISTANCE_FROM_CHEST_TO_INSEAM;
        // DRAW HEAD
        fill(255);
        ellipseMode(CENTER);
        ellipse(head_x, head_y, HEAD_DIAMETER, HEAD_DIAMETER);
        // DRAW NECK
        strokeWeight(2);
        line(this.chest_x, this.chest_y, head_x, this.chest_y - NECK_LENGTH);
        // DRAW ARMS
        line(this.chest_x, this.chest_y, this.chest_x - 30, this.chest_y + 30);
        line(this.chest_x, this.chest_y, this.chest_x + 30, this.chest_y + 30);
        // DRAW Torso
        line(this.chest_x, this.chest_y, inseam_x, inseam_y);
        // DRAW LEGS
        line(inseam_x, inseam_y, inseam_x - 35, inseam_y + DISTANCE_FROM_INSEAM_TO_FOOT);
        line(inseam_x, inseam_y, inseam_x + 35, inseam_y + DISTANCE_FROM_INSEAM_TO_FOOT);
    }
    
    private void drawRunningBody() {
        
    }
    
    private void drawJumpingBody() {
        
    }
}
