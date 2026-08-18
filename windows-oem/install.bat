@echo off
echo ==========================================
echo Iniciando o provisionamento pos-instalacao
echo ==========================================

echo [1] Criando a flag no Desktop Publico...
echo FLAG{p1v0t1ng_und3r_th3_h00d_w1nd0w5} > C:\Users\Public\Desktop\flag.txt

echo [2] Desativando o Firewall do Windows para facilitar o lab inicial...
netsh advfirewall set allprofiles state off

echo [3] Criando um compartilhamento SMB vulneravel (Leitura para Todos)...
net share flag_share=C:\Users\Public\Desktop /grant:everyone,READ

echo [4] Habilitando RDP explicitamente...
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f

echo Provisionamento concluido com sucesso!
