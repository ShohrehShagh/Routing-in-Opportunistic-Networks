function [message_delivery_time]= decentralized_linearOpt_batch(N,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,meeting_rates,message_creation_node,TTL,message_creation_time);   
Latency_estimations=inf*ones(N,N);
Latency_estimations(destination,destination)=0;
fID = fopen(filename,'r');
events=textscan(fID,'%f %s %d %d %s');
links=zeros(N,N);
Forward=zeros(N,N);

%Sim_time=100000;


message_delivery_time=inf*ones(1,Number_of_messages);
for i=1:Number_of_messages
    message_state(i,:)='NS'; %%%'NS','SE','DE','DR'
end
hop_count=zeros(1,Number_of_messages);
message_to_send=1;
nodes_buffer=zeros(N,buffer_limit);
buffer_occupancy=zeros(N,length(events{5}));
mean_buffer_occupancy=zeros(1,N);
delivery_rate=0;
average_delivery_delay=0;
average_hop_count=0;
average_buffer_occupancy=0;

% message_creation_time=zeros(1,Number_of_messages);
 message_location=zeros(1,Number_of_messages);
% for i=1:Number_of_messages
%     message_creation_time(i)=(i-1)*interarrival_time+events{1}(1);
% end

index_L=1;
i=1;
while (i<= length(events{5}))
    node1=events{3}(i);
    node2=events{4}(i);
    
    links(node1,node2)=1;
    links(node2,node1)=1;
    %if (events{1}(i)<Sim_time)
    Latency_estimations(node1,node2)=Latency_estimations(node2,node2);
    Latency_estimations(node2,node1)=Latency_estimations(node1,node1);
    %% Latency Calculation for node1
    connected1=find(links(node1,:)>0);% node1's neighbours
    on_link_node1=connected1(find(Latency_estimations(node1,connected1)<inf));
    Neigh_Size1=length(on_link_node1);
    if (node1==destination)
        Latency_estimations(node1,node1)=0;
        Forward(node1,node2)=0;
    elseif (node2==destination && Neigh_Size1==1)
        Latency_estimations(node2,node2)=0;
        Latency_estimations(node1,node1)=1/meeting_rates(node1,node2);
        Forward(node1,node2)=1;
        Forward(node2,node1)=0;
    elseif (Neigh_Size1>0)
        A1=zeros(2*Neigh_Size1,Neigh_Size1+1);
        A1(1:Neigh_Size1,Neigh_Size1+1)=-1;
        Aeq1=zeros(1,Neigh_Size1+1);
        f1=ones(Neigh_Size1+1,1);
        p1= zeros(Neigh_Size1,1);
        for ii=1:Neigh_Size1
            A1(ii,ii)=1;
            A1(Neigh_Size1+ii,ii)=-1;
            Aeq1(1,ii)=meeting_rates(node1,on_link_node1(ii));
            f1(ii,1)=meeting_rates(node1,on_link_node1(ii))*Latency_estimations(node1,on_link_node1(ii));
        end
        b1=zeros(2*Neigh_Size1,1);
        beq1=1;
        lb1=-inf*ones(Neigh_Size1+1,1);
        lb1(Neigh_Size1+1,1)=0;
        x1=zeros(Neigh_Size1+1,1);
        options = optimset('Display','none');
        [x1,minval1]= linprog(f1,A1,b1,Aeq1,beq1,lb1,[],[],options);
        p1(1:Neigh_Size1,1)=x1(1:Neigh_Size1,1)/x1(Neigh_Size1+1,1);
        if (minval1<inf)
            Latency_estimations(node1,node1)=minval1;
            for k=1:Neigh_Size1
                Forward(node1,on_link_node1(k))=p1(k);
            end
        end
    end
    %% Latency Calculation for node2
    connected2=find(links(node2,:)>0);% node1's neighbours
    on_link_node2=connected2(find(Latency_estimations(node2,connected2)<inf));
    Neigh_Size2=length(on_link_node2);
    if (node2==destination)
        Latency_estimations(node2,node2)=0;
        Forward(node2,node1)=0;
    elseif (node1==destination && Neigh_Size2==1)
        Latency_estimations(node1,node1)=0;
        Latency_estimations(node2,node2)=1/meeting_rates(node2,node1);
        Forward(node2,node1)=1;
        Forward(node1,node2)=0;
    elseif (Neigh_Size2>0)
        A2=zeros(2*Neigh_Size2,Neigh_Size2+1);
        A2(1:Neigh_Size2,Neigh_Size2+1)=-1;
        Aeq2=zeros(1,Neigh_Size2+1);
        f2=ones(Neigh_Size2+1,1);
        p2= zeros(Neigh_Size2,1);
        for ii=1:Neigh_Size2
            A2(ii,ii)=1;
            A2(Neigh_Size2+ii,ii)=-1;
            Aeq2(1,ii)=meeting_rates(node2,on_link_node2(ii));
            f2(ii,1)=meeting_rates(node2,on_link_node2(ii))*Latency_estimations(node2,on_link_node2(ii));
        end
        b2=zeros(2*Neigh_Size2,1);
        beq2=1;
        lb2=-inf*ones(Neigh_Size2+1,1);
        lb2(Neigh_Size2+1,1)=0;
        x2=zeros(Neigh_Size2+1,1);
        options = optimset('Display','none');
        [x2,minval2]= linprog(f2,A2,b2,Aeq2,beq2,lb2,[],[],options);
        p2(1:Neigh_Size2,1)=x2(1:Neigh_Size2,1)/x2(Neigh_Size2+1,1);
        if (minval2<inf)
            Latency_estimations(node2,node2)=minval2;
            for k=1:Neigh_Size2
                Forward(node2,on_link_node2(k))=p2(k);
            end
        end
    end
    links(node1,node2)=1;
    links(node2,node1)=1;
    for j=1:N
        LL(j,index_L)= Latency_estimations(j,j);
    end
    %    end
    %%
    while(message_creation_time(message_to_send)<events{1}(i) && message_to_send<Number_of_messages)
        end_of_buffer=length(find(nodes_buffer(message_creation_node(message_to_send),:)>0));
        if (end_of_buffer==buffer_limit)
            message_state(message_to_send,:)='DR';
        else
            message_state(message_to_send,:)='SE';
            nodes_buffer(message_creation_node(message_to_send),end_of_buffer+1)=message_to_send;
        end
        message_location(message_to_send)=message_creation_node(message_to_send);
        message_to_send=message_to_send+1;
    end
    %%
    buffer_location=0;
    for j=1:message_to_send-1
        if (message_state(j,1)=='S' && message_state(j,2)=='E' && events{1}(i)-message_creation_time(j)>TTL)
            message_state(j,:)='TO';
            buffer_location=find(nodes_buffer(message_location(j),:)==j);
            nodes_buffer(message_location(j),buffer_location)=0;
            nodes_buffer(message_location(j),:)=nodes_buffer(message_location(j),[1:buffer_location-1 buffer_location+1:buffer_limit buffer_location]);
        end
    end
    %%
    end_of_buffer1=length(find(nodes_buffer(node1,:)>0));
    end_of_buffer2=length(find(nodes_buffer(node2,:)>0));
    
    exchange1to2=min([exchange_limit,end_of_buffer1]);
    exchange2to1=min([exchange_limit,end_of_buffer2]);
    if (Forward(node1,node2)>0.5 && exchange1to2>0)
        if (node2==destination)
            for j=1:exchange1to2
                message_state(nodes_buffer(node1,1),:)='DE';
                message_delivery_time(nodes_buffer(node1,1))=events{1}(i);
                message_location(nodes_buffer(node1,1))=destination;
                hop_count(nodes_buffer(node1,1))=hop_count(nodes_buffer(node1,1))+1;
                nodes_buffer(node1,1)=0;
                nodes_buffer(node1,:)=nodes_buffer(node1,[2:buffer_limit 1]);
            end
        else
            for j=1:min(exchange1to2,buffer_limit-end_of_buffer2)
                nodes_buffer(node2,end_of_buffer2+j)=nodes_buffer(node1,1);
                hop_count(nodes_buffer(node1,1))=hop_count(nodes_buffer(node1,1))+1;
                message_location(nodes_buffer(node1,1))=node2;
                nodes_buffer(node1,1)=0;
                nodes_buffer(node1,:)=nodes_buffer(node1,[2:buffer_limit 1]);
            end
        end
    elseif (Forward(node2,node1)>0.5 && exchange2to1>0)
        if (node1==destination)
            for j=1:exchange2to1
                message_state(nodes_buffer(node2,1),:)='DE';
                message_delivery_time(nodes_buffer(node2,1))=events{1}(i);
                message_location(nodes_buffer(node2,1))=destination;
                hop_count(nodes_buffer(node2,1))=hop_count(nodes_buffer(node2,1))+1;
                nodes_buffer(node2,1)=0;
                nodes_buffer(node2,:)=nodes_buffer(node2,[2:buffer_limit 1]);
            end
        else
            for j=1:min(exchange2to1,buffer_limit-end_of_buffer1)
                nodes_buffer(node1,end_of_buffer1+j)=nodes_buffer(node2,1);
                hop_count(nodes_buffer(node2,1))=hop_count(nodes_buffer(node2,1))+1;
                message_location(nodes_buffer(node2,1))=node1;
                nodes_buffer(node2,1)=0;
                nodes_buffer(node2,:)=nodes_buffer(node2,[2:buffer_limit 1]);
            end
        end
    end
    for j=1:N
        buffer_occupancy(j,index_L)=length(find(nodes_buffer(j,:)>0));
    end
    time(index_L)=events{1}(i);
    index_L=index_L+1;
    i=i+1;
end
fclose(fID);