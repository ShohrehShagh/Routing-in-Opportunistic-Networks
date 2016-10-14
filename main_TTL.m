clc
clear all
%% Initialization
N=100; %number of nodes
Number_of_messages=10000;

Number_of_runs=10;
interarrival_time=5;
destination_vector=ceil(N*rand(1,Number_of_runs));%a random choice would be ceil(N*rand(1,1))
Sim_time=247031;

P_init=0.75;
beta=0.25;
gamma=0.98;
time_step1=1;
time_step2=3600;

m0=5;
m=5;%10;

lambda_average=2*7.5371e-05;%mean(meeting_rates_info(meeting_rates_info>0))
[meeting_rates_half,meeting_rates]= preferential_attachment_rates(N,lambda_average,m0,m);

T=[0:6250:2.5*10^4,3.75*10^4:1.25*10^4:Sim_time];
average_delivery_delay_PR1=zeros(length(T),Number_of_runs);
average_delivery_delay_ML=zeros(length(T),Number_of_runs);
delivery_rate_PR1=zeros(length(T),Number_of_runs);
delivery_rate_ML=zeros(length(T),Number_of_runs);
average_hop_count_PR1=zeros(length(T),Number_of_runs);
average_hop_count_ML=zeros(length(T),Number_of_runs);
average_buffer_occupancy_PR1=zeros(length(T),Number_of_runs);
average_buffer_occupancy_ML=zeros(length(T),Number_of_runs);
parfor runtime=1:Number_of_runs
    runtime
    filename = sprintf('Traces_TTL/mytracefile%d.txt',runtime);
    generator_general(Sim_time,filename,meeting_rates_half,N);
    destination=destination_vector(runtime);
    generating_nodes=[1:destination-1,destination+1:N];
    message_creation_node=generating_nodes(ceil((N-1)*rand(1,Number_of_messages)));
    
    buffer_limit=Number_of_messages;
    exchange_limit=buffer_limit;
    t=1;
    l_e=zeros(1,length(T));
    l_p1=zeros(1,length(T));
    l_p2=zeros(1,length(T));
    l_ML=zeros(1,length(T));
    l_MP=zeros(1,length(T));

    d_e=zeros(1,length(T));
    d_p1=zeros(1,length(T));
    d_p2=zeros(1,length(T));
    d_ML=zeros(1,length(T));
    d_MP=zeros(1,length(T));

    h_e=zeros(1,length(T));
    h_p1=zeros(1,length(T));
    h_p2=zeros(1,length(T));
    h_ML=zeros(1,length(T));
    h_MP=zeros(1,length(T));

    b_e=zeros(1,length(T));
    b_p1=zeros(1,length(T));
    b_p2=zeros(1,length(T));
    b_ML=zeros(1,length(T));
    b_MP=zeros(1,length(T));
    for TTL=[0:6250:2.5*10^4,3.75*10^4:1.25*10^4:Sim_time]
        [l_e(t),d_e(t),h_e(t),b_e(t)]= Epidemic(N,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL);
        [l_p1(t),d_p1(t),h_p1(t),b_p1(t)]= prophet(N,destination,filename,P_init,beta,gamma,time_step1,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL);
        [l_p2(t),d_p2(t),h_p2(t),b_p2(t)]= prophet(N,destination,filename,P_init,beta,gamma,time_step2,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL);
        [l_ML(t),d_ML(t),h_ML(t),b_ML(t)]= decentralized_linearOpt(N,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,meeting_rates,message_creation_node,TTL);
        [l_MP(t),d_MP(t),h_MP(t),b_MP(t)]= maxprop(N,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL);
        t=t+1;
    end
    average_delivery_delay_E(:,runtime)=l_e;
    average_delivery_delay_PR1(:,runtime)=l_p1;
    average_delivery_delay_PR2(:,runtime)=l_p2;
    average_delivery_delay_ML(:,runtime)=l_ML;
    average_delivery_delay_MP(:,runtime)=l_MP;
     
    delivery_rate_E(:,runtime)=d_e;
    delivery_rate_PR1(:,runtime)=d_p1;
    delivery_rate_PR2(:,runtime)=d_p2;
    delivery_rate_ML(:,runtime)=d_ML;
    delivery_rate_MP(:,runtime)=d_MP;
    
    average_hop_count_E(:,runtime)=h_e;
    average_hop_count_PR1(:,runtime)=h_p1;
    average_hop_count_PR2(:,runtime)=h_p2;
    average_hop_count_ML(:,runtime)=h_ML;
    average_hop_count_MP(:,runtime)=h_MP;
    
    average_buffer_occupancy_E(:,runtime)=b_e;
    average_buffer_occupancy_PR1(:,runtime)=b_p1;
    average_buffer_occupancy_PR2(:,runtime)=b_p2;
    average_buffer_occupancy_ML(:,runtime)=b_ML;
    average_buffer_occupancy_MP(:,runtime)=b_MP;
