void setup() {
    size(800, 800);
}

float armDuration = 50;
float legDuration = 40;
float armDeg = armDuration * 0.3;
float legDeg = legDuration * 0.3;
float minArmAngle = 0.1 * PI;
float maxArmAngle = 0.9 * PI;
float minLegAngle = 0.2 * PI;
float maxLegAngle = 0.8 * PI;
float armLength = 40;
float legLength = 50;
private final float HEAD_DIAMETER = 40;
private final float NECK_LENGTH = 18;
private final float DISTANCE_FROM_CHEST_TO_INSEAM = 45;
private final float DISTANCE_FROM_INSEAM_TO_FOOT = 50;

void draw() {
    background(255);
    float chest_x = width / 2;
    float chest_y = height / 2 + sin(frameCount * 0.1) * 10; // 上下の動きを追加
    stroke(0);
    
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
    float percentage_arm = abs(armDeg) / armDuration;
    float armAngle = map(percentage_arm, 0, 1, minArmAngle, maxArmAngle);
    armDeg--;
    if (armDeg < - 1 * armDuration) {
        armDeg = armDuration;
    }
    float armX_left = armLength * cos(armAngle);
    float armY_left = armLength * sin(armAngle);
    float armX_right = armLength * cos(armAngle + PI);
    float armY_right = armLength * sin(armAngle + PI);
    line(chest_x, chest_y, armX_left + chest_x, chest_y - armY_left);
    line(chest_x, chest_y, armX_right + chest_x, chest_y - armY_right);
    
    // DRAW Torso
    line(chest_x, chest_y, inseam_x, inseam_y);
    
    // DRAW LEGS
    float percentage_leg = abs(legDeg) / legDuration;
    float legAngle = map(percentage_leg, 0, 1, minLegAngle, maxLegAngle);
    legDeg--;
    if (legDeg < - 1 * legDuration) {
        legDeg = legDuration;
    }
    float legX_left = legLength * cos(legAngle);
    float legY_left = legLength * sin(legAngle);
    float legX_right = legLength * cos(legAngle + PI);
    float legY_right = legLength * sin(legAngle + PI);
    line(inseam_x, inseam_y, inseam_x - legX_left, inseam_y + legY_left);
    line(inseam_x, inseam_y, inseam_x - legX_right, inseam_y + legY_right);
}
