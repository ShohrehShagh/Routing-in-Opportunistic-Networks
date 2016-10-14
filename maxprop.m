function [average_delivery_delay,delivery_rate,average_hop_count,average_buffer_occupancy,delivery_state_of_messages,latency_of_messages]= maxprop(N,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL)

delivery_state_of_messages=zeros(Number_of_messages,1);
latency_of_messages=zeros(Number_of_messages,1);

fID = fopen(filename,'r');
events=textscan(fID,'%f %s %d %d %s');

meeting_likelihood=(1/N)*ones(N,N,N);

acks=zeros(N,Number_of_messages);
message_delivery_time=inf*ones(1,Number_of_messages);
hop_count=-1*ones(N,Number_of_messages);
message_to_send=1;
nodes_buffer=zeros(N,buffer_limit);
buffer_occupancy=zeros(N,length(events{5}));
mean_buffer_occupancy=zeros(1,N);
delivery_rate=0;
average_delivery_delay=0;
average_hop_count=0;
average_buffer_occupancy=0;

N_forwarding=zeros(1,N);

message_creation_time=zeros(1,Number_of_messages);
message_location=zeros(1,Number_of_messages);
for i=1:Number_of_messages
    message_creation_time(i)=(i-1)*interarrival_time+events{1}(1);
end

links=inf*ones(N,N);
Forward=zeros(N,N);

i=1;

