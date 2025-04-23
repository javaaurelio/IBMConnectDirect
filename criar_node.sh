#!/bin/bash

# Função principal
mostrar_menu() {
    clear
    echo "=============================="
    echo "  🐧 Administracao IBM CD via Shell Linux"
    echo "=============================="
    echo "1 - Criar Node Remoto"
    echo "2 - Ver usuários logados"
    echo "3 - Mostrar calendário"
    echo "4 - Sair"
    echo "=============================="
    echo -n "Escolha uma opção: "
}


criar_usuario_e_node_remoto_opcoes() {
    clear
    echo "=============================="
    echo "  🐧 Administracao IBM CD - Criar Node Remoto e Usuario Remoto"
    echo "=============================="
    echo "===  Node Remoto   "
	echo "Node Name (1/5) : "
	read nodeName
	echo "Node IP (2/5): "
	read nodeIP
	
	echo "Porta (3/5): "
	read nodePorta
    
	echo "Sessoes Pnode Max (4/5): "
	read sessoesPNode

	echo "Sessoes Snode Max (5/5): "
	read sessoesSNode	
	
	echo "===  As informacoes estao corretas(y/n ) ?   "
	echo "     Node Name:   " $nodeName
	echo "     Node IP:   " $nodeIP
	echo "     Node Porta:   " $nodePorta
	echo "     Pnode Max:   " $sessoesPNode
	echo "     Snode Max:   " $sessoesSNode
	read resposta	


	if [ "$resposta" = "Y" ] || [ "$resposta" = "y" ]; then
		
		echo "Atualizando a configuracao do Connect:Direct  /home/cduser/cdunix/ndm/cfg/CDNODE01/netmap.cfg "
		ARQ_ORIGINAL="/home/cduser/cdunix/ndm/cfg/CDNODE01/netmap.cfg"
		ARQ_DESTINO="${ARQ_ORIGINAL%.*}.${ARQ_ORIGINAL##*.}_$(date +%Y%m%d)"
		cp "$ARQ_ORIGINAL" "$ARQ_DESTINO"
		echo "Backup da configuracao do Connect:Direct: $ARQ_ORIGINAL para $ARQ_DESTINO"
		

		modelo_netmap=$(cat <<EOF
$nodeName:
 :conn.retry.stwait=00.00.30:/\
 :conn.retry.stattempts=6:/\
 :conn.retry.ltwait=00.10.00:/\
 :conn.retry.ltattempts=6:/\
 :sess.pnode.max=$sessoesPNode:/\
 :sess.snode.max=$sessoesSNode:/\
 :sess.default=1:/\
 :comm.info=$nodeIP;$nodePorta:/\
 :comm.transport=tcp:/\
 :ostype=unix:/\
 :pacing.send.count=0:
EOF
)
		

# Exibindo o conteúdo do modelo
echo "$modelo_netmap"


		echo "$modelo_netmap" >> /home/cduser/cdunix/ndm/cfg/CDNODE01/netmap.cfg
			
		echo "Configuracao Finalizada."	
			
		
	elif [ "$resposta" = "F" ] || [ "$resposta" = "f" ]; then
		echo "Você escolheu sair."
	else
		echo "Opção inválida. Digite apenas y ou n."
	fi

	
	echo "=============================="
    echo -n "Escolha uma opção: "
}

# Loop principal
while true; do
    mostrar_menu
    read opcao
    case $opcao in
        1)
            echo -e "\n👥 Node Remoto:"
            criar_usuario_e_node_remoto_opcoes
            ;;
        2)
            echo -e "\n👥 Usuários logados:"
            who
            ;;
        3)
            echo -e "\n📅 Calendário:"
            cal
            ;;
        4)
            echo "👋 Saindo..."
            exit 0
            ;;
        *)
            echo "❌ Opção inválida!"
            ;;
    esac
    echo -e "\nPressione Enter para continuar..."
    read
done
