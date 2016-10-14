function [final_meeting_rates,filename,existing_nodes_vector]= info_partitioned(dataset_name,Number_of_nodes,p,t_end,t_start)

fID = fopen(dataset_name,'r');
events=textscan(fID,'%f %s %d %d %s');

last_meeting=zeros(Number_of_nodes,Number_of_nodes);
number_of_meetings=zeros(Number_of_nodes,Number_of_nodes);
sum_of_intermeetings=zeros(Number_of_nodes,Number_of_nodes);
simulation_time=length(events{1});

intermeeting_parameter=zeros(Number_of_nodes,Number_of_nodes);
meeting_rates=zeros(Number_of_nodes,Number_of_nodes);

existing_nodes=zeros(1,Number_of_nodes);
K=10;

for i=1:simulation_time
    if (events{1}(i)>t_start && events{1}(i)<t_end)
        node1=events{3}(i);
        node2=events{4}(i);
        sum_of_intermeetings(node1,node2)=sum_of_intermeetings(node1,node2)+events{1}(i)-last_meeting(node1,node2);
        sum_of_intermeetings(node2,node1)=sum_of_intermeetings(node1,node2);
        last_meeting(node1,node2)=events{1}(i);
        last_meeting(node2,node1)=last_meeting(node1,node2);
        number_of_meetings(node1,node2)=number_of_meetings(node1,node2)+1;
        number_of_meetings(node2,node1)=number_of_meetings(node1,node2);
    end
end
for i=1:Number_of_nodes
    for j=1:i
        if (sum_of_intermeetings(i,j)==0)
            intermeeting_parameter(i,j)=0;
        else
            intermeeting_parameter(i,j)=number_of_meetings(i,j)/sum_of_intermeetings(i,j);
            intermeeting_parameter(j,i)=intermeeting_parameter(i,j);
        end
    end
end

for i=1:Number_of_nodes
    [sorted_meeting_rates,index_sort]=sort(intermeeting_parameter(i,:),'descend');
    if (sorted_meeting_rates(K)>0)
        existing_nodes(i)=1;
        for j=1:K
            meeting_rates(i,index_sort(j))=sorted_meeting_rates(j);
            meeting_rates(index_sort(j),i)=sorted_meeting_rates(j);
        end
    end
end

existing_nodes_vector=find(existing_nodes>0);
Num_exist_nodes=length(existing_nodes_vector);

final_meeting_rates=zeros(Num_exist_nodes,Num_exist_nodes);
for i=1:Num_exist_nodes
    for j=1:Num_exist_nodes
        final_meeting_rates(i,j)=meeting_rates(existing_nodes_vector(i),existing_nodes_vector(j));
    end
end

filename = sprintf('Traces_partitioned/info05_final%d.txt',p);
fID = fopen(filename,'w');
for i=1:simulation_time
    if (events{1}(i)>t_start)
        node1=events{3}(i);
        node2=events{4}(i);
        node1prime=find(existing_nodes_vector==events{3}(i));
        node2prime=find(existing_nodes_vector==events{4}(i));
        if (existing_nodes(node1)>0 && existing_nodes(node2)>0 && final_meeting_rates(node1prime,node2prime)>0 && length(node1prime)>0 && length(node2prime)>0)
            fprintf(fID,'%d CONN %d %d up \n',events{1}(i),node1prime,node2prime);
        end
    end
end


