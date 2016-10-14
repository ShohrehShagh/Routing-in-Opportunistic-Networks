function [prev,dist]=myDijkstra(N,weights,source,destination)
% weights=zeros(7,7);
% weights(1,:)=[0,4,3,0,7,0,0];
% weights(2,:)=[4,0,6,5,0,0,0];
% weights(3,:)=[3,6,0,11,8,0,0];
% weights(4,:)=[0,5,11,0,2,2,10];
% 
% weights(5,:)=[7,0,8,2,0,0,5];
% weights(6,:)=[0,0,0,2,0,0,3];
% weights(7,:)=[0,0,0,10,5,3,0];

% % weights=zeros(6,6);
% % weights(1,:)=[0,7,9,0,0,14];
% % weights(2,:)=[7,0,10,15,0,0];
% % weights(3,:)=[9,10,0,11,0,2];
% % weights(4,:)=[0,15,11,0,6,0];
% % 
% % weights(5,:)=[0,0,0,6,0,9];
% % weights(6,:)=[14,0,2,0,9,0];

Visited=zeros(1,N);
Visited(source)=1;

dist=inf*ones(1,N);
dist(source)=0;

prev=zeros(1,N);
prev(source)=source;

last_visited=source;
j=0;
while(Visited(destination)==0)
    j=j+1;
    neighbours=find(weights(last_visited,:)>0);
    for i=1:length(neighbours)
        if (Visited(neighbours(i))==0 && dist(neighbours(i))> dist(last_visited)+weights(last_visited,neighbours(i)))
           dist(neighbours(i))= dist(last_visited)+weights(last_visited,neighbours(i));
           prev(neighbours(i))=last_visited;
        end
    end
    unvisited_nodes=find(Visited==0);
    [min_value,index]=min(dist(unvisited_nodes));
    min_index=unvisited_nodes(index);
    Visited(min_index)=1;
    last_visited=min_index;
end


