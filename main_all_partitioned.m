clc
clear all
%% Initialization
N=41; %number of nodes
Number_of_messages=1000;%0;
interarrival_time=5;
Sim_time=247031;%100000;
Number_of_runs=1%10;

P_init=0.75;
beta=0.25;
gamma=0.98;
time_step1=1;

TTL=Sim_time;
buffer_limit=Number_of_messages;
exchange_limit=buffer_limit;

%% infocom
Number_of_nodes=41;
partition_length=12;
Number_of_partitions=3*(24/partition_length);

l_e_I=zeros(Number_of_partitions,Number_of_nodes);d_e_I=zeros(Number_of_partitions,Number_of_nodes);h_e_I=zeros(Number_of_partitions,Number_of_nodes);b_e_I=zeros(Number_of_partitions,Number_of_nodes);
l_p1_I=zeros(Number_of_partitions,Number_of_nodes);d_p1_I=zeros(Number_of_partitions,Number_of_nodes);h_p1_I=zeros(Number_of_partitions,Number_of_nodes);b_p1_I=zeros(Number_of_partitions,Number_of_nodes);
l_MP_I=zeros(Number_of_partitions,Number_of_nodes);d_MP_I=zeros(Number_of_partitions,Number_of_nodes);h_MP_I=zeros(Number_of_partitions,Number_of_nodes);b_MP_I=zeros(Number_of_partitions,Number_of_nodes);
l_ML_I=zeros(Number_of_partitions,Number_of_nodes);d_ML_I=zeros(Number_of_partitions,Number_of_nodes);h_ML_I=zeros(Number_of_partitions,Number_of_nodes);b_ML_I=zeros(Number_of_partitions,Number_of_nodes);

laten_PR_I=zeros(Number_of_partitions,Number_of_nodes);
laten_ML_I=zeros(Number_of_partitions,Number_of_nodes);
laten_e_I=zeros(Number_of_partitions,Number_of_nodes);
laten_MP_I=zeros(Number_of_partitions,Number_of_nodes);

laten_PR_SI=zeros(Number_of_partitions,Number_of_nodes);
laten_ML_SI=zeros(Number_of_partitions,Number_of_nodes);
laten_e_SI=zeros(Number_of_partitions,Number_of_nodes);
laten_MP_SI=zeros(Number_of_partitions,Number_of_nodes);

s_l_e_I=zeros(Number_of_partitions,1);s_d_e_I=zeros(Number_of_partitions,1);s_h_e_I=zeros(Number_of_partitions,1);s_b_e_I=zeros(Number_of_partitions,1);
s_l_p1_I=zeros(Number_of_partitions,1);s_d_p1_I=zeros(Number_of_partitions,1);s_h_p1_I=zeros(Number_of_partitions,1);s_b_p1_I=zeros(Number_of_partitions,1);
s_l_MP_I=zeros(Number_of_partitions,1);s_d_MP_I=zeros(Number_of_partitions,1);s_h_MP_I=zeros(Number_of_partitions,1);s_b_MP_I=zeros(Number_of_partitions,1);
s_l_ML_I=zeros(Number_of_partitions,1);s_d_ML_I=zeros(Number_of_partitions,1);s_h_ML_I=zeros(Number_of_partitions,1);s_b_ML_I=zeros(Number_of_partitions,1);

l_e_SI=zeros(Number_of_partitions,Number_of_nodes,Number_of_runs);d_e_SI=zeros(Number_of_partitions,Number_of_nodes,Number_of_runs);h_e_SI=zeros(Number_of_partitions,Number_of_nodes,Number_of_runs);b_e_SI=zeros(Number_of_partitions,Number_of_nodes,Number_of_runs);
l_p1_SI=zeros(Number_of_partitions,Number_of_nodes,Number_of_runs);d_p1_SI=zeros(Number_of_partitions,Number_of_nodes,Number_of_runs);h_p1_SI=zeros(Number_of_partitions,Number_of_nodes,Number_of_runs);b_p1_SI=zeros(Number_of_partitions,Number_of_nodes,Number_of_runs);
l_MP_SI=zeros(Number_of_partitions,Number_of_nodes,Number_of_runs);d_MP_SI=zeros(Number_of_partitions,Number_of_nodes,Number_of_runs);h_MP_SI=zeros(Number_of_partitions,Number_of_nodes,Number_of_runs);b_MP_SI=zeros(Number_of_partitions,Number_of_nodes,Number_of_runs);
l_ML_SI=zeros(Number_of_partitions,Number_of_nodes,Number_of_runs);d_ML_SI=zeros(Number_of_partitions,Number_of_nodes,Number_of_runs);h_ML_SI=zeros(Number_of_partitions,Number_of_nodes,Number_of_runs);b_ML_SI=zeros(Number_of_partitions,Number_of_nodes,Number_of_runs);

