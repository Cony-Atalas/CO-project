#edited by lcj
#14����instructions�� lw, sw, add, sub, and,  or,  slt, beq, j
#15����instructions�� lw, sw, add��sub��subu��ori, slt��beq, j, sltu��addiu
#���ǵ�ָ����ܲ�ͬ��ֻ�ã�lw, sw, add, sub, slt, beq, j�߸�ָ��


#������ˮ��û��beq��jָ��
#��ʼ $t0 = 7, $t1 = 15, ����Ϊ0
begin:
#add $t0, $zero, 7
#add $t1, $zero, 15
add  $t2, $t0, $t1  #t1 = 22
add  $t3, $t0, $t0  #t3 = 14
sub  $t4, $t1, $t0  #t4 = 8
slt  $t5, $t0, $t1  #t5 = 1
slt  $t6, $t0, $t0  #t6 = 0
sw   $t1, 100($zero)#t1 => 
lw   $t7, 100($zero)#t7 <= 

#����ð��1: Ex hazard�� MEM hazard�������
#EX/MEM.RegisterRd = ID/EX.RegisterRt��MEM/WB.RegisterRd = ID/EX.RegisterRs
#��EX/MEM.RegisterRd = ID/EX.RegisterRt��MEM/WB.RegisterRd = ID/EX.RegisterRt
#��ʼ $t0 = 7, $t1 = 15, ����Ϊ0
add  $t2, $zero, $zero
add  $t3, $zero, $zero
add  $t4, $zero, $zero
add  $t5, $zero, $zero
add  $t6, $zero, $zero
add  $t7, $zero, $zero

sub  $t2, $t1, $t0 #t2 = 8
add  $t3, $t2, $t1 #t3 = 22, EX/MEM.RegisterRd = ID/EX.RegisterRs
add  $t4, $t2, $t0 #t4 = 15, MEM/WB.RegisterRd = ID/EX.RegisterRs
add  $t5, $t1, $t4 #t5 = 30,  EX/MEM.RegisterRd = ID/EX.RegisterRt
add  $t6, $t1, $t4 #t6 = 30,  MEM/WB.RegisterRd = ID/EX.RegisterRt

#����ð��2  Ex hazard�� MEM hazardͬʱ����,Ӧѡ����һ��ָ�Ex hazard���Ľ��
#��ʼ $t0 = 7, $t1 = 15, ����Ϊ0
add  $t2, $zero, $zero
add  $t3, $zero, $zero
add  $t4, $zero, $zero
add  $t5, $zero, $zero
add  $t6, $zero, $zero

sub  $t2, $t1, $t0 #t2 = 8
add  $t2, $t2, $t1 #t2 = 23, EX/MEM.RegisterRd = ID/EX.RegisterRs
add  $t4, $t0, $t2 #t4 = 30, EX/MEM.RegisterRd = ID/EX.RegisterRt & MEM/WB.RegisterRd = ID/EX.RegisterRt
sub  $t4, $t1, $t0 #t4 = 8
add  $t5, $t4, $t2 #t5 = 31,  EX/MEM.RegisterRd = ID/EX.RegisterRs & MEM/WB.RegisterRd = ID/EX.RegisterRs

#load-useð��  & �ṹð�գ����һ���ǽṹð�գ�
#��ʼ $t0 = 7, $t1 = 15, ����Ϊ0
add  $t2, $zero, $zero
add  $t3, $zero, $zero
add  $t4, $zero, $zero
add  $t5, $zero, $zero

sw   $t1, 100($zero) #t1 =>
lw   $t2, 100($zero) #t2 <= 15
add  $t3, $t2, $t0   #t3 = 22, load-useð��1����Ҫ����һ��ָ������һ�����ݣ�Ȼ������MEM/WB.RegisterRd = ID/EX.RegisterRs��ת��
sub  $t4, $t2, $t0   #t4 = 8,  load-useð��2���ṹð�գ�����lw���һ�����ݺ�һ��ָ� lwǰ�������д��Ĵ����ѣ��������ڣ�$t2����

#branch
#��ʼ $t0 = 7, $t1 = 15, ����Ϊ0
add  $t2, $zero, $zero
add  $t3, $zero, $zero
add  $t4, $zero, $zero

##���ڵ�branch
beq  $t1, $t1, test0   #��ת��   �������branch����
j    begin
test0:
add  $t2, $t1, $t0     #$t2 = 22
beq  $t2, $t1, test1   #����ת��  branch�ڵڶ������ڣ�ID���жϣ���Ҫ��һ��ָ��ִ������������ڣ�EX����������Ҫ��������
sub  $t3, $t1, $t0     #$t3 = 8
sub  $t4, $t1, $t0     #$t4 = 8
beq  $t3, $t4, test2   #��ת��    �ж���������ָ������
test1:
j    begin
##lw-branch�����
test2:
sw  $t1, 100($zero)
lw  $t5, 100($zero)    #$t5 = 15
beq $t5, $t0, test3    #����ת,lw,branch����ָ��(Ҫ�������������ݣ�lw���һ����branchǰ��һ��)
lw  $t7, 100($zero)
add $t6, $t1, $zero    #$t6 = 15
test3:
beq $t6, $t7, test4    #��ת��lw,branch��һ��ָ��	
j begin
test4:
lw  $t5, 100($zero)    #$t5 = 15
beq $t5, $t5, test5    #��ת,lw,branch����ָ��(Ҫ�������������ݣ�lw���һ����branchǰ��һ��)
j   begin
test5:

#use-loadð�գ�ת����Ԫ��Iָ����ܴ��ڵ����⡣��ֻ���forwardB,����alu��busB��
#ֻҪ��Rָ�alu��busB��imm16�ͺ�
#��ʼ $t0 = 7, $t1 = 15, ����Ϊ0
#���������ð�ն��ѽ���� ������ָ���ļ��
add  $t2, $zero, $zero
add  $t3, $zero, $zero
add  $t4, $zero, $zero
add  $t5, $zero, $zero
add  $t6, $zero, $zero
add  $t7, $zero, $zero

add  $t2, $t1, $t0    #t2 = 22
sw   $t1, 100($zero)
lw   $t2, 100($zero)  #t2 = 15�� ʵ��Ӧ����15(�����µõ�0)��������ǰ��ID/EX��MEM/WB.RegisterRd = ID/EX.RegisterRt,����forwardB = 01��ת����ʱ����busB��alu�У�����imm16����22
add  $s7, $zero, $zero
add  $s7, $zero, $zero
add  $s7, $zero, $zero
sub  $t3, $t1, $t0    #t3 = 8
lw   $t3, 100($zero)  #t3 = 15,  ʵ��Ӧ����15(�����µõ�0)��������ǰ��ID/EX��EX/MEM.RegisterRd = ID/EX.RegisterRt,����forwardB = 10��ת����ʱ����alu��busB����imm16����8
sw   $t3, 40($zero)   #t3 =>     ���洢�ĵ�ַ����ǰ��һ����ȷ������£��洢�������ڴ��ַ���ܲ���40��$zero��, ���Ȳ���һ�����ݣ����� MEM/WB.RegisterRd = ID/EX.RegisterRt, ����forwardB = 01��ת����ʱ����busB��alu�У�����imm16����$t3

j    begin


#���branch�ǵ�һ��ָ�ˢ�µ�ʱ��������ѭ����
