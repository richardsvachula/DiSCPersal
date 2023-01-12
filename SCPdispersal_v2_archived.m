clear all; close all
load InoueSizes
count=1:1:100000;
diam=[];
xdistance=[];
ydistance=[];
xdistanceJapan=[];
ydistanceJapan=[];
xdistanceStack=[];
ydistanceStack=[];
heightsdiagnostic=[];
densities=[];
heightsJapan=[];

for k=1:length(count);
    HJapan=0+50*rand(1,1);
    Hdiagnostic=0+200*rand(1,1);
    HStack=200;
    u=0+2.*rand(1,1); %x wind vector
    v=0+2.*rand(1,1);
    heightsdiagnostic=[heightsdiagnostic Hdiagnostic];
    heightsJapan=[heightsJapan HJapan];
    vnegator=randi([0 1]);
    if vnegator==1
        v=-v
    end
    density=0.7+0.4*rand(1,1);
    densities=[densities density];
    t=randi([1 length(InoueSizes)],1)
    diameter=InoueSizes(t);
    vterm=terminal(diameter,density);
    falltime=Hdiagnostic/vterm;
    xdist=u*falltime;
    ydist=v*falltime;
    diam=[diam diameter];
    xdistance=[xdistance xdist];
    ydistance=[ydistance ydist];
    falltimeJapan=HJapan/vterm;
    xdistJapan=u*falltimeJapan;
    ydistJapan=v*falltimeJapan;
    xdistanceJapan=[xdistanceJapan xdistJapan];
    ydistanceJapan=[ydistanceJapan ydistJapan];
    falltimeStack=HStack/vterm;
    xdistStack=u*falltimeStack;
    ydistStack=v*falltimeStack;
    xdistanceStack=[xdistanceStack xdistStack];
    ydistanceStack=[ydistanceStack ydistStack];

end
sz=6;
fulldistdiagnostic=sqrt(((xdistance).^2)+((ydistance).^2))/1000;
fulldistJapan=sqrt(((xdistanceJapan).^2)+((ydistanceJapan).^2))/1000;
fulldistStack=sqrt(((xdistanceStack).^2)+((ydistanceStack).^2))/1000;

%% %%Diagnostic Figures
figure
ax(1)=subplot(2,1,1)
scatter(heightsdiagnostic(1,:),fulldistdiagnostic(1,:), 10, diam,'filled')
colorbar
c = colorbar;
colormap(ax(1),turbo)
caxis([5 40])
c.Label.String = 'Particle diameter (microns)';
ylim([0 50])
text(5,48,'A.','FontSize',16)
xlabel('Injection height (m)')
ylabel('Distance traveled (km)')
set(gca,'XAxisLocation','top','fontsize',12,'TickDir','out')
set(c,'fontsize',12,'TickDir','out')

ax(2)=subplot(2,1,2)
scatter(diam(1,:),fulldistdiagnostic(1,:), 10, densities,'filled')
text(90,150,'B.','FontSize',16)
colorbar
c = colorbar;
colormap(ax(2),hot)
set(c,'fontsize',12,'TickDir','out')
c.Label.String = 'Particle density (g/cm^{3})';
ylim([1 200])
xlim([0 100])
xlabel('Particle diameter (microns)')
ylabel('Distance traveled (km)')
set(gca,'YScale','log','fontsize',12,'TickDir','out')


%% %%%Comparison with Inoue Data
load Inoue;

sampling=1:1:30;
sampledsizes=[];
sampleddists=[]
medsofsamps=[];
for w=1:length(sampling);
    sampdist=0+17*rand(1,1);
    for z=1:length(fulldistJapan);
        if (sampdist-0.007)<fulldistJapan(z) && fulldistJapan(z)<(sampdist+0.007);
        %if (sampdist-0.01)<fulldistJapan(z) && fulldistJapan(z)<(sampdist+0.01);
            sampledsizes=[sampledsizes diam(z)];
        end
    end
    sampleddists=[sampleddists sampdist];
    med=median(sampledsizes,'all');
    medsofsamps=[medsofsamps med];
    sampledsizes=[];
end

figure;
scatter(sampleddists,medsofsamps,20,'r','filled')
hold on
scatter(Inoue(:,1),Inoue(:,2),15,'k','filled')
xlabel('Distance from source (km)')
ylabel('Median diameter (microns)')
xlim([0 20])
lgd=legend('Modelled','Empirical (Inoue et al. (2013))')
lgd.FontSize=12;
set(gca,'fontsize',12,'TickDir','out')

%% %%%Comparison between ambient (Inoue conditions) and stack (Gadsden)
figure;
subplot(1,2,1)
scatter(xdistanceJapan/1000,ydistanceJapan/1000,sz,diam,'filled')
xlabel('Distance traveled (km)')
ylabel('Distance traveled (km)')
xlim([0 20])
ylim([-10 10])
text(1,11,'Height = 0 to 50 m','FontSize',12)
caxis([5 40])
set(gca,'fontsize',12,'TickDir','out')

subplot(1,2,2)
scatter(xdistanceStack/1000,ydistanceStack/1000,sz,diam,'filled')
xlabel('Distance traveled (km)')
xlim([0 200])
ylim([-100 100])
text(10,110,'Height = 200 m','FontSize',12)
colorbar
c = colorbar;
caxis([5 40])
c.Label.String = 'Particle diameter (microns)';
set(gca,'fontsize',12,'TickDir','out')
set(c,'fontsize',12,'TickDir','out')