s_l_e_SI=zeros(Number_of_partitions,1);s_d_e_SI=zeros(Number_of_partitions,1);s_h_e_SI=zeros(Number_of_partitions,1);s_b_e_SI=zeros(Number_of_partitions,1);
s_l_p1_SI=zeros(Number_of_partitions,1);s_d_p1_SI=zeros(Number_of_partitions,1);s_h_p1_SI=zeros(Number_of_partitions,1);s_b_p1_SI=zeros(Number_of_partitions,1);
s_l_MP_SI=zeros(Number_of_partitions,1);s_d_MP_SI=zeros(Number_of_partitions,1);s_h_MP_SI=zeros(Number_of_partitions,1);s_b_MP_SI=zeros(Number_of_partitions,1);
s_l_ML_SI=zeros(Number_of_partitions,1);s_d_ML_SI=zeros(Number_of_partitions,1);s_h_ML_SI=zeros(Number_of_partitions,1);s_b_ML_SI=zeros(Number_of_partitions,1);


for p=1:4%Number_of_partitions
    % real
    p
    dataset_name=sprintf('info05_new.txt');
    t_start=(p-1)*partition_length *3600;
    t_end=p*partition_length *3600;
    [meeting_rates_info,filename,existing_nodes_vector]= info_partitioned(dataset_name,Number_of_nodes,p,t_end,t_start);
    Num_exist_nodes=length(existing_nodes_vector);
    for d=1:Num_exist_nodes
        real_d=existing_nodes_vector(d);
        destination=d;
        generating_nodes=[1:d-1,d+1:Num_exist_nodes];
        message_creation_node=generating_nodes(ceil((Num_exist_nodes-1)*rand(1,Number_of_messages)));
        [l_e_I(p,real_d),d_e_I(p,real_d),h_e_I(p,real_d),b_e_I(p,real_d),Dstate_Messages_e_I,Lstate_Messages_e_I]= Epidemic(Num_exist_nodes,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL);
        [l_p1_I(p,real_d),d_p1_I(p,real_d),h_p1_I(p,real_d),b_p1_I(p,real_d),Dstate_Messages_PR_I,Lstate_Messages_PR_I]= prophet(Num_exist_nodes,destination,filename,P_init,beta,gamma,time_step1,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL);
        [l_ML_I(p,real_d),d_ML_I(p,real_d),h_ML_I(p,real_d),b_ML_I(p,real_d),Dstate_Messages_ML_I,Lstate_Messages_ML_I]= decentralized_linearOpt(Num_exist_nodes,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,meeting_rates_info,message_creation_node,TTL);
        [l_MP_I(p,real_d),d_MP_I(p,real_d),h_MP_I(p,real_d),b_MP_I(p,real_d),Dstate_Messages_MP_I,Lstate_Messages_MP_I]= maxprop(Num_exist_nodes,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL);
        Num_commun_messages=0;
        for m=1:Number_of_messages-1
            if (Dstate_Messages_e_I(m)==1 && Dstate_Messages_PR_I(m)==1 && Dstate_Messages_ML_I(m)==1 && Dstate_Messages_MP_I(m)==1)
                laten_PR_I(p,real_d)=laten_PR_I(p,real_d)+Lstate_Messages_PR_I(m);
                laten_ML_I(p,real_d)=laten_ML_I(p,real_d)+Lstate_Messages_ML_I(m);
                laten_e_I(p,real_d)=laten_e_I(p,real_d)+Lstate_Messages_e_I(m);
                laten_MP_I(p,real_d)=laten_MP_I(p,real_d)+Lstate_Messages_MP_I(m);
                Num_commun_messages=Num_commun_messages+1;
            end
        end
        Num_commun_messages
        laten_PR_I(p,real_d)=laten_PR_I(p,real_d)/Num_commun_messages;
        laten_ML_I(p,real_d)=laten_ML_I(p,real_d)/Num_commun_messages;
        laten_e_I(p,real_d)=laten_e_I(p,real_d)/Num_commun_messages;
        laten_MP_I(p,real_d)=laten_MP_I(p,real_d)/Num_commun_messages;
    end
    s_laten_e_I(p)=mean(laten_e_I(p,laten_e_I(p,:)>0));
    s_laten_PR_I(p)=mean(laten_PR_I(p,laten_PR_I(p,:)>0));
    s_laten_ML_I(p)=mean(laten_ML_I(p,laten_ML_I(p,:)>0));
    s_laten_MP_I(p)=mean(laten_MP_I(p,laten_MP_I(p,:)>0));
    %     s_l_e_I(p)=mean(l_e_I(p,l_e_I(p,:)>0));s_d_e_I(p)=mean(d_e_I(p,d_e_I(p,:)>0));s_h_e_I(p)=mean(h_e_I(p,h_e_I(p,:)>0));s_b_e_I(p)=mean(b_e_I(p,b_e_I(p,:)>0));
    %     s_l_p1_I(p)=mean(l_p1_I(p,l_p1_I(p,:)>0));s_d_p1_I(p)=mean(d_p1_I(p,d_p1_I(p,:)>0));s_h_p1_I(p)=mean(h_p1_I(p,h_p1_I(p,:)>0));s_b_p1_I(p)=mean(b_p1_I(p,b_p1_I(p,:)>0));
    %     s_l_ML_I(p)=mean(l_ML_I(p,l_ML_I(p,:)>0));s_d_ML_I(p)=mean(d_ML_I(p,d_ML_I(p,:)>0));s_h_ML_I(p)=mean(h_ML_I(p,h_ML_I(p,:)>0));s_b_ML_I(p)=mean(b_ML_I(p,b_ML_I(p,:)>0));
    %     s_l_MP_I(p)=mean(l_MP_I(p,l_MP_I(p,:)>0));s_d_MP_I(p)=mean(d_MP_I(p,d_MP_I(p,:)>0));s_h_MP_I(p)=mean(h_MP_I(p,h_MP_I(p,:)>0));s_b_MP_I(p)=mean(b_MP_I(p,b_MP_I(p,:)>0));
    %exp
    a=2
    meeting_rates_half_info=meeting_rates_info;
    for i=1:Num_exist_nodes
        for j=i+1:Num_exist_nodes
            meeting_rates_half_info(j,i)=0;
        end
    end
    
    for runtime=1:Number_of_runs
        runtime;
        filename = sprintf('Traces_partitioned/mytracefile%d_%d.txt',p,runtime);
        generator_general(Number_of_partitions*partition_length*3600,filename,meeting_rates_half_info,Num_exist_nodes,t_start);
        for d=1:Num_exist_nodes
            real_d=existing_nodes_vector(d);
            destination=d;
            generating_nodes=[1:d-1,d+1:Num_exist_nodes];
            message_creation_node=generating_nodes(ceil((Num_exist_nodes-1)*rand(1,Number_of_messages)));
            [l_e_SI(p,real_d,runtime),d_e_SI(p,real_d,runtime),h_e_SI(p,real_d,runtime),b_e_SI(p,real_d,runtime),Dstate_Messages_e_SI,Lstate_Messages_e_SI]= Epidemic(Num_exist_nodes,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL);
            [l_p1_SI(p,real_d,runtime),d_p1_SI(p,real_d,runtime),h_p1_SI(p,real_d,runtime),b_p1_SI(p,real_d,runtime),Dstate_Messages_PR_SI,Lstate_Messages_PR_SI]= prophet(Num_exist_nodes,destination,filename,P_init,beta,gamma,time_step1,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL);
            [l_ML_SI(p,real_d,runtime),d_ML_SI(p,real_d,runtime),h_ML_SI(p,real_d,runtime),b_ML_SI(p,real_d,runtime),Dstate_Messages_ML_SI,Lstate_Messages_ML_SI]= decentralized_linearOpt(Num_exist_nodes,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,meeting_rates_info,message_creation_node,TTL);
            [l_MP_SI(p,real_d,runtime),d_MP_SI(p,real_d,runtime),h_MP_SI(p,real_d,runtime),b_MP_SI(p,real_d,runtime),Dstate_Messages_MP_SI,Lstate_Messages_MP_SI]= maxprop(Num_exist_nodes,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL);
            Num_commun_messages2=0;
            for m=1:Number_of_messages
                if (Dstate_Messages_e_SI(m)==1 && Dstate_Messages_PR_SI(m)==1 && Dstate_Messages_ML_SI(m)==1 && Dstate_Messages_MP_SI(m)==1)
                    laten_PR_SI(p,real_d)=laten_PR_SI(p,real_d)+Lstate_Messages_PR_SI(m);
                    laten_ML_SI(p,real_d)=laten_ML_SI(p,real_d)+Lstate_Messages_ML_SI(m);
                    laten_e_SI(p,real_d)=laten_e_SI(p,real_d)+Lstate_Messages_e_SI(m);
                    laten_MP_SI(p,real_d)=laten_MP_SI(p,real_d)+Lstate_Messages_MP_SI(m);
                    Num_commun_messages2=Num_commun_messages2+1;
                end
            end
            Num_commun_messages2
            laten_PR_SI(p,real_d)=laten_PR_SI(p,real_d)/Num_commun_messages2;
            laten_ML_SI(p,real_d)=laten_ML_SI(p,real_d)/Num_commun_messages2;
            laten_e_SI(p,real_d)=laten_e_SI(p,real_d)/Num_commun_messages2;
            laten_MP_SI(p,real_d)=laten_MP_SI(p,real_d)/Num_commun_messages2;
        end
    end
    s_laten_e_SI(p)=mean(laten_e_SI(p,laten_e_SI(p,:)>0));
    s_laten_PR_SI(p)=mean(laten_PR_SI(p,laten_PR_SI(p,:)>0));
    s_laten_ML_SI(p)=mean(laten_ML_SI(p,laten_ML_SI(p,:)>0));
    s_laten_MP_SI(p)=mean(laten_MP_SI(p,laten_MP_SI(p,:)>0));
