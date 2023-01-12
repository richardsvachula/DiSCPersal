function vterm=terminal(d,density)
%density should range from 0.4 to 0.6 g/cc
%diameter is input in microns
%d=0:10:500;
dcm=d/10000.;
rho=0.00127;
mu=0.00018;
gravity=981.;
vterm=[]
for k=1:length(dcm)
    v=(((density-rho)*gravity*dcm(k)*dcm(k))/(18*mu))/100;
    vterm=[vterm v];
end