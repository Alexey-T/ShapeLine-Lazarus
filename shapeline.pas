unit shapeline;

interface

{$mode delphi}

uses
  Graphics, SysUtils, Classes, Controls;

type
  TShapeLineDirection = (drLeftRight, drUpDown, drTopLeftBottomRight, drTopRightBottomLeft);

  { TShapeLine }

  TShapeLine = class(TGraphicControl)
  private
    { Private declarations }
    FLineDir: TShapeLineDirection;
    FArrow1: Boolean;
    FArrow2: Boolean;
    FArrowFactor: Integer;
    FLineWidth: integer;
    FLineColor: TColor;
    FArrowColor: TColor;

    procedure SetArrowColor(AValue: TColor);
    procedure SetLineColor(AValue: TColor);
    procedure SetLineDir(AValue: TShapeLineDirection);
    procedure SetArrow1(Value: Boolean);
    procedure SetArrow2(Value: Boolean);
    procedure SetArrowFactor(Value: integer);
    procedure SetLineWidth(AValue: Integer);
  protected
    { Protected declarations }
    procedure Paint; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property DragCursor;
    property DragKind;
    property DragMode;
    property Align;
    property ParentShowHint;
    property Hint;
    property ShowHint;
    property Visible;
    property PopupMenu;
    property Direction: TShapeLineDirection read FLineDir write SetLineDir default drLeftRight;
    property LineColor: TColor read FLineColor write SetLineColor;
    property ArrowColor: TColor read FArrowColor write SetArrowColor;
    property LineWidth: Integer read FLineWidth write SetLineWidth;
    property Arrow1: Boolean read FArrow1 write SetArrow1 default False;
    property Arrow2: Boolean read FArrow2 write SetArrow2 default False;
    property ArrowFactor: Integer read FArrowFactor write SetArrowFactor default 8;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEndDock;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnClick;
    property OnDblClick;
  end;

procedure Register;

implementation

{ TShapeLine }

constructor TShapeLine.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  Width:=110;
  Height:=30;
  FArrow1:=false;
  FArrow2:=false;
  FArrowFactor:=8;
  FArrowColor:=clBlack;
  FLineColor:=clBlack;
  FLineWidth:=1;
  FLineDir:=drLeftRight;
end;

destructor TShapeLine.Destroy;
begin
  inherited Destroy;
end;

procedure TShapeLine.SetArrowFactor(Value: integer);
begin
  if Value <> FArrowFactor then begin
     FArrowFactor := Value;
     Invalidate; 
  end;
end;

procedure TShapeLine.SetArrow1(Value: Boolean);
begin
  if Value <> FArrow1 then begin
     FArrow1 := Value;
     if Value then SetLineWidth(1);
     Invalidate;
  end;
end;

procedure TShapeLine.SetArrow2(Value: Boolean);
begin
  if Value <> FArrow2 then begin
     FArrow2 := Value;
     if Value then SetLineWidth(1);
     Invalidate;
  end;
end;

procedure TShapeLine.SetLineWidth(AValue: Integer);
begin
  if AValue <> FLineWidth then
  begin
    if FArrow1 or FArrow2 then
      FLineWidth := 1
    else
      FLineWidth := AValue;
    Invalidate;
  end;
end;

procedure TShapeLine.SetLineColor(AValue: TColor);
begin
  if AValue <> FLineColor then
  begin
    FLineColor := AValue;
    Invalidate;
  end;
end;

procedure TShapeLine.SetArrowColor(AValue: TColor);
begin
  if AValue <> FArrowColor then
  begin
    FArrowColor := AValue;
    Invalidate;
  end;
end;

procedure TShapeLine.SetLineDir(AValue: TShapeLineDirection);
begin
  if AValue <> FLineDir then
  begin
    FLineDir := AValue;
    Invalidate;
  end;
end;

procedure TShapeLine.Paint;
var
  start: Integer;
  p1,p2,p3: TPoint;
  H0,W0,H,W: Integer;
  Alfa: double;