%     s_l_e_SI(p)=mean(l_e_SI(p,l_e_SI(p,:,:)>0));s_d_e_SI(p)=mean(d_e_SI(p,d_e_SI(p,:,:)>0));s_h_e_SI(p)=mean(h_e_SI(p,h_e_SI(p,:,:)>0));s_b_e_SI(p)=mean(b_e_SI(p,b_e_SI(p,:,:)>0));
%     s_l_p1_SI(p)=mean(l_p1_SI(p,l_p1_SI(p,:,:)>0));s_d_p1_SI(p)=mean(d_p1_SI(p,d_p1_SI(p,:,:)>0));s_h_p1_SI(p)=mean(h_p1_SI(p,h_p1_SI(p,:,:)>0));s_b_p1_SI(p)=mean(b_p1_SI(p,b_p1_SI(p,:,:)>0));
%     s_l_ML_SI(p)=mean(l_ML_SI(p,l_ML_SI(p,:,:)>0));s_d_ML_SI(p)=mean(d_ML_SI(p,d_ML_SI(p,:,:)>0));s_h_ML_SI(p)=mean(h_ML_SI(p,h_ML_SI(p,:,:)>0));s_b_ML_SI(p)=mean(b_ML_SI(p,b_ML_SI(p,:,:)>0));
%     s_l_MP_SI(p)=mean(l_MP_SI(p,l_MP_SI(p,:,:)>0));s_d_MP_SI(p)=mean(d_MP_SI(p,d_MP_SI(p,:,:)>0));s_h_MP_SI(p)=mean(h_MP_SI(p,h_MP_SI(p,:,:)>0));s_b_MP_SI(p)=mean(b_MP_SI(p,b_MP_SI(p,:,:)>0));
end
%% OUTPUT
save main_all_partitioned
for i=1:Number_of_nodes
    ss_laten_e_I(i)=mean(s_laten_e_I(s_laten_e_I(:,i)>0,i));
    ss_laten_PR_I(i)=mean(s_laten_PR_I(s_laten_PR_I(:,i)>0,i));
    ss_laten_ML_I(i)=mean(s_laten_ML_I(s_laten_ML_I(:,i)>0,i));
    ss_laten_MP_I(i)=mean(s_laten_MP_I(s_laten_MP_I(:,i)>0,i));
    
    ss_laten_e_SI(i)=mean(s_laten_e_SI(s_laten_e_SI(:,i)>0,i));
    ss_laten_PR_SI(i)=mean(s_laten_PR_SI(s_laten_PR_SI(:,i)>0,i));
    ss_laten_ML_SI(i)=mean(s_laten_ML_SI(s_laten_ML_SI(:,i)>0,i));
    ss_laten_MP_SI(i)=mean(s_laten_MP_SI(s_laten_MP_SI(:,i)>0,i));
    
    ss_laten_e_PA(i)=mean(s_laten_e_PA(s_laten_e_PA(:,i)>0,i));
    ss_laten_PR_PA(i)=mean(s_laten_PR_PA(s_laten_PR_PA(:,i)>0,i));
    ss_laten_ML_PA(i)=mean(s_laten_ML_PA(s_laten_ML_PA(:,i)>0,i));
    ss_laten_MP_PA(i)=mean(s_laten_MP_PA(s_laten_MP_PA(:,i)>0,i));
    
    ss_deliv_e_I(i)=mean(s_deliv_e_I(s_deliv_e_I(:,i)>0,i));
    ss_deliv_PR_I(i)=mean(s_deliv_PR_I(s_deliv_PR_I(:,i)>0,i));
    ss_deliv_ML_I(i)=mean(s_deliv_ML_I(s_deliv_ML_I(:,i)>0,i));
    ss_deliv_MP_I(i)=mean(s_deliv_MP_I(s_deliv_MP_I(:,i)>0,i));
    
    ss_deliv_e_SI(i)=mean(s_deliv_e_SI(s_deliv_e_SI(:,i)>0,i));
    ss_deliv_PR_SI(i)=mean(s_deliv_PR_SI(s_deliv_PR_SI(:,i)>0,i));
    ss_deliv_ML_SI(i)=mean(s_deliv_ML_SI(s_deliv_ML_SI(:,i)>0,i));
    ss_deliv_MP_SI(i)=mean(s_deliv_MP_SI(s_deliv_MP_SI(:,i)>0,i));
    
    ss_deliv_e_PA(i)=mean(s_deliv_e_PA(s_deliv_e_PA(:,i)>0,i));
    ss_deliv_PR_PA(i)=mean(s_deliv_PR_PA(s_deliv_PR_PA(:,i)>0,i));
    ss_deliv_ML_PA(i)=mean(s_deliv_ML_PA(s_deliv_ML_PA(:,i)>0,i));
    ss_deliv_MP_PA(i)=mean(s_deliv_MP_PA(s_deliv_MP_PA(:,i)>0,i));
    
    ss_h_e_I(i)=mean(s_h_e_I(s_h_e_I(:,i)>0,i));
    ss_h_PR_I(i)=mean(s_h_PR_I(s_h_PR_I(:,i)>0,i));
    ss_h_ML_I(i)=mean(s_h_ML_I(s_h_ML_I(:,i)>0,i));
    ss_h_MP_I(i)=mean(s_h_MP_I(s_h_MP_I(:,i)>0,i));
    
    ss_h_e_SI(i)=mean(s_h_e_SI(s_h_e_SI(:,i)>0,i));
    ss_h_PR_SI(i)=mean(s_h_PR_SI(s_h_PR_SI(:,i)>0,i));
    ss_h_ML_SI(i)=mean(s_h_ML_SI(s_h_ML_SI(:,i)>0,i));
    ss_h_MP_SI(i)=mean(s_h_MP_SI(s_h_MP_SI(:,i)>0,i));
    
    ss_h_e_PA(i)=mean(s_h_e_PA(s_h_e_PA(:,i)>0,i));
    ss_h_PR_PA(i)=mean(s_h_PR_PA(s_h_PR_PA(:,i)>0,i));
    ss_h_ML_PA(i)=mean(s_h_ML_PA(s_h_ML_PA(:,i)>0,i));
    ss_h_MP_PA(i)=mean(s_h_MP_PA(s_h_MP_PA(:,i)>0,i));
    
    ss_b_e_I(i)=mean(s_b_e_I(s_b_e_I(:,i)>0,i));
    ss_b_PR_I(i)=mean(s_b_PR_I(s_b_PR_I(:,i)>0,i));
    ss_b_ML_I(i)=mean(s_b_ML_I(s_b_ML_I(:,i)>0,i));
    ss_b_MP_I(i)=mean(s_b_MP_I(s_b_MP_I(:,i)>0,i));
    
    ss_b_e_SI(i)=mean(s_b_e_SI(s_b_e_SI(:,i)>0,i));
    ss_b_PR_SI(i)=mean(s_b_PR_SI(s_b_PR_SI(:,i)>0,i));
    ss_b_ML_SI(i)=mean(s_b_ML_SI(s_b_ML_SI(:,i)>0,i));
    ss_b_MP_SI(i)=mean(s_b_MP_SI(s_b_MP_SI(:,i)>0,i));
    
    ss_b_e_PA(i)=mean(s_b_e_PA(s_b_e_PA(:,i)>0,i));
    ss_b_PR_PA(i)=mean(s_b_PR_PA(s_b_PR_PA(:,i)>0,i));
    ss_b_ML_PA(i)=mean(s_b_ML_PA(s_b_ML_PA(:,i)>0,i));
    ss_b_MP_PA(i)=mean(s_b_MP_PA(s_b_MP_PA(:,i)>0,i));
