function [meeting_rates,filename]= info(dataset_name,Number_of_nodes)

fID = fopen(dataset_name,'r');
events=textscan(fID,'%f %s %d %d %s');

last_meeting=zeros(Number_of_nodes,Number_of_nodes);
number_of_meetings=zeros(Number_of_nodes,Number_of_nodes);
sum_of_intermeetings=zeros(Number_of_nodes,Number_of_nodes);
simulation_time=length(events{1});

intermeeting_parameter=zeros(Number_of_nodes,Number_of_nodes);
meeting_rates=zeros(Number_of_nodes,Number_of_nodes);

for i=1:simulation_time
    if (strcmp(events{5}(i),'up')==1)
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
    for j=1:10
        meeting_rates(i,index_sort(j))=sorted_meeting_rates(j);
        meeting_rates(index_sort(j),i)=sorted_meeting_rates(j);
    end
end
% for i=1:Number_of_nodes
%     for j=1:Number_of_nodes
%         if (intermeeting_parameter(i,j)<mean(MR)/2)
%             meeting_rates(i,j)=0;
%         end
%     end
% end
filename = sprintf('info05_final.txt');
fID = fopen(filename,'w');
for i=1:length(events{1})
    node1=events{3}(i);
    node2=events{4}(i);
    if (meeting_rates(node1,node2)>0)
        fprintf(fID,'%d CONN %d %d up \n',events{1}(i),node1,node2);
    end
end
