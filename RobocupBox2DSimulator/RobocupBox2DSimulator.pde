import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import java.util.Random;
import java.io.BufferedWriter;
import java.io.FileWriter;


Box2DProcessing box2d;


  boolean recentlyRedy;
  boolean needToInit = false;
  int lastWin = 0;//0 tie 1 blue 2 yellow
  int totalSteps = 0;
  float[][] sum;
  float[][] theta;
  boolean saved = true;
  
  Simulator s;
  void setup(){
    s = new Simulator(this);
    Strategies.setSimulator(s);
    

    sum = new float[3][15];
    theta = new float[3][15];
    for(int i = 0; i < sum.length; i++){
     for(int j = 0; j < sum[i].length; j++){
      sum[i][j] = 0;
      theta[i][j] = 0;
     } 
      
    }
    String[] text = loadStrings("LearningValues.txt");
   for(int i = 0; i< text.length; i++){
     String[] numbers = split(text[i], ' ');
     for(int j = 0; j < numbers.length; j++){
       if(Float.isNaN(Float.parseFloat(numbers[j]))){
         theta[i][j] = 0;
         println("nan!!!");
       }else{
         theta[i][j] = Float.parseFloat(numbers[j]);
       }
       //theta[i][j] = 0;
       //print(theta[i][j] + "  ");
     }
     //println();
     /*for(int j = 0; j < theta[i].length; j++){
       theta[i][j] = 0;
     }*/
   }
   
   
   for(int i = 0 ; i < theta.length; i++){
    for(int j = 0 ; j < theta[i].length; j++){
     println(theta[i][j]);
    } 
   }
  }
  
  //robot1 -> right
  //robot -> left
  void draw(){
      for(int k = 0; k < 1000; k++){
      if((s.goalsBlue+s.goalsYellow+s.ties) % 100 == 0 && !saved){
        String[] list = new String[theta.length];
        String output = "";
        for(int i = 0; i < theta.length; i++){
          String line = "";
         for(int j = 0; j < theta[i].length; j++){
          line += " " +theta[i][j];
          //println(theta[i][j]);
         } 
         output += line.trim()+"\n";
         list[i] = line.trim();
         println(list[i]);
        }
        //String[] list = {output.substring(0, output.length()-1)};
        saveStrings("LearningValues.txt", list);
        //println("saved!!!!");
        saved = true;
      }
      saved = (s.goalsBlue+s.goalsYellow+s.ties) % 100 == 0;
      
      //Strategies.optimal1(s.robot, 3);
      //Strategies.optimal1(s.robot1, 1);
      //s.robot1.kick(s.ball);
      //s.robot.kick(s.ball);
      
      //Strategies.goToMyGoal(s.robot);
      
      
      for (int i=0; i < theta.length; i++)
        for (int j = 0; j < theta[i].length; j++){
          //println(theta[i][j]);
          theta[i][j] += s.lastWin * sum[i][j];
          //if(Float.isNaN(theta[i][j])) println("asdasdasdasdasdasdsadasdsdovusdohasoduhdsvlhdsivbfdvi");
          if (s.lastWin == 1) {
            //println("Won!");
            //println(theta[i][j]);
          }
          sum[i][j] = 0;
        }
    
    float[][] summand = Strategies.policyGradient(theta[0], theta[1], theta[2], s.robot, s.robot1, s.ball);    
    for(int i = 0; i < summand.length; i++){
     for(int j = 0; j < summand[i].length; j++){
      sum[i][j] += summand[i][j];
     }
    }
    for(int i = 0; i < 1; i ++){
      s.step();
    }
      
    }
    s.display(); 
      
    
    
    
    
    
    //optimal(robot);
    /*for(int k = 0; k < 100; k++){
   
   
    if(steps > 1250){//1250 for normal game
      steps = 0;
      ties++;
      needToInit = true;
      lastWin = 0;
     }
     if(needToInit){
      needToInit = false;
      ball.setPosition(random(width-(240*3), 240*3), random(height-(200*3), 200*3));
      //ball.setPosition(random(240*2, 240*3), random(height-(200*3), 200*3));
      //ball.setPosition(random(240, 240 *1.4), random(height-(200*3), 200*3));
      //ball.setPosition(200*2, 182*2);
      ball.body.setLinearVelocity(new Vec2(0, 0));
      robot.setPosition(244*2-250, 182*2, 90);
      //robot1.setPosition(100, 100, 0);
      robot1.setPosition(244*2+250, 182*2, 0);
      steps = 0;
      println("blue: " + goalsBlue + " yellow: " + goalsYellow + " ties: " + ties + " games: " + (goalsBlue+goalsYellow+ties) + " stpes: " + totalSteps);
      if((goalsBlue+goalsYellow+ties) % 1000 == 0){
        String output = "";
        for(int i = 0; i < 3; i++){
          String line = "";
         for(int j = 0; j < 14; j++){
          line += " " +theta[i][j];
         } 
         output += line.trim()+"\n";
        }
        String[] list = {output.substring(0, output.length()-1)};
        saveStrings("LearningValues.txt", list);
      }
      for (int i=0; i < 3; i++)
        for (int j = 0; j < 14; j++){
          //println(theta[i][j]);
          theta[i][j] += lastWin * sum[i][j];
          if (lastWin == 1) {
            //println("Won!");
            //println(sum[i][j]);
          }
          sum[i][j] = 0;
        }
    } 
    float[][] summand = policyGradient(theta[0], theta[1], theta[2], robot, robot1, ball);    
    for(int i = 0; i < 3; i++){
     for(int j = 0; j < 14; j++){
      sum[i][j] += summand[i][j];
      
     } 
    }
    //optimal1(robot, 3, ball.getX(), ball.getY());
    //optimal1(robot1, 0.01, ball.getX(), ball.getY());
    //robot1.move(0,0,0,0);
    
    //box2d.step();
    steps++;
    totalSteps++;
    }
   
   
   
   drawField();
    for (Boundary wall: boundaries) {
    wall.display();
  }
  robot.display();
  robot1.display();
  ball.display();*/
  }
  
  
  /*void play(Robot robot, float speed, float ballX, float ballY){
     float m = (robot._goalY-ballY)/(robot._goalX-ballX);
     float angle = degrees(atan(-m));
     float b = ballY-ballX*m;
     float l = 100;
     float redyX = ballX-l;
     float redyY = (ballX-l)*m+b;
     float allowedErrorX = 25;
     float allowedErrorY = 25;
     
     if(robot._goalX < robot._x){
       redyX = ballX+l;
       redyY = (ballX+l)*m+b;
     }
     if(ballX-robot._goalX < 0){
       angle+=180;
     }
     //println(angle);
     if(redyX > robot._x-allowedErrorX && redyX < robot._x+allowedErrorX && redyY > robot._y-allowedErrorY && redyY < robot._y+allowedErrorY)
       recentlyRedy = true;
     if(robot.holdsBall(ball.getX(), ball.getY())){
       moveTo(robot._goalX, robot._goalY, angle, speed, 2, robot);
       recentlyRedy = false;
       //println("goal");
     }else if(!recentlyRedy){
       moveToAvoid(redyX, redyY, angle, speed, 2, robot, ballX, ballY, 21*4);
       //println("avoid to perfect");
   }else{
       moveTo(ballX, ballY, angle, speed, 2, robot);
       //recentlyRedy = false;
       //println("go to ball");
     } 
    //println(robot.holdsBall(ballX, ballY));
  }
  
  void playWithDefence(Robot robot, float speed, float ballX, float ballY){
     float m = (robot._goalY-ballY)/(robot._goalX-ballX);
     float angle = degrees(atan(-m));
     float b = ballY-ballX*m;
     float l = 100;
     float redyX = ballX-l;
     float redyY = (ballX-l)*m+b;
     float allowedErrorX = 25;
     float allowedErrorY = 25;
     float ballSpeed = sqrt(ball.body.getLinearVelocity().x*ball.body.getLinearVelocity().x+ball.body.getLinearVelocity().y*ball.body.getLinearVelocity().y);
     
     if(robot._goalX < robot._x){
       redyX = ballX+l;
       redyY = (ballX+l)*m+b;
     }
     if(ballX-robot._goalX < 0){
       angle+=180;
     }
     //println(angle);
     if(redyX > robot._x-allowedErrorX && redyX < robot._x+allowedErrorX && redyY > robot._y-allowedErrorY && redyY < robot._y+allowedErrorY)
       recentlyRedy = true;
     if(robot.holdsBall(ball.getX(), ball.getY())){
       moveTo(robot._goalX, robot._goalY, angle, speed, 2, robot);
       recentlyRedy = false;
       //println("goal");
     }else if(ballSpeed > 1){
       moveTo(ballX, ballY, angle, speed, 2, robot);
     }else if(!recentlyRedy){
       moveToAvoid(redyX, redyY, angle, speed, 2, robot, ballX, ballY, 21*4);
       //println("avoid to perfect");
   }else{
       moveTo(ballX, ballY, angle, speed, 2, robot);
       //recentlyRedy = false;
       //println("go to ball");
     } 
    //println(robot.holdsBall(ballX, ballY));
  }
  

  
  
  String regressionPoints(Robot robot, Robot robot1, Ball ball, float angle, float speed, float theta){
    float[] state = new float[6];
    state[0] = robot._x;
    state[1] = robot._y;
    state[2] = ball.getX();
    state[3] = ball.getY();
    state[4] = ball.body.getLinearVelocity().x;
    state[5] = ball.body.getLinearVelocity().y;
    String output = "";
    for(int i =0; i< state.length; i++){
      output += state[i] + ",";
    }
    output += angle;
    return output;
    
  }*/
  
  
  
  
  
  
  
  
  
  /*void optimal1(Robot robot, float speed, float ballX, float ballY){
     float m = (robot._goalY-ballY)/(robot._goalX-ballX);
     float angle = degrees(atan(-m));
     float b = ballY-ballX*m;
     float l = 100;
     float redyX = ballX-l;
     float redyY = (ballX-l)*m+b;
     float allowedErrorX = 25;
     float allowedErrorY = 25;
     float ballSpeed = sqrt(ball.body.getLinearVelocity().x*ball.body.getLinearVelocity().x+ball.body.getLinearVelocity().y*ball.body.getLinearVelocity().y);
     
     if(robot._goalX < robot._x){
       redyX = ballX+l;
       redyY = (ballX+l)*m+b;
     }
     if(ballX-robot._goalX < 0){
       angle+=180;
     }
     if(redyX > robot._x-allowedErrorX && redyX < robot._x+allowedErrorX && redyY > robot._y-allowedErrorY && redyY < robot._y+allowedErrorY)
       recentlyRedy = true;
     if(robot.holdsBall(ball.getX(), ball.getY())){
       moveTo(robot._goalX, robot._goalY, angle, speed, 0.1, robot);
       recentlyRedy = false;
       //println("goal");
     }else if(ballSpeed > 1){
       moveTo(ballX, ballY, angle, speed, 0.1, robot);
     }else if(!recentlyRedy){
       moveToAvoid(redyX, redyY, angle, speed, 0.1, robot, ballX, ballY, 21*4);
       //println("avoid to perfect");
   }else{
       moveTo(ballX, ballY, angle, speed, 0.1, robot);
       //recentlyRedy = false;
       //println("go to ball");
     } 
    //println(robot.holdsBall(ballX, ballY));
  }
  
  
  boolean IsStuck(Robot robot, float x, float y){
    float distance = sqrt((robot._x-x)*(robot._x-x)+(robot._y-y)*(robot._y-y));
    return distance < 21*5;
    
  }
  
  void playAvoid(Robot robot, float speed, float ballX, float ballY, float ax, float ay){
     float m = (robot._goalY-ballY)/(robot._goalX-ballX);
     float angle = degrees(atan(-m));
     float b = ballY-ballX*m;
     float l = 100;
     float redyX = ballX-l;
     float redyY = (ballX-l)*m+b;
     float allowedErrorX = 25;
     float allowedErrorY = 25;
     
     if(robot._goalX < robot._x){
       redyX = ballX+l;
       redyY = (ballX+l)*m+b;
     }
     if(ballX-robot._goalX < 0){
       angle+=180;
     }
     //println(angle);
     if(redyX > robot._x-allowedErrorX && redyX < robot._x+allowedErrorX && redyY > robot._y-allowedErrorY && redyY < robot._y+allowedErrorY)
       recentlyRedy = true;
     if(robot.holdsBall(ball.getX(), ball.getY())){
       moveToAvoid(robot._goalX, robot._goalY, angle, speed, 2, robot, ax, ay, 21*8);
       recentlyRedy = false;
       //println("goal");
     }else if(!recentlyRedy){
       moveToAvoid(redyX, redyY, angle, speed, 2, robot, ballX, ballY, 21*4);
       //println("avoid to perfect");
   }else{
       moveTo(ballX, ballY, angle, speed, 2, robot);
       //recentlyRedy = false;
       //println("go to ball");
     } 
    //println(robot.holdsBall(ballX, ballY));
  }
  
  
  float distance(float x1, float y1, float x2, float y2){
   return sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1)); 
  }
  
  void left(Robot robot){
    println("left");
   robot.move(-1,-1,1,1);
  }
  void right(Robot robot){
    println("right");
   robot.move(1,1,-1,-1);
  }
  void up(Robot robot){
    println("up");
   robot.move(-1,-1,-1,-1);
  }
  
  void down(Robot robot){
    println("down");
   robot.move(1,1,1,1);
  }
  
  
  

  
  
  void moveTo(float x, float y, float theta, float speed, float speedOfRotation, Robot robot){
     theta = theta-90;
     float m = (y-robot._y)/(x-robot._x);
     float angle = degrees(atan(m))+45-robot._theta;
     if(x-robot._x < 0){
       angle+=180;
     }
     angle = angle%360;
     //println(angle);
     moveTo(angle, speed, theta, speedOfRotation, robot);
  }
  
  void moveTo(float angle, float speed, float theta, float speedOfRotation, Robot robot){
     float a = cos(radians(angle)) * speed;
     float b = sin(radians(angle)) * speed;
     float d1 = a+(theta-robot._theta)*speedOfRotation;
     float d2 = a-(theta-robot._theta)*speedOfRotation;
     float d3 = b+(theta-robot._theta)*speedOfRotation;
     float d4 = b-(theta-robot._theta)*speedOfRotation;
     robot.move(d1, d2, d3, d4); 
     //appendTextToFile("data.csv", regressionPoints(robot, robot1, ball, angle, speed, theta));
     
  }
  
  void moveTo(float angle, float speed, float theta, Robot robot){
    if(speed > 3) speed = 3;
    else if(speed < -3) speed = -3;
     float a = cos(radians(angle)) * speed;
     float b = sin(radians(angle)) * speed;
     float d1 = a+(theta-robot._theta)*2;
     float d2 = a-(theta-robot._theta)*2;
     float d3 = b+(theta-robot._theta)*2;
     float d4 = b-(theta-robot._theta)*2;
     robot.move(d1, d2, d3, d4); 
  }
  
  
  void moveToAvoid(float x, float y, float theta, float speed, float speedOfRotation, Robot robot, float ax, float ay, float r){
     theta = theta-90;
     float m = (y-robot._y)/(x-robot._x);
     float lastM = m;
      m = findMWithoutContact(robot._x, robot._y, m, ax, ay, r);
     //println(degrees(atan(m))+"    " + degrees(atan(lastM)));
     float angle = degrees(atan(m))+45-robot._theta;
     //appendTextToFile("data.csv", regressionPoints(robot, robot1, ball, angle, speed, theta));
     //println(angle);
     if(x-robot._x < 0){
       angle+=180;
     }
     angle = angle%360;
     //println(angle);
     float a = cos(radians(angle)) * speed;
     float b = sin(radians(angle)) * speed;
     float d1 = a+(theta-robot._theta)*speedOfRotation;
     float d2 = a-(theta-robot._theta)*speedOfRotation;
     float d3 = b+(theta-robot._theta)*speedOfRotation;
     float d4 = b-(theta-robot._theta)*speedOfRotation;
     robot.move(d1, d2, d3, d4); 
  }
  
  boolean isInCircle(float px, float py, float x, float y, float r){
    return (px-x)*(px-x)+(py-y)*(py-y) < r*r;//r square insted of root in the other side 
  }
  
  boolean willContact(float x0, float y0, float m, float x1, float y1, float r){
    float b = y0-x0*m;
    for(float x = x0; x < x0+300; x+=3){
      if(isInCircle(x, x*m+b, x1, y1, r)) return true;
    } 
    return false;
  }
  
  float findMWithoutContact(float x0, float y0, float m, float x1, float y1, float r){ 
    float startM = m;
    for(int i = 0;i < 360/15 && willContact(x0, y0, m, x1, y1, r); i++){
      //if (i > 360/15) return startM;
      m = tan((atan(m)+15)%360);
      //println(i);
      
    }
   //println(m-startM);
     return m;
  }
  
  
  public void drawField(){
     background(58, 203, 82);
     fill(0, 102, 153);
     textSize(32);
     text("RoboCup Simulator", 10, 30); 
     

     stroke(255, 255, 255);
     
     line(120, 120, 856, 120);
     line(120, 120, 120, 608);
     line(856, 608, 856, 120);
     line(120, 608, 856, 608);
     
     stroke(0, 0, 0);
     
     line(240, 184, 240, 544);
     line(240, 184, 120, 184);
     line(240, 544, 120, 544);
     
     line(736, 184, 736, 544);
     line(736, 184, 856, 184);
     line(736, 544, 856, 544);
     noFill();
     ellipse(488, 364, 240, 240); 
    
    
  }
  
  // Collision event functions!

  
  
  
  /**
 * Appends text to the end of a text file located in the data directory, 
 * creates the file if it does not exist.
 * Can be used for big files with lots of rows, 
 * existing lines will not be rewritten
 */
void appendTextToFile(String filename, String text){
  File f = new File(dataPath(filename));
  if(!f.exists()){
    createFile(f);
    appendTextToFile(filename, "robot._x,robot._y,ball.getX(),ball.getY(),ball.body.getLinearVelocity().x,ball.body.getLinearVelocity().y,angle");
  }
  try {
    PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(f, true)));
    out.println(text);
    out.close();
  }catch (IOException e){
      e.printStackTrace();
  }
}

/**
 * Creates a new file including all subfolders
 */
void createFile(File f){
  File parentDir = f.getParentFile();
  try{
    parentDir.mkdirs(); 
    f.createNewFile();
  }catch(Exception e){
    e.printStackTrace();
  }
}    

void beginContact(Contact cp){
  s.beginContact(cp);
}

void endContact(Contact cp) {
}
  
  
  
