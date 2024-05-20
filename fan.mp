prologues:=3;
outputtemplate:="%j-%c.mps";

verbatimtex
%&uplatex
\documentclass[uplatex]{jsarticle}
\usepackage[T1]{fontenc}
\usepackage{textcomp}
\usepackage{listings,jvlisting}
\begin{document}
etex;

% zのマクロをsuffixで(点を定義)
def zdef(suffix A)=
  vardef z.A=(x.A, y.A) enddef;
enddef;

% zマクロ間の点のEuclid距離
vardef dist(suffix A, B)=
  begingroup
    save dx, dy; numeric dx, dy;
    (dx, dy) = z.A - z.B;
    sqrt(dx*dx + dy*dy)
  endgroup
enddef;

% 線分を切る線分
vardef cut(expr a, b, pos, len) =
  begingroup
    save dx, dy, l, v; numeric dx, dy, l; pair v;
    (-dy, dx) = a-b;
    l = len*0.5/sqrt(dx*dx+dy*dy);
    v = l*(dx, dy);
    pos[a,b]+v -- pos[a,b]-v
  endgroup
enddef;

% 単位ベクトル
vardef unit(expr v) = 
  begingroup
    save a, x, y; numeric a, x, y;
    (x, y) = v;
    a = sqrt(x*x+y*y);
    v/a
  endgroup
enddef;
  
% 角の塗り潰し用
vardef fillangle(expr c, a, b, r) =
  begingroup
    save aa, bb, mm; pair aa, bb, mm;
    aa = c + r*unit(a-c);
    bb = c + r*unit(b-c);
    mm = c + r*unit(.5[aa,bb]-c);
    c--aa..mm..bb--cycle
  endgroup
enddef;

% 角のマーク
def mark_angle(expr a, b, o, r, rr) =
  begingroup
    save v, u, m; pair v, u, m;
    v = o+r*unit((a-o)*0.1);
    u = o+r*unit((b-o)*0.1);
    m = o+r*unit((a+b-o-o)*0.1)*rr;
    draw v..m..u;
    %draw 0.1[m, o]--(-0.1)[m,o];
  endgroup
enddef;

def draw_metric(suffix a, b)(expr s, len) =
  save l, dx, dy, p, q; numeric l, dx, dy; pair p, q;
  l = dist(a,b);
  (dy, -dx)=(z.b-z.a)/l*len;
  p = 0.5[z.a, z.b]+(dx, dy);
  draw z.a...p...z.b;
  q = p + (dx, dy);
  label(s, q);
enddef;

beginfig(0)
u=20;
save z;
zdef(o);zdef(a);zdef(b);zdef(c);zdef(d);zdef(e);
z.o = (20,20);
z.a = z.o + (-u, 0);
r = u*2*sqrt(7);
z.b = z.o + (-u, 3*sqrt(3)*u);
a = angle(z.b-z.o)/3;
z.c = z.o + r*dir(a*2);
z.d = z.o + r*dir(a);
z.e = (x.d, y.o);

% 図本体の描画
pickup pencircle scaled 1bp;
drawoptions(withcolor black);
draw z.o--z.b--z.a--z.e--z.d..z.c..z.b;
draw z.c--z.o--z.d dashed evenly;

% ラベルの描画
label.llft(btex $A$ etex, z.a);
label.top(btex $B$ etex, z.b);
label.urt(btex $C$ etex, z.c);
label.urt(btex $D$ etex, z.d);
label.bot(btex $E$ etex, z.e);
label.bot(btex $O$ etex, z.o);
% 図の注釈の描画
drawoptions(withcolor (68red+114green+196blue)/255);
rr=7;
ra=21;
draw z.a+(rr,0) -- z.a+(rr,rr) -- z.a+(0,rr);
mark_angle(z.b, z.c, z.o, ra, 1.1);
mark_angle(z.c, z.d, z.o, ra, 1.1);
mark_angle(z.d, z.e, z.o, ra, 1.1);
drawoptions(withcolor (196red+64green+68blue)/255);
draw_metric(o, b)(btex $2\sqrt7$ etex, 12);
draw_metric(o, a)(btex $1$ etex, 5);
endfig;
end
