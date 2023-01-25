import javax.vecmath.Vector3f;
import javax.vecmath.Quat4f;
import bRigid.*;

class Robot
{
  Robot(PApplet papp, BPhysics physics, Vector3f bodySize, Vector3f bodyPos, float bodyMass, Vector3f wheelPos, float wheelRadius, float wheelMass, boolean modelDisplay)
  {

    this.bodySize = bodySize;
    this.bodyPos = bodyPos;
    this.wheelPos = wheelPos;
    this.wheelRadius = wheelRadius;
    this.modelDisplay = modelDisplay;

    if (modelDisplay)
    {
      //OBJファイル読み込み
      robotShape[0] = loadShape("AnyConv.com__RasPiMouse_with_Pi4B2_1.obj");
      robotShape[1] = loadShape("AnyConv.com__RasPiMouse_with_Pi4B2_2.obj");
      robotShape[2] = loadShape("AnyConv.com__RasPiMouse_with_Pi4B2_3.obj");
      wheelShape[0][0] = loadShape("AnyConv.com__wheel1.obj");
      wheelShape[0][1] = loadShape("AnyConv.com__wheel2.obj");
      wheelShape[1][0] = loadShape("AnyConv.com__wheel1.obj");
      wheelShape[1][1] = loadShape("AnyConv.com__wheel2.obj");

      for (PShape obj : robotShape)
      {
        obj.disableStyle();
      }

      for (PShape[] objList : wheelShape)
      {
        for (PShape obj : objList)
        {
          obj.disableStyle();
        }
      }
    }

    //ロボットの車体に対応する剛体を生成
    body = new BBox(papp, bodyMass, bodyPos, bodySize, true);
    physics.addBody(body);



    for (int i=0; i < wheelObjects.length; i++)
    {
      Vector3f pos = new Vector3f(wheelPos.x, -wheelPos.y, wheelPos.z/2f);
      if (i == 1)
      {
        pos.y = -pos.y;
      }
      //車輪に対応する剛体を生成
      wheelObjects[i] = new BSphere(papp, wheelMass, pos.x, pos.y, pos.z, wheelRadius);
      
      physics.addBody(wheelObjects[i]);
      BObject r = new BObject(papp, wheelMass, wheelObjects[i], pos, true);
      physics.addBody(r);


      Vector3f pivA = new Vector3f(0, -bodySize.y/2f, -bodyPos.z+wheelRadius);
      Vector3f pivB = new Vector3f(0, 0, 0);
      Vector3f axisInA = new Vector3f(0, -1, 0);
      Vector3f axisInB = new Vector3f(0, -1, 0);

      if (i == 1)
      {
        pivA.y = -pivA.y;
        pivB.y = -pivB.y;
      }
      //車輪と車体を接続するヒンジジョイントを生成
      wheelJoints[i] = new BJointHinge(body, wheelObjects[i], pivA, pivB, axisInA, axisInB);
      physics.addJoint(wheelJoints[i]);

    }
  }

  public void drawObject()
  {
    float shiftz = -0.8;

    if (modelDisplay)
    {
      pushMatrix();
      setObjectPosition(body.rigidBody);
      translate(-bodyPos.x, -bodyPos.y, -bodyPos.z+shiftz);
      fill(#000000);
      pushMatrix();
      scale(0.1);
      shape(robotShape[0]);
      fill(#c0c0c0);
      shape(robotShape[1]);
      fill(#ff0000);
      shape(robotShape[2]);
      popMatrix();

      //車輪は回転するため、他のパーツと別に処理する
      pushMatrix();
      translate(wheelPos.x, wheelPos.y, wheelPos.z);
      rotateX(-PI/2);
      float angle1 = wheelJoints[1].getHingeAngle();
      // 車輪の回転を表現
      rotateZ(angle1);
      pushMatrix();
      scale(0.1);
      fill(#c0c0c0);
      shape(wheelShape[0][0]);
      fill(#000000);
      shape(wheelShape[0][1]);
      popMatrix();
      popMatrix();
      pushMatrix();
      translate(wheelPos.x, -wheelPos.y, wheelPos.z);
      rotateX(PI/2);
      float angle0 = wheelJoints[1].getHingeAngle();
      // 車輪の回転を表現
      rotateZ(angle0);
      pushMatrix();
      scale(0.1);
      fill(#c0c0c0);
      shape(wheelShape[1][0]);
      fill(#000000);
      shape(wheelShape[1][1]);
      popMatrix();
      popMatrix();
      popMatrix();
    } else {
      pushMatrix();
      setObjectPosition(body.rigidBody);

      box(bodySize.x, bodySize.y, bodySize.z);
      popMatrix();


      for (BSphere obj : wheelObjects)
      {
        pushMatrix();
        setObjectPosition(obj.rigidBody);
        sphere(wheelRadius);
        popMatrix();
      }
    }
  }

  public float getRightMotorSpeed()
  {
    return rightMotorSpeed;
  }
  public float getLeftMotorSpeed()
  {
    return leftMotorSpeed;
  }

  public void setVelocity(float vx, float va)
  {
    //Bulletは力が均衡状態にあるとスリープ状態に移行するため、スリープ状態を解除
    body.rigidBody.activate();
    wheelObjects[0].rigidBody.activate();
    wheelObjects[1].rigidBody.activate();

    float impulse = 100.0;
    float wheelDistance = wheelPos.y*2f;
    rightMotorSpeed = (vx - va*wheelDistance) / wheelRadius;
    leftMotorSpeed = (vx + va*wheelDistance) / wheelRadius;
    
    //ヒンジジョイントの速度を設定
    wheelJoints[0].enableAngularMotor(true, rightMotorSpeed, impulse);
    wheelJoints[1].enableAngularMotor(true, leftMotorSpeed, impulse);
  }

  private Vector3f bodySize;
  private Vector3f bodyPos;
  private Vector3f wheelPos;
  private float wheelRadius;

  private PShape[] robotShape = new PShape[3];
  private PShape[][] wheelShape = new PShape[2][2];

  private BBox body;
  private BSphere[] wheelObjects = new BSphere[2];
  private BJointHinge[] wheelJoints = new BJointHinge[2];

  private float rightMotorSpeed = 0;
  private float leftMotorSpeed = 0;

  private boolean modelDisplay = true;
}
