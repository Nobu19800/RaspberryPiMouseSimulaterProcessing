import com.bulletphysics.dynamics.RigidBody;
import javax.vecmath.Vector3f;
import javax.vecmath.Quat4f;

Vector3f quaternion_to_euler_angle(Quat4f quat) {
  float ysqr = quat.y * quat.y;

  float t0 = 2.0 * (quat.w * quat.x + quat.y * quat.z);
  float t1 = 1.0 - 2.0 * (quat.x * quat.x + ysqr);
  float X = atan2(t0, t1);

  float t2 = 2.0 * (quat.w * quat.y - quat.z * quat.x);
  t2 = (t2 > 1.0)? 1.0:t2;
  t2 = (t2 < -1.0)? -1.0:t2;
  float Y = asin(t2);

  float t3 = 2.0 * (quat.w * quat.z + quat.x * quat.y);
  float t4 = 1.0 - 2.0 * (ysqr + quat.z * quat.z);

  float Z = atan2(t3, t4);

  Vector3f forReturn = new Vector3f(X, Y, Z);

  return forReturn;
}

void setObjectPosition(RigidBody rigidBody)
{
  try
  {
    Vector3f pos = rigidBody.getCenterOfMassPosition(new Vector3f());
    Quat4f rot = rigidBody.getOrientation(new Quat4f());
    Vector3f euler = quaternion_to_euler_angle(rot);

    translate(pos.x, pos.y, pos.z);
    rotateZ(euler.z);
    rotateY(euler.y);
    rotateX(euler.x);
  }
  catch(IndexOutOfBoundsException ex)
  {
  }
}


class Ground
{
  Ground(BPhysics physics, Vector3f size)
  {
    //地面を生成する
    plane = new BPlane(new Vector3f(0, 0, -1), new Vector3f(0, 0, 1));
    physics.addPlane(plane);
    this.size = size;
  }
  public void drawObject()
  {
    pushMatrix();
    setObjectPosition(plane.rigidBody);
    
    //地面を描画する
    fill(#bdb76b);
    box(size.x, size.y, size.z);
    popMatrix();
  }
  private BPlane plane;
  private Vector3f size;
}
