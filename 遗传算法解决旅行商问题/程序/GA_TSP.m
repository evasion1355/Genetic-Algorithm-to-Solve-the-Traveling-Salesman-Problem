%遗传算法求解TSP问题(为选择操作从新设计后程序)
%输入：
%D       距离矩阵
%NIND    为种群个数
%X       参数是中国34个城市的坐标(初始给定)
%MAXGEN  为停止代数，遗传到第MAXGEN代时程序停止,MAXGEN的具体取值视问题的规模和耗费的时间而定
%m       为适值淘汰加速指数,最好取为1,2,3,4,不宜太大
%Pc      交叉概率
%Pm      变异概率
%输出：
%R       为最短路径
%Rlength 为路径长度
clear
clc
close all
%% 加载数据 %%遗传参数
load CityPosition2;%个城市坐标位置
NIND=100;       %种群大小
MAXGEN=200;
Pc=0.9;         %交叉概率
Pm=0.05;        %变异概率
GGAP=0.9;      %代沟(Generation gap)
D=Distanse(X);  %生成距离矩阵
N=size(D,1);    %(34*34)
%% 初始化种群
Chrom=InitPop(NIND,N);
%% 在二维图上画出所有坐标点
% figure
% plot(X(:,1),X(:,2),'o');
%% 画出随机解的路线图
DrawPath(Chrom(1,:),X)
pause(0.0001)
%% 输出随机解的路线和总距离
disp('初始种群中的一个随机值:')
OutputPath(Chrom(1,:));
Rlength=PathLength(D,Chrom(1,:));
disp(['总距离：',num2str(Rlength)]);
disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
%% 优化
gen=0;
figure;
hold on;box on
xlim([0,MAXGEN])
title('优化过程')
xlabel('代数')
ylabel('最优值')
ObjV=PathLength(D,Chrom);  %计算路线长度
preObjV=min(ObjV);
while gen<MAXGEN
    %% 计算适应度
    ObjV=PathLength(D,Chrom);  %计算路线长度
    % fprintf('%d   %1.10f\n',gen,min(ObjV))
    line([gen-1,gen],[preObjV,min(ObjV)]);pause(0.0001)
    preObjV=min(ObjV);
    FitnV=Fitness(ObjV);
    %% 选择
    SelCh=Select(Chrom,FitnV,GGAP);
    %% 交叉操作
    SelCh=Recombin(SelCh,Pc);
    %% 变异
    SelCh=Mutate(SelCh,Pm);
    %% 逆转操作
    SelCh=Reverse(SelCh,D);
    %% 重插入子代的新种群
    Chrom=Reins(Chrom,SelCh,ObjV);
    %% 更新迭代次数
    gen=gen+1 ;
end
%% 画出最优解的路线图
ObjV=PathLength(D,Chrom);  %计算路线长度
[minObjV,minInd]=min(ObjV);
DrawPath(Chrom(minInd(1),:),X)
%% 输出最优解的路线和总距离
disp('最优解:')
p=OutputPath(Chrom(minInd(1),:));
disp(['总距离：',num2str(ObjV(minInd(1)))]);
disp('-------------------------------------------------------------')