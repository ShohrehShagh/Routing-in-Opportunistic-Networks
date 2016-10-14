clc
clear all
%% Initialization
load('main_TTL.mat','meeting_rates')
N=100; %number of nodes
Number_of_messages=10000;

Number_of_runs=10;
interarrival_time=5;
destination_vector=[82,91,13,92,64,10,28,55,96,97];%ceil(N*rand(1,Number_of_runs));%a random choice would be ceil(N*rand(1,1))
Sim_time=247031;

P_init=0.75;
beta=0.25;
gamma=0.98;
time_step1=1;
time_step2=3600;

m0=5;
m=5;%10;

lambda_average=2*7.5371e-05;%mean(meeting_rates_info(meeting_rates_info>0))
%[meeting_rates_half,meeting_rates]= preferential_attachment_rates(N,lambda_average,m0,m);

B=[0:10:100,200:100:500,750:250:1250];
average_delivery_delay_PR1=zeros(length(B),Number_of_runs);
average_delivery_delay_ML=zeros(length(B),Number_of_runs);
average_delivery_delay_E=zeros(length(B),Number_of_runs);
average_delivery_delay_MLE=zeros(length(B),Number_of_runs);

delivery_rate_PR1=zeros(length(B),Number_of_runs);
delivery_rate_ML=zeros(length(B),Number_of_runs);
delivery_rate_E=zeros(length(B),Number_of_runs);
delivery_rate_MLE=zeros(length(B),Number_of_runs);

average_hop_count_PR1=zeros(length(B),Number_of_runs);
average_hop_count_ML=zeros(length(B),Number_of_runs);
average_hop_count_E=zeros(length(B),Number_of_runs);
average_hop_count_MLE=zeros(length(B),Number_of_runs);

average_buffer_occupancy_PR1=zeros(length(B),Number_of_runs);
average_buffer_occupancy_ML=zeros(length(B),Number_of_runs);
average_buffer_occupancy_E=zeros(length(B),Number_of_runs);
average_buffer_occupancy_MLE=zeros(length(B),Number_of_runs);

parfor runtime=1:Number_of_runs
    runtime
    filename = sprintf('Traces_TTL/mytracefile%d.txt',runtime);
%    generator_general(Sim_time,filename,meeting_rates_half,N);
    destination=destination_vector(runtime);
    generating_nodes=[1:destination-1,destination+1:N];
    message_creation_node=generating_nodes(ceil((N-1)*rand(1,Number_of_messages)));
    
    t=1;
    l_e=zeros(1,length(B));
    l_p1=zeros(1,length(B));
    l_ML=zeros(1,length(B));
    l_MP=zeros(1,length(B));

    d_e=zeros(1,length(B));
    d_p1=zeros(1,length(B));
    d_ML=zeros(1,length(B));
    d_MP=zeros(1,length(B));

    h_e=zeros(1,length(B));
    h_p1=zeros(1,length(B));
    h_ML=zeros(1,length(B));
    h_MP=zeros(1,length(B));

    b_e=zeros(1,length(B));
    b_p1=zeros(1,length(B));
    b_ML=zeros(1,length(B));
    b_MP=zeros(1,length(B));
    TTL=10^5;
    for buffer_limit=[0:10:100,200:100:500,750:250:1250]
	exchange_limit=buffer_limit;
        [l_e(t),d_e(t),h_e(t),b_e(t)]= Epidemic(N,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL);
        [l_p1(t),d_p1(t),h_p1(t),b_p1(t)]= prophet(N,destination,filename,P_init,beta,gamma,time_step1,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL);
        [l_ML(t),d_ML(t),h_ML(t),b_ML(t)]= decentralized_linearOpt(N,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,meeting_rates,message_creation_node,TTL);
        [l_MP(t),d_MP(t),h_MP(t),b_MP(t)]= maxprop(N,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL);
        t=t+1;
    end
    average_delivery_delay_E(:,runtime)=l_e;
    average_delivery_delay_PR1(:,runtime)=l_p1;
    average_delivery_delay_ML(:,runtime)=l_ML;
    average_delivery_delay_MP(:,runtime)=l_MP;
     
    delivery_rate_E(:,runtime)=d_e;
    delivery_rate_PR1(:,runtime)=d_p1;
    delivery_rate_ML(:,runtime)=d_ML;
    delivery_rate_MP(:,runtime)=d_MP;
    
    average_hop_count_E(:,runtime)=h_e;
    average_hop_count_PR1(:,runtime)=h_p1;
    average_hop_count_ML(:,runtime)=h_ML;
    average_hop_count_MP(:,runtime)=h_MP;
    
    average_buffer_occupancy_E(:,runtime)=b_e;
    average_buffer_occupancy_PR1(:,runtime)=b_p1;
    average_buffer_occupancy_ML(:,runtime)=b_ML;
    average_buffer_occupancy_MP(:,runtime)=b_MP;