end
save main_TTL
%%
for t=1:length(T)
    m_delivery_delay_E(t)=mean(average_delivery_delay_E(t,:));
    m_delivery_delay_PR1(t)=mean(average_delivery_delay_PR1(t,:));
    m_delivery_delay_PR2(t)=mean(average_delivery_delay_PR2(t,:));
    m_delivery_delay_ML(t)=mean(average_delivery_delay_ML(t,:));
    m_delivery_delay_MP(t)=mean(average_delivery_delay_MP(t,:));
    
    m_delivery_rate_E(t)=mean(delivery_rate_E(t,:));
    m_delivery_rate_PR1(t)=mean(delivery_rate_PR1(t,:));
    m_delivery_rate_PR2(t)=mean(delivery_rate_PR2(t,:));
    m_delivery_rate_ML(t)=mean(delivery_rate_ML(t,:));
    m_delivery_rate_MP(t)=mean(delivery_rate_MP(t,:));
    
    m_hop_count_E(t)=mean(average_hop_count_E(t,:));
    m_hop_count_PR1(t)=mean(average_hop_count_PR1(t,:));
    m_hop_count_PR2(t)=mean(average_hop_count_PR2(t,:));
    m_hop_count_ML(t)=mean(average_hop_count_ML(t,:));
    m_hop_count_MP(t)=mean(average_hop_count_MP(t,:));
    
    m_buffer_occupancy_E(t)=mean(average_buffer_occupancy_E(t,:));
    m_buffer_occupancy_PR1(t)=mean(average_buffer_occupancy_PR1(t,:));
    m_buffer_occupancy_PR2(t)=mean(average_buffer_occupancy_PR2(t,:));
    m_buffer_occupancy_ML(t)=mean(average_buffer_occupancy_ML(t,:));
    m_buffer_occupancy_MP(t)=mean(average_buffer_occupancy_MP(t,:));
end

%%
h1=figure(1)
plot(T,m_delivery_delay_E,'red')
hold on
plot(T,m_delivery_delay_PR1,'black')
hold on
plot(T,m_delivery_delay_PR2,'green')
hold on
plot(T,m_delivery_delay_MP,'yellow')
hold on
plot(T,m_delivery_delay_ML,'blue')
xlabel('TTL');
title('Delivery Delay');

h2=figure(2)
plot(T,m_delivery_rate_E,'red')
hold on
plot(T,m_delivery_rate_PR1,'black')
hold on
plot(T,m_delivery_rate_PR2,'green')
hold on
plot(T,m_delivery_rate_MP,'yellow')
hold on
plot(T,m_delivery_rate_ML,'blue')
legend('Epidemic','PRoPHET1','PRoPHET2','MaxProp','MinLat')
xlabel('TTL');
title('Delivery Rate');

h3=figure(3)
plot(T,m_hop_count_E,'red')
hold on
plot(T,m_hop_count_PR1,'black')
hold on
plot(T,m_hop_count_PR2,'green')
hold on
plot(T,m_hop_count_MP,'yellow')
hold on
plot(T,m_hop_count_ML,'blue')
xlabel('TTL');
title('hop count');

h4=figure(4)
plot(T,m_buffer_occupancy_E,'red')
hold on
plot(T,m_buffer_occupancy_PR1,'black')
hold on
plot(T,m_buffer_occupancy_PR2,'green')
hold on
plot(T,m_buffer_occupancy_MP,'yellow')
hold on
plot(T,m_buffer_occupancy_ML,'blue')
xlabel('TTL');
title('buffer');

save main_TTL

