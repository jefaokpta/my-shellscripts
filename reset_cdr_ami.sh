#!/bin/sh

# O Asterisk passa os argumentos sequencialmente ($1, $2...)
CANAL_A=$1

# Configurações do seu Asterisk Manager Interface (AMI)
AMI_HOST="127.0.0.1"
AMI_PORT="5038"
AMI_USER="script_cdr"
AMI_SECRET="SuaSenhaSegura123"

# Valida se o nome do canal foi recebido
if [ -z "$CANAL_A" ]; then
    echo "Erro: Canal não especificado."
    echo "Uso: $0 <CHANNEL_NAME>"
    exit 1
fi

# O AMI exige finais de linha em formato CRLF (\r\n)
# O uso de printf garante que o protocolo seja respeitado
(
  printf "Action: Login\r\n"
  printf "Username: %s\r\n" "$AMI_USER"
  printf "Secret: %s\r\n" "$AMI_SECRET"
  printf "\r\n"
  
  sleep 0.1

  # Executa a aplicação ResetCDR especificamente no Canal A
  # Nota: 'Action: Exec' pode exigir o módulo res_manager_exec.so.
  # Se falhar, use 'Action: AGI' com 'Command: EXEC ResetCDR v'.
  printf "Action: Exec\r\n"
  printf "Channel: %s\r\n" "$CANAL_A"
  printf "Application: ResetCDR\r\n"
  printf "Options: v\r\n"
  printf "\r\n"
  
  sleep 0.1

  printf "Action: Logoff\r\n"
  printf "\r\n"
) | nc -w 1 $AMI_HOST $AMI_PORT

exit 0