PImage bg;
PImage sp;
PImage rock;
PImage pu;
void setup()
{
  size(1600, 900);
  bg = loadImage("dims.jpg");
  sp = loadImage("StarShip.png");
  rock = loadImage("rock.png");
  pu = loadImage("PowerUp.png");
  textSize(35);
  frameRate(60);
  rectMode(CENTER);
  imageMode(CENTER);
}

final int STARSHIP_SIZE = 80;
//shots
int[][] shots = new int[200][2];
int shotsCount = 0;
int shotTimer = 0;
int defaultShotTimer = 20;
//rocks
int[][] rocks = new int[200][3];
int rockCount = 0;
int rockTimer = 60;
int defaultRockTimer = 300;
int rockFallingSpeed = 2;
int defaultRockSize = 100;
//PowerUps
int[][] powerUps = new int[200][2];
int playerPowerUps = 1;
int powerUpCount = 0;
int powerUpSize = 50;
int powerUpFallingSpeed = 3;
//management
int score = 0;
boolean gameOver = false;


void draw()
{
  if (!gameOver)
  {
    galaxy();
    starShip();
    shots();
    rocks();
    rockIncrease();
    score();
    if (playerPowerUps != 20)
      powerUp();
    checkDead();
  }
}

void keyPressed()
{
  if (key == '1')
    initialize();
}

void starShip()
{
  fill(0, 255, 0);
  image(sp, mouseX, mouseY, STARSHIP_SIZE, STARSHIP_SIZE);
  fill(0);
}

void galaxy()
{
  image(bg, 800, 450, 1600, 900);
}

void shoot()
{
  shots[shotsCount][0] = mouseX;
  shots[shotsCount][1] = mouseY - 25;
  shotsCount++;
}

void shots()
{
  shotTimer--;
  if (keyPressed)
  {
    if (key == ' ' && shotTimer < 0)
    {
      shoot();
      shotTimer = defaultShotTimer;
    }
  }
  if (shots[0][1] < 0)
  {
    if (shotsCount == 1)
    {
      shots[0][1] = 2000;
      shotsCount--;
    } else
    {
      removeShot(0);
    }
  }
  for (int i = 0; i < shotsCount; i++)
  {
    stroke(255, 0, 0);
    strokeWeight(5);
    line(shots[i][0], shots[i][1], shots[i][0], shots[i][1] - 20);
    shots[i][1] -= 20;
    stroke(0);
    strokeWeight(1);
  }
}

void rocks()
{
  if (rocks[0][1] > 950)
  {
    removeRock(0, false);
  }
  checkHit();
  rockTimer -= 1;
  if (rockTimer == 0)
  {
    newRock();
    rockTimer = defaultRockTimer;
  }
  for (int i = 0; i < rockCount; i++)
  {
    image(rock, rocks[i][0], rocks[i][1], rocks[i][2], rocks[i][2]);
    rocks[i][1] += rockFallingSpeed;
  }
}

void newRock()
{
  rocks[rockCount][0] = (int)random(100, 1500);
  rocks[rockCount][1] = -50;
  rocks[rockCount][2] = defaultRockSize;
  rockCount++;
}

void checkHit()
{
  for (int i = 0; i < rockCount; i++)
  {
    for (int j = 0; j < shotsCount; j++)
    {
      if (rocks[i][0] + rocks[i][2] / 2 > shots[j][0] && rocks[i][0] - rocks[i][2] / 2 < shots[j][0] && rocks[i][1] + rocks[i][2] / 2 > shots[j][1] && rocks[i][1] - rocks[i][2] / 2 < shots[j][1])
      {
        rocks[i][2] -= 10;
        removeShot(j);
        if (rocks[i][2] == 20)//if stones destroyed
        {
          removeRock(i, true);
        }
      }
    }
  }
}

void score()
{
  fill(100, 255, 100);
  text("Score: " + score, 10, 35);
  text("Power Up: " + playerPowerUps, 10, 70);
  fill(0);
}

