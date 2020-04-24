%to do 
%kjøretid i tid på døgnet ? 
%få overfartstid fra simuleringen. oversette
%-------------
%legge inn antal personer tansportert 

close all;
%Tid på døgnet HHMMSS
starttidspkt = '08:00:00';

%counters   Dette funker ikke helt
bro = update_persons(out.bro, out.tout(end));
bro1 = update_persons(out.bro1, out.tout(end));
baat = update_persons(out.baat, out.tout(end));
baat1 = update_persons(out.baat1, out.tout(end));
kai1 = update_persons(out.kai, out.tout(end));
kai2 = update_persons(out.kai2, out.tout(end));

%endepkt båt 
baatstart = 0;
baatstopp = transportTime+1;% out.transportTid.Data;

%posisjon kai
pos_kai1 = baatstart - 10;
pos_kai2 = baatstopp + 10;

pos_bro = (pos_kai1 + pos_kai2)/2;

%batteri 
batt_start = 0.7 ; %  
batteri_max = 0.6; %visuell grense 
batt_cap = 38.4; %kw
batteri_naa = batt_cap*batt_start;

%lading 
batteri_gain = 4.6/3600*10;  % kw /s 
batteri_loss = 8.5/3600 * 10;  % kw/s 

%limits 
ystart = pos_kai1 - 5;
yslutt = pos_kai2 + 5;

vent = 0;
ventfinal = boardingTime*2;

t = 1; %sek
tfinal = out.tout(end);

%fart
absfart = 1;
fart = -absfart;
ret = -1;
pos_baat = 0;

i = 1;

figure('Renderer', 'painters', 'Position', [1500 -300 800 900])


while(t <= tfinal)
    if (pos_baat >= baatstopp) || (pos_baat <=0)
        fart = 0;
        vent = vent + absfart;
        batteri_naa = min([batt_cap batteri_naa+batteri_gain*absfart]);
        if vent >= ventfinal || (i < 20 && vent >= ceil(ventfinal/2))
            ret = -ret;
            fart = sign(ret)*absfart;
            vent = 0;
        end  
    else 
        batteri_naa = max([0 batteri_naa - batteri_loss*absfart]);
    end
    
    pos_baat = fart + pos_baat;
    
    %plot baat
    plot(pos_baat, 'd', 'Markersize', 60, 'MarkerFaceColor', 'w', 'MarkerEdgeColor','k');
    text(1,pos_baat, cellstr(num2str(baat(t)+baat1(t))));
    hold on 
    
    %plot kai 1
    plot(pos_kai1,'s', 'Markersize', 60, 'MarkerFaceColor', 'y', 'MarkerEdgeColor','k');
    text(1,pos_kai1, cellstr(num2str(kai1(t))));
    
    %plot kai 2
    plot(pos_kai2,'s', 'Markersize', 60, 'MarkerFaceColor', 'y', 'MarkerEdgeColor','k');
    text(1,pos_kai2, cellstr(num2str(kai2(t))));
    
    %plot bro
    rectangle('Position',[1.6,-15,0.3,90]);
    plot(1.75,pos_bro-25, 'o', 'Markersize', 30, 'MarkerFaceColor', 'w', 'MarkerEdgeColor','k');
    text(1.72,pos_bro-25, cellstr(num2str(bro(t))));
    
    %plot bro1
    plot(1.75,pos_bro+25, 'o', 'Markersize', 30, 'MarkerFaceColor', 'w', 'MarkerEdgeColor','k');
    text(1.72,pos_bro+25, cellstr(num2str(bro1(t))));
    
    %info box
    rectangle('Position',[0.05,-13,0.6,40]);
    text(0.1,25, 'Tid');
    dt = datetime( starttidspkt, 'InputFormat', 'HH:mm:ss' );
    dt.Format = 'HH:mm:ss';
    dt = dt + seconds(t);
    text(0.12,23, cellstr(dt));
%    
%     text(0.1, 20,'Transporterte personer')
%     text(0.12,18 , 'Baat')
%     text(0.3,18, 'counter')
%     
%     text(0.12,16, 'Bro')
%     text(0.3,16, 'counter')
    
    %Batteri box 
    rectangle('Position',[0.05,30,batteri_max,10]);
    text(0.2,42, 'Batteri');
    rectangle('Position',[0.05 30 batteri_naa/batt_cap*batteri_max 10],'Curvature',0.2,'FaceColor',[0 .5 .5]);

    legend({'Båt','Kai 1','Kai 2', 'Bro'},'Location', 'northwest')
    hold off
    ylim([ystart,yslutt]);
    xlim([0,2]);
    anim(i) = getframe;
    i = i+1;
    t = t+absfart;
end



