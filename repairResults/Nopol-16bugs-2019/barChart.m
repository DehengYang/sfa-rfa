clear;clc; 
close all;
% x=[1 2 3 4 5 6 7 8];%  
% training20_testing50  
% y1=[69 33 90 95 96 94 100 73];  
% y2=[94 67 88 93 98 85 100 77];  
  
% training10_testing50  
%  y1=[60 51 83 69 96 61 100 61];  
%  y2=[92 46 63 95 98 54 98 60];  
% y_all=[y1;y2]';  
% bar(x,y_all) 
% title(' 10-Training and 50-Testing')  
% xlabel('Class')  
% ylabel('Accuracy')  
% legend('SVM','NN',2)  
% set(gca,'xticklabel',{'Hyt','Maple','Su','Zm','Bob','Hly','Hhf','Yq'});  




% bar(y) %以y中的值为长度画一个长柱 %出来了个正方形。。
% bar(x,y) %该函数在指定的横坐标x上画出y
% bar(x,y,width)         %设置宽度 width 设置柱的宽度 默认值为0.8 大于1会相互重叠
% bar(...,'style')?? %默认为group 可以设定为'stack' 就是把y的每行摞起来
% bar(...,'bar_color')   %定义柱的颜色
%函数barh()可以绘制水平柱状图，用法与bar()相同
%例：
fig=figure(1);
set(fig,'color',[1 1 1]);
x=[60 13   9 4   9 6  7 7 ;0 47   0 5   0 3   0 0]';  %;3 4 5 6 7 8 9
% set(fig, 'Position', [100, 100, 600, 400]);
% subplot(121);
% barh(1:7,x);
% bar(1:7,x);
% subplot(122);




% range=[1 1.5 2.2 2.7 3.4 3.9 4.6 5.1] -0.5;  %-0.7
range=[0.5 1.0 1.7 2.2 2.9 3.4 4.1 4.6]
% range=[0.2 0.6   1.4 1.8 2.6 3.0 3.8 4.2]
disp(range)
% sfaRange=[1  3 5 7]  %linspace(1,8,4);
b=bar(range ,x,'stack','EdgeColor','none','BarWidth',0.9)  %,'BarWidth',0.5)
color=  [	205 51 51]/255;  
color2= [	        			220 220 220      ]/255; %[139 115 85]/255;
set(b(1),'FaceColor',color);  
set(b(2),'FaceColor',color2);  
set(gca,'xtick',range);
set(gca,'xticklabel',{'RFA-Nopol','SFA-Nopol','RFA-jKali','SFA-jKali','RFA-jMutRepair','SFA-jMutRepair','RFA-SimFix','SFA-SimFix'});  

set(gca,'FontSize',8,'XTickLabelRotation',35);   %,'FontName','Times New Roman')%使标注旋转角度

axis([0 5 0 70])

for i = 1:2:8 %直方图上面数据对不齐，利用水平和垂直对齐 ，可以参考search ?Document 中的text函数  %strcat('0/',num2str(x(i,1))),
    text(range(i),x(i,1)+1.6,strcat('\color[rgb]{0.8039    0.2000    0.2000}',num2str(x(i,1))) ,'VerticalAlignment','middle','HorizontalAlignment','center');
% '\color[rgb]{0.5451    0.4510    0.3333}' ,'0','\color[rgb]{0 0 0}/' ,

end

for i = 2:2:8 %直方图上面数据对不齐，利用水平和垂直对齐 ，可以参考search ?Document 中的text函数
%     percent=char(vpa(x(i,1)/x(i-1,1)*100,4));
%     disp(percent); %num2str
%     text(range(i)+0.05,x(i-1,1)+1.5,strcat(  (percent),'%'),'VerticalAlignment','middle','HorizontalAlignment','center');
%     percent=char(vpa(x(i,1)/x(i-1,1)*100,4));
%     disp(percent); %num2str  %['\color[rgb]{0 0.5 0.5}hello \color[rgb]{0
%     0 0.5} Wold']   strcat( num2str(x(i,2)),'/',num2str(x(i-1,1)))
    
    if i==8
        text(range(i),x(i-1,1)+1.6, strcat('\color[rgb]{0.8039    0.2000    0.2000}',num2str(x(i,1)))  ,'VerticalAlignment','middle','HorizontalAlignment','center');
    else
        text(range(i),x(i-1,1)+1.6, strcat('\color[rgb]{0.7098    0.7098    0.7098}' , num2str(x(i,2)),'\color[rgb]{0 0 0}/' ,'\color[rgb]{0.8039    0.2000    0.2000}', ...
            num2str(x(i,1)))  ,'VerticalAlignment','middle','HorizontalAlignment','center');
    end

end


% xlabel('')  
ylabel('Number of buggy programs')  
le=legend('One patch for a buggy program','More than one patch for a buggy program',2)  ;
set(le,'Box','off')
% grid on;
set(gca,'Ygrid','on') 
set(gca,'GridLineStyle',':','GridColor','k','GridAlpha',1);


% h=get(gca)
% 
% set(h,'xcolor','none')
% h.XAxis.Label.Color=[0 0 0];
% h.XAxis.Label.Visible='on';
disp(get(gca,'XTick'))
disp(gca)
% grid on
% hold on;
% rfaRange=[1.5 3.5 5.5 7.5]
% bar(rfaRange ,x,'stack')
