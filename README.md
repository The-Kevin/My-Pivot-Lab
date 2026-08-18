# Pivot Lab - Laboratório Prático de Pivoting de Redes

Este é um laboratório virtual projetado para o aprendizado e prática de técnicas de **Pivoting**, movimentação lateral e tunelamento em redes internas complexas e ambientes híbridos (Linux e Windows).

O cenário simula uma infraestrutura corporativa segmentada em várias redes internas protegidas, onde o atacante começa na rede externa e precisa navegar até a zona mais isolada.

---

## Topologia da Rede

A rede é segmentada em 4 níveis de profundidade, utilizando redes Docker internas:

```
                  [Atacante] (Rede Externa)
                      │
              10.10.10.0/24 (net_ext)
                      │
               ┌──────┴──────┐
               │  target01   │ (Ubuntu Linux)
               └──────┬──────┘
              10.10.20.0/24 (net_dmz)
                      │
               ┌──────┴──────┐
               │  target02   │ (Ubuntu Linux)
               └──────┬──────┘
              10.10.30.0/24 (net_deep)
                      │
               ┌──────┴──────┐
               │  target03   │ (Windows 11)
               └──────┬──────┘
              10.10.40.0/24 (net_inner)
                      │
               ┌──────┴──────┐
               │  target04   │ (Ubuntu Linux - Flag Final)
               └─────────────┘
```

---

## Detalhes dos Targets

### **Target 01 (Ubuntu Linux - DMZ Entry)**
- **Redes:** `net_ext` (10.10.10.5) & `net_dmz` (10.10.20.5)
- **Função:** Ponto de entrada externo. Serve como o primeiro pivô para acessar a DMZ.

### **Target 02 (Ubuntu Linux - Deep Pivoter)**
- **Redes:** `net_dmz` (10.10.20.6) & `net_deep` (10.10.30.6)
- **Função:** Máquina intermediária na DMZ com acesso à rede de infraestrutura profunda (`net_deep`).

### **Target 03 (Windows 11 - Active Host)**
- **Redes:** `net_deep` (10.10.30.7) & `net_inner` (10.10.40.7)
- **Função:** Uma máquina Windows 11 vulnerável que atua como ponte para a rede mais isolada (`net_inner`).
- **Provisionamento:**
  - Desativa o firewall do Windows para fins educacionais.
  - Habilita o protocolo RDP (Remote Desktop).
  - Possui um compartilhamento SMB vulnerável (com permissão de leitura para todos).
- **Flag 1:** `FLAG{p1v0t1ng_und3r_th3_h00d_w1nd0w5}` no arquivo `C:\Users\Public\Desktop\flag.txt` e no compartilhamento SMB.

### **Target 04 (Ubuntu Linux - Final Target)**
- **Redes:** `net_inner` (10.10.40.8)
- **Função:** Máquina final altamente isolada, contendo a flag master do laboratório.
- **Serviço Ativo:** SSH habilitado na porta 22.
- **Credenciais de Acesso (Simuladas):**
  - Usuário comum: `pivotuser` / Senha: `pivotpass`
  - Administrador: `root` / Senha: `rootpass`
- **Flag Final:** `FLAG{p1v0t_m4st3r_l1nux_f1n4l_fl4g}` localizada em `/root/flag.txt` e em `/home/flag.txt`.

---

## Fluxo do Laboratório (Guia de Exploração)

1. **Comprometer o Target 01:**
   Inicie obtendo acesso ao `target01` (10.10.10.5). Em um cenário real, isso envolveria a exploração de um serviço exposto. Neste laboratório, você pode interagir com o contêiner ou usar técnicas de tunelamento.
   
2. **Pivot para o Target 02:**
   A partir de `target01`, realize um escaneamento de rede na subrede `10.10.20.0/24` para descobrir o `target02` (10.10.20.6). Configure um túnel (como SOCKS proxy via SSH ou Chisel) para direcionar ferramentas de ataque (ex: Nmap, Metasploit) do seu host atacante através do `target01` para alcançar o `target02`.

3. **Pivot para o Target 03 (Windows):**
   Uma vez comprometido o `target02`, configure o próximo nível do túnel para alcançar a subrede `10.10.30.0/24`. Descubra o `target03` (10.10.30.7) e explore seus serviços, como o compartilhamento SMB aberto para obter a Flag 1 ou o acesso via RDP.

