FEE=100.0; CUT=0.85; N=6
net=lambda p:p*CUT
S={'low':8,'base':40,'high':150}            # paid-only sales / product-year at $2 (assumption)
F={'low':300,'base':2000,'high':15000}      # free installs / product-year  (assumption)
C={'low':0.005,'base':0.015,'high':0.03}    # free->Pro attach on Pro-eligible devices
K=0.4                                       # share of would-be blind buyers who take free instead
print("scn  paid-only$2 | twin$2 | twin$3(elast .75) | twin$4(elast .55)")
for s in S:
    po=N*S[s]*net(2)-FEE
    def tw(p,e):
        sales=S[s]*(1-K)*e+F[s]*C[s]*e
        return N*sales*net(p)-FEE, sales
    a,sa=tw(2,1.0); b,sb=tw(3,.75); c,sc=tw(4,.55)
    print(f"{s:4} {po:9.0f}    | {a:6.0f} ({sa:.0f}/prod) | {b:6.0f} ({sb:.0f}/prod)  | {c:6.0f} ({sc:.0f}/prod)")
for s in S: print(s,"twin beats paid-only at $2 iff F*C > K*S:", F[s]*C[s], ">", K*S[s], F[s]*C[s]>K*S[s])
print("min attach for twin to beat paid-only, base:", round(K*S['base']/F['base'],4))
print("min attach for twin to beat paid-only, low:", round(K*S['low']/F['low'],4))
