import javax.vecmath.Vector3f;
import javax.vecmath.Quat4f;
import bRigid.*;

class Blocks
{
  Blocks(PApplet papp, BPhysics physics, int BoxNumberV, int BoxNumberH, Vector3f boxSize, Vector3f boxCenterPos, float boxMass)
  {
    //ブロック用3Dモデルの読み込み
    boxShape = loadShape("AnyConv.com__block.obj");
    boxShape.disableStyle();

    float xpos = boxCenterPos.x;
    for (int i=0; i < objectsList.length; i++)
    {
      float zpos = i * boxSize.z + boxSize.z/2f + boxCenterPos.z;
      for (int j=0; j < objectsList[i].length; j++)
      {
        float ypos = j * boxSize.y - (float)objectsList[i].length*boxSize.y/2f + boxCenterPos.y;
        Vector3f pos = new Vector3f(xpos, ypos, zpos);
        //ブロックに対応する剛体を生成する
        objectsList[i][j] = new BBox(papp, boxMass, pos, boxSize, true);
        physics.addBody(objectsList[i][j]);
      }
    }
  }

  void drawObject()
  {
    for (BBox[] objects : objectsList)
    {
      for (BBox object : objects)
      {

        pushMatrix();
        //剛体の座標系に移動する
        setObjectPosition(object.rigidBody);

        fill(#dc143c);
        scale(0.1);
        shape(boxShape);


        popMatrix();
      }
    }
  }
  private BBox objectsList[][] = new BBox[BoxNumberV][BoxNumberH];
  private PShape boxShape;
}
