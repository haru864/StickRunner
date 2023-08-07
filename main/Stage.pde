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
}
