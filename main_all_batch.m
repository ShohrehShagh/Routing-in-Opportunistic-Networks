clc
clear all
Number_of_runs=32
matlabpool('open',Number_of_runs);

%% Initialization
N=41; %number of nodes
interarrival_time=5;
Sim_time=300000;%100000;
%10;
% d=[1:30,32:41];
destination=22%ceil(N*rand(1,1)) %d(ceil((N-1)*rand(1,Number_of_runs)));

P_init=0.75;
beta=0.25;
gamma=0.98;
time_step1=1;
dataset_name=sprintf('info05_new.txt');
[meeting_rates_info,revised_dataset]= info(dataset_name,N);

meeting_rates_half_info=meeting_rates_info;
for i=1:N
    for j=i+1:N
        meeting_rates_half_info(j,i)=0;
    end
end

message_creation_time(1)=100;
i=1;
while (message_creation_time(i)<Sim_time-5*10^4)
    i=i+1;
    message_creation_time(i)=message_creation_time(i-1)+interarrival_time*rand(1,1);
end
Number_of_messages=i-1

generating_nodes=[1:destination-1,destination+1:N];
message_creation_node=generating_nodes(ceil((N-1)*rand(1,Number_of_messages)));

TTL=Sim_time;
buffer_limit=Number_of_messages;
exchange_limit=buffer_limit;

batch_size=500;
number_of_batches=floor(Number_of_messages/batch_size)

Batch_Latencies_e=zeros(Number_of_runs,number_of_batches);
Batch_Latencies_p1=zeros(Number_of_runs,number_of_batches);
Batch_Latencies_p2=zeros(Number_of_runs,number_of_batches);
Batch_Latencies_MP=zeros(Number_of_runs,number_of_batches);
Batch_Latencies_ML=zeros(Number_of_runs,number_of_batches);
Batch_Latencies_MLE=zeros(Number_of_runs,number_of_batches);

time_p1=zeros(Number_of_runs,number_of_batches);
time_MP=zeros(Number_of_runs,number_of_batches);
time_ML=zeros(Number_of_runs,number_of_batches);
time_MLE=zeros(Number_of_runs,number_of_batches);

%% infocom exp
parfor runtime=1:Number_of_runs
    runtime
    filename = sprintf('Traces_batch/mytracefile%d.txt',runtime);    
    generator_general(Sim_time,filename,meeting_rates_half_info,N);
%     epidemic=1 
%     [message_delivery_time_e]= Epidemic_batch(N,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL,message_creation_time);
    prophet=1
     [message_delivery_time_p1]= prophet_batch(N,destination,filename,P_init,beta,gamma,time_step1,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL,message_creation_time);
     minlat=1
     [message_delivery_time_ML]= decentralized_linearOpt_batch(N,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,meeting_rates_info,message_creation_node,TTL,message_creation_time);   
     minlatE=1
    [message_delivery_time_MLE]= decentralized_linearOpt_estimations_batch(N,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL,message_creation_time);   
    maxprop=1
     [message_delivery_time_MP]= maxprop_batch(N,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL,message_creation_time);
    
    index=1;
    for i=1:number_of_batches
        time_p1(runtime,i)=message_delivery_time_p1(index+batch_size/2);
        time_MP(runtime,i)=message_delivery_time_MP(index+batch_size/2);
        time_ML(runtime,i)=message_delivery_time_ML(index+batch_size/2);
        time_MLE(runtime,i)=message_delivery_time_MLE(index+batch_size/2);
        Batch_Latencies_p1(runtime,i)=mean(message_delivery_time_p1(index:index+batch_size-1)-message_creation_time(index:index+batch_size-1));
        Batch_Latencies_MP(runtime,i)=mean(message_delivery_time_MP(index:index+batch_size-1)-message_creation_time(index:index+batch_size-1));
        Batch_Latencies_ML(runtime,i)=mean(message_delivery_time_ML(index:index+batch_size-1)-message_creation_time(index:index+batch_size-1));
        Batch_Latencies_MLE(runtime,i)=mean(message_delivery_time_MLE(index:index+batch_size-1)-message_creation_time(index:index+batch_size-1));
        index=index+batch_size;
    end
