function [message_delivery_time]= prophet_batch(N,destination,filename,P_init,beta,gamma,time_step,Number_of_messages,interarrival_time,buffer_limit,exchange_limit,message_creation_node,TTL,message_creation_time)
fID = fopen(filename,'r');
events=textscan(fID,'%f %s %d %d %s');

delivery_probability=zeros(N,N);
message_delivery_time=inf*ones(1,Number_of_messages);
for i=1:Number_of_messages
    message_state(i,:)='NS'; %%%'NS','SE','DE','DR','TO'
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

for i=1:N
    delivery_probability(i,i)=1;
end

% message_creation_time=zeros(1,Number_of_messages);
message_location=zeros(1,Number_of_messages);
% for i=1:Number_of_messages
%     message_creation_time(i)=(i-1)*interarrival_time+events{1}(1);
% end

links=zeros(N,N);
Forward=zeros(N,N);
last_meeting=zeros(N,N);
i=1;
length(events{5})
while (i<=length(events{5}))
    node1=events{3}(i);
    node2=events{4}(i);
    
    links(node1,node2)=1;
    links(node2,node1)=1;
    
    delivery_probability(node1,node2)=delivery_probability(node1,node2)*gamma^((events{1}(i)-last_meeting(node1,node2))/time_step);
    delivery_probability(node1,node2)=delivery_probability(node1,node2)+(1-delivery_probability(node1,node2))*P_init;
    max_neighbour=0;
    for j=1:N
        if (links(node1,j)==1 && links(node2,j)==1)
            A=delivery_probability(node1,j)*gamma^((events{1}(i)-last_meeting(node1,j))/time_step);
            B=delivery_probability(node2,j)*gamma^((events{1}(i)-last_meeting(node2,j))/time_step);
            
            if(delivery_probability(node1,j)*delivery_probability(node2,j)*beta>max_neighbour)
                max_neighbour=delivery_probability(node1,j)*delivery_probability(node2,j)*beta;
            end
        end
    end
    delivery_probability(node1,node2)=max(delivery_probability(node1,node2),max_neighbour);
    delivery_probability(node2,node1)=delivery_probability(node1,node2);
    last_meeting(node1,node2)=events{1}(i);
    last_meeting(node2,node1)=events{1}(i);
    
    if(delivery_probability(node1,destination)<delivery_probability(node2,destination))
        Forward(node1,node2)=1;
        Forward(node2,node1)=0;
    else
        Forward(node1,node2)=0;
        Forward(node2,node1)=1;
    end
    Forward(:,destination)=1;
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
    if (Forward(node1,node2)==1 && exchange1to2>0)
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
    elseif (Forward(node2,node1)==1 && exchange2to1>0)
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
        buffer_occupancy(j,i)=length(find(nodes_buffer(j,:)>0));
    end
    i=i+1
end

fclose(fID);