4. **Pivot Final para o Target 04:**
   Do `target03` (Windows), utilize ferramentas de port forwarding adequadas para Windows (como `chisel`, `plink.exe` ou `netsh interface portproxy`) para alcançar a rede interna isolada `10.10.40.0/24`. Descubra o `target04` (10.10.40.8) e acesse-o via SSH para ler a Flag Final.

---

## Requisitos de Hardware e Sistema

Este laboratório roda um sistema operacional Windows 11 inteiro emulado dentro do Docker (`target03`), além de 3 instâncias Linux. Por conta disso, os requisitos são mais elevados:

### **Requisitos Gerais**
- **Processador:** CPU Intel ou AMD com suporte a Virtualização de Hardware habilitado na BIOS/UEFI.
- **Memória RAM:** Mínimo de 8 GB (Recomendado: 16 GB), pois o target03 consome 4 GB de RAM dedicados por padrão.
- **Armazenamento:** Pelo menos 20 GB de espaço livre em disco (a imagem do Windows é consideravelmente grande).

### **Requisitos por Sistema Operacional**

#### **Linux (Ubuntu, Debian, Fedora, etc.)**
- **KVM (Kernel-based Virtual Machine):** É altamente recomendado para que o Windows 11 (`target03`) rode com aceleração de hardware nativa.
- Verifique se a aceleração está habilitada rodando:
  ```bash
  kvm-ok
  # Se o comando acima não estiver instalado:
  lsmod | grep kvm
  ```
- Garanta que o seu usuário pertença ao grupo `kvm` (em algumas distribuições, também ao grupo `libvirt`).

#### **Windows (Windows 10/11 Home ou Pro)**
- **Docker Desktop** instalado e configurado para usar o backend **WSL2** (Windows Subsystem for Linux).
- Certifique-se de que a **Virtualização** está ativa no Gerenciador de Tarefas (Aba "Desempenho" -> "CPU").

#### **macOS (Intel ou Apple Silicon M1/M2/M3)**
- **Docker Desktop** instalado.
- **Apple Silicon (M1/M2/M3):** O container do Windows 11 será executado via emulação x86/x64 no Hypervisor do macOS. A inicialização e operação do Windows nesta arquitetura podem ser consideravelmente lentas. Certifique-se de alocar recursos suficientes nas configurações do Docker Desktop (pelo menos 4 CPUs e 6 GB de RAM).

---

## Como Instalar o Laboratório

Siga as etapas abaixo para realizar a instalação do laboratório em sua máquina:

1. **Baixe ou clone os arquivos do repositório** para uma pasta local de sua escolha:
   ```bash
   git clone <url-do-repositorio> pivot_lab
   cd pivot_lab
   ```

2. **Suba os contêineres** utilizando o Docker Compose:
   ```bash
   docker compose up -d
   ```

3. **Aguarde a inicialização:**
   - Os targets Linux (`target01`, `target02`, `target04`) iniciam quase instantaneamente.
   - O `target03` (Windows) baixa e instala o Windows 11 em background na primeira execução. Isso pode demorar entre **5 a 15 minutos** dependendo da velocidade de sua internet e processador.
   - Você pode acompanhar o progresso de inicialização do Windows visualizando os logs:
     ```bash
     docker compose logs -f target03
     ```

4. **Verifique se todos os ambientes estão de pé:**
   ```bash
   docker compose ps
   ```

---

## Como Acessar o Target 01 (Ponto de Entrada)

Como o `target01` está na rede externa simulada (`net_ext` - 10.10.10.5) e não expõe portas diretamente para o seu host (para manter o realismo da rede isolada), você pode acessá-lo diretamente via console do Docker para simular que comprometeu essa máquina de fora.

Para iniciar o laboratório, entre no console interativo do **Target 01**:

```bash
docker exec -it target01 /bin/bash
```

A partir desta sessão interativa:
- Você estará na rede externa `10.10.10.0/24`.
- Terá acesso direto à subrede intermediária `10.10.20.0/24`, onde o `target02` (`10.10.20.6`) está localizado.
- Pode usar ferramentas como `ping`, `ssh`, `curl` ou subir túneis para começar a explorar a rede internamente.

---

## Ferramentas Recomendadas para o Lab
- **Chisel:** Excelente para encapsulamento de túneis TCP.
- **Proxychains-ng:** Para rotear tráfego de ferramentas locais através do túnel SOCKS.
- **Socat:** Para redirecionamento rápido de portas.
- **SSH Port Forwarding:** (Local, Remote e Dynamic port forwarding).
- **CrackMapExec / Netexec:** Para enumeração de redes Windows/SMB.
- **Remmina / xfreerdp:** Para conexões de Área de Trabalho Remota (RDP).
