clc
clear all
%% Initialization
N=100; %number of nodes
Number_of_messages=10000;

Number_of_runs=1;
interarrival_time=5;
destination_vector=ceil(N*rand(1,Number_of_runs));%a random choice would be ceil(N*rand(1,1))
Sim_time=247031;

P_init=0.75;
beta=0.25;
gamma=0.98;
time_step1=1;
time_step2=3600;

m0=5;
m=5;

lambda_average=2*7.5371e-05;%mean(meeting_rates_info(meeting_rates_info>0))
[meeting_rates_half,meeting_rates]= preferential_attachment_rates(N,lambda_average,m0,m);

%% TTL
T=11;%[0:6250:2.5*10^4,3.75*10^4:1.25*10^4:Sim_time];
TTL_delay_E=zeros(length(T),Number_of_runs);
TTL_delay_PR1=zeros(length(T),Number_of_runs);
TTL_delay_MP=zeros(length(T),Number_of_runs);
TTL_delay_ML=zeros(length(T),Number_of_runs);

TTL_rate_E=zeros(length(T),Number_of_runs);
TTL_rate_PR1=zeros(length(T),Number_of_runs);
TTL_rate_MP=zeros(length(T),Number_of_runs);
TTL_rate_ML=zeros(length(T),Number_of_runs);

TTL_hopcount_E=zeros(length(T),Number_of_runs);
TTL_hopcount_PR1=zeros(length(T),Number_of_runs);
TTL_hopcount_MP=zeros(length(T),Number_of_runs);
TTL_hopcount_ML=zeros(length(T),Number_of_runs);

TTL_occupancy_E=zeros(length(T),Number_of_runs);
TTL_occupancy_PR1=zeros(length(T),Number_of_runs);
TTL_occupancy_MP=zeros(length(T),Number_of_runs);
TTL_occupancy_ML=zeros(length(T),Number_of_runs);
for runtime=1:Number_of_runs
    runtime
    filename = sprintf('Traces_Restricted/mytracefile%d.txt',runtime);
    generator_general(Sim_time,filename,meeting_rates_half,N);
    destination=destination_vector(runtime);
    generating_nodes=[1:destination-1,destination+1:N];
    message_creation_node=generating_nodes(ceil((N-1)*rand(1,Number_of_messages)));
    
    buffer_limit=Number_of_messages;
    exchange_limit=buffer_limit;
    t=1;
    Tl_e=zeros(1,length(T));
    Tl_p1=zeros(1,length(T));
    Tl_ML=zeros(1,length(T));
    Tl_MP=zeros(1,length(T));

    Td_e=zeros(1,length(T));
    Td_p1=zeros(1,length(T));
    Td_ML=zeros(1,length(T));
    Td_MP=zeros(1,length(T));

    Th_e=zeros(1,length(T));
    Th_p1=zeros(1,length(T));
    Th_ML=zeros(1,length(T));
    Th_MP=zeros(1,length(T));

    Tb_e=zeros(1,length(T));
    Tb_p1=zeros(1,length(T));
    Tb_ML=zeros(1,length(T));
    Tb_MP=zeros(1,length(T));
    for TTL=11%[0:6250:2.5*10^4,3.75*10^4:1.25*10^4:Sim_time]
        TTL
        [Tl_e(t),Td_e(t),Th_e(t),Tb_e(t)]= Epidemic_revised(N,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL)
        [Tl_p1(t),Td_p1(t),Th_p1(t),Tb_p1(t)]= prophet(N,destination,filename,P_init,beta,gamma,time_step1,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL)
        [Tl_ML(t),Td_ML(t),Th_ML(t),Tb_ML(t)]= decentralized_linearOpt(N,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,meeting_rates,message_creation_node,TTL)
        [Tl_MP(t),Td_MP(t),Th_MP(t),Tb_MP(t)]= maxprop_revised(N,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL)
        t=t+1;
    end
    TTL_delay_E(:,runtime)=Tl_e;
    TTL_delay_PR1(:,runtime)=Tl_p1;
    TTL_delay_ML(:,runtime)=Tl_ML;
    TTL_delay_MP(:,runtime)=Tl_MP;
     
    TTL_rate_E(:,runtime)=Td_e;
    TTL_rate_PR1(:,runtime)=Td_p1;
    TTL_rate_ML(:,runtime)=Td_ML;
    TTL_rate_MP(:,runtime)=Td_MP;
    
    TTL_hopcount_E(:,runtime)=Th_e;
    TTL_hopcount_PR1(:,runtime)=Th_p1;
    TTL_hopcount_ML(:,runtime)=Th_ML;
    TTL_hopcount_MP(:,runtime)=Th_MP;
    
    TTL_occupancy_E(:,runtime)=Tb_e;
    TTL_occupancy_PR1(:,runtime)=Tb_p1;
    TTL_occupancy_ML(:,runtime)=Tb_ML;
    TTL_occupancy_MP(:,runtime)=Tb_MP;
