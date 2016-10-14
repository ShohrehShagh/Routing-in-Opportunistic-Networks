function [meeting_rates_half,meeting_rates]= preferential_attachment_rates(N,lambda_average,m0,m)
meeting_rates_half=zeros(N,N);
meeting_rates=zeros(N,N);
links=zeros(N,N);

for i=1:m0
    links(i,i+1:m0)=1;
    links(i+1:m0,i)=1;
    meeting_rates_half(i,i+1:m0)=lambda_average*rand(1,m0-i);
    meeting_rates(i,i+1:m0)=meeting_rates_half(i,i+1:m0);
    meeting_rates(i+1:m0,i)=meeting_rates_half(i,i+1:m0);
end
nodes_added=m0;
for i=m0+1:N
    degrees=zeros(1,nodes_added);
    for j=1:nodes_added
        degrees(j)=sum(links(j,:));
    end
    
    chosen_nodes=randsample(1:nodes_added,m,true,degrees);
    for j=1:length(chosen_nodes)
        links(i,chosen_nodes(j))=1;
        links(chosen_nodes(j),i)=1;
        meeting_rates_half(i,chosen_nodes(j))=lambda_average*rand(1,1);
        meeting_rates(i,chosen_nodes(j))=meeting_rates_half(i,chosen_nodes(j));
        meeting_rates(chosen_nodes(j),i)=meeting_rates_half(i,chosen_nodes(j));
    end
    nodes_added=nodes_added+1;
end
degrees=zeros(1,N);
for j=1:N
    degrees(j)=sum(links(j,:));
end
