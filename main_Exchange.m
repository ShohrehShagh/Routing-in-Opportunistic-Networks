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

E=[0:10:100,150:50:250,300:100:500];
average_delivery_delay_PR1=zeros(length(E),Number_of_runs);
average_delivery_delay_ML=zeros(length(E),Number_of_runs);
average_delivery_delay_E=zeros(length(E),Number_of_runs);
average_delivery_delay_MLE=zeros(length(E),Number_of_runs);

delivery_rate_PR1=zeros(length(E),Number_of_runs);
delivery_rate_ML=zeros(length(E),Number_of_runs);
delivery_rate_E=zeros(length(E),Number_of_runs);
delivery_rate_MLE=zeros(length(E),Number_of_runs);

average_hop_count_PR1=zeros(length(E),Number_of_runs);
average_hop_count_ML=zeros(length(E),Number_of_runs);
average_hop_count_E=zeros(length(E),Number_of_runs);
average_hop_count_MLE=zeros(length(E),Number_of_runs);

average_buffer_occupancy_PR1=zeros(length(E),Number_of_runs);
average_buffer_occupancy_ML=zeros(length(E),Number_of_runs);
average_buffer_occupancy_E=zeros(length(E),Number_of_runs);
average_buffer_occupancy_MLE=zeros(length(E),Number_of_runs);

parfor runtime=1:Number_of_runs
    runtime
    filename = sprintf('Traces_TTL/mytracefile%d.txt',runtime);
%    generator_general(Sim_time,filename,meeting_rates_half,N);
    destination=destination_vector(runtime);
    generating_nodes=[1:destination-1,destination+1:N];
    message_creation_node=generating_nodes(ceil((N-1)*rand(1,Number_of_messages)));
    
    t=1;
    l_e=zeros(1,length(E));
    l_p1=zeros(1,length(E));
    l_ML=zeros(1,length(E));
    l_MP=zeros(1,length(E));

    d_e=zeros(1,length(E));
    d_p1=zeros(1,length(E));
    d_ML=zeros(1,length(E));
    d_MP=zeros(1,length(E));

    h_e=zeros(1,length(E));
    h_p1=zeros(1,length(E));
    h_ML=zeros(1,length(E));
    h_MP=zeros(1,length(E));

    b_e=zeros(1,length(E));
    b_p1=zeros(1,length(E));
    b_ML=zeros(1,length(E));
    b_MP=zeros(1,length(E));
    TTL=10^5;
    buffer_limit=1000;
    for exchange_limit=[0:10:100,150:50:250,300:100:500]
        [l_e(t),d_e(t),h_e(t),b_e(t)]= Epidemic_BuffManMax(N,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL);
        [l_p1(t),d_p1(t),h_p1(t),b_p1(t)]= prophet_BuffManMax(N,destination,filename,P_init,beta,gamma,time_step1,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL);
        [l_ML(t),d_ML(t),h_ML(t),b_ML(t)]= decentralized_linearOpt_BuffManMax(N,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,meeting_rates,message_creation_node,TTL);
        [l_MP(t),d_MP(t),h_MP(t),b_MP(t)]= maxprop_BuffManMax(N,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL);
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
save main_Exchange
%%
for t=1:length(E)
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
save main_Exchange
%%
h1=figure(1)
plot(E,[NaN*ones(1,10),m_delivery_delay_E(11:length(E))],'black+-','LineWidth',3,'MarkerSize',10)
hold on
plot(E,[NaN*ones(1,10),m_delivery_delay_PR1(11:length(E))],'greendiamond-','LineWidth',3,'MarkerSize',10)
hold on
plot(E,[NaN*ones(1,10),m_delivery_delay_MP(11:length(E))],'bluesquare-','LineWidth',3,'MarkerSize',10)
hold on
plot(E,[NaN*ones(1,10),m_delivery_delay_ML(11:length(E))],'redo-','LineWidth',3,'MarkerSize',10)
hold on

plot(E,m_delivery_delay_E,'black-','LineWidth',3)
hold on
plot(E,m_delivery_delay_PR1,'green-','LineWidth',3)
hold on
plot(E,m_delivery_delay_MP,'blue-','LineWidth',3)
hold on
plot(E,m_delivery_delay_ML,'red-','LineWidth',3)
hold on

plot(E(2),m_delivery_delay_E(2),'black+','LineWidth',3,'MarkerSize',10)
hold on
plot(E(2),m_delivery_delay_PR1(2),'greendiamond','LineWidth',3,'MarkerSize',10)
hold on
plot(E(2),m_delivery_delay_MP(2),'bluesquare','LineWidth',3,'MarkerSize',10)
hold on
plot(E(2),m_delivery_delay_ML(2),'redo','LineWidth',3,'MarkerSize',10)
hold on

legend('Epidemic','PRoPHETv2','MaxProp','MinLat')
xlabel('Exchange Limit');
title('Delivery Delay');