void removeRock(int i, boolean addScore)
{
  if (addScore)//if a stone was detroyed.
  {
    score += 100;
    if (playerPowerUps != 20);
    newPowerUp(rocks[i][0], rocks[i][1]);
  }
  for (int k = i + 1; k < rockCount; k++)//removes stone
  {
    rocks[k - 1][0] = rocks[k][0];
    rocks[k - 1][1] = rocks[k][1];
    rocks[k - 1][2] = rocks[k][2];
  }
  rockCount--;
}

void removeShot(int j)
{
  for (int k = j + 1; k < shotsCount; k++)//removes shot which hit
  {
    shots[k - 1][0] = shots[k][0];
    shots[k - 1][1] = shots[k][1];
  }
  shotsCount--;
}

void checkDead()
{
  for (int i = 0; i < rockCount; i++)
  {
    if(Math.sqrt(Math.pow(mouseX - rocks[i][0], 2) + Math.pow(mouseY - rocks[i][1], 2)) < STARSHIP_SIZE / 2 + rocks[i][2] / 2 - 15)
    {
      textSize(100);
      fill(0);
      gameOver = true;
      text("YOU ARE A LOSER", 380, 480);
    }
  }
}

void initialize()
{
  shotsCount = 0;
  shotTimer = 0;
  defaultShotTimer = 20;
  rockCount = 0;
  rockTimer = 60;
  defaultRockTimer = 300;
  rockFallingSpeed = 2;
  playerPowerUps = 1;
  powerUpCount = 0;
  score = 0;
  gameOver = false;
}

void powerUp()
{
  if (powerUps[0][1] > 950)
  {
    if (powerUpCount == 1)
    {
      powerUps[0][1] = -50;
      powerUpCount--;
    } else
    {
      removePowerUp(0);
    }
  }
  checkPowerUpCatch();
  for (int i = 0; i < powerUpCount; i++)
  {
    image(pu, powerUps[i][0], powerUps[i][1], powerUpSize, powerUpSize);
    powerUps[i][1] += powerUpFallingSpeed;
  }
}
void newPowerUp(int x, int y)
{
  if (random(0, 100) < 40)
  {
    powerUps[powerUpCount][0] = x;
    powerUps[powerUpCount][1] = y;
    powerUpCount++;
  }
}

void removePowerUp(int i)
{
  for (; i < powerUpCount; i++)//removes power up
  {
    powerUps[i][0] = powerUps[i + 1][0];
    powerUps[i][1] = powerUps[i + 1][1];
  }
  powerUpCount--;
}

void checkPowerUpCatch()
{
  for (int i = 0; i < powerUpCount; i++)
  {
    if (defaultShotTimer != 1)
    {
      if (Math.sqrt(Math.pow(mouseX - powerUps[i][0], 2) + Math.pow(mouseY - powerUps[i][1], 2)) < STARSHIP_SIZE / 2 + powerUpSize / 2 - 15)
      {
        removePowerUp(i);
        playerPowerUps += 1;
        defaultShotTimer -= 1;
      }
    }
  }
}

void rockIncrease()
{
  if (score == 1000)
  {
    defaultRockTimer = 240;
    rockFallingSpeed = 3;
  }
  if (score == 2000)
  {
    defaultRockTimer = 180;
    rockFallingSpeed = 4;
  }
  if (score == 3000)
  {
    defaultRockTimer = 120;
    rockFallingSpeed = 5;
  }
  if (score == 4000)
  {
    defaultRockTimer = 60;
    rockFallingSpeed = 6;
  }
  if (score == 5000)
  {
    defaultRockTimer = 30;
    rockFallingSpeed = 7;
  }
  if (score == 6000)
  {
    defaultRockTimer = 15;
    rockFallingSpeed = 8;
  }
  if (score == 7000)
  {
    defaultRockTimer = 10;
    rockFallingSpeed = 9;
  }
  if (score == 8000)
  {
    defaultRockTimer = 5;
    rockFallingSpeed = 10;
  }
}
