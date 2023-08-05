public enum StickFigureStatus {
    STOPPED(0),
    RUNNING(1),
    JUMPING(2);
    
    private final int id;
    
    private StickFigureStatus(final int id) {
        this.id = id;
    }
};
