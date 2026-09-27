import json,urllib.request,math,datetime,sys,time
def usno(date,lat,lon,tz):
    u=f"https://aa.usno.navy.mil/api/rstt/oneday?date={date}&coords={lat},{lon}&tz={tz}"
    d=json.load(urllib.request.urlopen(urllib.request.Request(u,headers={"User-Agent":"Mozilla/5.0"}),timeout=30))
    sd=d['properties']['data'].get('sundata') or []
    return {x['phen']:x['time'] for x in sd}
def jd_of(y,m,d,frac=0.0):
    return datetime.date(y,m,d).toordinal()+1721424.5+frac
def solar(jd):
    T=(jd-2451545.0)/36525.0
    L0=(280.46646+T*(36000.76983+T*0.0003032))%360
    M=357.52911+T*(35999.05029-0.0001537*T)
    e=0.016708634-T*(0.000042037+0.0000001267*T)
    C=math.sin(math.radians(M))*(1.914602-T*(0.004817+0.000014*T))+math.sin(math.radians(2*M))*(0.019993-0.000101*T)+math.sin(math.radians(3*M))*0.000289
    tl=L0+C; om=125.04-1934.136*T; lam=tl-0.00569-0.00478*math.sin(math.radians(om))
    eps0=23+(26+((21.448-T*(46.815+T*(0.00059-T*0.001813))))/60)/60
    eps=eps0+0.00256*math.cos(math.radians(om))
    dec=math.degrees(math.asin(math.sin(math.radians(eps))*math.sin(math.radians(lam))))
    y_=math.tan(math.radians(eps/2))**2
    eot=4*math.degrees(y_*math.sin(2*math.radians(L0))-2*e*math.sin(math.radians(M))+4*e*y_*math.sin(math.radians(M))*math.cos(2*math.radians(L0))-0.5*y_*y_*math.sin(4*math.radians(L0))-1.25*e*e*math.sin(2*math.radians(M)))
    return dec,eot
def events(y,m,d,lat,lon,tz,zen=90.833):
    # evaluate the sun at local noon of that local date
    jd=jd_of(y,m,d,0.5-tz/24.0)   # UT of local noon
    dec,eot=solar(jd)
    cosH=(math.cos(math.radians(zen))/(math.cos(math.radians(lat))*math.cos(math.radians(dec)))-math.tan(math.radians(lat))*math.tan(math.radians(dec)))
    noon_local=720-4*lon-eot+tz*60   # local minutes
    if cosH>1: return None,None,noon_local,'no-rise' # polar night
    if cosH<-1: return None,None,noon_local,'no-set'  # midnight sun
    H=math.degrees(math.acos(cosH))
    return noon_local-4*H,noon_local+4*H,noon_local,'ok'
def hm(x):
    if x is None: return '--'
    x=round(x); return f"{(x//60)%24:02d}:{x%60:02d}"
def tomin(s): 
    h,m=s.split(':'); return int(h)*60+int(m)
cases=[('London BST',51.5,-0.12,1,'2026-09-27'),('London GMT',51.5,-0.12,0,'2026-12-21'),('London BST solstice',51.5,-0.12,1,'2026-06-21'),
 ('London DST start day',51.5,-0.12,1,'2026-03-29'),('London DST end day',51.5,-0.12,0,'2026-10-25'),
 ('Dubai UTC+4',25.2,55.27,4,'2026-09-27'),('Dubai UTC+4 winter',25.2,55.27,4,'2026-12-21'),
 ('Honolulu UTC-10 no DST',21.3,-157.86,-10,'2026-09-27'),('Honolulu June',21.3,-157.86,-10,'2026-06-21'),
 ('Sydney AEST',-33.87,151.2,10,'2026-09-27'),('Sydney AEDT',-33.87,151.2,11,'2026-12-21'),
 ('Kathmandu UTC+5:45',27.7,85.32,5.75,'2026-09-27'),('Auckland NZST',-36.85,174.76,12,'2026-06-21'),
 ('New York EDT',40.71,-74.0,-4,'2026-09-27'),('New York DST start day',40.71,-74.0,-4,'2026-03-08'),
 ('Denver MST',39.74,-104.99,-7,'2026-12-21'),('Reykjavik UTC+0',64.15,-21.94,0,'2026-06-21'),('Reykjavik winter',64.15,-21.94,0,'2026-12-21'),
 ('Tromso polar night',69.6496,18.956,1,'2026-12-21'),('Tromso midnight sun',69.6496,18.956,2,'2026-06-21'),
 ('Tromso sun returns',69.6496,18.956,1,'2027-01-21'),('Tromso sun returns -1',69.6496,18.956,1,'2027-01-20'),('Tromso midnight sun starts',69.6496,18.956,2,'2026-05-18'),('Tromso midnight sun starts +1',69.6496,18.956,2,'2026-05-19'),
 ('Tromso equinox',69.6496,18.956,2,'2026-09-23'),('Ushuaia',-54.8,-68.3,-3,'2026-12-21'),('Singapore equator',1.35,103.82,8,'2026-03-20')]
out=[]
for name,lat,lon,tz,date in cases:
    y,m,d=map(int,date.split('-'))
    try: u=usno(date,lat,lon,tz)
    except Exception as e: print('ERR',name,e); continue
    r,s,noon,st=events(y,m,d,lat,lon,tz)
    ur=u.get('Rise'); us=u.get('Set'); un=u.get('Upper Transit')
    dr=(round(r)-tomin(ur)) if (r is not None and ur) else None
    ds=(round(s)-tomin(us)) if (s is not None and us) else None
    dn=(round(noon)%1440-tomin(un)) if un else None
    out.append((name,lat,lon,tz,date,ur,us,un,hm(r),hm(s),hm(noon),st,dr,ds,dn,u.get('Begin Civil Twilight'),u.get('End Civil Twilight')))
    print(f"{name:28} tz={tz:>5} {date} USNO {ur or '--'}/{us or '--'} noon {un} | calc {hm(r)}/{hm(s)} {st:8} dRise={dr} dSet={ds} dNoon={dn}")
    time.sleep(0.3)
json.dump(out,open('usno_ref.json','w'))