end
save main_all_batch2

f_p1=find(Batch_Latencies_p1(:,number_of_batches)<inf);
f_MP=find(Batch_Latencies_MP(:,number_of_batches)<inf);
f_ML=find(Batch_Latencies_ML(:,number_of_batches)<inf);
f_MLE=find(Batch_Latencies_MLE(:,number_of_batches)<inf);
for i=1:number_of_batches
    mean_time_p1(i)=mean(time_p1(:,i));
    mean_time_MP(i)=mean(time_MP(:,i));
    mean_time_ML(i)=mean(time_ML(:,i));
    mean_time_MLE(i)=mean(time_MLE(:,i));
    
    fi_p1=find(Batch_Latencies_p1(:,i)<inf);
    fi_MP=find(Batch_Latencies_MP(:,i)<inf);
    fi_ML=find(Batch_Latencies_ML(:,i)<inf);
    fi_MLE=find(Batch_Latencies_MLE(:,i)<inf);
    
    mean_batch_latencies_p1(i)=mean(Batch_Latencies_p1(fi_p1,i));
    mean_batch_latencies_MP(i)=mean(Batch_Latencies_MP(fi_MP,i));
    mean_batch_latencies_ML(i)=mean(Batch_Latencies_ML(fi_ML,i));
    mean_batch_latencies_MLE(i)=mean(Batch_Latencies_MLE(fi_MLE,i));
end
%%

coeff=3;
for i=coeff:coeff:number_of_batches  
    time(i/coeff)=message_creation_time(coeff*batch_size/2 + (i/coeff-1)*coeff*batch_size);
    mean_batch_latencies_p1_coeff(i/coeff)=mean(mean_batch_latencies_p1(i-coeff+1:i));
    mean_batch_latencies_MP_coeff(i/coeff)=mean(mean_batch_latencies_MP(i-coeff+1:i));
    mean_batch_latencies_ML_coeff(i/coeff)=mean(mean_batch_latencies_ML(i-coeff+1:i));
    mean_batch_latencies_MLE_coeff(i/coeff)=mean(mean_batch_latencies_MLE(i-coeff+1:i));
end
%% OUTPUT

figure
plot(time,[NaN,NaN,mean_batch_latencies_p1_coeff(3),NaN*ones(1,length(time)-3)],'greendiamond-','LineWidth',3,'MarkerSize',10)
hold on
plot(time,NaN*ones(1,length(time)),'bluesquare-','LineWidth',3,'MarkerSize',10)
hold on
plot(time,NaN*ones(1,length(time)),'redo-','LineWidth',3,'MarkerSize',10)
hold on
plot(time,NaN*ones(1,length(time)),'black+-','LineWidth',3,'MarkerSize',10)
hold on

plot(time,mean_batch_latencies_p1_coeff,'green-','LineWidth',3,'MarkerSize',10)
hold on
plot(time(3:4:length(time)),mean_batch_latencies_p1_coeff(3:4:length(time)),'greendiamond','LineWidth',3,'MarkerSize',10)
hold on

plot(time,mean_batch_latencies_MP_coeff,'blue-','LineWidth',3,'MarkerSize',10)
hold on
plot(time(3:4:length(time)),mean_batch_latencies_MP_coeff(3:4:length(time)),'bluesquare','LineWidth',3,'MarkerSize',10)
hold on

plot(time,mean_batch_latencies_ML_coeff,'red-','LineWidth',3,'MarkerSize',10)
hold on
plot(time(3:4:length(time)),mean_batch_latencies_ML_coeff(3:4:length(time)),'redo','LineWidth',3,'MarkerSize',10)
hold on

plot(time,mean_batch_latencies_MLE_coeff,'black-','LineWidth',3,'MarkerSize',10)
hold on
plot(time(3:4:length(time)),mean_batch_latencies_MLE_coeff(3:4:length(time)),'black+','LineWidth',3,'MarkerSize',10)

legend('PRoPHETv2','MaxProp','MinLat','MinLat-E')

save main_all_batch2
matlabpool('close'); 