%%
%u=15;
%l=5;
% for t=1:length(T)
%     s_a_delivery_delay_PR_T(t,:)=sort(average_delivery_delay_PR_T(t,:),'ascend');
%     l_delivery_delay_PR_T(t)=mean(average_delivery_delay_PR_T(t,:))-s_a_delivery_delay_PR_T(t,l);
%     u_delivery_delay_PR_T(t)=s_a_delivery_delay_PR_T(t,u)-mean(average_delivery_delay_PR_T(t,:));
%     m_delivery_delay_PR_T(t)=mean(average_delivery_delay_PR_T(t,:));
%
%     s_a_delivery_delay_DE_T(t,:)=sort(average_delivery_delay_DE_T(t,:),'ascend');
%     l_delivery_delay_DE_T(t)=mean(average_delivery_delay_DE_T(t,:))-s_a_delivery_delay_DE_T(t,l);
%     u_delivery_delay_DE_T(t)=s_a_delivery_delay_DE_T(t,u)-mean(average_delivery_delay_DE_T(t,:));
%     m_delivery_delay_DE_T(t)=mean(average_delivery_delay_DE_T(t,:));
%
%     s_d_rate_PR_T(t,:)=sort(delivery_rate_PR_T(t,:),'ascend');
%     l_delivery_rate_PR_T(t)=mean(delivery_rate_PR_T(t,:))-s_d_rate_PR_T(t,l);
%     u_delivery_rate_PR_T(t)=s_d_rate_PR_T(t,u)-mean(delivery_rate_PR_T(t,:));
%     m_delivery_rate_PR_T(t)=mean(delivery_rate_PR_T(t,:));
%
%     s_d_rate_DE_T(t,:)=sort(delivery_rate_DE_T(t,:),'ascend');
%     l_delivery_rate_DE_T(t)=mean(delivery_rate_DE_T(t,:))-s_d_rate_DE_T(t,l);
%     u_delivery_rate_DE_T(t)=s_d_rate_DE_T(t,u)-mean(delivery_rate_DE_T(t,:));
%     m_delivery_rate_DE_T(t)=mean(delivery_rate_DE_T(t,:));
%
%     s_a_hop_count_PR_T(t,:)=sort(average_hop_count_PR_T(t,:),'ascend');
%     l_hop_count_PR_T(t)=mean(average_hop_count_PR_T(t,:))-s_a_hop_count_PR_T(t,l);
%     u_hop_count_PR_T(t)=s_a_hop_count_PR_T(t,u)-mean(average_hop_count_PR_T(t,:));
%     m_hop_count_PR_T(t)=mean(average_hop_count_PR_T(t,:));
%
%     s_a_hop_count_DE_T(t,:)=sort(average_hop_count_DE_T(t,:),'ascend');
%     l_hop_count_DE_T(t)=mean(average_hop_count_DE_T(t,:))-s_a_hop_count_DE_T(t,l);
%     u_hop_count_DE_T(t)=s_a_hop_count_DE_T(t,u)-mean(average_hop_count_DE_T(t,:));
%     m_hop_count_DE_T(t)=mean(average_hop_count_DE_T(t,:));
%
%     s_a_buffer_occupancy_PR_T(t,:)=sort(average_buffer_occupancy_PR_T(t,:),'ascend');
%     l_buffer_occupancy_PR_T(t)=mean(average_buffer_occupancy_PR_T(t,:))-s_a_buffer_occupancy_PR_T(t,l);
%     u_buffer_occupancy_PR_T(t)=s_a_buffer_occupancy_PR_T(t,u)-mean(average_buffer_occupancy_PR_T(t,:));
%     m_buffer_occupancy_PR_T(t)=mean(average_buffer_occupancy_PR_T(t,:));
%
%     s_a_buffer_occupancy_DE_T(t,:)=sort(average_buffer_occupancy_DE_T(t,:),'ascend');
%     l_buffer_occupancy_DE_T(t)=mean(average_buffer_occupancy_DE_T(t,:))-s_a_buffer_occupancy_DE_T(t,l);
%     u_buffer_occupancy_DE_T(t)=s_a_buffer_occupancy_DE_T(t,u)-mean(average_buffer_occupancy_DE_T(t,:));
%     m_buffer_occupancy_DE_T(t)=mean(average_buffer_occupancy_DE_T(t,:));
%
% end