end
save main_TTL
%%
for t=1:length(B)
    m_delivery_delay_E(t)=mean(average_delivery_delay_E(t,:));
    m_delivery_delay_PR1(t)=mean(average_delivery_delay_PR1(t,:));
    m_delivery_delay_ML(t)=mean(average_delivery_delay_ML(t,:));
    m_delivery_delay_MP(t)=mean(average_delivery_delay_MP(t,:));
    
    m_delivery_rate_E(t)=mean(delivery_rate_E(t,:));
    m_delivery_rate_PR1(t)=mean(delivery_rate_PR1(t,:));
    m_delivery_rate_ML(t)=mean(delivery_rate_ML(t,:));
    m_delivery_rate_MP(t)=mean(delivery_rate_MP(t,:));
    
    m_hop_count_E(t)=mean(average_hop_count_E(t,:));
    m_hop_count_PR1(t)=mean(average_hop_count_PR1(t,:));
    m_hop_count_ML(t)=mean(average_hop_count_ML(t,:));
    m_hop_count_MP(t)=mean(average_hop_count_MP(t,:));
    
    m_buffer_occupancy_E(t)=mean(average_buffer_occupancy_E(t,:));
    m_buffer_occupancy_PR1(t)=mean(average_buffer_occupancy_PR1(t,:));
   m_buffer_occupancy_ML(t)=mean(average_buffer_occupancy_ML(t,:));
    m_buffer_occupancy_MP(t)=mean(average_buffer_occupancy_MP(t,:));
end
save main_Buffer
%%
h1=figure(1)
plot(B,[NaN*ones(1,10),m_delivery_delay_E(11:length(B))],'black+-','LineWidth',3,'MarkerSize',10)
hold on
plot(B,[NaN*ones(1,10),m_delivery_delay_PR1(11:length(B))],'greendiamond-','LineWidth',3,'MarkerSize',10)
hold on
plot(B,[NaN*ones(1,10),m_delivery_delay_MP(11:length(B))],'bluesquare-','LineWidth',3,'MarkerSize',10)
hold on
plot(B,[NaN*ones(1,10),m_delivery_delay_ML(11:length(B))],'redo-','LineWidth',3,'MarkerSize',10)
hold on

plot(B,m_delivery_delay_E,'black-','LineWidth',3)
hold on
plot(B,m_delivery_delay_PR1,'green-','LineWidth',3)
hold on
plot(B,m_delivery_delay_MP,'blue-','LineWidth',3)
hold on
plot(B,m_delivery_delay_ML,'red-','LineWidth',3)
hold on

plot(B(2),m_delivery_delay_E(2),'black+','LineWidth',3,'MarkerSize',10)
hold on
plot(B(2),m_delivery_delay_PR1(2),'greendiamond','LineWidth',3,'MarkerSize',10)
hold on
plot(B(2),m_delivery_delay_MP(2),'bluesquare','LineWidth',3,'MarkerSize',10)
hold on
plot(B(2),m_delivery_delay_ML(2),'redo','LineWidth',3,'MarkerSize',10)
hold on

legend('Epidemic','PRoPHETv2','MaxProp','MinLat')
xlabel('Buffer Size');
title('Delivery Delay');

h2=figure(2)
plot(B,[NaN*ones(1,10),m_delivery_rate_E(11:length(B))],'black+-','LineWidth',3,'MarkerSize',10)
hold on
plot(B,[NaN*ones(1,10),m_delivery_rate_PR1(11:length(B))],'greendiamond-','LineWidth',3,'MarkerSize',10)
hold on
plot(B,[NaN*ones(1,10),m_delivery_rate_MP(11:length(B))],'bluesquare-','LineWidth',3,'MarkerSize',10)
hold on
plot(B,[NaN*ones(1,10),m_delivery_rate_ML(11:length(B))],'redo-','LineWidth',3,'MarkerSize',10)
hold on

