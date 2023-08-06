public class Stage {
    
    private final int COLOR_OF_STAGE = #BA5039;
    private final int COLOR_OF_HOLE = #CAF5F5;
    private final int COLOR_OF_FLAG = #F84157;
    private final int COLOR_OF_WALL = #BBA1A4;
    private final float MOVE_SPEED = 10;
    private final float STAGE_WIDTH = 2000;
    private final float HOLE_WIDTH = 100;
    private final float START_WALL_WIDTH = 20;
    private final float GOAL_FLAG_HEIGHT = height * 2.0 / 5.0;
    private float STAGE_LEFT_EDGE_X = 0;
    private float START_WALL_X = 50;
    private float GOAL_FLAG_X = STAGE_WIDTH - 150;
    private float SURFACE_HEIGHT;
    private final ArrayList<Float> HOLE_LEFT_EDGE_X_LIST = new ArrayList<Float>() {
        {
            add(600.0);
            add(1400.0);
            add(1600.0);
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
    
    public void moveStage(ActionButton actBtn, StickFigure stickFigure) {
        switch(actBtn) {
            case LEFT_ARROW:
                if (START_WALL_X + START_WALL_WIDTH + MOVE_SPEED <= stickFigure.getChestCoordX() - 35) {
                    STAGE_LEFT_EDGE_X += MOVE_SPEED;
                    GOAL_FLAG_X += MOVE_SPEED;
                    START_WALL_X += MOVE_SPEED;
                    for (int i = 0; i < HOLE_LEFT_EDGE_X_LIST.size(); i++) {
                        HOLE_LEFT_EDGE_X_LIST.set(i, HOLE_LEFT_EDGE_X_LIST.get(i) + MOVE_SPEED);
                    }
                }
                break;	
            case RIGHT_ARROW:
                if (abs(STAGE_LEFT_EDGE_X - MOVE_SPEED) <= STAGE_WIDTH + width / 2) {
                    STAGE_LEFT_EDGE_X -= MOVE_SPEED;
                    GOAL_FLAG_X -= MOVE_SPEED;
                    START_WALL_X -= MOVE_SPEED;
                    for (int i = 0; i < HOLE_LEFT_EDGE_X_LIST.size(); i++) {
                        HOLE_LEFT_EDGE_X_LIST.set(i, HOLE_LEFT_EDGE_X_LIST.get(i) - MOVE_SPEED);
                    }
                }
                break;	
        }
        // println(HOLE_LEFT_EDGE_X_LIST);
    }
    
    public boolean doGoal(StickFigure stickFigure) {
        return stickFigure.getChestCoordX() - 30 > GOAL_FLAG_X;
    }
}
