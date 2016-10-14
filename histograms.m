figure(1)
lbins=2*10^4:5000:10*10^4;
dbins=0.05:0.05:.95;

subplot(4,2,1)
[a_l_e_I,b_l_e_I]=hist(l_e_I,lbins);
bar(b_l_e_I,a_l_e_I/sum(a_l_e_I),1)
title('Latency Epidemic')

subplot(4,2,2)
[a_d_e_I,b_d_e_I]=hist(d_e_I,dbins);
bar(b_d_e_I,a_d_e_I/sum(a_d_e_I),1)
title('Delivery Epidemic')


subplot(4,2,3)
[a_l_p1_I,b_l_p1_I]=hist(l_p1_I,lbins);
bar(b_l_p1_I,a_l_p1_I/sum(a_l_p1_I),1)
title('Latency PRoPHET')

subplot(4,2,4)
[a_d_p1_I,b_d_p1_I]=hist(d_p1_I,dbins);
bar(b_d_p1_I,a_d_p1_I/sum(a_d_p1_I),1)
title('Delivery PRoPHET')


subplot(4,2,5)
[a_l_MP_I,b_l_MP_I]=hist(l_MP_I,lbins);
bar(b_l_MP_I,a_l_MP_I/sum(a_l_MP_I),1)
title('Latency MaxProp')

subplot(4,2,6)
[a_d_MP_I,b_d_MP_I]=hist(d_MP_I,dbins);
bar(b_d_MP_I,a_d_MP_I/sum(a_d_MP_I),1)
title('Delivery MaxProp')


subplot(4,2,7)
[a_l_ML_I,b_l_ML_I]=hist(l_ML_I,lbins);
bar(b_l_ML_I,a_l_ML_I/sum(a_l_ML_I),1)
title('Latency MinLat')

subplot(4,2,8)
[a_d_ML_I,b_d_ML_I]=hist(d_ML_I,dbins);
bar(b_d_ML_I,a_d_ML_I/sum(a_d_ML_I),1)
title('Delivery MinLat')
%%
figure(2)
subplot(4,2,1)
AveLat_e_I=zeros(1,N);
for i=[1:30,32:35,37:N]
    ind=find(destination_vector==i);
    AveLat_e_I(i)=mean(l_e_I(ind));
    clear ind
end
bar(AveLat_e_I,1)
title('Latency Epidemic')

subplot(4,2,2)
AveDel_e_I=zeros(1,N);
for i=[1:30,32:35,37:N]
    ind=find(destination_vector==i);
    AveDel_e_I(i)=mean(d_e_I(ind));
    clear ind
end
bar(AveDel_e_I,1)
title('Delivery Epidemic')


subplot(4,2,3)
AveLat_p1_I=zeros(1,N);
for i=[1:30,32:35,37:N]
    ind=find(destination_vector==i);
    AveLat_p1_I(i)=mean(l_p1_I(ind));
    clear ind
end
bar(AveLat_p1_I,1)
title('Latency PRoPHET')

subplot(4,2,4)
AveDel_p1_I=zeros(1,N);
for i=[1:30,32:35,37:N]
    ind=find(destination_vector==i);
    AveDel_p1_I(i)=mean(d_p1_I(ind));
    clear ind
end
bar(AveDel_p1_I,1)
title('Delivery PRoPHET')


subplot(4,2,5)
AveLat_MP_I=zeros(1,N);
for i=[1:30,32:35,37:N]
    ind=find(destination_vector==i);
    AveLat_MP_I(i)=mean(l_MP_I(ind));
    clear ind
end
bar(AveLat_MP_I,1)
title('Latency MaxProp')

subplot(4,2,6)
AveDel_MP_I=zeros(1,N);
for i=[1:30,32:35,37:N]
    ind=find(destination_vector==i);
    AveDel_MP_I(i)=mean(d_MP_I(ind));
    clear ind
end
bar(AveDel_MP_I,1)
title('Delivery MaxProp')


subplot(4,2,7)
AveLat_ML_I=zeros(1,N);
for i=[1:30,32:35,37:N]
    ind=find(destination_vector==i);
    AveLat_ML_I(i)=mean(l_ML_I(ind));
    clear ind
end
bar(AveLat_ML_I,1)
title('Latency MinLat')

subplot(4,2,8)
AveDel_ML_I=zeros(1,N);
for i=[1:30,32:35,37:N]
    ind=find(destination_vector==i);
    AveDel_ML_I(i)=mean(d_ML_I(ind));
    clear ind
end
bar(AveDel_ML_I,1)
title('Delivery MinLat')

%%
figure(3)
lbins=2*10^4:5000:10*10^4;
dbins=0.05:0.05:.95;

subplot(4,2,1)
[a_AveLat_e_I,b_AveLat_e_I]=hist(AveLat_e_I([1:30,32:35,37:N]),lbins);
bar(b_AveLat_e_I,a_AveLat_e_I/sum(a_AveLat_e_I),1)
title('Latency Epidemic')

