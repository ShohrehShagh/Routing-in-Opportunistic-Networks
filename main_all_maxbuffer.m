clc
clear all
%% Initialization
N=41; %number of nodes
Number_of_messages=10000;
interarrival_time=5;
Sim_time=247031;%100000;
Number_of_runs=N%10;
d=1:N;%[1:30,32:41];
destination_vector=d(ceil((N-1)*rand(1,Number_of_runs)));%a random choice would be ceil(N*rand(1,1))

P_init=0.75;
beta=0.25;
gamma=0.98;
time_step1=1;
time_step2=3600;
dataset_name=sprintf('info05_new.txt');
[meeting_rates_info,revised_dataset]= info(dataset_name,N);

meeting_rates_half_info=meeting_rates_info;
for i=1:N
    for j=i+1:N
        meeting_rates_half_info(j,i)=0;
    end
end
TTL=Sim_time;
buffer_limit=Number_of_messages;
exchange_limit=buffer_limit;

%% infocom exp
    filename = sprintf('Traces/mytracefile.txt');
    generator_general(Sim_time,filename,meeting_rates_half_info,N);
for runtime=1:Number_of_runs
    runtime;

    destination=d(runtime)%destination_vector(runtime);
    generating_nodes=[1:destination-1,destination+1:N];
    message_creation_node=generating_nodes(ceil((N-1)*rand(1,Number_of_messages)));

    [l_e_PA(runtime),d_e_PA(runtime),h_e_PA(runtime),b_e_PA(runtime),N_forward_e(runtime,:)]= Epidemic(N,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL);
    [l_p1_PA(runtime),d_p1_PA(runtime),h_p1_PA(runtime),b_p1_PA(runtime),N_forward_p1(runtime,:)]= prophet(N,destination,filename,P_init,beta,gamma,time_step1,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL);
    [l_p2_PA(runtime),d_p2_PA(runtime),h_p2_PA(runtime),b_p2_PA(runtime),N_forward_p2(runtime,:)]= prophet(N,destination,filename,P_init,beta,gamma,time_step2,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL);
    [l_ML_PA(runtime),d_ML_PA(runtime),h_ML_PA(runtime),b_ML_PA(runtime),N_forward_ML(runtime,:)]= decentralized_linearOpt(N,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,meeting_rates_info,message_creation_node,TTL);   
    [l_MP_PA(runtime),d_MP_PA(runtime),h_MP_PA(runtime),b_MP_PA(runtime),N_forward_MP(runtime,:)]= maxprop(N,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL);
    for i=1:N
        N_forward_e(runtime,i)=N_forward_e(runtime,i)-length(find(message_creation_node==i));
        N_forward_p1(runtime,i)=N_forward_p1(runtime,i)-length(find(message_creation_node==i));
        N_forward_p2(runtime,i)=N_forward_p2(runtime,i)-length(find(message_creation_node==i));
        N_forward_MP(runtime,i)=N_forward_MP(runtime,i)-length(find(message_creation_node==i));
        N_forward_ML(runtime,i)=N_forward_ML(runtime,i)-length(find(message_creation_node==i));
    end
end
%%
for i=1:N
    M_forward_e(i)=mean(N_forward_e(:,i));
    M_forward_p1(i)=mean(N_forward_p1(:,i));
    M_forward_p2(i)=mean(N_forward_p2(:,i));
    M_forward_MP(i)=mean(N_forward_MP(:,i));
    M_forward_ML(i)=mean(N_forward_ML(:,i));
end
save main_all_maxbuffer
figure
subplot(3,2,1)
hist(M_forward_e)
title('Epidemic')
subplot(3,2,2)
hist(M_forward_p1)
title('PRoPHET1')
subplot(3,2,3)
hist(M_forward_p2)
title('PRoPHET2')
subplot(3,2,4)
hist(M_forward_ML)
title('MinLat')
subplot(3,2,5)
hist(M_forward_MP)
% hist(N_forward_MP([1:destination-1,destination+1:N]))
% title('MaxProp')
                               