end
sort_laten_e_I=sort(ss_laten_e_I,'ascend');sort_deliv_e_I=sort(ss_deliv_e_I,'ascend');sort_h_e_I=sort(ss_h_e_I,'ascend');sort_b_e_I=sort(ss_b_e_I,'ascend');
sort_laten_e_SI=sort(ss_laten_e_SI,'ascend');sort_deliv_e_SI=sort(ss_deliv_e_SI,'ascend');sort_h_e_SI=sort(ss_h_e_SI,'ascend');sort_b_e_SI=sort(ss_b_e_SI,'ascend');
sort_laten_e_PA=sort(ss_laten_e_PA,'ascend');sort_deliv_e_PA=sort(ss_deliv_e_PA,'ascend');sort_h_e_PA=sort(ss_h_e_PA,'ascend');sort_b_e_PA=sort(ss_b_e_PA,'ascend');

sort_laten_PR_I=sort(ss_laten_PR_I,'ascend');sort_deliv_PR_I=sort(ss_deliv_PR_I,'ascend');sort_h_PR_I=sort(ss_h_PR_I,'ascend');sort_b_PR_I=sort(ss_b_PR_I,'ascend');
sort_laten_PR_SI=sort(ss_laten_PR_SI,'ascend');sort_deliv_PR_SI=sort(ss_deliv_PR_SI,'ascend');sort_h_PR_SI=sort(ss_h_PR_SI,'ascend');sort_b_PR_SI=sort(ss_b_PR_SI,'ascend');
sort_laten_PR_PA=sort(ss_laten_PR_PA,'ascend');sort_deliv_PR_PA=sort(ss_deliv_PR_PA,'ascend');sort_h_PR_PA=sort(ss_h_PR_PA,'ascend');sort_b_PR_PA=sort(ss_b_PR_PA,'ascend');