subplot(4,2,2)
[a_AveDel_e_I,b_AveDel_e_I]=hist(AveDel_e_I([1:30,32:35,37:N]),dbins);
bar(b_AveDel_e_I,a_AveDel_e_I/sum(a_AveDel_e_I),1)
title('Delivery Epidemic')


subplot(4,2,3)
[a_AveLat_p1_I,b_AveLat_p1_I]=hist(AveLat_p1_I([1:30,32:35,37:N]),lbins);
bar(b_AveLat_p1_I,a_AveLat_p1_I/sum(a_AveLat_p1_I),1)
title('Latency PRoPHET')

subplot(4,2,4)
[a_AveDel_p1_I,b_AveDel_p1_I]=hist(AveDel_p1_I([1:30,32:35,37:N]),dbins);
bar(b_AveDel_p1_I,a_AveDel_p1_I/sum(a_AveDel_p1_I),1)
title('Delivery PRoPHET')


subplot(4,2,5)
[a_AveLat_MP_I,b_AveLat_MP_I]=hist(AveLat_MP_I([1:30,32:35,37:N]),lbins);
bar(b_AveLat_MP_I,a_AveLat_MP_I/sum(a_AveLat_MP_I),1)
title('Latency MaxProp')

subplot(4,2,6)
[a_AveDel_MP_I,b_AveDel_MP_I]=hist(AveDel_MP_I([1:30,32:35,37:N]),dbins);
bar(b_AveDel_MP_I,a_AveDel_MP_I/sum(a_AveDel_MP_I),1)
title('Delivery MaxProp')


subplot(4,2,7)
[a_AveLat_ML_I,b_AveLat_ML_I]=hist(AveLat_ML_I([1:30,32:35,37:N]),lbins);
bar(b_AveLat_ML_I,a_AveLat_ML_I/sum(a_AveLat_ML_I),1)
title('Latency MinLat')

subplot(4,2,8)
[a_AveDel_ML_I,b_AveDel_ML_I]=hist(AveDel_ML_I([1:30,32:35,37:N]),dbins);
bar(b_AveDel_ML_I,a_AveDel_ML_I/sum(a_AveDel_ML_I),1)
title('Delivery MinLat')

%%
figure(4)
lbins=2*10^4:5000:10*10^4;
dbins=0.05:0.05:.95;

subplot(4,2,1)
[a_AveLat_e_I,b_AveLat_e_I]=hist(AveLat_e_I([1:3,5:11,13:20,22:30,32:33,35,37:N]),lbins);
bar(b_AveLat_e_I,a_AveLat_e_I/sum(a_AveLat_e_I),1)
title('Latency Epidemic')

subplot(4,2,2)
%1:11,13:30,32:35,37:N
[a_AveDel_e_I,b_AveDel_e_I]=hist(AveDel_e_I([1:3,5:11,13:20,22:30,32:33,35,37:N]),dbins);
bar(b_AveDel_e_I,a_AveDel_e_I/sum(a_AveDel_e_I),1);
title('Delivery Epidemic')


subplot(4,2,3)
[a_AveLat_p1_I,b_AveLat_p1_I]=hist(AveLat_p1_I([1:3,5:11,13:20,22:30,32:33,35,37:N]),lbins);
bar(b_AveLat_p1_I,a_AveLat_p1_I/sum(a_AveLat_p1_I),1);
title('Latency PRoPHET')

subplot(4,2,4)
[a_AveDel_p1_I,b_AveDel_p1_I]=hist(AveDel_p1_I([1:3,5:11,13:20,22:30,32:33,35,37:N]),dbins);
bar(b_AveDel_p1_I,a_AveDel_p1_I/sum(a_AveDel_p1_I),1);
title('Delivery PRoPHET')


subplot(4,2,5)
[a_AveLat_MP_I,b_AveLat_MP_I]=hist(AveLat_MP_I([1:3,5:11,13:20,22:30,32:33,35,37:N]),lbins);
bar(b_AveLat_MP_I,a_AveLat_MP_I/sum(a_AveLat_MP_I),1);
title('Latency MaxProp')

subplot(4,2,6)
[a_AveDel_MP_I,b_AveDel_MP_I]=hist(AveDel_MP_I([1:3,5:11,13:20,22:30,32:33,35,37:N]),dbins);
bar(b_AveDel_MP_I,a_AveDel_MP_I/sum(a_AveDel_MP_I),1);
title('Delivery MaxProp')


subplot(4,2,7)
[a_AveLat_ML_I,b_AveLat_ML_I]=hist(AveLat_ML_I([1:3,5:11,13:20,22:30,32:33,35,37:N]),lbins);
bar(b_AveLat_ML_I,a_AveLat_ML_I/sum(a_AveLat_ML_I),1);
title('Latency MinLat')

