function [message_delivery_time]= Epidemic_batch(N,destination,filename,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL,message_creation_time)
fID = fopen(filename,'r');
events=textscan(fID,'%f %s %d %d %s');

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

links=zeros(N,N);
Forward=zeros(N,N);
 
% message_creation_time=zeros(1,Number_of_messages);
% for i=1:Number_of_messages
%     message_creation_time(i)=(i-1)*interarrival_time+events{1}(1);
% end

i=1;

while (i<=length(events{5}))
    node1=events{3}(i);
    node2=events{4}(i);
    
    links(node1,node2)=1;
    links(node2,node1)=1;
    
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
        %j=k;%buffer1(k);
        if (acks(node2,nodes_buffer(node1,j))==1 || events{1}(i)-message_creation_time(nodes_buffer(node1,j))>TTL)
            acks(node1,nodes_buffer(node1,j))=1;
            jj=find(buffer_status_node1==nodes_buffer(node1,j));
            buffer_status_node1(jj)=0;
            buffer_status_node1([jj:length(buffer_status_node1)])=buffer_status_node1([jj+1:length(buffer_status_node1) jj]);
        end
    end
    
    for j=1:end_of_buffer2
        %j=k;%buffer2(k);
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
        
    if (node2==destination)
        for j=1:exchange1to2
            acks(node1,buffer_status_node1(1))=1;
            acks(destination,buffer_status_node1(1))=1;
            message_delivery_time(buffer_status_node1(1))=events{1}(i);
            hop_count(node2,buffer_status_node1(1))=hop_count(node1,buffer_status_node1(1))+1;
            buffer_status_node1(1)=0;
            buffer_status_node1([1:length(buffer_status_node2)])=buffer_status_node1([2:buffer_limit 1]);
        end
    elseif (node1==destination)
        for j=1:exchange2to1
            acks(node2,buffer_status_node2(1))=1;
            acks(destination,buffer_status_node2(1))=1;
            message_delivery_time(buffer_status_node2(1))=events{1}(i);
            hop_count(node1,buffer_status_node2(1))=hop_count(node2,buffer_status_node2(1))+1;
            buffer_status_node2(1)=0;
            buffer_status_node2([1:length(buffer_status_node1)])=buffer_status_node2([2:buffer_limit 1]);
        end
    else
        jj=1;
        for j=1:min(exchange1to2,buffer_limit-end_of_buffer2)            
            if (isempty(find(nodes_buffer(node2,:)==nodes_buffer(node1,j))))
                buffer_status_node2(end_of_buffer2+jj)=nodes_buffer(node1,j);
                hop_count(node2,buffer_status_node1(j))=hop_count(node1,buffer_status_node1(j))+1;
                jj=jj+1;
            end
        end
        jj=1;
        for j=1:min(exchange2to1,buffer_limit-end_of_buffer1)
            if (isempty(find(nodes_buffer(node1,:)==nodes_buffer(node2,j))))
                buffer_status_node1(end_of_buffer1+jj)=nodes_buffer(node2,j);
                hop_count(node1,buffer_status_node2(j))=hop_count(node2,buffer_status_node2(j))+1;
                jj=jj+1;
            end
        end
    end
    nodes_buffer(node1,:)= buffer_status_node1;
    nodes_buffer(node2,:)= buffer_status_node2;
    for j=1:N
        buffer_occupancy(j,i)=length(find(nodes_buffer(j,:)>0));
    end
    i=i+1
end
fclose(fID);