sort_laten_ML_I=sort(ss_laten_ML_I,'ascend');sort_deliv_ML_I=sort(ss_deliv_ML_I,'ascend');sort_h_ML_I=sort(ss_h_ML_I,'ascend');sort_b_ML_I=sort(ss_b_ML_I,'ascend');
sort_laten_ML_SI=sort(ss_laten_ML_SI,'ascend');sort_deliv_ML_SI=sort(ss_deliv_ML_SI,'ascend');sort_h_ML_SI=sort(ss_h_ML_SI,'ascend');sort_b_ML_SI=sort(ss_b_ML_SI,'ascend');
sort_laten_ML_PA=sort(ss_laten_ML_PA,'ascend');sort_deliv_ML_PA=sort(ss_deliv_ML_PA,'ascend');sort_h_ML_PA=sort(ss_h_ML_PA,'ascend');sort_b_ML_PA=sort(ss_b_ML_PA,'ascend');

sort_laten_MP_I=sort(ss_laten_MP_I,'ascend');sort_deliv_MP_I=sort(ss_deliv_MP_I,'ascend');sort_h_MP_I=sort(ss_h_MP_I,'ascend');sort_b_MP_I=sort(ss_b_MP_I,'ascend');
sort_laten_MP_SI=sort(ss_laten_MP_SI,'ascend');sort_deliv_MP_SI=sort(ss_deliv_MP_SI,'ascend');sort_h_MP_SI=sort(ss_h_MP_SI,'ascend');sort_b_MP_SI=sort(ss_b_MP_SI,'ascend');
sort_laten_MP_PA=sort(ss_laten_MP_PA,'ascend');sort_deliv_MP_PA=sort(ss_deliv_MP_PA,'ascend');sort_h_MP_PA=sort(ss_h_MP_PA,'ascend');sort_b_MP_PA=sort(ss_b_MP_PA,'ascend');
vector=[1:11,13:30,32:41];
AVERAGE_LATENCY=[mean(ss_laten_e_PA(vector)),mean(ss_laten_PR_PA(vector)),mean(ss_laten_MP_PA(vector)),mean(ss_laten_ML_PA(vector));mean(ss_laten_e_SI(vector)),mean(ss_laten_PR_SI(vector)),mean(ss_laten_MP_SI(vector)),mean(ss_laten_ML_SI(vector));mean(ss_laten_e_I(vector)),mean(ss_laten_PR_I(vector)),mean(ss_laten_MP_I(vector)),mean(ss_laten_ML_I(vector))];
DELIVERY_RATE=[mean(ss_deliv_e_PA(vector)),mean(ss_deliv_PR_PA(vector)),mean(ss_deliv_MP_PA(vector)),mean(ss_deliv_ML_PA(vector));mean(ss_deliv_e_SI(vector)),mean(ss_deliv_PR_SI(vector)),mean(ss_deliv_MP_SI(vector)),mean(ss_deliv_ML_SI(vector));mean(ss_deliv_e_I(vector)),mean(ss_deliv_PR_I(vector)),mean(ss_deliv_MP_I(vector)),mean(ss_deliv_ML_I(vector))];
AVERAGE_HOP_COUNT=[mean(ss_h_e_PA(vector)),mean(ss_h_PR_PA(vector)),mean(ss_h_MP_PA(vector)),mean(ss_h_ML_PA(vector));mean(ss_h_e_SI(vector)),mean(ss_h_PR_SI(vector)),mean(ss_h_MP_SI(vector)),mean(ss_h_ML_SI(vector));mean(ss_h_e_I(vector)),mean(ss_h_PR_I(vector)),mean(ss_h_MP_I(vector)),mean(ss_h_ML_I(vector))];
AVERAGE_BUFFER_OCCUPANCY=[mean(ss_b_e_PA(vector)),mean(ss_b_PR_PA(vector)),mean(ss_b_MP_PA(vector)),mean(ss_b_ML_PA(vector));mean(ss_b_e_SI(vector)),mean(ss_b_PR_SI(vector)),mean(ss_b_MP_SI(vector)),mean(ss_b_ML_SI(vector));mean(ss_b_e_I(vector)),mean(ss_b_PR_I(vector)),mean(ss_b_MP_I(vector)),mean(ss_b_ML_I(vector))];
l=2;
u=37;

