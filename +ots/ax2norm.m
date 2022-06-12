function cord = ax2norm(AX,P)

Xlim=AX.XLim;
Ylim=AX.YLim;
Pos = AX.Position;

cord(1)=Pos(1)+(Pos(3))/(Xlim(2)-Xlim(1))*(P(1)-Xlim(1));
cord(2)=Pos(2)+(Pos(4))/(Ylim(2)-Ylim(1))*(P(2)-Ylim(1));



