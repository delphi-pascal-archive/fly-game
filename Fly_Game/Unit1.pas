unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Math, StdCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Timer1: TTimer;
    Memo1: TMemo;
    GroupBox1: TGroupBox;
    PowerBar: TProgressBar;
    GroupBox2: TGroupBox;
    SpeedBar: TProgressBar;
    GroupBox3: TGroupBox;
    EditPoids: TEdit;
    GroupBox4: TGroupBox;
    EditSurf: TEdit;
    VSpeedBox: TGroupBox;
    BarVitZ: TTrackBar;
    GroupBox6: TGroupBox;
    BarAlt: TProgressBar;
    RedAlert: TShape;
    GameT: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure Trace;
    function Cx(a:single):single;
    function Cz(a:single):single;
    procedure Timer1Timer(Sender: TObject);
    procedure Perdu;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CalculeObstacle;
    procedure GameTClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    PosX,PosZ,VitX,VitZ,Traj,Power: single;
    Surf,Poids : single;
    Landed : Boolean;
    Obstacle : TRect;
    Obstacle2 : array[0..8] of TPoint;
    Obstacle3 : array[0..8] of TPoint;
    //GameType : Integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

/////////////////////////////////////////////////
procedure TForm1.FormCreate(Sender: TObject);
begin
    Form1.Caption := '';

    Randomize;
    Traj := 0;
    VitX := 100;
    VitZ := 0;
    Landed := False;

    Power := 9000;

    If GameT.ItemIndex = 0 then begin
      EditSurf.Text  := IntToStr(12 - 6 + random(12));
      EditPoids.Text := IntToStr(4310 - 2000 + random(4000));
    end else begin
      EditSurf.Text  := IntToStr(11);
      EditPoids.Text := IntToStr(2000);
    end;

    CalculeObstacle;

    PosX := 10;
    PosZ := 200;

    Form1.DoubleBuffered := True;
    Timer1.Enabled := True;
end;

/////////////////////////////////////////////////
procedure TForm1.CalculeObstacle;
var
  i : integer;
begin
  if GameT.ItemIndex = 0 then begin
    Obstacle.Left := 150 + random(300);
    Obstacle.Right := Obstacle.Left + 10 + random(50);
    Obstacle.Bottom := Image1.Height;
    Obstacle.Top := Image1.Height - (50 + random(200));
  end else begin
    Obstacle2[0].X := Round(Image1.Width / 4);
    Obstacle2[0].Y := 0;
    Obstacle3[0].X := Round(Image1.Width / 4);
    Obstacle3[0].Y := Image1.Height - 1;
    for i := 1 to 7 do begin
      //Obstacle2[i].X := Round(Image1.Width / 4 + (Image1.Width * 3 / 4) / 6 * i);
      Obstacle2[i].X := Round(Image1.Width / 4 + (Image1.Width * 3 / 4) / 6 * (i-1));
      Obstacle2[i].Y := Random(Image1.Height div 4) + Image1.Height div 2 - 70;
      //Obstacle3[i].X := Round(Image1.Width / 4 + (Image1.Width * 3 / 4) / 6 * i);
      Obstacle3[i].X := Obstacle2[i].X;
      //Obstacle3[i].Y := Image1.Height - Random(Image1.Height div 2);
      Obstacle3[i].Y := Obstacle2[i].Y + Random(120) + 20;
    end;
    Obstacle2[8].X := Image1.Width;
    Obstacle2[8].Y := 0;
    Obstacle3[8].X := Image1.Width;
    Obstacle3[8].Y := Image1.Height - 1;
  end;
end;

/////////////////////////////////////////////////
procedure TForm1.Trace();
var
    t : integer;
    a, b : single;
begin
    t := 10;

    Image1.Canvas.Brush.Color := clBlack;
    Image1.Canvas.FillRect(Rect(0,0,Image1.Width,Image1.Height));

    if GameT.ItemIndex = 0 then begin
      Image1.Canvas.Brush.Color := clGray;
      Image1.Canvas.FillRect(Obstacle);
    end else begin
      Image1.Canvas.Brush.Color := clGray;
      Image1.Canvas.Polygon(Obstacle2);
      Image1.Canvas.Polygon(Obstacle3);
    end;

    a := cos(Traj*Pi/180)*t;
    b := sin(Traj*Pi/180)*t;

    If Image1.Canvas.Pixels[round(PosX+a), round(Image1.Height - PosZ-b)] = clGray then Perdu;
    If Image1.Canvas.Pixels[round(PosX-a), round(Image1.Height - PosZ+b)] = clGray then Perdu;

    Image1.Canvas.Pen.Color := clWhite;
    Image1.Canvas.MoveTo(round(PosX+a), round(Image1.Height - PosZ-b));
    Image1.Canvas.LineTo(round(PosX-a), round(Image1.Height - PosZ+b));
    Image1.Canvas.LineTo(round(PosX-a-b/2), round(Image1.Height - PosZ+b-a/2));

    PowerBar.Position := Round(Power);
    SpeedBar.Position := Round(Sqrt(VitX*VitX+VitZ*VitZ));
end;

/////////////////////////////////////////////////
// Cx et Cz en fonction de l'incidense en degrés
//
function TForm1.Cx(a: single): single;
begin
  Result := 4E-06 * a*a*a*a - 5E-05 * a*a*a + 0.0003 * a*a + 0.0003 * a + 0.0098;
  if Result > 0.035 then Result := 0.035;
  Result := Result*5;