Low_AVERAGE_LATENCY=[sort_laten_e_PA(l),sort_laten_PR_PA(l),sort_laten_MP_PA(l),sort_laten_ML_PA(l);sort_laten_e_SI(l),sort_laten_PR_SI(l),sort_laten_MP_SI(l),sort_laten_ML_SI(l);sort_laten_e_I(l),sort_laten_PR_I(l),sort_laten_MP_I(l),sort_laten_ML_I(l)];
Low_DELIVERY_RATE=[sort_deliv_e_PA(l),sort_deliv_PR_PA(l),sort_deliv_MP_PA(l),sort_deliv_ML_PA(l);sort_deliv_e_SI(l),sort_deliv_PR_SI(l),sort_deliv_MP_SI(l),sort_deliv_ML_SI(l);sort_deliv_e_I(l),sort_deliv_PR_I(l),sort_deliv_MP_I(l),sort_deliv_ML_I(l)];
Low_AVERAGE_HOP_COUNT=[sort_h_e_PA(l),sort_h_PR_PA(l),sort_h_MP_PA(l),sort_h_ML_PA(l);sort_h_e_SI(l),sort_h_PR_SI(l),sort_h_MP_SI(l),sort_h_ML_SI(l);sort_h_e_I(l),sort_h_PR_I(l),sort_h_MP_I(l),sort_h_ML_I(l)];
Low_AVERAGE_BUFFER_OCCUPANCY=[sort_b_e_PA(l),sort_b_PR_PA(l),sort_b_MP_PA(l),sort_b_ML_PA(l);sort_b_e_SI(l),sort_b_PR_SI(l),sort_b_MP_SI(l),sort_b_ML_SI(l);sort_b_e_I(l),sort_b_PR_I(l),sort_b_MP_I(l),sort_b_ML_I(l)];