end
save main_AllRestrictions
%% Buffer
B=[0:10:100,200:100:500,750:250:1250];
BUF_delay_E=zeros(length(B),Number_of_runs);
BUF_delay_PR1=zeros(length(B),Number_of_runs);
BUF_delay_MP=zeros(length(B),Number_of_runs);
BUF_delay_ML=zeros(length(B),Number_of_runs);

BUF_rate_E=zeros(length(B),Number_of_runs);
BUF_rate_PR1=zeros(length(B),Number_of_runs);
BUF_rate_MP=zeros(length(B),Number_of_runs);
BUF_rate_ML=zeros(length(B),Number_of_runs);

BUF_hopcount_E=zeros(length(B),Number_of_runs);
BUF_hopcount_PR1=zeros(length(B),Number_of_runs);
BUF_hopcount_MP=zeros(length(B),Number_of_runs);
BUF_hopcount_ML=zeros(length(B),Number_of_runs);

BUF_occupancy_E=zeros(length(B),Number_of_runs);
BUF_occupancy_PR1=zeros(length(B),Number_of_runs);
BUF_occupancy_MP=zeros(length(B),Number_of_runs);
BUF_occupancy_ML=zeros(length(B),Number_of_runs);
parfor runtime=1:Number_of_runs
    runtime
     filename = sprintf('Traces_Restricted/mytracefile%d.txt',runtime);
%     generator_general(Sim_time,filename,meeting_rates_half,N);
    destination=destination_vector(runtime);
    generating_nodes=[1:destination-1,destination+1:N];
%    message_creation_node=generating_nodes(ceil((N-1)*rand(1,Number_of_messages)));
    
    t=1;
    Bl_e=zeros(1,length(B));
    Bl_p1=zeros(1,length(B));
    Bl_ML=zeros(1,length(B));
    Bl_MP=zeros(1,length(B));

    Bd_e=zeros(1,length(B));
    Bd_p1=zeros(1,length(B));
    Bd_ML=zeros(1,length(B));
    Bd_MP=zeros(1,length(B));

    Bh_e=zeros(1,length(B));
    Bh_p1=zeros(1,length(B));
    Bh_ML=zeros(1,length(B));
    Bh_MP=zeros(1,length(B));

    Bb_e=zeros(1,length(B));
    Bb_p1=zeros(1,length(B));
    Bb_ML=zeros(1,length(B));
    Bb_MP=zeros(1,length(B));
    
    TTL=10^5;
    for buffer_limit=[0:10:100,200:100:500,750:250:1250]
        exchange_limit=buffer_limit;
        [Bl_e(t),Bd_e(t),Bh_e(t),Bb_e(t)]= Epidemic_revised(N,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL);
        [Bl_p1(t),Bd_p1(t),Bh_p1(t),Bb_p1(t)]= prophet(N,destination,filename,P_init,beta,gamma,time_step1,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL);
        [Bl_ML(t),Bd_ML(t),Bh_ML(t),Bb_ML(t)]= decentralized_linearOpt(N,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,meeting_rates,message_creation_node,TTL);
        [Bl_MP(t),Bd_MP(t),Bh_MP(t),Bb_MP(t)]= maxprop_revised(N,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL);
        t=t+1;
    end
    BUF_delay_E(:,runtime)=Bl_e;
    BUF_delay_PR1(:,runtime)=Bl_p1;
    BUF_delay_ML(:,runtime)=Bl_ML;
    BUF_delay_MP(:,runtime)=Bl_MP;
     
    BUF_rate_E(:,runtime)=Bd_e;
    BUF_rate_PR1(:,runtime)=Bd_p1;
    BUF_rate_ML(:,runtime)=Bd_ML;
    BUF_rate_MP(:,runtime)=Bd_MP;
    
    BUF_hopcount_E(:,runtime)=Bh_e;
    BUF_hopcount_PR1(:,runtime)=Bh_p1;
    BUF_hopcount_ML(:,runtime)=Bh_ML;
    BUF_hopcount_MP(:,runtime)=Bh_MP;
    
    BUF_occupancy_E(:,runtime)=Bb_e;
    BUF_occupancy_PR1(:,runtime)=Bb_p1;
    BUF_occupancy_ML(:,runtime)=Bb_ML;
    BUF_occupancy_MP(:,runtime)=Bb_MP;
