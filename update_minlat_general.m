function [average_latency,forward_neighbours]= update_minlat_general(number_of_nodes,Number_of_messages,interarrival_time,destination,filename,meeting_rates)
Fstring=fileread(filename);
fID = fopen(filename,'r');

latency_minlat=inf*ones(1,Number_of_messages);
message_states_minlat=zeros(1,number_of_nodes);
neighbours=zeros(number_of_nodes,number_of_nodes);
forward_neighbours=zeros(number_of_nodes,number_of_nodes);
node_latency=inf*ones(1,number_of_nodes);
node_latency(destination)=0;

for message_number=1:Number_of_messages
    message_creation_time=interarrival_time*(message_number-1);
    message_states_minlat(1,1)=message_number;
    current_message_number=message_number;
    flag_minlat=0;
    while (flag_minlat==0)
        string=sprintf(' C M%d 1 %d 100 0',current_message_number,destination);
        strfind(Fstring, string);
        fseek(fID, strfind(Fstring, string)+length(string), 'bof');
        events=textscan(fID,'%f %s %d %d %s');
        i=1;
        while (i<= length(events{5}))
            if (strcmp(events{5}(i),'up')==1)
                node1=events{3}(i);
                node2=events{4}(i);
%                 nodes=[node1,node2]
                neighbours(node1,node2)=1;
                neighbours(node2,node1)=1;
                [message_states_minlat,node_latency,forward_neighbours]=forward_minlat_general(neighbours,message_number,message_states_minlat,number_of_nodes,node1,node2,node_latency,meeting_rates,destination,flag_minlat,forward_neighbours);
                if (flag_minlat==0)
                    if (message_states_minlat(destination)==message_number)
                        latency_minlat(message_number)=events{1}(i)-message_creation_time;
                        flag_minlat=1;
                    end
                end
            end
            i=i+1;
        end 
        current_message_number=current_message_number+1;
    end
end 
fclose(fID);
average_latency=sum(latency_minlat(1:length(latency_minlat)))/length(1:length(latency_minlat));
forward_neighbours;

