public enum StickFigureStatus {
    STOPPED(0),
    RUNNING_LEFT(1),
    RUNNING_RIGHT(2),
    JUMPING(3);
    
    private final int id;
    
    private StickFigureStatus(final int id) {
        this.id = id;
    }
};