UP_AVERAGE_LATENCY=[sort_laten_e_PA(u),sort_laten_PR_PA(u),sort_laten_MP_PA(u),sort_laten_ML_PA(u);sort_laten_e_SI(u),sort_laten_PR_SI(u),sort_laten_MP_SI(u),sort_laten_ML_SI(u);sort_laten_e_I(u),sort_laten_PR_I(u),sort_laten_MP_I(u),sort_laten_ML_I(u)];
UP_DELIVERY_RATE=[sort_deliv_e_PA(u),sort_deliv_PR_PA(u),sort_deliv_MP_PA(u),sort_deliv_ML_PA(u);sort_deliv_e_SI(u),sort_deliv_PR_SI(u),sort_deliv_MP_SI(u),sort_deliv_ML_SI(u);sort_deliv_e_I(u),sort_deliv_PR_I(u),sort_deliv_MP_I(u),sort_deliv_ML_I(u)];
UP_AVERAGE_HOP_COUNT=[sort_h_e_PA(u),sort_h_PR_PA(u),sort_h_MP_PA(u),sort_h_ML_PA(u);sort_h_e_SI(u),sort_h_PR_SI(u),sort_h_MP_SI(u),sort_h_ML_SI(u);sort_h_e_I(u),sort_h_PR_I(u),sort_h_MP_I(u),sort_h_ML_I(u)];
UP_AVERAGE_BUFFER_OCCUPANCY=[sort_b_e_PA(u),sort_b_PR_PA(u),sort_b_MP_PA(u),sort_b_ML_PA(u);sort_b_e_SI(u),sort_b_PR_SI(u),sort_b_MP_SI(u),sort_b_ML_SI(u);sort_b_e_I(u),sort_b_PR_I(u),sort_b_MP_I(u),sort_b_ML_I(u)];
%% Display
h=figure(11);
legend('Epidemic','PRoPHETv2','MaxProp','MinLat');
bar(AVERAGE_LATENCY,'grouped','BarWidth',1)
set(gca,'XTickLabel',{'Net I','Net II','Net III'},'FontSize',18)
hold on;
numgroups = size(AVERAGE_LATENCY, 1); 
numbars = size(AVERAGE_LATENCY, 2); 
groupwidth = min(0.8, numbars/(numbars+1.5));
for i = 1:numbars
      % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
      x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
      errorbar(x, AVERAGE_LATENCY(:,i), AVERAGE_LATENCY(:,i)-Low_AVERAGE_LATENCY(:,i), UP_AVERAGE_LATENCY(:,i)-AVERAGE_LATENCY(:,i),'k', 'linestyle', 'none');