subplot(4,2,8)
[a_AveDel_ML_I,b_AveDel_ML_I]=hist(AveDel_ML_I([1:3,5:11,13:20,22:30,32:33,35,37:N]),dbins);
bar(b_AveDel_ML_I,a_AveDel_ML_I/sum(a_AveDel_ML_I),1);
title('Delivery MinLat')
%%
figure(5)
subplot(4,2,1)
[a_l_e_SI,b_l_e_SI]=hist(l_e_SI,lbins);
bar(b_l_e_SI,a_l_e_SI/sum(a_l_e_SI),1)
title('Latency Epidemic')

subplot(4,2,2)
[a_d_e_SI,b_d_e_SI]=hist(d_e_SI,dbins);
bar(b_d_e_SI,a_d_e_SI/sum(a_d_e_SI),1);
title('Delivery Epidemic')


subplot(4,2,3)
[a_l_p1_SI,b_l_p1_SI]=hist(l_p1_SI,lbins);
bar(b_l_p1_SI,a_l_p1_SI/sum(a_l_p1_SI),1);
title('Latency PRoPHET')

subplot(4,2,4)
[a_d_p1_SI,b_d_p1_SI]=hist(d_p1_SI,dbins);
bar(b_d_p1_SI,a_d_p1_SI/sum(a_d_p1_SI),1);
title('Delivery PRoPHET')


subplot(4,2,5)
[a_l_MP_SI,b_l_MP_SI]=hist(l_MP_SI,lbins);
bar(b_l_MP_SI,a_l_MP_SI/sum(a_l_MP_SI),1);
title('Latency MaxProp')

subplot(4,2,6)
[a_d_MP_SI,b_d_MP_SI]=hist(d_MP_SI,dbins);
bar(b_d_MP_SI,a_d_MP_SI/sum(a_d_MP_SI),1);
title('Delivery MaxProp')


subplot(4,2,7)
[a_l_ML_SI,b_l_ML_SI]=hist(l_ML_SI,lbins);
bar(b_l_ML_SI,a_l_ML_SI/sum(a_l_ML_SI),1);
title('Latency MinLat')

subplot(4,2,8)
[a_d_ML_SI,b_d_ML_SI]=hist(d_ML_SI,dbins);
bar(b_d_ML_SI,a_d_ML_SI/sum(a_d_ML_SI),1);
title('Delivery MinLat')
 %%
figure(6)
subplot(4,2,1)
AveLat_e_SI=zeros(1,N);
for i=[1:30,32:35,37:N]
    ind=find(destination_vector==i);
    AveLat_e_SI(i)=mean(l_e_SI(ind));
    clear ind
end
bar(AveLat_e_SI,1)
title('Latency Epidemic')

subplot(4,2,2)
AveDel_e_SI=zeros(1,N);
for i=[1:30,32:35,37:N]
    ind=find(destination_vector==i);
    AveDel_e_SI(i)=mean(d_e_SI(ind));
    clear ind
end
bar(AveDel_e_SI,1)
title('Delivery Epidemic')


subplot(4,2,3)
AveLat_p1_SI=zeros(1,N);
for i=[1:30,32:35,37:N]
    ind=find(destination_vector==i);
    AveLat_p1_SI(i)=mean(l_p1_SI(ind));
    clear ind
end
bar(AveLat_p1_SI,1)
title('Latency PRoPHET')

subplot(4,2,4)
AveDel_p1_SI=zeros(1,N);
for i=[1:30,32:35,37:N]
    ind=find(destination_vector==i);
    AveDel_p1_SI(i)=mean(d_p1_SI(ind));
    clear ind
end
bar(AveDel_p1_SI,1)
title('Delivery PRoPHET')


subplot(4,2,5)
AveLat_MP_SI=zeros(1,N);
for i=[1:30,32:35,37:N]
    ind=find(destination_vector==i);
    AveLat_MP_SI(i)=mean(l_MP_SI(ind));
    clear ind
end
bar(AveLat_MP_SI,1)
title('Latency MaxProp')

subplot(4,2,6)
AveDel_MP_SI=zeros(1,N);
for i=[1:30,32:35,37:N]
    ind=find(destination_vector==i);
    AveDel_MP_SI(i)=mean(d_MP_SI(ind));
    clear ind
end
bar(AveDel_MP_SI,1)
title('Delivery MaxProp')


subplot(4,2,7)
AveLat_ML_SI=zeros(1,N);
for i=[1:30,32:35,37:N]
    ind=find(destination_vector==i);
    AveLat_ML_SI(i)=mean(l_ML_SI(ind));
    clear ind
end
bar(AveLat_ML_SI,1)
title('Latency MinLat')

subplot(4,2,8)
AveDel_ML_SI=zeros(1,N);
for i=[1:30,32:35,37:N]
    ind=find(destination_vector==i);
    AveDel_ML_SI(i)=mean(d_ML_SI(ind));
    clear ind
end
bar(AveDel_ML_SI,1)
title('Delivery MinLat')

