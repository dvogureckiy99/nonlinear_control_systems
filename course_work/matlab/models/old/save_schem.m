name = 'star';
folder='E:\education\6_sem\nonlinear_control_systems\kursach\7494\Lomskiy\matlab\models\old\img\';
handle = load_system(name); %�������� �����
% ���������� ������� �����
     print(['-s',name], '-dpdf','-tiff', [folder,name]) 

   dos(['pdfcrop ' folder name '.pdf ' folder  'sim_final_VSS_PWM.pdf']);% & �������� � ������� ������
   dos('EXIT');
   
   save_system(handle);
   close_system(handle);