end
save main_AllRestrictions
%% Exchange
E=[0:10:100,150:50:250,300:100:500];
EXC_delay_E=zeros(length(E),Number_of_runs);
EXC_delay_PR1=zeros(length(E),Number_of_runs);
EXC_delay_MP=zeros(length(E),Number_of_runs);
EXC_delay_ML=zeros(length(E),Number_of_runs);

EXC_rate_E=zeros(length(E),Number_of_runs);
EXC_rate_PR1=zeros(length(E),Number_of_runs);
EXC_rate_MP=zeros(length(E),Number_of_runs);
EXC_rate_ML=zeros(length(E),Number_of_runs);

EXC_hopcount_E=zeros(length(E),Number_of_runs);
EXC_hopcount_PR1=zeros(length(E),Number_of_runs);
EXC_hopcount_MP=zeros(length(E),Number_of_runs);
EXC_hopcount_ML=zeros(length(E),Number_of_runs);

EXC_occupancy_E=zeros(length(E),Number_of_runs);
EXC_occupancy_PR1=zeros(length(E),Number_of_runs);
EXC_occupancy_MP=zeros(length(E),Number_of_runs);
EXC_occupancy_ML=zeros(length(E),Number_of_runs);
parfor runtime=1:Number_of_runs
    runtime
     filename = sprintf('Traces_Restricted/mytracefile%d.txt',runtime);
%     generator_general(Sim_time,filename,meeting_rates_half,N);
    destination=destination_vector(runtime);
    generating_nodes=[1:destination-1,destination+1:N];
%    message_creation_node=generating_nodes(ceil((N-1)*rand(1,Number_of_messages)));
    
    TTL=10^5;
    buffer_limit=1000;

    t=1;
    El_e=zeros(1,length(E));
    El_p1=zeros(1,length(E));
    El_ML=zeros(1,length(E));
    El_MP=zeros(1,length(E));

    Ed_e=zeros(1,length(E));
    Ed_p1=zeros(1,length(E));
    Ed_ML=zeros(1,length(E));
    Ed_MP=zeros(1,length(E));

    Eh_e=zeros(1,length(E));
    Eh_p1=zeros(1,length(E));
    Eh_ML=zeros(1,length(E));
    vh_MP=zeros(1,length(E));

    Eb_e=zeros(1,length(E));
    Eb_p1=zeros(1,length(E));
    Eb_ML=zeros(1,length(E));
    Eb_MP=zeros(1,length(E));
    for exchange_limit=[0:10:100,150:50:250,300:100:500]
        [El_e(t),Ed_e(t),Eh_e(t),Eb_e(t)]= Epidemic_revised(N,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL);
        [El_p1(t),Ed_p1(t),Eh_p1(t),Eb_p1(t)]= prophet(N,destination,filename,P_init,beta,gamma,time_step1,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL);
        [El_ML(t),Ed_ML(t),Eh_ML(t),Eb_ML(t)]= decentralized_linearOpt(N,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,meeting_rates,message_creation_node,TTL);
        [El_MP(t),Ed_MP(t),Eh_MP(t),Eb_MP(t)]= maxprop_revised(N,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL);
        t=t+1;
    end
    EXC_delay_E(:,runtime)=El_e;
    EXC_delay_PR1(:,runtime)=El_p1;
    EXC_delay_ML(:,runtime)=El_ML;
    EXC_delay_MP(:,runtime)=El_MP;
     
    EXC_rate_E(:,runtime)=Ed_e;
    EXC_rate_PR1(:,runtime)=Ed_p1;
    EXC_rate_ML(:,runtime)=Ed_ML;
    EXC_rate_MP(:,runtime)=Ed_MP;
    
    EXC_hopcount_E(:,runtime)=Eh_e;
    EXC_hopcount_PR1(:,runtime)=Eh_p1;
    EXC_hopcount_ML(:,runtime)=Eh_ML;
    EXC_hopcount_MP(:,runtime)=Eh_MP;
    
    EXC_occupancy_E(:,runtime)=Eb_e;
    EXC_occupancy_PR1(:,runtime)=Eb_p1;
    EXC_occupancy_ML(:,runtime)=Eb_ML;
    EXC_occupancy_MP(:,runtime)=Eb_MP;
