public class Stage {
    
    private final int COLOR_OF_STAGE = #BA5039;
    private final int COLOR_OF_HOLE = #E7E6E8;
    private final int COLOR_OF_FLAG = #F84157;
    private final float MOVE_SPEED = 10;
    private final float STAGE_WIDTH = 1200;
    private final float HOLE_WIDTH = 100;
    private final float GOAL_FLAG_HEIGHT = height * 2.0 / 5.0;
    private float STAGE_LEFT_EDGE_X = 0;
    private float START_WALL = 50;
    private float GOAL_FLAG_X = STAGE_WIDTH - 150;
    private float SURFACE_HEIGHT;
    private final ArrayList<Float> HOLE_LEFT_EDGE_X_LIST = new ArrayList<Float>() {
        {
            add(700.0);
        }
    };
    
    public Stage(final float underfoot_y) {
        SURFACE_HEIGHT = height - underfoot_y;
    }
    
    public void draw() {
        // DRAW WHOLE STAGE
        fill(COLOR_OF_STAGE);
        rect(0, height - SURFACE_HEIGHT, STAGE_WIDTH, SURFACE_HEIGHT);
        // DRAW HOLES
        for (float holeLeftEdgeX : HOLE_LEFT_EDGE_X_LIST) {
            // rect(rectLeftEdgeX, height - SURFACE_HEIGHT, holeLeftEdgeX - rectLeftEdgeX, SURFACE_HEIGHT);
            // rectLeftEdgeX = holeLeftEdgeX + HOLE_WIDTH;
        }
        // DRAW START WALL
        fill(#BBA1A4);
        rect(START_WALL, height - SURFACE_HEIGHT - GOAL_FLAG_HEIGHT, 20, GOAL_FLAG_HEIGHT);
        // DRAW GOAL FLAG
        fill(COLOR_OF_FLAG);
        final float top_of_flag = height - SURFACE_HEIGHT - GOAL_FLAG_HEIGHT;
        line(GOAL_FLAG_X, height - SURFACE_HEIGHT, GOAL_FLAG_X, top_of_flag);
        triangle(GOAL_FLAG_X, top_of_flag, GOAL_FLAG_X, top_of_flag + 30, GOAL_FLAG_X + 50, top_of_flag + 15);
    }
    
    public void moveStage(ActionButton actBtn) {
        switch(actBtn) {
            case LEFT_ARROW:
                if (STAGE_LEFT_EDGE_X + MOVE_SPEED <= 0) {
                    STAGE_LEFT_EDGE_X += MOVE_SPEED;
                    GOAL_FLAG_X += MOVE_SPEED;
                    START_WALL += MOVE_SPEED;
                }
                break;	
            case RIGHT_ARROW:
                if (abs(STAGE_LEFT_EDGE_X - MOVE_SPEED) <= STAGE_WIDTH + width / 2) {
                    STAGE_LEFT_EDGE_X -= MOVE_SPEED;
                    GOAL_FLAG_X -= MOVE_SPEED;
                    START_WALL -= MOVE_SPEED;
                }
                break;	
        }
    }

    public boolean doGoal(StickFigure stickFigure) {
        return stickFigure.getChestCoordX() - 30 > GOAL_FLAG_X;
    }
}