end;
function TForm1.Cz(a: single): single;
begin
  Result := -0.0001* a*a*a - 0.0004* a*a + 0.1079*a + 0.3317;
  if (a < -5) then result := -0.2;
  if (a > 13) then result := 1.31;
end;
//
/////////////////////////////////////////////////

procedure TForm1.Timer1Timer(Sender: TObject);
var
  c, s : single;
  Incid : single;
  AccelX,AccelZ : single;
  Vit : single;
  p : single;
begin

  Surf  := StrToIntDef(EditSurf.Text, 10);
  Poids := StrToIntDef(EditPoids.Text, 3000);

  p := 0.1;

  c := cos(Traj*Pi/180);
  s := sin(Traj*Pi/180);
  Incid := Traj - (ArcTan2(VitZ,VitX)*180/Pi);

  Traj := Traj - Incid / 100;
  if Traj > 90 Then Traj := 90;
  if Traj < -90 Then Traj := -90;

  Vit := Sqrt(VitX*VitX+VitZ*VitZ);

  AccelX := (Power*c - 0.5*1.293*Surf*Vit*Vit*Cx(Incid)*c - 0.5*1.293*Surf*Vit*Vit*Cz(Incid)*s) / Poids;
  AccelZ := (Power*s - 0.5*1.293*Surf*Vit*Vit*Cx(Incid)*s + 0.5*1.293*Surf*Vit*Vit*Cz(Incid)*c) / Poids - 9.81;

  VitX := VitX + AccelX * p;
  //if VitX<0 then VitX :=0;
  VitZ := VitZ + AccelZ * p;
  //if VitZ<-100 then VitZ :=-100;
  if VitZ > 0 then Landed := False;

  PosX := PosX + VitX * p / 10;
  PosZ := PosZ + VitZ * p / 10;

  if PosX > Image1.Width then begin
    PosX := 0;
    if GameT.ItemIndex = 1 then CalculeObstacle;
  end;
  if PosX < 0 then PosX := Image1.Width;
  if PosZ > Image1.Height then PosZ := 0;
  if PosZ < 1 then PosZ := 1;

  Trace;

  if ((PosZ = 1) and (VitZ < 0)) then begin
     if VitZ < -10 then begin
       Perdu;
     end else begin
       if Not landed then Form1.Caption := 'You Win ! Score :' + FloatToStr(Int(100-Vit+VitZ)) ;
       VitZ := 0;
       if Traj < 0 then Traj := 0;
       if Power = 0 then VitX := VitX - 0.5;
       if VitX < 0 then VitX := 0;
       Landed := True;
     end;
  end;

  BarAlt.Position := Round((PosZ-1)*100);
  BarVitZ.Position := -Round((VitZ)*100);
  RedAlert.Visible := ((VitZ < -10) and (PosZ < 30));

  Memo1.Lines.Clear;
  Memo1.Lines.Add(Format('Vit=%.f VitZ=%.f', [Vit, VitZ]));
  //Memo1.Lines.Add(Format('Traj=%f Incid=%f', [Traj, Incid]));
  //Memo1.Lines.Add(Format('AccelX=%f', [AccelX]));
  //Memo1.Lines.Add(Format('AccelZ=%f', [AccelZ]));
  //Memo1.Lines.Add(Format('Vit=%f VitX=%f VitZ=%f', [Vit, VitX, VitZ]));
  //Memo1.Lines.Add(Format('Power=%f', [Power]));
  //Memo1.Lines.Add(Format('Surf=%.f Poids=%.f', [Surf, Poids]));

  //For a := 0 To 255 do  begin //scan les touches de 0 a 255(en général ca fait tou le clavier)
  //  If (GetAsyncKeyState(a) And 32768) <> 0 Then begin
  //    Form1.Caption := inttostr(a);
  //  end;
  //end;

  If (GetAsyncKeyState(40) And 32768) <> 0 Then Traj := Traj + 0.8;
  If (GetAsyncKeyState(38) And 32768) <> 0 Then Traj := Traj - 0.8;

  If (GetAsyncKeyState(39) And 32768) <> 0 Then Power := Power + 400;
  If Power > 25000 then Power := 25000;
  If (GetAsyncKeyState(37) And 32768) <> 0 Then Power := Power - 400;
  If Power < 0 then Power := 0;

end;

/////////////////////////////////////////////////
procedure TForm1.Perdu;
var
  i : integer;
begin
  Form1.Caption := 'You Lose !' + IntToStr(Round(VitZ));
  for i := 0 to 100 do begin
    Image1.Canvas.Pen.Color := Random(65535);
    Image1.Canvas.MoveTo(round(PosX), round(Image1.Height - PosZ));
    Image1.Canvas.LineTo(round(PosX - 50 + random(100)), round(Image1.Height - PosZ -50+random(100)));
    Image1.Refresh;
    Sleep(10);
  end;
  Timer1.Enabled := False;
end;

/////////////////////////////////////////////////
procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = ' ' then FormCreate(nil);
end;

procedure TForm1.GameTClick(Sender: TObject);
begin
  FormCreate(nil);
  GameT.SetFocus;
end;

end.