while (i<=length(events{5}))
    
    node1=events{3}(i);
    node2=events{4}(i);
    
    links(node1,node2)=1;
    links(node2,node1)=1;
    
    
    
    meeting_likelihood(node1,node2,node1)=meeting_likelihood(node1,node2,node1)+1;
    connected_nodes1=find(meeting_likelihood(node1,:,node1)>0);
    meeting_likelihood(node1,connected_nodes1,node1)=meeting_likelihood(node1,connected_nodes1,node1)/sum(meeting_likelihood(node1,connected_nodes1,node1));
    meeting_likelihood([1:node1-1,node1+1:N],node2,node1)=meeting_likelihood([1:node1-1,node1+1:N],node2,node2);
      
    meeting_likelihood(node2,node1,node2)=meeting_likelihood(node2,node1,node2)+1;
    connected_nodes2=find(meeting_likelihood(node2,:,node2)>0);
    meeting_likelihood(node2,connected_nodes2,node2)=meeting_likelihood(node2,connected_nodes2,node2)/sum(meeting_likelihood(node2,connected_nodes2,node2));
    meeting_likelihood([1:node2-1,node2+1:N],node1,node2)=meeting_likelihood([1:node2-1,node2+1:N],node1,node1);
    
    weights1=links-meeting_likelihood(:,:,node1);
    weights2=links-meeting_likelihood(:,:,node2);
    
    prev2=myDijkstra(N,weights1,node2,destination);
    node_before=destination;
    if (prev2(destination)==node2)
        Forward(node2,destination)=1;
    elseif (prev2(destination)>0)
        while (node_before ~= node2)
            two_nodes_before2=node_before;
            node_before=prev2(node_before);
        end
        Forward(node2,:)=zeros(1,N);
        Forward(node2,two_nodes_before2)=1;
    end
    
    prev1=myDijkstra(N,weights2,node1,destination);
    node_before=destination;
    if (prev1(destination)==node1)
        Forward(node1,destination)=1;
    elseif (prev1(destination)>0)
        while (node_before ~= node1)
            two_nodes_before1=node_before;
            node_before=prev1(node_before);
        end
        Forward(node1,:)=zeros(1,N);
        Forward(node1,two_nodes_before1)=1;
    end
    
    %% sending the messages
    while(message_creation_time(message_to_send)<events{1}(i) && message_to_send<Number_of_messages)
        end_of_buffer=length(find(nodes_buffer(message_creation_node(message_to_send),:)>0));
        if (end_of_buffer<buffer_limit)
            nodes_buffer(message_creation_node(message_to_send),end_of_buffer+1)=message_to_send;
            hop_count(message_creation_node(message_to_send),message_to_send)=0;
        end
        message_to_send=message_to_send+1;
    end
    %% message forwarding
    buffer_status_node1=nodes_buffer(node1,:);
    buffer_status_node2=nodes_buffer(node2,:);
    buffer1=find(buffer_status_node1>0);
    buffer2=find(buffer_status_node2>0);
    end_of_buffer1=length(buffer1);
    end_of_buffer2=length(buffer2);
    acks_node1=find(acks(node1,:)==1);
    acks_node2=find(acks(node2,:)==1);
    
    for j=1:end_of_buffer1
        if (acks(node2,nodes_buffer(node1,j))==1 || events{1}(i)-message_creation_time(nodes_buffer(node1,j))>TTL)
            acks(node1,nodes_buffer(node1,j))=1;
            jj=find(buffer_status_node1==nodes_buffer(node1,j));
            buffer_status_node1(jj)=0;
            buffer_status_node1([jj:length(buffer_status_node1)])=buffer_status_node1([jj+1:length(buffer_status_node1) jj]);
        end
    end
    
    for j=1:end_of_buffer2
        if (acks(node1,nodes_buffer(node2,j))==1 || events{1}(i)-message_creation_time(nodes_buffer(node2,j))>TTL)
            acks(node2,nodes_buffer(node2,j))=1;
            jj=find(buffer_status_node2==nodes_buffer(node2,j));
            buffer_status_node2(jj)=0;
            buffer_status_node2([jj:length(buffer_status_node2)])=buffer_status_node2([jj+1:length(buffer_status_node2) jj]);
        end
    end
    
    nodes_buffer(node1,:)= buffer_status_node1;
    nodes_buffer(node2,:)= buffer_status_node2;
    
    end_of_buffer1=length(find(buffer_status_node1>0));
    end_of_buffer2=length(find(buffer_status_node2>0));
    
    exchange1to2=min([exchange_limit,end_of_buffer1]);
    exchange2to1=min([exchange_limit,end_of_buffer2]);
    
    if (Forward(node1,node2)==1 && exchange1to2>0)
        if (node2==destination)
            for j=1:exchange1to2
                acks(node1,buffer_status_node1(1))=1;
                acks(destination,buffer_status_node1(1))=1;
                message_delivery_time(buffer_status_node1(1))=events{1}(i);
                hop_count(node2,buffer_status_node1(1))=hop_count(node1,buffer_status_node1(1))+1;
                buffer_status_node1(1)=0;
                buffer_status_node1([1:length(buffer_status_node2)])=buffer_status_node1([2:buffer_limit 1]);
                N_forwarding(node1)=N_forwarding(node1)+1;
            end
        else
            jj=1;
            for j=1:min(exchange1to2,buffer_limit-end_of_buffer2)
                if (isempty(find(nodes_buffer(node2,:)==nodes_buffer(node1,j))))
                    buffer_status_node2(end_of_buffer2+jj)=nodes_buffer(node1,j);
                    hop_count(node2,buffer_status_node1(j))=hop_count(node1,buffer_status_node1(j))+1;
                    jj=jj+1;
                    N_forwarding(node1)=N_forwarding(node1)+1;
                end
            end
        end
    elseif (Forward(node2,node1)==1 && exchange2to1>0)
        if (node1==destination)
            for j=1:exchange2to1
                acks(node2,buffer_status_node2(1))=1;
                acks(destination,buffer_status_node2(1))=1;
                message_delivery_time(buffer_status_node2(1))=events{1}(i);
                hop_count(node1,buffer_status_node2(1))=hop_count(node2,buffer_status_node2(1))+1;
                buffer_status_node2(1)=0;
                buffer_status_node2([1:length(buffer_status_node1)])=buffer_status_node2([2:buffer_limit 1]);
                N_forwarding(node2)=N_forwarding(node2)+1;
            end
        else
            jj=1;
            for j=1:min(exchange2to1,buffer_limit-end_of_buffer1)
                if (isempty(find(nodes_buffer(node1,:)==nodes_buffer(node2,j))))
                    buffer_status_node1(end_of_buffer1+jj)=nodes_buffer(node2,j);
                    hop_count(node1,buffer_status_node2(j))=hop_count(node2,buffer_status_node2(j))+1;
                    jj=jj+1;
                    N_forwarding(node2)=N_forwarding(node2)+1;
                end
            end
        end
    end
    nodes_buffer(node1,:)= buffer_status_node1;
    nodes_buffer(node2,:)= buffer_status_node2;
    for j=1:N
        buffer_occupancy(j,i)=length(find(nodes_buffer(j,:)>0));
    end
    i=i+1;
end

for j=1:N
    mean_buffer_occupancy(j)= mean(buffer_occupancy(j,:));
    max_buffer_occupancy(j)= max(buffer_occupancy(j,:));
end
d=0;
for j=1:Number_of_messages-1
    if(acks(destination,j)==1)
        d=d+1;
        delivery_rate=delivery_rate+1;
        average_delivery_delay=average_delivery_delay+message_delivery_time(j)-message_creation_time(j);
        average_hop_count=average_hop_count+hop_count(destination,j);
        delivery_state_of_messages(j)=1;
    end
    latency_of_messages(j)=message_delivery_time(j)-message_creation_time(j);
end
delivery_rate=delivery_rate/(Number_of_messages-1);
average_delivery_delay=average_delivery_delay/d;
average_hop_count=average_hop_count/d;
average_buffer_occupancy=mean(mean_buffer_occupancy([1:destination-1,destination+1:N]));
fclose(fID);