h2=figure(2)
plot(E,[NaN*ones(1,10),m_delivery_rate_E(11:length(E))],'black+-','LineWidth',3,'MarkerSize',10)
hold on
plot(E,[NaN*ones(1,10),m_delivery_rate_PR1(11:length(E))],'greendiamond-','LineWidth',3,'MarkerSize',10)
hold on
plot(E,[NaN*ones(1,10),m_delivery_rate_MP(11:length(E))],'bluesquare-','LineWidth',3,'MarkerSize',10)
hold on
plot(E,[NaN*ones(1,10),m_delivery_rate_ML(11:length(E))],'redo-','LineWidth',3,'MarkerSize',10)
hold on

plot(E,m_delivery_rate_E,'black-','LineWidth',3)
hold on
plot(E,m_delivery_rate_PR1,'green-','LineWidth',3)
hold on
plot(E,m_delivery_rate_MP,'blue-','LineWidth',3)
hold on
plot(E,m_delivery_rate_ML,'red-','LineWidth',3)
hold on

plot(E(2),m_delivery_rate_E(2),'black+','LineWidth',3,'MarkerSize',10)
hold on
plot(E(2),m_delivery_rate_PR1(2),'greendiamond','LineWidth',3,'MarkerSize',10)
hold on
plot(E(2),m_delivery_rate_MP(2),'bluesquare','LineWidth',3,'MarkerSize',10)
hold on
plot(E(2),m_delivery_rate_ML(2),'redo','LineWidth',3,'MarkerSize',10)
hold on
legend('Epidemic','PRoPHETv2','MaxProp','MinLat')
xlabel('Exchange Limit');
title('Delivery Rate');

h3=figure(3)
plot(E,[NaN*ones(1,10),m_hop_count_E(11:length(E))],'black+-','LineWidth',3,'MarkerSize',10)
hold on
plot(E,[NaN*ones(1,10),m_hop_count_PR1(11:length(E))],'greendiamond-','LineWidth',3,'MarkerSize',10)
hold on
plot(E,[NaN*ones(1,10),m_hop_count_MP(11:length(E))],'bluesquare-','LineWidth',3,'MarkerSize',10)
hold on
plot(E,[NaN*ones(1,10),m_hop_count_ML(11:length(E))],'redo-','LineWidth',3,'MarkerSize',10)
hold on

plot(E,m_hop_count_E,'black-','LineWidth',3)
hold on
plot(E,m_hop_count_PR1,'green-','LineWidth',3)
hold on
plot(E,m_hop_count_MP,'blue-','LineWidth',3)
hold on
plot(E,m_hop_count_ML,'red-','LineWidth',3)
hold on

plot(E(2),m_hop_count_E(2),'black+','LineWidth',3,'MarkerSize',10)
hold on
plot(E(2),m_hop_count_PR1(2),'greendiamond','LineWidth',3,'MarkerSize',10)
hold on
plot(E(2),m_hop_count_MP(2),'bluesquare','LineWidth',3,'MarkerSize',10)
hold on
plot(E(2),m_hop_count_ML(2),'redo','LineWidth',3,'MarkerSize',10)
hold on

legend('Epidemic','PRoPHETv2','MaxProp','MinLat')
xlabel('Exchange Limit');
title('hop count');

h4=figure(4)
plot(E,[NaN*ones(1,10),m_buffer_occupancy_E(11:length(E))],'black+-','LineWidth',3,'MarkerSize',10)
hold on
plot(E,[NaN*ones(1,10),m_buffer_occupancy_PR1(11:length(E))],'greendiamond-','LineWidth',3,'MarkerSize',10)
hold on
plot(E,[NaN*ones(1,10),m_buffer_occupancy_MP(11:length(E))],'bluesquare-','LineWidth',3,'MarkerSize',10)
hold on
plot(E,[NaN*ones(1,10),m_buffer_occupancy_ML(11:length(E))],'redo-','LineWidth',3,'MarkerSize',10)
hold on

plot(E,m_buffer_occupancy_E,'black-','LineWidth',3)
hold on
plot(E,m_buffer_occupancy_PR1,'green-','LineWidth',3)
hold on
plot(E,m_buffer_occupancy_MP,'blue-','LineWidth',3)
hold on
plot(E,m_buffer_occupancy_ML,'red-','LineWidth',3)
hold on

plot(E(2),m_buffer_occupancy_E(2),'black+','LineWidth',3,'MarkerSize',10)
hold on
plot(E(2),m_buffer_occupancy_PR1(2),'greendiamond','LineWidth',3,'MarkerSize',10)
hold on
plot(E(2),m_buffer_occupancy_MP(2),'bluesquare','LineWidth',3,'MarkerSize',10)
hold on
plot(E(2),m_buffer_occupancy_ML(2),'redo','LineWidth',3,'MarkerSize',10)
hold on
legend('Epidemic','PRoPHETv2','MaxProp','MinLat')
xlabel('Exchange Limit');
title('buffer');

save main_Exchange