begin
  inherited;

  Canvas.Pen.Color:= FLineColor;
  Canvas.Brush.Color:=FArrowColor;
  Canvas.Pen.Width:=FLineWidth;

  case FLineDir of
    drLeftRight:
      begin
        start := (Height - FLineWidth) div 2;
        Canvas.MoveTo(0, start);
        Canvas.LineTo(Width, Start);
        if FArrow1 then begin
          //Flecha hacia izquierda
          p1:=Point(0,start);
          p2:=Point(FArrowFactor,Start-FArrowFactor);
          p3:=Point(FArrowFactor,Start+FArrowFactor);
          Canvas.Polygon([p1,p2,p3]);
        end;

        if FArrow2 then begin
          //Flecha hacia derecha
          p1:=Point(Width-1, Start);
          p2:=Point(Width-(FArrowFactor+1),Start-FArrowFactor);
          p3:=Point(Width-(FArrowFactor+1),Start+FArrowFactor);
          Canvas.Polygon([p1,p2,p3]);
        end;
      end;
    drUpDown:
      begin
        start := (Width - FLineWidth) div 2;
        Canvas.MoveTo(start, 0);
        Canvas.LineTo(start, Height);
        if FArrow1 then begin
          //Flecha hacia arriba
          p1:=Point(start,0);
          p2:=Point(Start-FArrowFactor,FArrowFactor);
          p3:=Point(Start+FArrowFactor,FArrowFactor);
          Canvas.Polygon([p1,p2,p3]);
        end;

        if FArrow2 then begin
          //Flecha hacia abajo
          p1:=Point(start,Height-1);
          p2:=Point(Start-FArrowFactor,Height-(FArrowFactor+1));
          p3:=Point(Start+FArrowFactor,Height-(FArrowFactor+1));
          Canvas.Polygon([p1,p2,p3]);
        end;
      end;
    drTopLeftBottomRight:
      begin
        Canvas.MoveTo(0, 0);
        Canvas.LineTo(Width, Height);
        if FArrow1 and(Width>0)then begin
          //Flecha hacia arriba
          Alfa:=ArcTan(Height/Width);
          H0:=Round((FArrowFactor+1)*Sin(Alfa));
          W0:=Round((FArrowFactor+1)*Cos(Alfa));

          p1:=Point(0,0);
          W:=Round(W0+(FArrowFactor*Cos((Pi/2)-Alfa)));
          H:=Round(H0-(FArrowFactor*Sin((Pi/2)-Alfa)));

          if H<0 then H:=0;
          if W<0 then W:=0;

          p2:=Point(W,H);

          W:=Round(W0-(FArrowFactor*Cos((Pi/2)-Alfa)));
          H:=Round(H0+(FArrowFactor*Sin((Pi/2)-Alfa)));

          if H<0 then H:=0;
          if W<0 then W:=0;

          p3:=Point(W,H);

          Canvas.Polygon([p1,p2,p3]);
        end;


        if FArrow2 and(Width>0)then begin
          //Flecha hacia abajo
          Alfa:=ArcTan(Height/Width);
          H0:=Round((FArrowFactor+1)*Sin(Alfa));
          W0:=Round((FArrowFactor+1)*Cos(Alfa));

          p1:=Point(Width-1, Height-1);
          
          W:=Round(W0-(FArrowFactor*Cos((Pi/2)-Alfa)));
          H:=Round(H0+(FArrowFactor*Sin((Pi/2)-Alfa)));

          W:=Width-W-1;
          H:=Height-H-1;
          
          if H>=Height then H:=Height-1;
          if W>=Width then W:=Width-1;

          p2:=Point(W,H);

          W:=Round(W0+(FArrowFactor*Cos((Pi/2)-Alfa)));
          H:=Round(H0-(FArrowFactor*Sin((Pi/2)-Alfa)));

          W:=Width-W-1;
          H:=Height-H-1;
          
          if H>=Height then H:=Height-1;
          if W>=Width then W:=Width-1;

          p3:=Point(W,H);

          Canvas.Polygon([p1,p2,p3]);
        end;

      end;
    drTopRightBottomLeft:
      begin
        Canvas.MoveTo(Width, 0);
        Canvas.LineTo(0, Height);
        if FArrow1 and(Width>0)then begin
          //Flecha hacia arriba
          Alfa:=ArcTan(Height/Width);
          H0:=Round((FArrowFactor+1)*Sin(Alfa));
          W0:=Round((FArrowFactor+1)*Cos(Alfa));

          p1:=Point(Width-1,0);
          
          W:=Round(W0+(FArrowFactor*Cos((Pi/2)-Alfa)));
          H:=Round(H0-(FArrowFactor*Sin((Pi/2)-Alfa)));

          W:=Width-W-1;

          if H<0 then H:=0;
          if W>=Width then W:=Width-1;

          p2:=Point(W,H);

          W:=Round(W0-(FArrowFactor*Cos((Pi/2)-Alfa)));
          H:=Round(H0+(FArrowFactor*Sin((Pi/2)-Alfa)));

          W:=Width-W-1;

          if H<0 then H:=0;
          if W>=Width then W:=Width-1;

          p3:=Point(W,H);

          Canvas.Polygon([p1,p2,p3]);
        end;

        if FArrow2 and(Width>0)then begin
          //Flecha hacia abajo
          Alfa:=ArcTan(Height/Width);
          H0:=Round((FArrowFactor+1)*Sin(Alfa));
          W0:=Round((FArrowFactor+1)*Cos(Alfa));

          p1:=Point(0, Height-1);
          
          W:=Round(W0-(FArrowFactor*Cos((Pi/2)-Alfa)));
          H:=Round(H0+(FArrowFactor*Sin((Pi/2)-Alfa)));

          H:=Height-H-1;
          
          if H>=Height then H:=Height-1;
          if W<0 then W:=0;

          p2:=Point(W,H);

          W:=Round(W0+(FArrowFactor*Cos((Pi/2)-Alfa)));
          H:=Round(H0-(FArrowFactor*Sin((Pi/2)-Alfa)));

          H:=Height-H-1;
          
          if H>=Height then H:=Height-1;
          if W<0 then W:=0;

          p3:=Point(W,H);

          Canvas.Polygon([p1,p2,p3]);
        end;
      end;
  end;
end;

procedure Register;
begin
  RegisterComponents('Misc', [TShapeLine]);
end;

end.
