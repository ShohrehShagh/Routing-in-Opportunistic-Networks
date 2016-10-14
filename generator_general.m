function []= generator_general(Sim_time,filename,meeting_rates,number_of_nodes,t_0)

active_links=find(meeting_rates'>0);
number_of_links=length(active_links);

up_length=0;
interarrival_time=30;

time_index=1;
Up_or_down(1)=1;
for j=1:number_of_links
    clear t
    t(1)=t_0;
    k=1;
    kk=1;
    while(k==1)
        meeting_rates_prime=meeting_rates';
        x=up_length-log(rand(1,1))./meeting_rates_prime(active_links(j));
        if x+t(kk)<Sim_time
            t(kk+1)=x+t(kk);
            kk=kk+1;
        else
            k=0;
        end
    end
    links(time_index:time_index+length(t)-2)= j;
    virtual_time(time_index:time_index+length(t)-2)=t(2:length(t));
    Up_or_down(time_index:time_index+length(t)-2)=1;
    time_index=time_index+length(t)-1;
    
    virtual_time(time_index:time_index+length(t)-2)=t(2:length(t))+up_length;
    links(time_index:time_index+length(t)-2)= j;
    Up_or_down(time_index:time_index+length(t)-2)=2;
    time_index=time_index+length(t)-1;
end
message_creation_time=0:interarrival_time:max(virtual_time);
virtual_time(length(virtual_time)+1:length(virtual_time)+length(message_creation_time))=message_creation_time;
Up_or_down(length(Up_or_down)+1:length(Up_or_down)+length(message_creation_time))=3;
links(length(links)+1:length(links)+length(message_creation_time))=number_of_links+1;
[sorted_time,index]=sort(virtual_time);
sorted_link=links(index);
connection=Up_or_down(index);

fileID=fopen(filename,'w');
connection_status=['up  ';'down'];
k=0;
for i=1:length(sorted_time)  
    if (sorted_link(i)<number_of_links+1)
        node1=ceil(active_links(sorted_link(i))/number_of_nodes);
        node2=mod(active_links(sorted_link(i)),number_of_nodes);
        if (node2==0)
            node2=number_of_nodes;
        end
        if (strcmp(connection_status(connection(i),:),'up  ')==1)
            fprintf(fileID,'%3.4f CONN %d %d %s \n',sorted_time(i),node1,node2,connection_status(connection(i),:));
        end
    end
end
fclose(fileID);

