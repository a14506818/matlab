%   function createfigure(PSNRs1,imagename, stego_image, T_number)
function createfigure(PSNRArray, array_name, imagename, stego_image, T_number, max_point,CompairWithMySelf)
  

%  Auto-generated by MATLAB on 05-Jun-2014 16:25:46

% Create figure
figure1 = figure;
set(figure1, 'Position', [1 1 1900 1000]);

% Create axes
axes1 = axes('Parent',figure1,'YGrid','on',...
    'XTickLabel',{'0','0.6','1.2','1.8','2.4','3.0', '3.6', '4.2', '4.8','5.4', '6.0'},...
    'XTick',[0 0.6 1.2 1.8 2.4 3.0 3.6 4.2 4.8 5.4 6.0],...
    'XGrid','on',...
    'FontSize',14);

%% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[0 5.6]);
xlim(axes1,[0 max_point]);
box(axes1,'on');
hold(axes1,'all');

marktype = char('+',  '<', 'p'  ,  'o', 'h','v', '*', '.', 'x', 's', 'd', '^',  '>' );	
linetype = char('-mo',  '--mo',  ':bs',  '-.', '--');	
 
% Create plot
r = 0.1; 
g = 0.1; 
b = 0.1; 

for i=1:size(PSNRArray,2)
    f_n = deblank(array_name(i,:));
    PSNRs1 = PSNRArray{i};
    array_value1 = PSNRs1(:,1) ;
    array_value2 = PSNRs1(:,2) ;
    r = mod(r + 0.18, 1);
    g = mod(g + 0.258, 1);
    b = mod(b + 0.147, 1);
    ind = mod ( i, size(marktype,1) ) +1  ; 
    mark_value = deblank(marktype(ind,:));
    ind_line = mod ( i, size(linetype,1) ) +1 ; 
      line_type_value = deblank(linetype(ind_line,:)) ;
    plot(array_value1,array_value2,line_type_value, 'Parent',axes1,'MarkerSize',8,'Marker',mark_value,'LineWidth',1,...
        'Color',[r g b],...
        'DisplayName',f_n);
end 



% Create xlabel
xlabel('Payload(bpp)','FontWeight','bold','FontSize',24,...
    'FontName','Times New Roman');

% Create ylabel
ylabel('PSNR(dB)','FontWeight','bold','FontSize',24,...
    'FontName','Times New Roman');
% Create legend
legend1 = legend(axes1,'show');
%  legend ('boxoff'); 
% set(legend1,'FontSize',12,'FontName','Times New Roman');
set(legend1,'FontSize',8,'FontName','Times New Roman', 'Location','northeast' );
legend ('boxoff');

% Create title
tt = [stego_image ' => ' imagename]
title(tt,'FontWeight','bold','FontSize',24,...
    'FontName','Times New Roman'); 
%  'Orientation','horizontal'  , 'Location','south' 
     file_title_word = '';
     if(CompairWithMySelf == 1)
         file_title_word = 'WithMyself_';
     end 

 saveas(figure1,['experimental results\' file_title_word imagename '_' stego_image '_T_' num2str(T_number) '.fig'],'fig');
saveas(figure1,['experimental results\' file_title_word imagename '_' stego_image '_T_' num2str(T_number) '.jpg'],'jpg');


