function [updated_message_states,updated_node_latency,updated_forward_neighbours]= forward_minlat_general(neighbours,message_number,message_states,number_of_nodes,node1,node2,node_latency,meeting_rates,destination,flag_minlat,forward_neighbours)

updated_message_states=message_states;
updated_node_latency=node_latency;
updated_forward_neighbours=forward_neighbours;

for R=1:2
    neighbours(node1,node2)=0;
    temp_set=zeros(1,number_of_nodes);
    temp_n=neighbours(node1,:);

    S=find(temp_n==1);
    for j=1:length(S)
        if  (forward_neighbours(node1,S(j))==1)
            %%%(node_latency(S(j))<node_latency(node2))
            temp_set(S(j))=1;
        end
    end
    
    S2=find(temp_set==1);
    Num=1;
    Denom=0;
    l_s2=0;
    for j=1:length(S2)
        if (node_latency(S2(j))<inf)
            Num=Num+meeting_rates(node1,S2(j))*node_latency(S2(j));
            Denom=Denom+meeting_rates(node1,S2(j));
            l_s2=l_s2+1;
        end
    end
 
%     if (node2==destination)    
%         if (flag_minlat==0 && message_states(node1)==message_number)
%             updated_message_states(node2)=message_number;
%             updated_message_states(node1)=0;
%         end
%         updated_forward_neighbours(node1,node2)=1;
%         updated_node_latency(node1)=(Num+meeting_rates(node1,node2)*node_latency(node2))/(Denom+meeting_rates(node1,node2));
%     else
    if (node1-destination<0)
        if (node2==destination)
            if (flag_minlat==0 && message_states(node1)==message_number)
                updated_message_states(node2)=message_number;
                updated_message_states(node1)=0;
            end
            updated_forward_neighbours(node1,node2)=1;
            updated_node_latency(node1)=1/meeting_rates(node1,node2);
        elseif (l_s2>0)
            M=Num/Denom;
            if (node_latency(node2)<M)
                if (flag_minlat==0 && message_states(node1)==message_number)
                    updated_message_states(node2)=message_number;
                    updated_message_states(node1)=0;
                end
                updated_forward_neighbours(node1,node2)=1;
                updated_node_latency(node1)=(Num+meeting_rates(node1,node2)*node_latency(node2))/(Denom+meeting_rates(node1,node2));
            else
                updated_forward_neighbours(node1,node2)=0;
            end
        else
            if (flag_minlat==0 && message_states(node1)==message_number)
                updated_message_states(node2)=message_number;
                updated_message_states(node1)=0;
            end
            updated_forward_neighbours(node1,node2)=1;
            updated_node_latency(node1)=1/meeting_rates(node1,node2)+node_latency(node2);
        end
    end
    temp_node=node1;
    node1=node2;
    node2=temp_node;
end