end
save main_AllRestrictions
%% OUTPUTS
for t=1:length(E)
    m_EXC_delay_E(t)=mean(EXC_delay_E(t,:));
    m_EXC_delay_PR1(t)=mean(EXC_delay_PR1(t,:));
    m_EXC_delay_ML(t)=mean(EXC_delay_ML(t,:));
    m_EXC_delay_MP(t)=mean(EXC_delay_MP(t,:));
    
    m_EXC_rate_E(t)=mean(EXC_rate_E(t,:));
    m_EXC_rate_PR1(t)=mean(EXC_rate_PR1(t,:));
    m_EXC_rate_ML(t)=mean(EXC_rate_ML(t,:));
    m_EXC_rate_MP(t)=mean(delivery_rate_MP(t,:));
    
    m_EXC_hopcount_E(t)=mean(EXC_hopcount_E(t,:));
    m_EXC_hopcount_PR1(t)=mean(EXC_hopcount_PR1(t,:));
    m_EXC_hopcount_ML(t)=mean(EXC_hopcount_ML(t,:));
    m_EXC_hopcount_MP(t)=mean(EXC_hopcount_MP(t,:));
    
    m_EXC_occupancy_E(t)=mean(EXC_occupancy_E(t,:));
    m_EXC_occupancy_PR1(t)=mean(EXC_occupancy_PR1(t,:));
    m_EXC_occupancy_ML(t)=mean(EXC_occupancy_ML(t,:));
    m_EXC_occupancy_MP(t)=mean(BUF_occupancy_MP(t,:));
end

%%
h1=figure(1)
plot(T,m_TTL_delay_E,'black')
hold on
plot(T,m_TTL_delay_PR1,'green')
hold on
plot(T,m_TTL_delay_MP,'blue')
hold on
plot(T,m_TTL_delay_ML,'red')
xlabel('TTL (sec)');
title('Delivery Delay');

h2=figure(2)
plot(T,m_TTL_rate_E,'black')
hold on
plot(T,m_TTL_rate_PR1,'green')
hold on
plot(T,m_TTL_rate_MP,'blue')
hold on
plot(T,m_TTL_rate_ML,'red')
legend('Epidemic','PRoPHET1','PRoPHET2','MaxProp','MinLat')
xlabel('TTL (sec)');
title('Delivery Rate');

h3=figure(3)
plot(T,m_TTL_hopcount_E,'black')
hold on
plot(T,m_TTL_hopcount_PR1,'green')
hold on
plot(T,m_TTL_hopcount_MP,'blue')
hold on
plot(T,m_TTL_hopcount_ML,'red')
xlabel('TTL (sec)');
title('hop count');

h4=figure(4)
plot(T,m_TTL_occupancy_E,'black')
hold on
plot(T,m_TTL_occupancy_PR1,'green')
hold on
plot(T,m_TTL_occupancy_MP,'blue')
hold on
plot(T,m_TTL_occupancy_ML,'red')
xlabel('TTL (sec)');
title('buffer');


