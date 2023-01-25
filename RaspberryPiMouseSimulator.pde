import javax.vecmath.Vector3f;
import javax.vecmath.Quat4f;
import peasy.*;
import bRigid.*;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import g4p_controls.*;
import java.awt.Font;


RobotGUI gui;

Ground ground;
Robot robot;
Blocks blocks;
Vector3f groundSize = new Vector3f(1000f, 1000f, 0.01f);

PeasyCam cam;

BPhysics physics;


Vector3f wheelPos = new Vector3f(0, 4, 2.395);
float wheelRadius = 2.3;
float wheelMass = 0.1f;
Vector3f bodySize = new Vector3f(9.6, 7.3, 6.6);
Vector3f bodyPos = new Vector3f(0.0, 0.0, 3.7);
float bodyMass = 1.5;

int BoxNumberV = 10;
int BoxNumberH = 5;
Vector3f boxSize = new Vector3f(1.0, 4.0, 2.0);
Vector3f boxCenterPos = new Vector3f(50.0, 0.0, 0.0);
float boxMass = 0.1;

boolean modelDisplay = true; //true：OBJファイル読み込み、false：簡易モデル表示

boolean loopFlag = true;

void setup() {
  size(1200, 800, OPENGL);
  
  float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  float nearClippingDistance = 0.01;
  perspective(fov, float(width)/float(height), nearClippingDistance, cameraZ*10.0);


  cam = new PeasyCam(this, 3.6, 70, 40, 1);

  cam.rotateX(-1.05);
  cam.rotateY(-0.32);
  cam.rotateZ(0.19);
  cam.setMinimumDistance(0.01);
  cam.setMaximumDistance(400);

  //Bullet初期化
  physics = new BPhysics();
  //重力設定
  physics.world.setGravity(new Vector3f(0, 0, -9.8));

  ground = new Ground(physics, groundSize);
  robot = new Robot(this, physics, bodySize, bodyPos, bodyMass, wheelPos, wheelRadius, wheelMass, modelDisplay);
  blocks = new Blocks(this, physics, BoxNumberV, BoxNumberH, boxSize, boxCenterPos, boxMass);

  gui = new RobotGUI(this, robot);

  thread("SubThread");
}

void SubThread() {
  while (loopFlag)
  {
    float vx = gui.getVx();
    float va = gui.getVa();
    robot.setVelocity(vx, va);
    physics.world.stepSimulation(0.02f);
    try {
      Thread.sleep(1);
    } 
    catch(InterruptedException ex) {
      ex.printStackTrace();
    }
  }
}






float value = 0;
void draw() {

  background(32);
  smooth();
  lights(); 
  directionalLight(51, 102, 126, -1, 0, 0);

  noStroke();

  ground.drawObject();
  robot.drawObject();
  blocks.drawObject();

}
