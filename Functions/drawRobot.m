%This function draws the robot and its components in a 3D plot.
function drawRobot(a,b,s,p,sliderLength,statorLength,currentDec,shift,distAttacheRing,multFact)

    % multFact : Un facteur de multiplication pour modifier les unités du
    % graphique.
    
    Ai = [];
    for i = 1:6
        for j = 1:2
            if ~isempty(a{i,j})
                Ai(1:3,end+1) = a{i,j};
            end
        end
    end
    
    Bi = zeros(3,8);
    Bi(:,5:8) = [b{3},b{4},b{5},b{6}];
    Bi(:,1:4) = [s{1},s{1},s{2},s{2}];
    
    Stator1 = zeros(3:8);
    Stator2 = zeros(3:8);
    topSlider = zeros(3:8);
    sliderBotEnd = zeros(3:8);
    sliderTopEnd = zeros(3:8);
    
    for i = 1:8
        unitABi = (Bi(:,i)-Ai(:,i)) / norm(Bi(:,i)-Ai(:,i));
        Stator1(:,i) = Ai(:,i) + unitABi*currentDec;
        Stator2(:,i) = Ai(:,i) + unitABi*(statorLength+currentDec);
        topSlider(:,i) = Ai(:,i) - unitABi*(sliderLength-norm(Bi(:,i)-Ai(:,i))+shift(i));
        sliderBotEnd(:,i) = Bi(:,i) - unitABi*shift(i);
        sliderTopEnd(:,i) = topSlider(:,i) + unitABi*distAttacheRing;
    end

    %Vecteurs de tracés de lignes
    VecPointBase = [a{3}';a{4}';a{2,1}',;a{2,2}',;a{5}';a{6}';a{1,1}';a{1,2}';a{3}';a{5}';a{2,2}';a{1,2}';a{1,1}';a{2,1}';a{4}';a{6}']*multFact;
    VecPointPlateForme = [b{1}';b{3}';b{4}';b{2}';b{5}';b{6}';b{1}';b{2}';b{5}';b{3}';b{4}';b{6}']*multFact;
    VecPointRedondant1 = [topSlider(:,1)';s{1}';topSlider(:,2)']*multFact;
    VecPointRedondant2 = [topSlider(:,3)';s{2}';topSlider(:,4)']*multFact;
    VecPointL1 = [s{2}';b{2}']*multFact;
    VecPointL2 = [s{1}';b{1}']*multFact;
    VecPointNRedondant1 = [topSlider(:,5)';b{3}']*multFact;
    VecPointNRedondant2 = [topSlider(:,6)';b{4}']*multFact;
    VecPointNRedondant3 = [topSlider(:,7)';b{5}']*multFact;
    VecPointNRedondant4 = [topSlider(:,8)';b{6}']*multFact;
    VecStator1 = [Stator1(:,1)';Stator2(:,1)']*multFact;
    VecStator2 = [Stator1(:,2)';Stator2(:,2)']*multFact;
    VecStator3 = [Stator1(:,3)';Stator2(:,3)']*multFact;
    VecStator4 = [Stator1(:,4)';Stator2(:,4)']*multFact;
    VecStator5 = [Stator1(:,5)';Stator2(:,5)']*multFact;
    VecStator6 = [Stator1(:,6)';Stator2(:,6)']*multFact;
    VecStator7 = [Stator1(:,7)';Stator2(:,7)']*multFact;
    VecStator8 = [Stator1(:,8)';Stator2(:,8)']*multFact;
    VecBotEnd1 = [Bi(:,1)';sliderBotEnd(:,1)']*multFact;
    VecBotEnd2 = [Bi(:,2)';sliderBotEnd(:,2)']*multFact;
    VecBotEnd3 = [Bi(:,3)';sliderBotEnd(:,3)']*multFact;
    VecBotEnd4 = [Bi(:,4)';sliderBotEnd(:,4)']*multFact;
    VecBotEnd5 = [Bi(:,5)';sliderBotEnd(:,5)']*multFact;
    VecBotEnd6 = [Bi(:,6)';sliderBotEnd(:,6)']*multFact;
    VecBotEnd7 = [Bi(:,7)';sliderBotEnd(:,7)']*multFact;
    VecBotEnd8 = [Bi(:,8)';sliderBotEnd(:,8)']*multFact;
    VecTopEnd1 = [topSlider(:,1)';sliderTopEnd(:,1)']*multFact;
    VecTopEnd2 = [topSlider(:,2)';sliderTopEnd(:,2)']*multFact;
    VecTopEnd3 = [topSlider(:,3)';sliderTopEnd(:,3)']*multFact;
    VecTopEnd4 = [topSlider(:,4)';sliderTopEnd(:,4)']*multFact;
    VecTopEnd5 = [topSlider(:,5)';sliderTopEnd(:,5)']*multFact;
    VecTopEnd6 = [topSlider(:,6)';sliderTopEnd(:,6)']*multFact;
    VecTopEnd7 = [topSlider(:,7)';sliderTopEnd(:,7)']*multFact;
    VecTopEnd8 = [topSlider(:,8)';sliderTopEnd(:,8)']*multFact;

    %Les points sont dessinés en ligne
    plot3(VecPointBase(:,1),VecPointBase(:,2),VecPointBase(:,3),'g','LineWidth',5), hold on
    plot3(VecPointPlateForme(:,1),VecPointPlateForme(:,2),VecPointPlateForme(:,3),'b','LineWidth',5)
    plot3(VecPointRedondant1(:,1),VecPointRedondant1(:,2),VecPointRedondant1(:,3),'y','LineWidth',3)
    plot3(VecPointRedondant2(:,1),VecPointRedondant2(:,2),VecPointRedondant2(:,3),'y','LineWidth',3)
    plot3(VecPointL1(:,1),VecPointL1(:,2),VecPointL1(:,3),'c','LineWidth',3)
    plot3(VecPointL2(:,1),VecPointL2(:,2),VecPointL2(:,3),'c','LineWidth',3)
    plot3(VecPointNRedondant1(:,1),VecPointNRedondant1(:,2),VecPointNRedondant1(:,3),'m','LineWidth',3)
    plot3(VecPointNRedondant2(:,1),VecPointNRedondant2(:,2),VecPointNRedondant2(:,3),'m','LineWidth',3)
    plot3(VecPointNRedondant3(:,1),VecPointNRedondant3(:,2),VecPointNRedondant3(:,3),'m','LineWidth',3)
    plot3(VecPointNRedondant4(:,1),VecPointNRedondant4(:,2),VecPointNRedondant4(:,3),'m','LineWidth',3)
    plot3(VecStator1(:,1),VecStator1(:,2),VecStator1(:,3),'k','LineWidth',6)
    plot3(VecStator2(:,1),VecStator2(:,2),VecStator2(:,3),'k','LineWidth',6)
    plot3(VecStator3(:,1),VecStator3(:,2),VecStator3(:,3),'k','LineWidth',6)
    plot3(VecStator4(:,1),VecStator4(:,2),VecStator4(:,3),'k','LineWidth',6)
    plot3(VecStator5(:,1),VecStator5(:,2),VecStator5(:,3),'k','LineWidth',6)
    plot3(VecStator6(:,1),VecStator6(:,2),VecStator6(:,3),'k','LineWidth',6)
    plot3(VecStator7(:,1),VecStator7(:,2),VecStator7(:,3),'k','LineWidth',6)
    plot3(VecStator8(:,1),VecStator8(:,2),VecStator8(:,3),'k','LineWidth',6)
    plot3(VecBotEnd1(:,1),VecBotEnd1(:,2),VecBotEnd1(:,3),'r','LineWidth',6)
    plot3(VecBotEnd2(:,1),VecBotEnd2(:,2),VecBotEnd2(:,3),'r','LineWidth',6)
    plot3(VecBotEnd3(:,1),VecBotEnd3(:,2),VecBotEnd3(:,3),'r','LineWidth',6)
    plot3(VecBotEnd4(:,1),VecBotEnd4(:,2),VecBotEnd4(:,3),'r','LineWidth',6)
    plot3(VecBotEnd5(:,1),VecBotEnd5(:,2),VecBotEnd5(:,3),'r','LineWidth',6)
    plot3(VecBotEnd6(:,1),VecBotEnd6(:,2),VecBotEnd6(:,3),'r','LineWidth',6)
    plot3(VecBotEnd7(:,1),VecBotEnd7(:,2),VecBotEnd7(:,3),'r','LineWidth',6)
    plot3(VecBotEnd8(:,1),VecBotEnd8(:,2),VecBotEnd8(:,3),'r','LineWidth',6)
    plot3(VecTopEnd1(:,1),VecTopEnd1(:,2),VecTopEnd1(:,3),'r','LineWidth',6)
    plot3(VecTopEnd2(:,1),VecTopEnd2(:,2),VecTopEnd2(:,3),'r','LineWidth',6)
    plot3(VecTopEnd3(:,1),VecTopEnd3(:,2),VecTopEnd3(:,3),'r','LineWidth',6)
    plot3(VecTopEnd4(:,1),VecTopEnd4(:,2),VecTopEnd4(:,3),'r','LineWidth',6)
    plot3(VecTopEnd5(:,1),VecTopEnd5(:,2),VecTopEnd5(:,3),'r','LineWidth',6)
    plot3(VecTopEnd6(:,1),VecTopEnd6(:,2),VecTopEnd6(:,3),'r','LineWidth',6)
    plot3(VecTopEnd7(:,1),VecTopEnd7(:,2),VecTopEnd7(:,3),'r','LineWidth',6)
    plot3(VecTopEnd8(:,1),VecTopEnd8(:,2),VecTopEnd8(:,3),'r','LineWidth',6)
    scatter3(p(1)*multFact,p(2)*multFact,p(3)*multFact,500,'MarkerFaceColor',[0 .75 .75])
    axis equal
    xlabel('x(m)');ylabel('y(m)');zlabel('z(m)');
    grid on

end