// void setup() {
//     size(800, 800);
//     background(255);
// }

// float deg = 70;
// float duration = 200;

// void draw() {
//     background(255);
//     float half_width = width / 2;
//     float half_height = height / 2;
//     stroke(0);
//     float minAngle = 0.2 * PI;
//     float maxAngle = 0.8 * PI;
//     float length = 200;
//     float percentage_left = abs(deg) / duration;
//     float angle_left = map(percentage_left, 0, 1, minAngle, maxAngle);
//     deg--;
//     if (deg < -1 * duration) {
//         deg = duration;
//     }
//     float x_left = length * cos(angle_left);
//     float y_left = length * sin(angle_left);
//     float x_right = length * cos(angle_left + PI);
//     float y_right = length * sin(angle_left + PI);
//     fill(100);
//     line(half_width, half_height, x_left + half_width, abs(y_left) + half_height);
//     fill(255);
//     line(half_width, half_height, x_right + half_width, abs(y_right) + half_height);
// }
