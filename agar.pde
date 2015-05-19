public static final int WINDOW_WIDTH  = 800;
public static final int WINDOW_HEIGHT = 800;
public static final int MAP_WIDTH     = 600;
public static final int MAP_HEIGHT    = 600;
public static final int POINT_COUNT   = 50;
public static final int PLAYER_RADIUS = 15;
public static final int GROWTH_RATIO  = 50;
public static final int MOVING_SPEED  = 3;

/**
 * A structure for a point
 */
public class Point {
  int x, y;
  int r, g, b;
};

Point[] points = new Point[POINT_COUNT];;
Point player = new Point();
int baseX, baseY;
int score = PLAYER_RADIUS * PLAYER_RADIUS,
    scoreDisplayOffset = PLAYER_RADIUS * PLAYER_RADIUS;

/**
 * Animate the projection window depending on mouse direction
 */
void animateWindow() {
  int distanceX = mouseX - WINDOW_WIDTH / 2;
  int distanceY = mouseY - WINDOW_HEIGHT / 2;
  // the ternary condition is to prevent the runtime error of "divide by zero"
  float tanTheta = distanceY / (distanceX==0? 0.00001: distanceX);
  float theta = atan(tanTheta);
  int deltaX = int(abs(MOVING_SPEED * cos(theta)));
  int deltaY = int(abs(MOVING_SPEED * sin(theta)));
 
  if (mouseX < WINDOW_WIDTH / 2) {
    if (baseX >= - WINDOW_WIDTH / 2) {
      baseX -= deltaX;
    } else {
      baseX = - WINDOW_WIDTH / 2;
    }
  } else {
    if (baseX <= MAP_WIDTH - WINDOW_WIDTH / 2) {
      baseX += deltaX;
    } else {
      baseX = MAP_WIDTH - WINDOW_WIDTH / 2;
    }
  }
  
  if (mouseY < WINDOW_HEIGHT / 2) {
    if (baseY >= - WINDOW_HEIGHT / 2) {
      baseY -= deltaY;
    } else {
      baseY = - WINDOW_HEIGHT / 2;
    }
  } else {
    if (baseY <= MAP_HEIGHT - WINDOW_HEIGHT / 2) {
      baseY += deltaY;
    } else {
      baseY = MAP_HEIGHT - WINDOW_HEIGHT / 2;
    }
  }
}

/**
 * Generate a point with random coordinate and color
 * @returns {Point}
 */
Point getRandomPoint() {
  Point p = new Point();
  p.r = int(random(0, 255));
  p.g = int(random(0, 255));
  p.b = int(random(0, 255));
  p.x = int(random(0, MAP_WIDTH - 1));
  p.y = int(random(0, MAP_HEIGHT - 1));
  return p;
}

Boolean isPointEatable(Point p) {
  return sq(p.x - baseX - (WINDOW_WIDTH / 2)) + sq(p.y - baseY - (WINDOW_HEIGHT / 2)) < score;
}

/**
 * Draw the little dots
 */
void drawDots() {
  
  for (int i = 0; i < POINT_COUNT; i++) {
    Point p = points[i];
    if (p.x - baseX < WINDOW_WIDTH && p.y - baseY < WINDOW_HEIGHT) {
      if (isPointEatable(p)) {
        points[i] = getRandomPoint();
        score += GROWTH_RATIO;
      }
      fill(p.r, p.g, p.b);
      ellipse(p.x - baseX, p.y - baseY, 15, 15);
    }
  }
}

/**
 * Draw the point of player
 */
void drawPlayer() {
  fill(player.r, player.g, player.b);
  int d = int(sqrt(score)) * 2;
  ellipse(player.x, player.y, d, d);
}

/**
 * Draw the current score
 */
void drawScore() {
  fill(0, 0, 0);
  textSize(32);
  text((score - scoreDisplayOffset) / GROWTH_RATIO, 10, WINDOW_HEIGHT - 20);
}

/**
 * Initialize environments
 */
void setup() {
  size(WINDOW_WIDTH, WINDOW_HEIGHT);
  noStroke();

  baseX = (MAP_WIDTH - WINDOW_WIDTH) / 2;
  baseY = (MAP_HEIGHT - WINDOW_HEIGHT) / 2;

  // initialize dots
  for (int i = 0; i < POINT_COUNT; i++) {
    points[i] = getRandomPoint();
  }
  
  // initialize player
  player = getRandomPoint();
  player.x = WINDOW_WIDTH / 2;
  player.y = WINDOW_HEIGHT / 2;
}

/**
 * The drawing pipeline
 */
void draw() { 
  animateWindow();
  // clear
  background(255, 255, 255);
  drawDots();
  drawPlayer();  
  drawScore();
}