plot(B,m_delivery_rate_E,'black-','LineWidth',3)
hold on
plot(B,m_delivery_rate_PR1,'green-','LineWidth',3)
hold on
plot(B,m_delivery_rate_MP,'blue-','LineWidth',3)
hold on
plot(B,m_delivery_rate_ML,'red-','LineWidth',3)
hold on

plot(B(2),m_delivery_rate_E(2),'black+','LineWidth',3,'MarkerSize',10)
hold on
plot(B(2),m_delivery_rate_PR1(2),'greendiamond','LineWidth',3,'MarkerSize',10)
hold on
plot(B(2),m_delivery_rate_MP(2),'bluesquare','LineWidth',3,'MarkerSize',10)
hold on
plot(B(2),m_delivery_rate_ML(2),'redo','LineWidth',3,'MarkerSize',10)
hold on
legend('Epidemic','PRoPHETv2','MaxProp','MinLat')
xlabel('Buffer Size');
title('Delivery Rate');

h3=figure(3)
plot(B,[NaN*ones(1,10),m_hop_count_E(11:length(B))],'black+-','LineWidth',3,'MarkerSize',10)
hold on
plot(B,[NaN*ones(1,10),m_hop_count_PR1(11:length(B))],'greendiamond-','LineWidth',3,'MarkerSize',10)
hold on
plot(B,[NaN*ones(1,10),m_hop_count_MP(11:length(B))],'bluesquare-','LineWidth',3,'MarkerSize',10)
hold on
plot(B,[NaN*ones(1,10),m_hop_count_ML(11:length(B))],'redo-','LineWidth',3,'MarkerSize',10)
hold on

plot(B,m_hop_count_E,'black-','LineWidth',3)
hold on
plot(B,m_hop_count_PR1,'green-','LineWidth',3)
hold on
plot(B,m_hop_count_MP,'blue-','LineWidth',3)
hold on
plot(B,m_hop_count_ML,'red-','LineWidth',3)
hold on

plot(B(2),m_hop_count_E(2),'black+','LineWidth',3,'MarkerSize',10)
hold on
plot(B(2),m_hop_count_PR1(2),'greendiamond','LineWidth',3,'MarkerSize',10)
hold on
plot(B(2),m_hop_count_MP(2),'bluesquare','LineWidth',3,'MarkerSize',10)
hold on
plot(B(2),m_hop_count_ML(2),'redo','LineWidth',3,'MarkerSize',10)
hold on

legend('Epidemic','PRoPHETv2','MaxProp','MinLat')
xlabel('Buffer Size');
title('hop count');

h4=figure(4)
plot(B,[NaN*ones(1,10),m_buffer_occupancy_E(11:length(B))],'black+-','LineWidth',3,'MarkerSize',10)
hold on
plot(B,[NaN*ones(1,10),m_buffer_occupancy_PR1(11:length(B))],'greendiamond-','LineWidth',3,'MarkerSize',10)
hold on
plot(B,[NaN*ones(1,10),m_buffer_occupancy_MP(11:length(B))],'bluesquare-','LineWidth',3,'MarkerSize',10)
hold on
plot(B,[NaN*ones(1,10),m_buffer_occupancy_ML(11:length(B))],'redo-','LineWidth',3,'MarkerSize',10)
hold on

plot(B,m_buffer_occupancy_E,'black-','LineWidth',3)
hold on
plot(B,m_buffer_occupancy_PR1,'green-','LineWidth',3)
hold on
plot(B,m_buffer_occupancy_MP,'blue-','LineWidth',3)
hold on
plot(B,m_buffer_occupancy_ML,'red-','LineWidth',3)
hold on

plot(B(2),m_buffer_occupancy_E(2),'black+','LineWidth',3,'MarkerSize',10)
hold on
plot(B(2),m_buffer_occupancy_PR1(2),'greendiamond','LineWidth',3,'MarkerSize',10)
hold on
plot(B(2),m_buffer_occupancy_MP(2),'bluesquare','LineWidth',3,'MarkerSize',10)
hold on
plot(B(2),m_buffer_occupancy_ML(2),'redo','LineWidth',3,'MarkerSize',10)
hold on
legend('Epidemic','PRoPHETv2','MaxProp','MinLat')
xlabel('Buffer Size');
title('buffer');

save main_Buffer
