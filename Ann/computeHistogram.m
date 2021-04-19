function computeHistorgram (Gray, Stego, titleWord, number)
[rows, cols] = size (Gray); 
 
cover_his = zeros(256);
stego_his = zeros(256);
for i=1:rows
    for j = 1:cols
        cover_his( Gray(i,j)+1, 1) =  cover_his(Gray(i,j)+1, 1) + 1;
        stego_his(Stego(i,j)+1, 1) =  stego_his(Stego(i,j)+1, 1) + 1;
         
    end 
end 
figurehist = figure;
set(figurehist, 'Position', [100 100 900 600]);
x = 1:1:256;

[ax,h1,h2] = plotyy(x, cover_his(:,1 ),x, stego_his(:,1 ));
set(get(ax(1),'Ylabel'),'String','Cover Count')
tname = [ 'Stego Count' ];
set(get(ax(2),'Ylabel'),'String',tname)
set(h1,'Linewidth',2);
set(h2,'LineStyle','*','color','r');
xlabel('Pixel');
 title(titleWord,'FontWeight','bold','FontSize',18,...
    'FontName','Times New Roman'); 
 
filewordTitle  = [ 'experimental results\computeHistorgram_' titleWord '.jpg'];
saveas(figurehist,filewordTitle, 'jpg');
 