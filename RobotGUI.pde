import g4p_controls.*;
import java.awt.Font;


float maxVx = 2.0;
float maxVa = 0.1;

private RobotGUI _gui;

class RobotGUI
{
  RobotGUI(PApplet papp, Robot robot)
  {
    _gui = this;
    
    this.robot = robot;
    //画面を生成する
    windControl = GWindow.getWindow(papp, "Controls", 600, 400, 440, 240, JAVA2D);
    PApplet app = windControl;

    //int x = app.width - 120; 
    //int y = app.height - 120;
    //gButton = new GButton(app, 50, 30, 100, 30, "G4P Button" );
    //車輪の回転速度を表示するラベルを生成
    Font vfont = new Font( "IPAゴシック", Font.PLAIN, 24 );
    LabelRightMotor = new GLabel(app, 230, 30, 80, 24, "0.0");
    LabelRightMotor.setFont(vfont);
    LabelRightMotor.setOpaque(true);
    LabelLeftMotor = new GLabel(app, 330, 30, 80, 24, "0.0");
    LabelLeftMotor.setFont(vfont);
    LabelLeftMotor.setOpaque(true);
    Font ufont = new Font( "IPAゴシック", Font.PLAIN, 16 );
    LabelRightMotorU = new GLabel(app, 250, 60, 80, 20, "[rad/s]");
    LabelRightMotorU.setFont(ufont);
    LabelLeftMotorU = new GLabel(app, 350, 60, 80, 20, "[rad/s]");
    LabelLeftMotorU.setFont(ufont);

    //車輪の回転速度を表示するノブを表示
    knbRightMotor = new GKnob(app, 210, 110, 100, 100, 0.75f);
    knbLeftMotor = new GKnob(app, 310, 110, 100, 100, 0.75f);
    knbRightMotor.setTurnMode(G4P.CTRL_ANGULAR);
    knbLeftMotor.setTurnMode(G4P.CTRL_ANGULAR);
    knbRightMotor.setTurnRange(120.0, 420.0);
    knbLeftMotor.setTurnRange(120.0, 420.0);

    //車体の速度指令を設定する2Dスライダを生成する
    sliderVelocity = new GSlider2D(app, 10, 10, 200, 200);
  }
  void sliderCallback(GSlider2D slider2d)
  {
    if (slider2d == sliderVelocity)
    {
      //ラベル、ノブに車輪の速度を設定
      LabelRightMotor.setText(nf(robot.getRightMotorSpeed()*20f, 1, 1));
      LabelLeftMotor.setText(nf(robot.getLeftMotorSpeed()*20f, 1, 1));
      knbRightMotor.setValue(robot.getRightMotorSpeed()*0.5+0.5);
      knbLeftMotor.setValue(robot.getLeftMotorSpeed()*0.5+0.5);
    }
  }
  
  float getVx()
  {
    return -maxVx*(sliderVelocity.getValueYF()-0.5f)*2f;
  }
  
  float getVa()
  {
    return -maxVa*(sliderVelocity.getValueXF()-0.5f)*2f;
  }
  private GWindow windControl;
  private GKnob knbRightMotor;
  private GKnob knbLeftMotor;
  private GSlider2D sliderVelocity;
  private GLabel LabelRightMotor;
  private GLabel LabelRightMotorU;
  private GLabel LabelLeftMotor;
  private GLabel LabelLeftMotorU;

  private Robot robot;
}

//2Dスライダを操作した時のコールバック関数
public void handleSlider2DEvents(GSlider2D slider2d, GEvent event) {
  _gui.sliderCallback(slider2d);
}

//ノブを操作した時のコールバック関数
public void handleKnobEvents(GValueControl knob, GEvent event) {
}

//ボタンを操作した時のコールバック関数
public void handleButtonEvents(GButton button, GEvent event) {
  /*
  BSphere ball = new BSphere(this, 0.1, 0, 0, 20.0, 1);
   balls.add(ball);
   physics.addBody(ball);
   */
}