end
saveas(h,'fig1.fig','fig')
hold off
print('-dpdf','-r300','res1')
title('Average Latency')

h=figure(12);
bar(DELIVERY_RATE,'grouped','BarWidth',1)
set(gca,'XTickLabel',{'Net I','Net II','Net III'},'FontSize',18)
hold on;
numgroups = size(DELIVERY_RATE, 1); 
numbars = size(DELIVERY_RATE, 2); 
groupwidth = min(0.8, numbars/(numbars+1.5));
for i = 1:numbars
      % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
      x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
      errorbar(x, DELIVERY_RATE(:,i), DELIVERY_RATE(:,i)-Low_DELIVERY_RATE(:,i),UP_DELIVERY_RATE(:,i)-DELIVERY_RATE(:,i), 'k', 'linestyle', 'none');
end

%set(lh,'Location','northeast','Orientation','horizontal','FontSize',20)
saveas(h,'fig2.fig','fig')
hold off
print('-dpdf','-r300','res2')
title('Average Delivery Rate')

h=figure(13);
bar(AVERAGE_BUFFER_OCCUPANCY,'grouped','BarWidth',1)
set(gca,'XTickLabel',{'Net I','Net II','Net III'},'FontSize',18)
hold on;
numgroups = size(AVERAGE_BUFFER_OCCUPANCY, 1); 
numbars = size(AVERAGE_BUFFER_OCCUPANCY, 2); 
groupwidth = min(0.8, numbars/(numbars+1.5));
for i = 1:numbars
      % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
      x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
      errorbar(x,AVERAGE_BUFFER_OCCUPANCY(:,i), AVERAGE_BUFFER_OCCUPANCY(:,i)-Low_AVERAGE_BUFFER_OCCUPANCY(:,i),UP_AVERAGE_BUFFER_OCCUPANCY(:,i)-AVERAGE_BUFFER_OCCUPANCY(:,i), 'k', 'linestyle', 'none');
end
saveas(h,'fig3.fig','fig')
hold off
print('-dpdf','-r300','res3')
title('Average Buffer Occupancy')

h=figure(14);
bar(AVERAGE_HOP_COUNT,'grouped','BarWidth',1)
set(gca,'XTickLabel',{'Net I','Net II','Net III'},'FontSize',18)
hold on;
numgroups = size(AVERAGE_HOP_COUNT, 1); 
numbars = size(AVERAGE_HOP_COUNT, 2); 
groupwidth = min(0.8, numbars/(numbars+1.5));
for i = 1:numbars
      % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
      x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
      errorbar(x, AVERAGE_HOP_COUNT(:,i), AVERAGE_HOP_COUNT(:,i)-Low_AVERAGE_HOP_COUNT(:,i), UP_AVERAGE_HOP_COUNT(:,i)-AVERAGE_HOP_COUNT(:,i),'k', 'linestyle', 'none');
end
saveas(h,'fig4.fig','fig')
hold off
print('-dpdf','-r300','res4')
title('Average Hop Count')



save main_all_partitioned