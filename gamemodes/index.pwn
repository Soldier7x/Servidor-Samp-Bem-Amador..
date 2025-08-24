
/*========================================================================================================================================================================
															[												]   |   |   |   |   |   |
														[														]
 ==========================================================================================================================================================================*/
#include <a_samp>
#include <zcmd>
#include <DOF2>
#include <sscanf2>
#include <foreach>
#include <Losgs>
#include <a_actor>


// Cores

#define C_BRANCO                  		0xFFFFFFAA
#define C_CINZA 						0xBEBEBEFF
#define C_VERMELHO 						0xFF0000FF
#define C_VERDE 						0x00FF00FF
#define C_ROSA_CLARO          			0xFFB7FFF6
#define COR_ADM  						0x007CF6AA
#define COR_ERRO 						0xDF3A01FF
#define COR_SUCESSO 					0x00AB00AA
#define COR_AV_ADM 						0x007CF6AA
#define COR_AZUL_CLARO 					0x00F6F6AA
#define COR_RAD 						0x4876FFAA

//Cores das orgs
#define C_Civil 						0xFFFFFFAA
#define C_PoliciaM 						0x9999FFF6
#define C_PoliciaC 						0x666699F6
#define C_PoliciaF 						0x00660CF6
#define C_Exercito 						0xCC6666F6
#define C_Prefeito 						0x005FFFFF
#define C_Groove 						0x109FFFAA
#define C_Ballas 						0x009999F6
#define C_Vagos 						0xA9A9A9F6
#define C_Alqaeda 						0xFF9900AA

#define varGet(%0)      getproperty(0,%0)
#define varSet(%0,%1)   setproperty(0, %0, %1)
#define new_strcmp(%0,%1) \
                (varSet(%0, 1), varGet(%1) == varSet(%0, 0))

//IDs das orgs
#define Civil 						0
#define PoliciaM 					1
#define PoliciaC 					2
#define PoliciaF 					3
#define Exercito 					4
#define Prefeito 					5
#define Groove 						6
#define Ballas 						7
#define Vagos 						8
#define Alqaeda 					9

//Trabalhos
#define Desempregado                0
#define MotoristaOnibus             1

            
//Dialogs
#define DIALOG_CADASTRO             0
#define DIALOG_CONECTAR             1
#define DIALOG_GENERO               2
#define DIALOG_ADMINS				3
#define DialogBan 					4
#define DDEPOSITO   				5 //Dialog deposito
#define DSAQUE      				6 //Dialog saque
#define DSENHAL     				7 //Dialog senha login
#define MENUBP      				8 //Menu bancario pronto
#define DSENHAR     				9 //Dialog senha registro
#define MENUBR      				10 //Menu bancario registro
#define BDEL        				11 //Banco delete
#define SENHA       				12 //Mudar senha
#define DTRANS      				13 //Dialog transferencia
#define GPSBANCO    				14 //Dialog Gps Banco
#define GPS                         15 //gps Geral
#define COMANDOS                    16//Mostra Os Comandos
#define CADM                        17//Mostra os Comandos ADM
#define MENUCAR                     18//Menu Dos Carros
#define CONCE                       19// Menu da conce
#define DIALOG_CADASTRO_ADM         20//menu registro adm
#define DIALOG_CONECTAR_ADM			21//menu login adm
#define Dialog_Carros               22//Menu carros conce
#define Pintarcarro                 23
#define Menu_Carro                  24
#define Profissoes                  25 //Menu de profissoes


//Defines de tamanho
#define MAX_PASSWORD                16      // Maximo de caracteres da senha
#define MIN_PASSWORD                4       // Minimo de caracteres da senha
#define MAX_ATTEMPS_PASSWORD        3       // Tentativas de acertar a senha

//Defines de confs
#define NOVATO_SKIN_MASCULINA       60
#define NOVATO_SKIN_FEMININA        56
#define NOVATO_DINHEIRO_INICIAL     1000
#define GRANA 						5000
#define GranaLvUp 					10000
#define ContaBanco       				"Banco\\%s.ini" //Pasta para salvar as Contas do bando
#define quantidade  				"Insira a quantidade desejada"

//Defines de pickups
#define coord1          			2316.4658,-15.6762,26.7422   	//Coordenada do Terminar 1
#define coord2          			2316.6191,-12.7899,26.7422   	//Coordenada do Terminar 2
#define coord3          			2316.6187,-9.9513,26.7422 		//Coordenada do Terminar 3
#define coord4          			2316.6208,-7.2376,26.7422 		//Coordenada do Terminar 4
#define g1              			2309.9907,-2.3623,26.7422 		//Coordenada do Menu gerente
#define EntradaBanco 				1462.3342,-1012.0580,26.8438    //Pickup entrada banco
#define SaidaBanco      			2305.2517,-16.2032,26.7422      //Pickup Saida banco
#define EntradaPref                 1480.7107,-1771.0424,18.7958    //Pickup Entrada Pref
#define SaidaPref                   389.8516,173.8203,1008.3828     //Pickup Saida Pref
#define EntradaDP                   1553.5592,-1675.6002,16.1953    //Pickup Entrada DP
#define SaidaDP                     246.6382,64.0559,1003.6406      //Pickup Saida DP
#define GaragemDP                   246.3705,87.5277,1003.6406      //Pickup Ir Garagem da DP
#define IrDPPelaGaragem             1524.4830,-1678.0035,6.2188     // Pickup Entrar Na DP Pela Garagem
#define LojaUm      				1352.3448,-1758.8737,13.5078    //Entrada Loja Um
#define LojaUmSaida     			-25.8124,-187.1984,1003.5469    //Saida Loja Um


#define ARQUIVO                     "Cadeia/%s.ini"
#define SendFormatMessage(%0,%1,%2,%3) format(String, sizeof(String),%2,%3) && SendClientMessage(%0, %1, String)
#define SendFormatMessageToAll(%1,%2,%3) format(String, sizeof(String),%2,%3) && SendClientMessageToAll(%1, String)
#define Kick(%0) SetTimerEx("Kicka", 100, false, "i", %0)

//ENUMS
enum Player
{
	xp,
    Skin,
    Level,
    Estrelas,
	Dinheiro,

    Senha[MAX_PASSWORD],
    SenhaAdm[MAX_PASSWORD],
    DataDeCadastro[24],
    UltimoLogin[24],
	AnosCadastrado,
    Licenca,
    Admin,
	Vip,
    dVip,
    Tentativas,
    Organizacao,
    Cargo,

    bool:BonusLevel,
    bool:Logado,
    bool:Spawnou,
    bool:Cadastrou
};

enum cInfo
{
    Cor,
    TemCarro
};

//=-=-=-=-=-=-=-=-=-=-=-=[ NEW'S ]=-=-=-=-=-=-=-=-=-=-=-=
new pInfo[MAX_PLAYERS][Player];
new bool:Ausente[MAX_PLAYERS];
new LogadoAdm[MAX_PLAYERS];
new Calado[MAX_PLAYERS];
new TimerCalado[MAX_PLAYERS];
new Data[20], Tempo[20];
new Hora, Minuto, Segundo;
new Dia, Mes, Ano;
new nome[MAX_PLAYER_NAME];
new b_file[28];
new strt[50];
new bool:mudou[MAX_PLAYERS];
new InfoCarro[MAX_PLAYERS][cInfo];
new CarroCriado[MAX_PLAYERS];
new PrisonTime[MAX_PLAYERS]; // Armazena o tempo restante da prisao para cada jogador


//Variables TextDrawns Inicio login


//Variables TextDrawns InGame
new Text:infoinicial;
new Text:datareal;
new Text:temporeal;


//=-=-=-=-=-=-=-=-=-=-=-=[ FIM NEW'S ]=-=-=-=-=-=-=-=-=-=

main()
{
	new ano,mes,dia,hora,minuto,segundo;getdate(ano,mes,dia);gettime(hora,minuto,segundo);
	print("\n============================================");
	if(fexist("/Contas/")) print("A pasta 'Contas' foi encontrada");
	else print("A pasta 'Contas' Nao foi encontrado"),SendRconCommand("exit");
	
	if(fexist("/Banco/")) print("A pasta 'Banco' foi encontrada");
	else print("A pasta 'Banco' Nao foi encontrado"),SendRconCommand("exit");

	if(fexist("/Banidos/")) print("A pasta 'Banidos' foi encontrada");
	else print("A pasta 'Banidos' Nao foi encontrado"),SendRconCommand("exit");
	
	if(fexist("/Backup/")) print("A pasta 'Backup' foi encontrada");
	else print("A pasta 'Backup' Nao foi encontrado"),SendRconCommand("exit");

	if(fexist("/Presos/")) print("A pasta 'Presos' foi encontrada");
	else print("A pasta 'Presos' Nao foi encontrado"),SendRconCommand("exit");
	
	if(fexist("/Veiculos/")) print("A pasta 'Veiculos' foi encontrada");
	else print("A pasta 'Veiculos' Nao foi encontrado"),SendRconCommand("exit");
	
	
	
	printf("Load Date: %02d/%02d/%4d  Time: %02d:%02d:%02d",dia,mes,ano,hora,minuto,segundo);
	print("==============================================\n");
	print("Servidor Iniciado com Sucesso!");
}

//STOCKS
stock PlayerName(playerid)
{
	new aname[MAX_PLAYER_NAME];
	GetPlayerName(playerid, aname, sizeof(aname));
	return aname;
}

GetPlayerIpf(playerid)
{
    new ip[16];
    GetPlayerIp(playerid, ip, 16);
    return ip;
}


SaveAccount(playerid)
{
    if(DOF2::FileExists(Account(playerid)) && pInfo[playerid][Logado])
    {
        format(pInfo[playerid][UltimoLogin], 24, formatTime());
        DOF2::SetString(Account(playerid), "UltimoLogin", pInfo[playerid][UltimoLogin]);
        DOF2::SetInt(Account(playerid), "Habilitacao", pInfo[playerid][Licenca]);
        DOF2::SetString(Account(playerid), "IP", GetPlayerIpf(playerid));
        DOF2::SetInt(Account(playerid), "Dinheiro", GetPlayerMoney(playerid));
        DOF2::SetInt(Account(playerid), "Level", GetPlayerScore(playerid));
        DOF2::SetInt(Account(playerid), "Skin", GetPlayerSkin(playerid));
        DOF2::SetInt(Account(playerid), "Interior", GetPlayerInterior(playerid));
        DOF2::SetInt(Account(playerid), "VirtualWorld", GetPlayerVirtualWorld(playerid));
        DOF2::SetInt(Account(playerid), "Estrelas", GetPlayerWantedLevel(playerid));
        DOF2::SetInt(Account(playerid), "Admin", pInfo[playerid][Admin]);
        DOF2::SetInt(Account(playerid), "VIP", pInfo[playerid][Vip]);
        DOF2::SetInt(Account(playerid), "Organizacao", pInfo[playerid][Organizacao]);
        DOF2::SetInt(Account(playerid), "Cargo", pInfo[playerid][Cargo]);
		DOF2::SetInt(Account(playerid), "xp", pInfo[playerid][xp]);
        DOF2::SaveFile();
    }
    return 1;
}


Backup(playerid)
{
    new file[500 + MAX_PLAYER_NAME];
    format(file, sizeof(file), "Backup/%s.ini", PlayerName(playerid));
	return file;
}

SaveBackup(playerid)
{
    for(new i = 0; i < MAX_PLAYERS; i++) // Um loop para pegar todos os Jogador Onlines!
    {
        if(DOF2::FileExists(Backup(i)) && pInfo[i][Logado])
		{
        	format(pInfo[playerid][UltimoLogin], 24, formatTime());
            format(pInfo[playerid][dVip], 24, formatTime());
        	DOF2::SetString(Backup(i), "Data De Cadastro", pInfo[i][DataDeCadastro]);
        	DOF2::SetString(Backup(i), "UltimoLogin", pInfo[i][UltimoLogin]);
            DOF2::SetInt(Account(i), "Habilitacao", pInfo[i][Licenca]);
        	DOF2::SetString(Backup(i), "IP", GetPlayerIpf(i));
        	DOF2::SetInt(Backup(i), "Dinheiro", GetPlayerMoney(i));
        	DOF2::SetInt(Backup(i), "Level", GetPlayerScore(i));
        	DOF2::SetInt(Backup(i), "Skin", GetPlayerSkin(i));
        	DOF2::SetInt(Backup(i), "Interior", GetPlayerInterior(i));
        	DOF2::SetInt(Backup(i), "VirtualWorld", GetPlayerVirtualWorld(i));
        	DOF2::SetInt(Backup(i), "Estrelas", GetPlayerWantedLevel(i));
        	DOF2::SetInt(Backup(i), "Admin", pInfo[i][Admin]);
        	DOF2::SetInt(Backup(i), "VIP", pInfo[i][Vip]);
        	DOF2_SetInt(Backup(i), "Organizacao", pInfo[i][Organizacao]);
        	DOF2_SetInt(Backup(i), "Cargo", pInfo[i][Cargo]);
			DOF2_SetInt(Account(i), "xp", pInfo[i][xp]);
        	DOF2::SaveFile();
    	}
		else 
		{
 			DOF2_CreateFile(Backup(i));
        	format(pInfo[i][UltimoLogin], 24, formatTime());
        	DOF2::SetString(Backup(i), "Data De Cadastro", pInfo[i][DataDeCadastro]);
        	DOF2::SetString(Backup(i), "UltimoLogin", pInfo[i][UltimoLogin]);
            DOF2::SetInt(Account(i), "Habilitacao", pInfo[i][Licenca]);
        	DOF2::SetString(Backup(i), "IP", GetPlayerIpf(i));
        	DOF2::SetInt(Backup(i), "Dinheiro", GetPlayerMoney(i));
        	DOF2::SetInt(Backup(i), "Level", GetPlayerScore(i));
            DOF2::SetInt(Account(i), "Procurado", GetPlayerWantedLevel(i));
        	DOF2::SetInt(Backup(i), "Skin", GetPlayerSkin(i));
        	DOF2::SetInt(Backup(i), "Interior", GetPlayerInterior(i));
        	DOF2::SetInt(Backup(i), "Estrelas", GetPlayerWantedLevel(i));
        	DOF2::SetInt(Backup(i), "Admin", pInfo[i][Admin]);
        	DOF2::SetInt(Backup(i), "VIP", pInfo[i][Vip]);
        	DOF2_SetInt(Backup(i), "Organizacao", pInfo[i][Organizacao]);
        	DOF2_SetInt(Backup(i), "Cargo", pInfo[i][Cargo]);
			DOF2_SetInt(Account(i), "xp", pInfo[i][xp]);
        	DOF2::SaveFile();
		}
    }
    return 1;
}

Account(playerid)
{
    new file[16 + MAX_PLAYER_NAME];
    format(file, sizeof(file), "Contas/%s.ini", PlayerName(playerid));
    return file;
}

stock CarregarDados(playerid)
{
 	SetPlayerScore(playerid, DOF2::GetInt(Account(playerid), "Level"));
 	SetPlayerSkin(playerid, DOF2::GetInt(Account(playerid), "Skin"));
 	SetPlayerWantedLevel(playerid, DOF2::GetInt(Account(playerid), "Estrelas"));
 	pInfo[playerid][Admin] = DOF2::GetInt(Account(playerid), "Admin");
 	pInfo[playerid][Vip] = DOF2::GetInt(Account(playerid), "VIP");
  	pInfo[playerid][Organizacao] = DOF2::GetInt(Account(playerid), "Organizacao");
    pInfo[playerid][Cargo] = DOF2::GetInt(Account(playerid), "Cargo");
	pInfo[playerid][xp] = DOF2::GetInt(Account(playerid), "xp");
    pInfo[playerid][Licenca] = DOF2::GetInt(Account(playerid), "Habilitacao");
    return 1;
}

stock kBan(playerid, motivo[])
{
    new arquivo[50];
    getdate(Ano, Mes, Dia);
    format(Data, 20, "%d/%d/%d", Dia, Mes, Ano);
    gettime(Hora, Minuto, Segundo);
    format(Tempo, 20, "%d:%d:%d", Hora, Minuto, Segundo);
    format(arquivo, sizeof(arquivo), "Banidos/%s.ini", PlayerName(playerid));
    DOF2_CreateFile(arquivo);
    DOF2_SetString(arquivo, "Admin", PlayerName(playerid));
    DOF2_SetString(arquivo, "Data", Data);
    DOF2_SetString(arquivo, "Horario", Tempo);
    DOF2_SetString(arquivo, "Motivo", motivo);
    DOF2_SaveFile();
    return 1;
}

stock kBanIP(playerid)
{
    new arquivo[30];
    getdate(Ano, Mes, Dia);
    format(Data, 20, "%d/%d/%d", Dia, Mes, Ano);
    gettime(Hora, Minuto, Segundo);
    format(Tempo, 20, "%d:%d:%d", Hora, Minuto, Segundo);
    format(arquivo, sizeof(arquivo), "IPs Banidos/%s.ini", GetPlayerIpf(playerid));
    DOF2_CreateFile(arquivo);
    DOF2_SetString(arquivo, "Nome", PlayerName(playerid));
    DOF2_SetString(arquivo, "Data", Data);
    DOF2_SetString(arquivo, "Horario", Tempo);
    DOF2_SaveFile();
    return 1;
}

stock AdminLevel(playerid)
{
    new name[32];
    //if(pInfo[playerid][Admin] == 0) format(name, sizeof(name), "");
    if(pInfo[playerid][Admin] == 1) format(name, sizeof(name), "[AUXILIAR]");
    else if(pInfo[playerid][Admin] == 2) format(name, sizeof(name), "[HELPER]");
    else if(pInfo[playerid][Admin] == 3) format(name, sizeof(name), "[ADMINISTRADOR]");
    else if(pInfo[playerid][Admin] == 4) format(name, sizeof(name), "[SUPORTE]");
    else if(pInfo[playerid][Admin] == 5) format(name, sizeof(name), "[MODERADOR]");
    else if(pInfo[playerid][Admin] == 6) format(name, sizeof(name), "[MODERADOR SENIOR]");
    else if(pInfo[playerid][Admin] == 7) format(name, sizeof(name), "[GERENTE]");
    else if(pInfo[playerid][Admin] == 8) format(name, sizeof(name), "[MAPPER]");
    else if(pInfo[playerid][Admin] == 9) format(name, sizeof(name), "[GERENTE GERAL]");
    return name;
}

stock LevelVip(playerid)
{
    new name[32];
    //if(pInfo[playerid][Vip] == 0) format(name, sizeof(name), "[SEM-VIP]");
    if(pInfo[playerid][Vip] == 1) format(name, sizeof(name), "[VIP-ANJO]");
    else if(pInfo[playerid][Vip] == 2) format(name, sizeof(name), "[VIP-ARCANJO]");
    else if(pInfo[playerid][Vip] == 3) format(name, sizeof(name), "[VIP-DEUS]");
    else if(pInfo[playerid][Vip] == 4) format(name, sizeof(name), "[VIP-LENDARIO]");
    else if(pInfo[playerid][Vip] == 5) format(name, sizeof(name), "[VIP-MESTRE]");
    return name;
}

stock SalariosOrgs(playerid)
{
    if(pInfo[playerid][Organizacao] == 0)	GivePlayerMoney(playerid, 2000);
    else if(pInfo[playerid][Organizacao] == 1)	{SendClientMessage(playerid, C_PoliciaM, "[Salario PM] Voce recebeu o salario da organizacao $4600"); GivePlayerMoney(playerid, 4600);}
    else if(pInfo[playerid][Organizacao] == 2)	{SendClientMessage(playerid, C_PoliciaC, "[Salario PC] Voce recebeu o salario da organizacao $4500"); GivePlayerMoney(playerid, 4500);}
    else if(pInfo[playerid][Organizacao] == 3)	{SendClientMessage(playerid, C_PoliciaF, "[Salario PF] Voce recebeu o salario da organizacao $7000"); GivePlayerMoney(playerid, 7000);}
    else if(pInfo[playerid][Organizacao] == 4)	{SendClientMessage(playerid, C_Exercito, "[Salario EB] Voce recebeu o salario da organizacao $8040"); GivePlayerMoney(playerid, 8040);}
    else if(pInfo[playerid][Organizacao] == 5)	{SendClientMessage(playerid, C_Prefeito, "[Salario ADM] Voce recebeu o salario da organizacao $30000"); GivePlayerMoney(playerid, 30000);}
    else if(pInfo[playerid][Organizacao] == 6)	{SendClientMessage(playerid, C_Groove, "[Salario GSF] Voce recebeu o salario da organizacao $3600"); GivePlayerMoney(playerid, 3600);}
    else if(pInfo[playerid][Organizacao] == 7)	{SendClientMessage(playerid, C_Ballas, "[Salario BLS] Voce recebeu o salario da organizacao $4500"); GivePlayerMoney(playerid, 4500);}
    else if(pInfo[playerid][Organizacao] == 8)	{SendClientMessage(playerid, C_Vagos, "[Salario LVS] Voce recebeu o salario da organizacao $8000"); GivePlayerMoney(playerid, 8000);}
    else if(pInfo[playerid][Organizacao] == 9)	{SendClientMessage(playerid, C_Alqaeda, "[Salario ALQ] Voce recebeu o salario da organizacao $7000"); GivePlayerMoney(playerid, 7000);}
	return 1;
}

stock SendFamilyMessageAdmin(admid, cor, mensagem[500]) //stock que envia a mensagem para tal organização de acordo com "ogrid"
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            if(pInfo[i][Admin] > 0)
            {
                SendClientMessage(i, cor, mensagem);
            }
        }
    }
    return 0;
}

stock CarregaCarro(playerid){
    new File[70], sendername[MAX_PLAYER_NAME];
    GetPlayerName(playerid, sendername, sizeof(sendername));
    format(File, sizeof(File), "Veiculos/%s.ini", sendername);
    if(DOF2_FileExists(File))
    {
        InfoCarro[playerid][Cor] = DOF2_GetInt(File, "Cor");
        InfoCarro[playerid][TemCarro] = DOF2_GetInt(File, "TemCarro");
    }
    else
    {
        DOF2_CreateFile(File);
        DOF2_SetInt(File, "Cor", 0);
        DOF2_SetInt(File, "TemCarro", 0);
        DOF2_SaveFile();
    }
    return 1;
}
stock salvacarro(playerid){

    new File[70], sendername[MAX_PLAYER_NAME];
    GetPlayerName(playerid, sendername, sizeof(sendername));
    format(File, sizeof(File), "Veiculos/%s.ini", sendername);
    DOF2_SetInt(File, "Cor", InfoCarro[playerid][Cor]);
    DOF2_SetInt(File, "TemCarro", InfoCarro[playerid][TemCarro]);
    DOF2_SaveFile();
    return 1;
}

formatTime()
{
    new output[24], date[4], hour[3];
    getdate(date[0], date[1], date[2]);
    gettime(hour[0], hour[1], hour[2]);
    format(output, sizeof(output), "%02d/%02d/%02d - %02d:%02d:%02d", date[0], date[1], date[2], hour[0], hour[1], hour[2]);
    return output;
}

ClearLines(playerid, lines)
    for(new i; i != lines; i++)
        SendClientMessage(playerid, -1, #);

forward MutadoTimer(playerid);
public MutadoTimer(playerid)
{
	SendClientMessage(playerid, 0xFF0000FF, "| INFO | Voce foi descalado, Nao quebre as regras novamente!");
	Calado[playerid] = 0;
	return 1;
}

forward Kicka(p);
public Kicka(p)
{
    #undef Kick
    Kick(p);
    #define Kick(%0) SetTimerEx("Kicka", 100, false, "i", %0)
    return 1;
}

forward PayDay();
public PayDay()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{   
        if(pInfo[i][Spawnou] == true) return 1;
        pInfo[i][xp] += 1;
        GivePlayerMoney(i, 500);
        SendClientMessage(i, -1, "-=-=-=-=-=-= PAYDAY -=-=-=-=-=-");
        new str[160];
        format(str, 160, "XP : %d/4", pInfo[i][xp]);
        SendClientMessage(i, -1, str);
        if(pInfo[i][xp] >= 4)
        {
            pInfo[i][Level] = DOF2::GetInt(Account(i), "Level");
            pInfo[i][Level] += 1;
            SetPlayerScore(i, pInfo[i][Level]);
            pInfo[i][xp] = 0;
            SendClientMessage(i, -1, "Parabens, voce subiu de nivel");
            format(str, 160, "Nivel : %d", GetPlayerScore(i));
            SendClientMessage(i, -1, str);
            SalariosOrgs(i);
        }
        else
        {
            format(str, 160, "Nivel : %d", GetPlayerScore(i));
            SendClientMessage(i, -1, str);
        }
	}
	return 1;
}

forward info(playerid);
public info(playerid)
{
	new str[128], str2[128], str3[128], dia, mes, ano, hora, minuto, segundo, meses[12];

	getdate(dia, mes, ano);

	gettime(hora, minuto, segundo);

	if(mes == 1) {meses = "Janeiro";}
	else if(mes == 2) {meses = "Fevereiro";}
	else if(mes == 3) {meses = "Marco";}
	else if(mes == 4) {meses = "Abril";}
	else if(mes == 5) {meses = "Maio";}
	else if(mes == 6) {meses = "Junho";}
	else if(mes == 7) {meses = "Julho";}
	else if(mes == 8) {meses = "Agosto";}
	else if(mes == 9) {meses = "Setembro";}
	else if(mes == 10) {meses = "Outubro";}
	else if(mes == 11) {meses = "Novembro";}
	else if(mes == 12) {meses = "Dezembro";}

	//alterar para meses a parte do mes "%02d/%02d/%02d", ano, mes, dia);"
	format(str, sizeof(str), " %02d/%02d/%02d", ano, mes, dia);
	TextDrawSetString(Text:datareal, str);
	format(str2, sizeof(str2), "%02d:%02d:%02d", hora, minuto, segundo);
	TextDrawSetString(Text:temporeal, str2);

    format(str3, sizeof(str3), "V: 1.0 NIVEL:%d ORG:%s XP:%d ID:%d",  DOF2::GetInt(Account(playerid), "Level"), GetOrgName(pInfo[playerid][Organizacao]), pInfo[playerid][xp], playerid);
    
	TextDrawSetString(Text:infoinicial, str3);
	return 1;
}

public OnGameModeInit()
{
	SetGameModeText("RPG");
	UsePlayerPedAnims();
 	EnableStuntBonusForAll(1);
	DisableInteriorEnterExits();
	SetTimer("PayDay", 260000 , true);
	SetTimer("info",1000,1);
    SetTimer("UpdatePrisonTime", 1000, true); // Atualiza a cada 1 segundo

	//=-=-=-=-=-=-=-=-=-=-=-=[ TEXT DRAW ]=-=-=-=-=-=-=-=-=-=-=-=
	//TextDraw Login


	//Text Drawn In Game
	infoinicial = TextDrawCreate(36.000000, 424.000000, "");
	TextDrawFont(infoinicial, 1);
	TextDrawLetterSize(infoinicial, 0.600000, 2.000000);
	TextDrawTextSize(infoinicial, 607.000000, 17.000000);
	TextDrawSetOutline(infoinicial, 1);
	TextDrawSetShadow(infoinicial, 0);
	TextDrawAlignment(infoinicial, 1);
	TextDrawColor(infoinicial, -1);
	TextDrawBackgroundColor(infoinicial, 255);
	TextDrawBoxColor(infoinicial, 50);
	TextDrawUseBox(infoinicial, 1);
	TextDrawSetProportional(infoinicial, 1);
	TextDrawSetSelectable(infoinicial, 0);
    
    datareal = TextDrawCreate(620.0,5.0,"00 de 00");
	TextDrawUseBox(datareal, 0);
	TextDrawFont(datareal, 3);
	TextDrawSetShadow(datareal,0);
	TextDrawSetOutline(datareal,2);
	TextDrawBackgroundColor(datareal,0xFF0000FF);
	TextDrawColor(datareal,0x000000FF);
	TextDrawAlignment(datareal,3);
	TextDrawLetterSize(datareal,0.5,1.5);


	temporeal = TextDrawCreate(632.0,25.0,"--:--:--");
	TextDrawUseBox(temporeal, 0);
	TextDrawFont(temporeal, 3);
	TextDrawSetShadow(temporeal,0);
	TextDrawSetOutline(temporeal,2);
	TextDrawBackgroundColor(temporeal,0xFF0000FF);
	TextDrawColor(temporeal,0x000000FF);
	TextDrawAlignment(temporeal,3);
	TextDrawLetterSize(temporeal,0.5,1.5);
	
 	//=-=-=-=-=-=-=-=-=-=-=-=[ OBJETOS DO BANCO ]=-=-=-=-=-=-=-=-=-=-=-=
	CreateObject(1491, 2311.1999511719, 0.20000000298023, 25.700000762939, 0, 0, 270);
    CreateObject(1714, 2318.5, -15.300000190735, 25.700000762939, 0, 0, 274);
    CreateObject(1714, 2318.6000976563, -12.800000190735, 25.700000762939, 0, 0, 269.9951171875);
    CreateObject(1714, 2318.5, -7.3000001907349, 25.700000762939, 0, 0, 269.99450683594);
    CreateObject(1724, 2309.3999023438, -7, 25.700000762939, 0, 0, 290);
    CreateObject(1724, 2309.8000488281, -8.8000001907349, 25.700000762939, 0, 0, 239.9951171875);
    CreateObject(1724, 2309.3000488281, -0.69999998807907, 25.700000762939, 0, 0, 289.9951171875);
    CreateObject(1724, 2309.8000488281, -2.9000000953674, 25.700000762939, 0, 0, 239.99084472656);
    CreateObject(2066, 2320.3000488281, -16.5, 25.700000762939, 0, 0, 270);
    CreateObject(2424, 2305.6999511719, -12.39999961853, 25.700000762939, 0, 0, 0);
    CreateObject(2424, 2306.6000976563, -12.39999961853, 25.700000762939, 0, 0, 0);
    CreateObject(2424, 2307.5, -12.39999961853, 25.700000762939, 0, 0, 0);
    CreateObject(2424, 2308.3999023438, -12.39999961853, 25.700000762939, 0, 0, 0);
    CreateObject(2424, 2309.3000488281, -12.39999961853, 25.700000762939, 0, 0, 0);
    CreateObject(2424, 2310.1999511719, -12.39999961853, 25.700000762939, 0, 0, 0);
    CreateObject(2424, 2311.1000976563, -12.39999961853, 25.700000762939, 0, 0, 0);
    CreateObject(2424, 2312, -12.39999961853, 25.700000762939, 0, 0, 0);
    CreateObject(2424, 2312.8999023438, -12.39999961853, 25.700000762939, 0, 0, 0);
    CreateObject(2424, 2313.3999023438, -12.39999961853, 25.700000762939, 0, 0, 0);
    CreateObject(2424, 2313.5, -12.300000190735, 25.700000762939, 0, 0, 90);
    CreateObject(2424, 2313.5, -11.39999961853, 25.700000762939, 0, 0, 90);
    CreateObject(2424, 2313.5, -10.60000038147, 25.700000762939, 0, 0, 90);
    CreateObject(2424, 2313, -10.5, 25.700000762939, 0, 0, 180);
    CreateObject(15038, 2313.6999511719, -9.6999998092651, 26.39999961853, 0, 0, 0);
    CreateObject(2424, 2312.8000488281, -10.89999961853, 25.700000762939, 0, 0, 270);
    CreateObject(2424, 2311.8999023438, -11.699999809265, 25.700000762939, 0, 0, 180);
    CreateObject(2424, 2311, -11.699999809265, 25.700000762939, 0, 0, 179.99450683594);
    CreateObject(2424, 2310.1000976563, -11.699999809265, 25.700000762939, 0, 0, 179.99450683594);
    CreateObject(2424, 2309.1999511719, -11.699999809265, 25.700000762939, 0, 0, 179.99450683594);
    CreateObject(2424, 2308.3000488281, -11.699999809265, 25.700000762939, 0, 0, 179.99450683594);
    CreateObject(2424, 2307.3999023438, -11.699999809265, 25.700000762939, 0, 0, 179.99450683594);
    CreateObject(2424, 2306.5, -11.699999809265, 25.700000762939, 0, 0, 179.99450683594);
    CreateObject(2424, 2305.6000976563, -11.699999809265, 25.700000762939, 0, 0, 179.99450683594);
    CreateObject(15038, 2312.1000976563, -10.10000038147, 26.39999961853, 0, 0, 0);
    CreateObject(2610, 2320.3999023438, -15.89999961853, 26.60000038147, 0, 0, 270);
    CreateObject(2610, 2320.3999023438, -15.39999961853, 26.60000038147, 0, 0, 270);
    CreateObject(2000, 2320.1999511719, -14.89999961853, 25.700000762939, 0, 0, 270);
    CreateObject(2164, 2320.6999511719, -13.39999961853, 25.700000762939, 0, 0, 270);
    CreateObject(2191, 2320.3000488281, -11.89999961853, 25.700000762939, 0, 0, 270);
    CreateObject(2163, 2320.6999511719, -10.10000038147, 25.799999237061, 0, 0, 270);
    CreateObject(2163, 2317, -17.5, 25.700000762939, 0, 0, 181.75);
    CreateObject(2163, 2305.5, -5.8000001907349, 25.700000762939, 0, 0, 91.746826171875);
    CreateObject(2201, 2305.8000488281, -5.5, 26.60000038147, 0, 0, 0);
    CreateObject(2164, 2305.3999023438, -4, 25.700000762939, 0, 0, 90);
    CreateObject(2164, 2320.8000488281, -8.3000001907349, 25.700000762939, 0, 0, 270);
    CreateObject(1724, 2311.8000488281, -6.5, 25.700000762939, 0, 0, 89.9951171875);
    CreateObject(1724, 2311.8000488281, -5.0999999046326, 25.700000762939, 0, 0, 89.994506835938);
    CreateObject(1724, 2311.8000488281, -3.5999999046326, 25.700000762939, 0, 0, 89.994506835938);
    CreateObject(2315, 2313.5, -4.0999999046326, 25.700000762939, 0, 0, 270);
    CreateObject(2852, 2313.5, -5.5999999046326, 26.200000762939, 0, 0, 0);
    CreateObject(2855, 2313.3000488281, -4.0999999046326, 26.200000762939, 0, 0, 0);
    CreateObject(2855, 2313.6999511719, -4.5999999046326, 26.200000762939, 0, 0, 320);
    CreateObject(16377, 2313.5, -17.299999237061, 26.700000762939, 0, 0, 0);
    CreateObject(2894, 2310.5, -12.10000038147, 26.89999961853, 0, 0, 0);
    CreateObject(2289, 2305.3999023438, -10.60000038147, 27.60000038147, 0, 0, 90);
    CreateObject(2282, 2308.6999511719, -0.30000001192093, 27.5, 0, 0, 0);
    CreateObject(2270, 2310.5, -0.40000000596046, 27.299999237061, 0, 0, 0);
    CreateObject(2267, 2307, 0.20000000298023, 27.700000762939, 0, 0, 0);
    CreateObject(2262, 2305.8999023438, -1.5, 27.39999961853, 0, 0, 90);
    CreateObject(2261, 2305.8999023438, -3.7000000476837, 27.60000038147, 0, 0, 80);
    CreateObject(2257, 2309.6000976563, -17.60000038147, 28.10000038147, 0, 0, 180);

	//=-=-=-=-=-=-=-=-=-=-=-=[ LABEL'S ]=-=-=-=-=-=-=-=-=-=-=-=
	Create3DTextLabel("Terminal 1\nUse a Tecla 'F'",0x5EAF03FF,coord1,50.0,0);
    Create3DTextLabel("Terminal 2\nUse a Tecla 'F'",0x5EAF03FF,coord2,50.0,0);
    Create3DTextLabel("Terminal 3\nUse a Tecla 'F'",0x5EAF03FF,coord3,50.0,0);
    Create3DTextLabel("Terminal 4\nUse a Tecla 'F'",0x5EAF03FF,coord4,50.0,0);
    Create3DTextLabel("Sala do Gerente\nUse a Tecla 'F'",0x5AF03FF,g1,50.0,0);
    Create3DTextLabel("Banco\nUse a Tecla 'F' Para Entrar",0x5AF03FF,EntradaBanco,50.0,0);
    Create3DTextLabel("Banco\nUse a Tecla 'F' Para Sair",0x5AF03FF,SaidaBanco,50.0,0);
    Create3DTextLabel("Concessionaria De Los Santos\n{008000}APERTE {FFFFFF}F {008000}Ver Carros", 0xFFFFFFAA , 2149.5764,-1172.2236,23.8203,254.1649,0);

	//=-=-=-=-=-=-=-=-=-=-=-=[ PICKUPS ]=-=-=-=-=-=-=-=-=-=-=-=
	AddStaticPickup(1239,	1,coord1); //Pickup Terminal 1!
    AddStaticPickup(1239,	1,coord2); //Pickup Terminal 2!
    AddStaticPickup(1239,	1,coord3); //Pickup Terminal 3!
    AddStaticPickup(1239,	1,coord4); //Pickup Terminal 4!
    AddStaticPickup(1277,	1,g1); //Pickup sala do gerente!
    AddStaticPickup(1318,	1,EntradaBanco); //ENTRADA BANCO [FORA]
    AddStaticPickup(19197,	1,LojaUm); //ENTRADA BANCO [FORA]
    AddStaticPickup(1318,	1,SaidaBanco); //SAIDA BANCO [DENTRO]
    AddStaticPickup(19197, 1, EntradaPref);
    CreatePickup(1239, 1, 2149.5764,-1172.2236,23.8203);

	//orgs
    AddStaticPickup(1275, 1, 1527.8973,-1667.4678,6.2188, -1);
    Create3DTextLabel("use: /equipar",0x5EAF03FF,1527.8973,-1667.4678,6.218,50.0,0);
    
	AddStaticPickup(1275, 1, 855.1198,-1650.5101,13.5603, -1);
	Create3DTextLabel("use: /equipar",0x5EAF03FF,855.1198,-1650.5101,13.5603,50.0,0);
	
	AddStaticPickup(1275, 1, 302.9983,-1530.9955,24.9219, -1);
	Create3DTextLabel("use: /equipar",0x5EAF03FF,302.9983,-1530.9955,24.9219,50.0,0);
	
	AddStaticPickup(1275, 1, 261.3844,1856.2665,8.7578, -1);
	Create3DTextLabel("use: /equipar",0x5EAF03FF,261.3844,1856.2665,8.7578,50.0,0);
	
	AddStaticPickup(1275, 1, 1403.7573,-1491.1599,20.4467, -1);
	Create3DTextLabel("use: /equipar",0x5EAF03FF,1403.7573,-1491.1599,20.4467,50.0,0);
	
	AddStaticPickup(1275, 1, 2529.2039,-1667.6077,15.1688, -1);
	Create3DTextLabel("use: /equipar",0x5EAF03FF,2529.2039,-1667.6077,15.1688,50.0,0);
	
	AddStaticPickup(1275, 1, 2104.3184,-1168.3340,25.5938, -1);
	Create3DTextLabel("use: /equipar",0x5EAF03FF,2104.3184,-1168.3340,25.5938,50.0,0);
	
	AddStaticPickup(1275, 1, 2803.5425,-1427.3954,40.0625, -1);
	Create3DTextLabel("use: /equipar",0x5EAF03FF,2803.5425,-1427.3954,40.0625,50.0,0);
	
	AddStaticPickup(1275, 1, 1040.8257,1305.5693,10.8203, -1);
	Create3DTextLabel("use: /equipar",0x5EAF03FF,1040.8257,1305.5693,10.8203,50.0,0);
    
    //=-=-=-=-=-=-=-=-=-=-=-=[CARROS DAS ORGS]=-=-=-=-=-=-=-=-=
    AddStaticVehicle(520,276.2109,1989.8773,18.2842,269.0757,0,0); // hydra hangar 2
	AddStaticVehicle(520,277.7398,2024.0935,18.2365,270.7532,0,0); // hydra hangar 3
	AddStaticVehicle(520,277.4798,1955.0096,18.2490,271.9680,0,0); // hydra hangar 1
	AddPlayerClass(0,1176.1998,-1180.2483,87.0378,63.5110,0,0,0,0,0,0); // prisao
	AddStaticVehicle(596,1546.3295,-1658.9500,5.7343,89.7654,0,1); // carroPm
	AddStaticVehicle(596,1546.6556,-1654.9734,5.7335,88.8341,0,1); // carroPm
	AddStaticVehicle(596,1547.1934,-1650.8578,5.7546,89.7776,0,1); // carroPm
	AddStaticVehicle(596,1528.3652,-1688.1935,5.7244,270.1207,0,1); // carroPm
	AddStaticVehicle(596,1528.1064,-1684.1481,5.6970,269.9506,0,1); // carroPm
	AddStaticVehicle(596,1546.4987,-1684.4797,5.7285,90.2277,0,1); // carroPm
	AddStaticVehicle(596,1546.5974,-1680.1393,5.7152,90.0964,0,1); // carroPm
	AddStaticVehicle(599,1538.3490,-1643.2990,6.0157,180.6010,0,1); // carroPmRange
	AddStaticVehicle(599,1534.5763,-1643.1669,6.0154,179.7834,0,1); // carroPmRange
	AddStaticVehicle(599,1530.5634,-1643.0792,6.0158,180.2887,0,1); // carroPmRange
	AddStaticVehicle(599,1526.2576,-1643.5837,6.0158,180.9180,0,1); // carroPmRange
	AddStaticVehicle(523,1541.7834,-1642.3984,5.4331,179.8668,0,0); // motoPm
	AddStaticVehicle(523,1542.8662,-1641.9495,5.4331,181.9859,0,0); // motoPm
	AddStaticVehicle(523,1544.4315,-1642.0261,5.4319,169.2530,0,0); // motoPm
	AddStaticVehicle(523,1545.5054,-1642.3179,5.5013,159.8413,0,0); // motoPm
	AddStaticVehicle(523,1546.2511,-1642.8557,5.4927,143.2976,0,0); // motoPm
	AddStaticVehicle(523,1547.3021,-1643.8301,5.5234,123.9299,0,0); // motoPm
	AddStaticVehicle(523,1547.9941,-1645.0591,5.5338,115.4175,0,0); // motoPm
	AddStaticVehicle(523,1548.3097,-1646.1771,5.5571,92.6689,0,0); // motoPm
	AddStaticVehicle(523,1548.3483,-1647.2738,5.4336,87.0991,0,0); // motoPm
	AddStaticVehicle(523,1548.2911,-1647.9137,5.4515,94.3261,0,0); // motoPm
	AddStaticVehicle(523,1548.2782,-1648.8208,5.4677,89.6734,0,0); // motoPm
	AddStaticVehicle(598,870.0341,-1658.0438,13.2564,179.7670,0,1); // carroPC
	AddStaticVehicle(598,870.0780,-1669.0430,13.2542,359.4030,0,1); // carroPC
	AddStaticVehicle(598,874.5224,-1669.3248,13.2557,358.9527,0,1); // carroPC
	AddStaticVehicle(598,874.5958,-1657.9697,13.2622,179.0343,0,1); // carroPC
	AddStaticVehicle(598,878.9664,-1657.9005,13.2581,180.7710,0,1); // carroPC
	AddStaticVehicle(598,883.5966,-1658.2311,13.2548,179.6611,0,1); // carroPC
	AddStaticVehicle(598,887.9203,-1658.2347,13.2573,179.9486,0,1); // carroPC
	AddStaticVehicle(598,892.3174,-1657.9983,13.2583,180.7352,0,1); // carroPC
	AddStaticVehicle(598,892.4401,-1669.5188,13.2612,359.6393,0,1); // carroPC
	AddStaticVehicle(598,888.2453,-1669.2999,13.2583,1.2111,0,1); // carroPC
	AddStaticVehicle(598,883.3287,-1669.3427,13.2568,359.9592,0,1); // carroPC
	AddStaticVehicle(598,879.2634,-1669.3424,13.2560,1.6419,0,1); // carroPC
	AddStaticVehicle(598,874.5546,-1669.3766,13.2564,1.2049,0,1); // carroPC
	AddStaticVehicle(490,277.1892,-1535.1704,24.7023,235.0257,0,0); // carroPF
	AddStaticVehicle(490,280.4396,-1530.6475,24.6955,235.3974,0,0); // carroPF
	AddStaticVehicle(490,283.8560,-1526.2551,24.6586,235.3853,0,0); // carroPF
	AddStaticVehicle(490,288.0386,-1522.3967,24.7148,234.8332,0,0); // carroPF
	AddStaticVehicle(490,290.1380,-1517.3119,24.6902,233.4180,0,0); // carroPF
	AddStaticVehicle(490,293.1726,-1512.4163,24.6586,235.2700,0,0); // carroPF
	AddStaticVehicle(490,296.7453,-1508.3647,24.6591,235.1031,0,0); // carroPF
	AddStaticVehicle(490,299.6306,-1503.6460,24.7009,235.7606,0,0); // carroPF
	AddStaticVehicle(490,300.7825,-1491.2527,24.6585,55.0561,0,0); // carroPF
	AddStaticVehicle(490,303.7787,-1486.3302,24.6586,55.7022,0,0); // carroPF
	AddStaticVehicle(490,306.3542,-1481.0984,24.6586,54.2384,0,0); // carroPF
	AddStaticVehicle(548,205.2663,1956.3669,19.1530,358.4367,1,1); // helicoptero Ex
	AddStaticVehicle(548,224.5986,1956.1770,19.9719,358.7577,1,1); // helicoptero Ex
	AddStaticVehicle(548,247.4887,1955.4232,20.6085,0.1418,1,1); // helicoptero Ex
	AddStaticVehicle(470,105.7858,1825.3536,17.5950,269.9614,43,0); // carro Exercito
	AddStaticVehicle(470,106.5360,1829.1283,17.5950,271.0244,43,0); // carro Exercito
	AddStaticVehicle(470,105.4702,1833.3235,17.5950,270.6321,43,0); // carro Exercito
	AddStaticVehicle(470,106.3169,1838.3114,17.5950,270.7564,43,0); // carro Exercito
	AddStaticVehicle(470,106.9443,1842.9694,17.5950,271.2634,43,0); // carro Exercito
	AddStaticVehicle(470,106.4643,1847.6058,17.6003,271.3528,43,0); // carro Exercito
	AddStaticVehicle(470,106.2080,1852.8683,17.6249,270.1133,43,0); // carro Exercito
	AddStaticVehicle(470,106.1317,1857.7040,17.6579,271.1845,43,0); // carro Exercito
	AddStaticVehicle(470,106.2726,1862.8086,17.7055,269.5876,43,0); // carro Exercito
	AddStaticVehicle(432,220.5220,1917.8252,17.6495,181.3182,43,0); // Tanque Exercito
	AddStaticVehicle(432,211.0339,1918.7621,17.6495,180.3157,43,0); // Tanque Exercito
	AddStaticVehicle(432,202.5148,1918.7557,17.6497,179.9142,43,0); // Tanque Exercito
	AddStaticVehicle(432,193.5239,1918.4736,17.6498,180.9165,43,0); // Tanque Exercito
	AddStaticVehicle(432,130.9833,1852.8317,17.7206,90.3889,43,0); // Tanque Exercito
	AddStaticVehicle(432,132.2957,1846.8291,17.6692,91.4754,43,0); // Tanque Exercito
	AddStaticVehicle(425,198.0921,2037.1320,18.1837,266.2130,43,0); // hunter Exercito
	AddStaticVehicle(425,198.2762,2024.9265,18.1835,267.7175,43,0); // hunter Exercito
	AddStaticVehicle(425,198.1774,2013.1456,18.3353,269.6522,43,0); // hunter Exercito
	AddStaticVehicle(425,198.2658,1997.8273,18.3262,267.7363,43,0); // hunter Exercito
	AddStaticVehicle(425,198.4310,1984.2649,18.1856,270.3882,43,0); // hunter Exercito
	AddStaticVehicle(425,198.3349,1974.4154,18.3284,268.5754,43,0); // hunter Exercito
	AddStaticVehicle(409,1465.4950,-1491.9463,13.3067,89.3369,1,1); // prefeito
	AddStaticVehicle(492,2507.7065,-1673.2844,13.1265,349.0853,30,26); // carroGroove
	AddStaticVehicle(492,2504.4919,-1678.7175,13.1233,317.2059,30,26); // carroGroove
	AddStaticVehicle(492,2496.8750,-1681.9041,13.0941,281.3943,30,26); // carroGroove
	AddStaticVehicle(492,2489.6006,-1682.6732,13.0785,270.3324,30,26); // carroGroove
	AddStaticVehicle(492,2480.6841,-1681.9054,13.0760,253.8640,30,26); // carroGroove
	AddStaticVehicle(492,2471.3909,-1674.3201,13.0740,208.9809,30,26); // carroGroove
	AddStaticVehicle(492,2472.8152,-1655.0219,13.0797,268.6204,30,26); // carroGroove
	AddStaticVehicle(492,2483.7505,-1655.0345,13.0624,268.9706,30,26); // carroGroove
	AddStaticVehicle(492,2497.9099,-1655.6887,13.1343,260.3546,30,26); // carroGroove
	AddStaticVehicle(566,2075.7317,-1171.1277,23.4379,179.1771,84,8); // carroBallas
	AddStaticVehicle(566,2075.7234,-1160.0894,23.4690,177.4945,84,8); // carroBallas
	AddStaticVehicle(566,2075.8611,-1149.3597,23.4586,178.9793,84,8); // carroBallas
	AddStaticVehicle(566,2075.5742,-1138.6539,23.4794,178.8594,84,8); // carroBallas
	AddStaticVehicle(566,2088.4561,-1139.6427,25.0683,88.5772,84,8); // carroBallas
	AddStaticVehicle(566,2075.5901,-1128.9662,23.4838,178.6588,84,8); // carroBallas
	AddStaticVehicle(566,2086.0935,-1194.2555,23.6099,88.6128,84,8); // carroBallas
	AddStaticVehicle(576,2816.7634,-1434.3163,39.6263,90.8607,74,8); // carroLv
	AddStaticVehicle(576,2816.6868,-1438.2052,39.6239,93.2624,74,8); // carroLv
	AddStaticVehicle(576,2817.4636,-1442.4353,39.6245,91.2312,74,8); // carroLv
	AddStaticVehicle(576,2816.9937,-1445.0741,39.6232,92.3229,74,8); // carroLv
	AddStaticVehicle(576,2817.7224,-1449.1727,39.6252,89.6638,74,8); // carroLv
	AddStaticVehicle(576,2817.1560,-1452.3136,39.6235,89.6435,74,8); // carroLv
	AddStaticVehicle(576,2817.4346,-1456.3229,39.6244,91.4261,74,8); // carroLv
	AddStaticVehicle(576,2817.1321,-1460.8082,39.6237,92.1388,74,8); // carroLv
	AddStaticVehicle(576,2817.3945,-1464.0226,39.6252,89.8045,74,8); // carroLv
	AddStaticVehicle(579,1040.7040,1358.5963,10.6989,180.6217,7,7); // CarroAlq
	AddStaticVehicle(579,1044.9165,1358.4374,10.6989,181.6761,7,7); // CarroAlq
	AddStaticVehicle(579,1048.8584,1358.1968,10.6987,180.2196,7,7); // CarroAlq
	AddStaticVehicle(579,1052.1089,1358.5195,10.7028,180.6043,7,7); // CarroAlq
	AddStaticVehicle(579,1055.7389,1358.9052,10.7028,180.5918,7,7); // CarroAlq
	AddStaticVehicle(579,1058.0848,1357.6890,10.7008,178.4744,7,7); // CarroAlq
	AddStaticVehicle(579,1092.0485,1356.4801,10.6989,93.7896,7,7); // CarroAlq
	AddStaticVehicle(579,1092.5774,1352.2367,10.6989,92.6340,7,7); // CarroAlq
	AddStaticVehicle(579,1093.2634,1347.7194,10.6989,94.6719,7,7); // CarroAlq
	AddStaticVehicle(579,1092.6423,1343.8256,10.6989,90.4468,7,7); // CarroAlq
	AddStaticVehicle(579,1094.0605,1340.8022,10.6989,91.2123,7,7); // CarroAlq
	return 1;
}

public OnGameModeExit()
{
	DOF2_Exit();
 	for(new i = 0; i < MAX_PLAYERS; i++) // Um loop para pegar todos os Jogador Onlines!
    {
        SaveAccount(i);
    }
   	TextDrawDestroy(infoinicial);
	TextDrawDestroy(datareal);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	PlayAudioStreamForPlayer(playerid, "http://live.hunterfm.com/sertanejo_high?origin=/country", x, y, z);

    for(new b = 0; b <= 20; b++) SendClientMessage(playerid, -1, "");
    SendClientMessage(playerid, 0x00FF00FF, "~> Seja bem-vindo(a) ao servidor [Real City RPG Brasil], Logue-se para jogar!");
    InterpolateCameraPos(playerid, 828.892395, -1470.234985, 159.147048, 1855.578247, -1356.315795, 106.570388, 90000);
    InterpolateCameraLookAt(playerid, 833.859008, -1469.715087, 158.897155, 1860.529296, -1355.671020, 106.302513, 90000);

	if(!pInfo[playerid][Logado])
    {
        if(!DOF2::FileExists(Account(playerid)))
            ShowPlayerDialog(playerid, DIALOG_CADASTRO, DIALOG_STYLE_PASSWORD, "Cadastro", "{FFFFFF}Insira uma senha para cadastrar-se:", "Cadastrar", "Sair");
        else
            ShowPlayerDialog(playerid, DIALOG_CONECTAR, DIALOG_STYLE_PASSWORD, "Conectando", "{FFFFFF}Insira sua senha para conectar-se:", "Conectar", "Sair");
    }
    
	return 1;
}


public OnPlayerConnect(playerid)
{
	//TextDrawn login definido para mostrar
	//TextDrawn Relogio
    info(playerid);
	new String[300];
	format(String, sizeof(String), "Banidos/%s.ini", PlayerName(playerid));
    if(DOF2_FileExists(String))
    {
        format(String, sizeof(String), "{FFFFFF}Voce foi {FF0000}banido\nAdmin: {FFFFFF}%s\n{FF0000}Motivo: {FFFFFF}%s\n{FF0000}Dia: {FFFFFF}%s\n{FF0000}Horario: {FFFFFF}%s\n{FF0000}Tire SS para revisao no Forum!", DOF2_GetString(String, "Admin"), DOF2_GetString(String, "Motivo"), DOF2_GetString(String, "Data"), DOF2_GetString(String, "Horario"));
        ShowPlayerDialog(playerid, DialogBan,  DIALOG_STYLE_MSGBOX, "{FF0000}Banimento", String, "Sair", "");
        Kick(playerid);
        return 1;
    }

    format(String, sizeof(String), "IPs Banidos/%s.ini", GetPlayerIpf(playerid));
    if(DOF2_FileExists(String))
    {
        SendFormatMessage(playerid, 0xFF0000, "O IP: {FFFFFF}%s {FF0000}esta banido do servidor!", GetPlayerIpf(playerid));
        Kick(playerid);
        return 1;
    }

	SetPlayerColor(playerid, C_BRANCO);
    SetPlayerInterior(playerid, 0);
	
	Ausente[playerid] = true;
    LogadoAdm[playerid] = false;

	new string[550];
	format(string, sizeof(string), "{FFFFFF}%s(%d){00FF00}Conectou ao jogo.", PlayerName(playerid), playerid);
	SendClientMessageToAll(playerid, string);
    CarregaCarro(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	SetPlayerInterior(playerid, 0);
    SaveAccount(playerid);
	
	for(new i = 0; i < MAX_PLAYERS; i++) // Um loop para pegar todos os Jogador Onlines!
    {
        SaveAccount(i);
    }
    //Banco
    format(b_file,sizeof b_file,ContaBanco,PlayerName(playerid));
    if(!fexist(b_file))
    {
        DOF2_CreateFile(b_file);
        DOF2_SetInt(b_file,"Dinheiro",0);
        DOF2_SaveFile();
    }
    pInfo[playerid][Spawnou] = false;
    pInfo[playerid][Logado] = false;
    
   	new stringDesconect[250];
	switch(reason)
	{
		case 0: format(stringDesconect, sizeof(stringDesconect), "{FFFFFF} %s (%d) saiu do servidor {FF0000}[Conexao/Crash]", PlayerName(playerid), playerid);
		case 1: format(stringDesconect, sizeof(stringDesconect), "{FFFFFF} %s (%d) saiu do servidor {FF0000}[Vontade propria]", PlayerName(playerid), playerid);
		case 2: format(stringDesconect, sizeof(stringDesconect), "{FFFFFF} %s (%d) saiu do servidor {FF0000}[Kickado/Banido]", PlayerName(playerid), playerid);
	}
	SendClientMessageToAll(playerid, stringDesconect);
	salvacarro(playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	//Destroe a textDrawn de login
  	
	//Mostra TextDraw in game
	TextDrawShowForPlayer(playerid, infoinicial);
	TextDrawShowForPlayer(playerid, datareal);
	TextDrawShowForPlayer(playerid, temporeal);
	
	//funcoes
    StopAudioStreamForPlayer(playerid);
    new str[360];
    format(str, sizeof(str), "{00FF00}O Jogador:{FFFFFF} %s(%d): {00FF00}Esta na cidade.", PlayerName(playerid), playerid);
    SendClientMessageToAll(playerid, str);
    
 	if(pInfo[playerid][Spawnou])
    {
        if(pInfo[playerid][Cadastrou])
        {
            new string[128];
            ClearLines(playerid, 50);
            pInfo[playerid][Spawnou] = false;
            pInfo[playerid][Cadastrou] = false;
            Ausente[playerid] = true;

            format(string, sizeof(string), "{2E8B57}[ > ] {FFFFFF}Bem-vindo(a) {1E90FF}%s {FFFFFF}pela primeira vez ao servidor.",PlayerName(playerid));
            SendClientMessageToAll(playerid, string);
            SendClientMessage(playerid, -1, "{2E8B57}[ > ] {FFFFFF}Caso tenha duvidas use /comandos e /duvida");
        }
        else
        {
            new string[128];
            ClearLines(playerid, 50);
            pInfo[playerid][Spawnou] = false;

            format(string, sizeof(string), "{2E8B57}[ > ] {FFFFFF}Bem-vindo(a) {1E90FF}%s {FFFFFF}novamente ao servidor.", PlayerName(playerid));
            SendClientMessage(playerid, -1, string);
            format(string, sizeof(string), "{2E8B57}[ > ] {FFFFFF}Voce entrou no servidor em: {FF0000}%s", pInfo[playerid][UltimoLogin]);
            SendClientMessage(playerid, -1, string);

            if(pInfo[playerid][Admin]>0)
            {
                Ausente[playerid] = true;
                LogadoAdm[playerid] = false;
            }
        }
    }

	//Spawns Das Orgs
	if(pInfo[playerid][Organizacao] == 0)
    {
        pInfo[playerid][Organizacao] = 0;
        SetPlayerPos(playerid, 1154.7363,-1767.0729,16.5938);
    }
    else if(pInfo[playerid][Organizacao] == 1)
    {
        SetPlayerPos(playerid, 1550.7076,-1667.8971,6.2188);
    }
    else if(pInfo[playerid][Organizacao] == 2)
    {
        SetPlayerPos(playerid, 863.2734,-1637.2144,14.9297);
    }
    else if(pInfo[playerid][Organizacao] == 3)
    {
        SetPlayerPos(playerid, 273.0712,-1531.8844,24.9219);
    }
    else if(pInfo[playerid][Organizacao] == 4)
    {
        SetPlayerPos(playerid, 246.4988,1858.9905,14.0840);
    }
    else if(pInfo[playerid][Organizacao] == 5)
    {
        SetPlayerPos(playerid, 1405.5774,-1477.9385,20.4323);
    }
    else if(pInfo[playerid][Organizacao] == 6)
    {
        SetPlayerPos(playerid, 2511.2456,-1651.7463,13.8614);
    }
    else if(pInfo[playerid][Organizacao] == 7)
    {
        SetPlayerPos(playerid, 2091.8667,-1166.2753,26.5859);
    }
    else if(pInfo[playerid][Organizacao] == 8)
    {
        SetPlayerPos(playerid, 2816.9297,-1431.2343,40.0625);
    }
    else if(pInfo[playerid][Organizacao] == 9)
    {
        SetPlayerPos(playerid, 1040.8257,1305.5693,10.8203);
    }
    
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	new string[500];
    SendDeathMessage(killerid, playerid, reason);
	format(string, sizeof(string), "{FF0000}[ANT-DM]{FFFFFF}:O Jogador: %s Matou: %s ", PlayerName(killerid), PlayerName(playerid));
	SendClientMessageToAll(playerid, string);
	
	SetPlayerInterior(playerid, 0);
	SetPlayerPos(playerid, 1176.8672,-1324.0752,14.0425);
	
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	new stringB[1500];
	if(Calado[playerid] == 1)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce esta calado e nao pode falar no chat!");
		return 0;
	}

    if(pInfo[playerid][Admin] >= 0 && pInfo[playerid][Vip] >= 0) {
		format(stringB, sizeof(stringB), "%s{FF0000}[ID:%d]:{FFFFFF}{00FF00}.::%s%s%s::.{FFFFFF} %s", PlayerName(playerid), playerid, AdminLevel(playerid), GetOrgName(pInfo[playerid][Organizacao]), LevelVip(playerid), text);
		SendClientMessageToAll(GetPlayerColor(playerid), stringB);
		return 0;
 	}
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	//Bloqueio de veiculos das orgs
	if(newstate == PLAYER_STATE_DRIVER)
	{

	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	DisablePlayerCheckpoint(playerid); // Destruira ao Ficar em Cima Dele.
    GameTextForPlayer(playerid, " ~>~ ~g~Voce ~b~Chegou ~r~No ~w~Destino ~<~", 5000, 3);
    SendClientMessage(playerid, COR_SUCESSO, "[GPS]:{FFFFFF}Voce Chegou Ao Destino.");
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            SetPlayerInterior(i, newinteriorid);
        }
    }
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if ((newkeys == KEY_SECONDARY_ATTACK))  // Key F / Enter
    {
       	cmd_bancomenu(playerid,"");
        cmd_infobanco(playerid,"");
        cmd_entrar(playerid,"");
        cmd_sair(playerid,"");
        cmd_f(playerid,"");
    }
	return true;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
    salvacarro(playerid);
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{//Dialog do sistema de login
    switch(dialogid)
    {
        case DIALOG_CADASTRO:
        {
            if(!response)
                return Kick(playerid);

            if(!(MIN_PASSWORD <= strlen(inputtext) <= MAX_PASSWORD))
            {
                new dialog[100];
                format(dialog, sizeof(dialog), "{FFFFFF}Insira uma senha para cadastrar-se:\n\n{FF0000}* Insira uma senha entre %i a %i caracteres.", MIN_PASSWORD, MAX_PASSWORD);
                ShowPlayerDialog(playerid, DIALOG_CADASTRO, DIALOG_STYLE_PASSWORD, "Cadastro", dialog, "Cadastrar", "Sair");
            }
            else
            {
                format(pInfo[playerid][Senha], MAX_PASSWORD, inputtext);
				format(pInfo[playerid][DataDeCadastro], 24, formatTime());
                format(pInfo[playerid][UltimoLogin], 24, formatTime());

                // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //

                DOF2::CreateFile(Account(playerid));
                DOF2::SetString(Account(playerid), "Senha", pInfo[playerid][Senha]);
                DOF2::SetString(Account(playerid), "Data De Cadastro", pInfo[playerid][DataDeCadastro]);
                DOF2::SetString(Account(playerid), "UltimoLogin", pInfo[playerid][UltimoLogin]);
                DOF2::SetString(Account(playerid), "IP", GetPlayerIpf(playerid));
                DOF2::SetInt(Account(playerid), "Dinheiro", 0);
                DOF2::SetInt(Account(playerid), "Level", 0);
				DOF2::SetInt(Account(playerid), "xp", 0);
                DOF2::SetInt(Account(playerid), "Skin", 0);
                DOF2::SetInt(Account(playerid), "Estrelas", 0);
                DOF2::SetInt(Account(playerid), "Admin", pInfo[playerid][Admin] = 0);
                DOF2::SetInt(Account(playerid), "VIP", pInfo[playerid][Vip] = 0);
                DOF2::SetInt(Account(playerid), "Organizacao", pInfo[playerid][Organizacao] = 0);
        		DOF2::SetInt(Account(playerid), "Cargo", pInfo[playerid][Cargo] = 0);
                DOF2::SaveFile();

                // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //

                GivePlayerMoney(playerid, NOVATO_DINHEIRO_INICIAL);
                SendClientMessage(playerid, -1, "[!] Cadastro efetuado com sucesso.");
                ShowPlayerDialog(playerid, DIALOG_GENERO, DIALOG_STYLE_MSGBOX, "Genero", "{FFFFFF}Informe seu genero abaixo:", "Masculino", "Feminino");
            }
        }
        case DIALOG_GENERO:
        {
            if(response)
            {
                pInfo[playerid][Logado] = true;
                pInfo[playerid][Spawnou] = true;
                pInfo[playerid][Cadastrou] = true;

                SendClientMessage(playerid, -1, "[!] Genero definido como Masculino.");
                SetSpawnInfo(playerid, NO_TEAM, NOVATO_SKIN_MASCULINA, 1154.7363,-1767.0729,16.5938,0.0000,0,0,0,0,0,0);
                SetCameraBehindPlayer(playerid);
                SpawnPlayer(playerid);
            }
            else
            {
                pInfo[playerid][Logado] = true;
                pInfo[playerid][Spawnou] = true;
                pInfo[playerid][Cadastrou] = true;

                SendClientMessage(playerid, -1, "[!] Genero definido como Feminino.");
                SetSpawnInfo(playerid, NO_TEAM, NOVATO_SKIN_FEMININA, 1154.7363,-1767.0729,16.5938,0.0000,0,0,0,0,0,0);
                SetCameraBehindPlayer(playerid);
                SpawnPlayer(playerid);
            }
        }
        case DIALOG_CONECTAR:
        {
            if(!response)
                return Kick(playerid);

            if(!strlen(inputtext))
                return ShowPlayerDialog(playerid, DIALOG_CONECTAR, DIALOG_STYLE_PASSWORD, "Conectando", "{FFFFFF}Insira sua senha para conectar-se:", "Conectar", "Sair");

            format(pInfo[playerid][Senha], MAX_PASSWORD, DOF2::GetString(Account(playerid), "Senha"));
            format(pInfo[playerid][UltimoLogin], 24, DOF2::GetString(Account(playerid), "UltimoLogin"));

            if(!strcmp(pInfo[playerid][Senha], inputtext))
            {
                GivePlayerMoney(playerid, DOF2::GetInt(Account(playerid), "Dinheiro"));
                SetPlayerScore(playerid, DOF2::GetInt(Account(playerid), "Level"));
                SetPlayerSkin(playerid, DOF2::GetInt(Account(playerid), "Skin"));
                SetPlayerInterior(playerid, DOF2::GetInt(Account(playerid), "Interior"));
                SetPlayerWantedLevel(playerid, DOF2::GetInt(Account(playerid), "Estrelas"));

                pInfo[playerid][Admin] = DOF2::GetInt(Account(playerid), "Admin");
                pInfo[playerid][Vip] = DOF2::GetInt(Account(playerid), "VIP");
                pInfo[playerid][Organizacao] = DOF2::GetInt(Account(playerid), "Organizacao");
                pInfo[playerid][Cargo] = DOF2::GetInt(Account(playerid), "Cargo");
				pInfo[playerid][xp] = DOF2::GetInt(Account(playerid), "xp");

                pInfo[playerid][Logado] = true;
                pInfo[playerid][Spawnou] = true;
                SendClientMessage(playerid, -1, "[!] Entrada efetuada com sucesso.");

                SetSpawnInfo(playerid, NO_TEAM, DOF2::GetInt(Account(playerid), "Skin"), 1154.7363,-1767.0729,16.5938,0.0000,0,0,0,0,0,0);
                SetCameraBehindPlayer(playerid);
                SpawnPlayer(playerid);
            }
            else
            {
                pInfo[playerid][Tentativas]++;
                if(pInfo[playerid][Tentativas] >= MAX_ATTEMPS_PASSWORD) return Kick(playerid);

                new dialog[90];
                format(dialog, sizeof(dialog), "{FFFFFF}Insira sua senha para conectar-se:\n\n{FF0000}* Senha incorreta (%i/%i).", pInfo[playerid][Tentativas], MAX_ATTEMPS_PASSWORD);
                ShowPlayerDialog(playerid, DIALOG_CONECTAR, DIALOG_STYLE_PASSWORD, "Conectando", dialog, "Conectar", "Sair");
            }
        }
    }
    
    //painel de login adm
    
    switch(dialogid)
    {
        case DIALOG_CADASTRO_ADM:
        {
            if(!response)
                return Kick(playerid);

            if(!(MIN_PASSWORD <= strlen(inputtext) <= MAX_PASSWORD))
            {
                new dialog[100];
                format(dialog, sizeof(dialog), "{FFFFFF}Insira uma senha adm para cadastrar-se:\n\n{FF0000}* Insira uma senha adm entre %i a %i caracteres.", MIN_PASSWORD, MAX_PASSWORD);
                ShowPlayerDialog(playerid, DIALOG_CADASTRO_ADM, DIALOG_STYLE_PASSWORD, "Cadastro", dialog, "Cadastrar", "Sair");
            }
            else
            {
                format(pInfo[playerid][SenhaAdm], MAX_PASSWORD, inputtext);

                // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //

                DOF2::CreateFile(Account(playerid));
                DOF2::SetString(Account(playerid), "SenhaAdm", pInfo[playerid][SenhaAdm]);
                DOF2::SaveFile();

                // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //

                GivePlayerMoney(playerid, NOVATO_DINHEIRO_INICIAL);
                SendClientMessage(playerid, -1, "[!] Cadastro da senha adm efetuado com sucesso.");
            }
        }

        case DIALOG_CONECTAR_ADM:
        {
            if(!response)
                return Kick(playerid);

            if(!strlen(inputtext))
                return ShowPlayerDialog(playerid, DIALOG_CONECTAR_ADM, DIALOG_STYLE_PASSWORD, "Conectando", "{FFFFFF}Insira sua senha ADM para conectar-se:", "Conectar", "Sair");

            format(pInfo[playerid][SenhaAdm], MAX_PASSWORD, DOF2::GetString(Account(playerid), "SenhaAdm"));

            if(!strcmp(pInfo[playerid][SenhaAdm], inputtext))
            {
                pInfo[playerid][Admin] = DOF2::GetInt(Account(playerid), "Admin");
                LogadoAdm[playerid] = true;
                SendClientMessage(playerid, -1, "[!] Entrada efetuada na adm com sucesso.");
            }
            else
            {
                pInfo[playerid][Tentativas]++;
                if(pInfo[playerid][Tentativas] >= MAX_ATTEMPS_PASSWORD) return Kick(playerid);

                new dialog[90];
                format(dialog, sizeof(dialog), "{FFFFFF}Insira sua senha adm para conectar-se:\n\n{FF0000}* Senha incorreta (%i/%i).", pInfo[playerid][Tentativas], MAX_ATTEMPS_PASSWORD);
                ShowPlayerDialog(playerid, DIALOG_CONECTAR_ADM, DIALOG_STYLE_PASSWORD, "Conectando", dialog, "Conectar", "Sair");
            }
        }
    }
	// Dialog Das ORGS
	if(dialogid == 666)
    {
        new playername[MAX_PLAYER_NAME], string[128];
        GetPlayerName(playerid, playername, sizeof(playername));
        if(response)
        {
            pInfo[playerid][Organizacao] = GetPVarInt(playerid, "OrgConvidado"); 
            pInfo[playerid][Cargo] = 1;
            format(string, sizeof(string), "%s aceitou seu Convite.", playername); 
            SendClientMessage(GetPVarInt(playerid, "QuemConvidou"), 0x00FF00FF, string); 
            format(string, sizeof(string), "%s E o mais novo membro da Organizacao", playername);
            SendFamilyMessage(pInfo[playerid][Organizacao], GetPlayerColor(playerid), string); 
            SendClientMessage(playerid, 0x00FF00FF, "Você aceitou o Convite."); 
            DeletePVar(playerid, "OrgConvidado"); 
            DeletePVar(playerid, "QuemConvidou"); 
            SpawnPlayer(playerid); 
        }
        else 
        {
            format(string, sizeof(string), "%s rejeitou seu Convite.", playername); 
            SendClientMessage(GetPVarInt(playerid, "QuemConvidou"), 0x00FF00FF, string); 
            SendClientMessage(playerid, 0x00FF00FF, "Voce rejeitou o Convite.");
            DeletePVar(playerid, "OrgConvidado");
            DeletePVar(playerid, "QuemConvidou"); 
        }
    }
    //Banco Dialog
    GetPlayerName(playerid,nome,24);
    if(dialogid == DDEPOSITO)
    {
        if(response)
        {
            format(b_file,sizeof b_file,ContaBanco,nome);
            if(GetPlayerMoney(playerid) < strval(inputtext)) return SendClientMessage(playerid,-1,"Voce nao tem tudo isso a depositar.");
            format(strt,50,"voce depositou R$%d.",strval(inputtext));
            DOF2_SetInt(b_file, "Dinheiro", strval(inputtext)+DOF2_GetInt(b_file,"Dinheiro"));
            DOF2_SaveFile();
            SendClientMessage(playerid,-1,strt);
            GivePlayerMoney(playerid,-strval(inputtext));
            ShowPlayerDialog(playerid,MENUBP,DIALOG_STYLE_LIST,"Menu bancario","Deposito\nSaque\nSaldo","Ok","Fechar");
            return 1;
        }
        return 1;
    }
    if(dialogid == DSAQUE)
    {
        format(b_file,sizeof b_file,ContaBanco,nome);
        if(response)
        {
            if(strval(inputtext) <= DOF2_GetInt(b_file,"Dinheiro"))
            {
                format(strt,sizeof strt,"Voce sacou R$%d, mas tem depositado R$%d",strval(inputtext),DOF2_GetInt(b_file,"Dinheiro")-strval(inputtext));
                DOF2_SetInt(b_file, "Dinheiro",DOF2_GetInt(b_file,"Dinheiro")-strval(inputtext));
                SendClientMessage(playerid,-1,strt);
                DOF2_SaveFile();
                GivePlayerMoney(playerid, strval(inputtext));
                ShowPlayerDialog(playerid,MENUBP,DIALOG_STYLE_LIST,"Menu bancorio","Deposito\nSaque\nSaldo","Ok","Fechar");
            }
            else
            {
                SendClientMessage(playerid,-1,"nao possui tudo isso.");
                ShowPlayerDialog(playerid,MENUBP,DIALOG_STYLE_LIST,"Menu bancario","Deposito\nSaque\nSaldo","Ok","Fechar");
            }
            return 1;
        }
        return 1;
    }
    if(dialogid == MENUBP)
    {
        if(response)
        {

            if(listitem == 0) return ShowPlayerDialog(playerid,DDEPOSITO,DIALOG_STYLE_INPUT,"banco",quantidade,"ok","fechar");
            if(listitem == 1) return ShowPlayerDialog(playerid,DSAQUE,DIALOG_STYLE_INPUT,"banco",quantidade,"ok","fechar");
            if(listitem == 2)
            {
                format(b_file,sizeof b_file,ContaBanco,nome);
                format(strt,50,"voce ainda tem depositado R$%d",DOF2_GetInt(b_file,"Dinheiro"));
                ShowPlayerDialog(playerid,664,DIALOG_STYLE_MSGBOX,"banco",strt,"ok","");
                return 1;
            }
            return 1;
        }
        return 1;
    }
    if(dialogid == MENUBR)
    {
        format(b_file,sizeof b_file,ContaBanco,nome);
        if(response)
        {
            if(listitem == 0)
            {
                if(DOF2_GetBool(b_file,"Registro Bancario") == false) return ShowPlayerDialog(playerid,DSENHAR,DIALOG_STYLE_INPUT,"Menu bancario","escolha sua senha bancaria, pois sem ela voce nao podera usar o banco!","Ok","Fechar");
                else return SendClientMessage(playerid,-1,"Voce ja tem uma conta no banco!");
            }
            if(listitem == 1)
            {
                if(DOF2_GetBool(b_file,"Registro Bancario") == true) return ShowPlayerDialog(playerid,BDEL,DIALOG_STYLE_INPUT,"Menu bancario","Digite sua senha para desativar sua Conta bancaria.","Ok","Fechar");
                else return SendClientMessage(playerid,-1,"Voce nao possui uma conta para poder desativar!");
            }
            if(listitem == 2)
            {
               if(DOF2_GetBool(b_file,"Registro Bancario") == true) return ShowPlayerDialog(playerid,SENHA,DIALOG_STYLE_INPUT,"Menu bancario","Mude sua senha aqui, primeiro digite sua senha antiga, depois a nova!","Ok","Fechar");
               else { SendClientMessage(playerid,-1,"Voce nao tem uma conta para poder mudar a senha."); }
               return 1;
            }
            return 1;
        }
    }
    if(dialogid == BDEL)
    {
        if(response)
        {
            format(b_file,sizeof b_file,ContaBanco,nome);
            if(strcmp(inputtext,DOF2_GetString(b_file,"Senha Bancaria"),true) == 0)
            {
                format(strt,sizeof strt,"Seu Dinheiro foi devolvido. (R$%d)",DOF2_GetInt(b_file,"Dinheiro"));
                DOF2_SetBool(b_file,"Registro Bancario",false);
                DOF2_SetString(b_file,"Senha Bancaria","Conta desativada pelo usuario.");
                GivePlayerMoney(playerid,DOF2_GetInt(b_file,"Dinheiro"));
                DOF2_SetInt(b_file,"Dinheiro",0);
                DOF2_SaveFile();
                GivePlayerMoney(playerid,-50);
                SendClientMessage(playerid,-1,strt);
                SendClientMessage(playerid,-1,"Uma taxa de R$50,00 foi cobrada para desativar sua Conta.");
                return 1;
            }
            else return ShowPlayerDialog(playerid,BDEL,DIALOG_STYLE_INPUT,"Menu bancario","Senha errada, tente outra vez.","Ok","Fechar");
        }
        return 1;
    }
    if(dialogid == DSENHAR)
    {
        format(b_file,sizeof b_file,ContaBanco,nome);
        if(response)
        {
            new string[35];
            format(string,sizeof string,"Sua senha e: %s",inputtext);
            if(!strlen(inputtext)) return ShowPlayerDialog(playerid,DSENHAR,DIALOG_STYLE_INPUT,"Menu bancario","Digite uma senha. (letras e numeros)","Ok","Fechar");
            DOF2_SetString(b_file,"Senha Bancaria",inputtext);
            DOF2_SetBool(b_file,"Registro Bancario",true);
            DOF2_SaveFile();
            SendClientMessage(playerid,-1,string);
            return 1;
        }
        return 1;
    }
    if(dialogid == DSENHAL)
    {
        if(response)
        {
            format(b_file,sizeof b_file,ContaBanco,nome);
            if(strcmp(inputtext,DOF2_GetString(b_file,"Senha Bancaria"),true) == 0) { ShowPlayerDialog(playerid,MENUBP,DIALOG_STYLE_LIST,"Menu bancario","Deposito\nSaque\nSaldo","Ok","Fechar"); }
            else {SendClientMessage(playerid,-1,"Senha errada!");}
            return 1;
        }
        return 1;
    }
    if(dialogid == SENHA)
    {
        new strs[30];
        format(b_file,sizeof b_file,ContaBanco,nome);
        if(response)
        {
            if(mudou[playerid] == false)
            {
                if(strcmp(inputtext,DOF2_GetString(b_file,"Senha Bancaria"),true) == 0)
                {
                    ShowPlayerDialog(playerid,SENHA,DIALOG_STYLE_INPUT,"Menu bancario","Insira sua nova senha bancaria(nao se esqueca dela por nada!)","Ok","Fechar");
                    mudou[playerid] = true;
                }
                else { ShowPlayerDialog(playerid,SENHA,DIALOG_STYLE_INPUT,"Menu bancario","Senha errada, tente outra vez.","Ok","Fechar"); }
                return 1;
            }
            if(mudou[playerid] == true)
            {
                if(strcmp(inputtext,DOF2_GetString(b_file,"Senha Bancaria"),true) == 0) return ShowPlayerDialog(playerid,SENHA,DIALOG_STYLE_INPUT,"Menu bancario","Sua nova senha e igual a antiga.\n\n\nDigite outra senha!","Ok","Fechar");
                if(strlen(inputtext) < 0 || strlen(inputtext) > 20) return ShowPlayerDialog(playerid,SENHA,DIALOG_STYLE_INPUT,"Menu bancario","Sua senha nao pode ter menos de 1 digito nem mais de 20.","Ok","Fechar");
                DOF2_SetString(b_file,"Senha Bancaria",inputtext);
                DOF2_SaveFile();
                SendClientMessage(playerid,-1,strs);
                mudou[playerid] = false;
            }
            return 1;
        }
        return 1;
    }

    if(dialogid == GPS)
    {
        if(response)
        {
            if(listitem == 0)
            {
                // Local Banco
                SetPlayerCheckpoint(playerid, EntradaBanco, 8.0);
                SendClientMessage(playerid, C_VERDE, "[GPS]:{FFFFFF}Local Marcado.");
            }
            else if(listitem == 1)
            {
                // Local Pref
                SetPlayerCheckpoint(playerid, EntradaPref, 8.0);
                SendClientMessage(playerid, C_VERDE, "[GPS]:{FFFFFF}Local Marcado.");
            }
            else if(listitem == 2)
            {
                SetPlayerCheckpoint(playerid, EntradaDP, 8.0);
                SendClientMessage(playerid, C_VERDE, "[GPS]:{FFFFFF}Local Marcado.");
            }
            else if(listitem == 3)//Conce
            {
                SetPlayerCheckpoint(playerid, 2149.5764,-1172.2236,23.8203, 8.0);
                SendClientMessage(playerid, C_VERDE, "[GPS]:{FFFFFF}Local Marcado.");
            }
        }
    }

    if(dialogid == Profissoes)
    {
        if(response)
        {
            if(listitem == 0)
            {
                //Desempregado
                
            }
            else if(listitem == 1)
            {
                //Motorista De Onibus
        
            }
        }
    }

    if(dialogid == Dialog_Carros)
    {
        if(response)
        {
            if(listitem == 0)
            {
                if(InfoCarro[playerid][TemCarro] ==1) return SendClientMessage(playerid, COR_ERRO, "Voce So Pode Comprar Um Carro Ou Uma Moto");
                if(GetPlayerMoney(playerid) < 500) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce nao Tem Dinheiro Suficiente!");
                new Float:Pos[4];
                GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
                GetPlayerFacingAngle(playerid, Pos[3]);
                CarroCriado[playerid] = CreateVehicle(481, Pos[0], Pos[1], Pos[2], Pos[3], -0, -0, -1);
                SendClientMessage(playerid, 0xFFFFFFAA, "Veiculo Comprado com Sucesso!");
                GivePlayerMoney(playerid, -500);
                InfoCarro[playerid][TemCarro] =1;
            }
            if(listitem == 1)
            {
                if(InfoCarro[playerid][TemCarro] ==1) return SendClientMessage(playerid, COR_ERRO, "Voce So Pode Comprar Um Carro Ou Uma Moto");
                if(GetPlayerMoney(playerid) < 1000) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce nao Tem Dinheiro Suficiente!");
                new Float:Pos[4];
                GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
                GetPlayerFacingAngle(playerid, Pos[3]);
                CarroCriado[playerid] = CreateVehicle(602, Pos[0], Pos[1], Pos[2], Pos[3], -0, -0, -1);
                SendClientMessage(playerid, 0xFFFFFFAA, "Veiculo Comprado com Sucesso!");
                GivePlayerMoney(playerid, -1000);
                InfoCarro[playerid][TemCarro] =1;
            }
            if(listitem == 2)
            {
                if(InfoCarro[playerid][TemCarro] ==1) return SendClientMessage(playerid, COR_ERRO, "Voce So Pode Comprar Um Carro Ou Uma Moto");
                if(GetPlayerMoney(playerid) < 2000) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce nao Tem Dinheiro Suficiente!");
                new Float:Pos[4];
                GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
                GetPlayerFacingAngle(playerid, Pos[3]);
                CarroCriado[playerid] = CreateVehicle(401, Pos[0], Pos[1], Pos[2], Pos[3], -0, -0, -1);
                SendClientMessage(playerid, 0xFFFFFFAA, "Veiculo Comprado com Sucesso!");
                GivePlayerMoney(playerid, -2000);
                InfoCarro[playerid][TemCarro] =1;
            }
            if(listitem == 3)
            {
                if(InfoCarro[playerid][TemCarro] ==1) return SendClientMessage(playerid, COR_ERRO, "Voce So Pode Comprar Um Carro Ou Uma Moto");
                if(GetPlayerMoney(playerid) < 3000) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce nao Tem Dinheiro Suficiente!");
                new Float:Pos[4];
                GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
                GetPlayerFacingAngle(playerid, Pos[3]);
                CarroCriado[playerid] = CreateVehicle(527, Pos[0], Pos[1], Pos[2], Pos[3], -0, -0, -1);
                SendClientMessage(playerid, 0xFFFFFFAA, "Veiculo Comprado com Sucesso!");
                GivePlayerMoney(playerid, -3000);
                InfoCarro[playerid][TemCarro] =1;
            }
            if(listitem == 4)
            {
                if(InfoCarro[playerid][TemCarro] ==1) return SendClientMessage(playerid, COR_ERRO, "Voce So Pode Comprar Um Carro Ou Uma Moto");
                if(GetPlayerMoney(playerid) < 4000) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce nao Tem Dinheiro Suficiente!");
                new Float:Pos[4];
                GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
                GetPlayerFacingAngle(playerid, Pos[3]);
                CarroCriado[playerid] = CreateVehicle(419, Pos[0], Pos[1], Pos[2], Pos[3], -0, -0, -1);
                SendClientMessage(playerid, 0xFFFFFFAA, "Veiculo Comprado com Sucesso!");
                GivePlayerMoney(playerid, -4000);
                InfoCarro[playerid][TemCarro] =1;
            }
            if(listitem == 5)
            {
                if(InfoCarro[playerid][TemCarro] ==1) return SendClientMessage(playerid, COR_ERRO, "Voce So Pode Comprar Um Carro Ou Uma Moto");
                if(GetPlayerMoney(playerid) < 5000) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce nao Tem Dinheiro Suficiente!");
                new Float:Pos[4];
                GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
                GetPlayerFacingAngle(playerid, Pos[3]);
                CarroCriado[playerid] = CreateVehicle(526, Pos[0], Pos[1], Pos[2], Pos[3], -0, -0, -1);
                SendClientMessage(playerid, 0xFFFFFFAA, "Veiculo Comprado com Sucesso!");
                GivePlayerMoney(playerid, -5000);
                InfoCarro[playerid][TemCarro] =1;
            }
            if(listitem == 6)
            {
                if(InfoCarro[playerid][TemCarro] ==1) return SendClientMessage(playerid, COR_ERRO, "Voce So Pode Comprar Um Carro Ou Uma Moto");
                if(GetPlayerMoney(playerid) < 6000) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce nao Tem Dinheiro Suficiente!");
                new Float:Pos[4];
                GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
                GetPlayerFacingAngle(playerid, Pos[3]);
                CarroCriado[playerid] = CreateVehicle(545, Pos[0], Pos[1], Pos[2], Pos[3], -0, -0, -1);
                SendClientMessage(playerid, 0xFFFFFFAA, "Veiculo Comprado com Sucesso!");
                GivePlayerMoney(playerid, -6000);
                InfoCarro[playerid][TemCarro] =1;
            }
            if(listitem == 7)
            {
                if(InfoCarro[playerid][TemCarro] ==1) return SendClientMessage(playerid, COR_ERRO, "Voce So Pode Comprar Um Carro Ou Uma Moto");
                if(GetPlayerMoney(playerid) < 7000) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce nao Tem Dinheiro Suficiente!");
                new Float:Pos[4];
                GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
                GetPlayerFacingAngle(playerid, Pos[3]);
                CarroCriado[playerid] = CreateVehicle(436, Pos[0], Pos[1], Pos[2], Pos[3], -0, -0, -1);
                SendClientMessage(playerid, 0xFFFFFFAA, "Veiculo Comprado com Sucesso!");
                GivePlayerMoney(playerid, -7000);
                InfoCarro[playerid][TemCarro] =1;
                }
            if(listitem == 8)
            {
                if(InfoCarro[playerid][TemCarro] ==1) return SendClientMessage(playerid, COR_ERRO, "Voce So Pode Comprar Um Carro Ou Uma Moto");
                if(GetPlayerMoney(playerid) < 8000) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce nao Tem Dinheiro Suficiente!");
                new Float:Pos[4];
                GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
                GetPlayerFacingAngle(playerid, Pos[3]);
                CarroCriado[playerid] = CreateVehicle(439, Pos[0], Pos[1], Pos[2], Pos[3], -0, -0, -1);
                SendClientMessage(playerid, 0xFFFFFFAA, "Veiculo Comprado com Sucesso!");
                GivePlayerMoney(playerid, -8000);
                InfoCarro[playerid][TemCarro] =1;
            }
            if(listitem == 9)
            {
                if(InfoCarro[playerid][TemCarro] ==1) return SendClientMessage(playerid, COR_ERRO, "Voce So Pode Comprar Um Carro Ou Uma Moto");
                if(GetPlayerMoney(playerid) < 9000) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce nao Tem Dinheiro Suficiente!");
                new Float:Pos[4];
                GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
                GetPlayerFacingAngle(playerid, Pos[3]);
                CarroCriado[playerid] = CreateVehicle(507, Pos[0], Pos[1], Pos[2], Pos[3], -0, -0, -1);
                SendClientMessage(playerid, 0xFFFFFFAA, "Veiculo Comprado com Sucesso!");
                GivePlayerMoney(playerid, -9000);
                InfoCarro[playerid][TemCarro] =1;
            }
            if(listitem == 10)
            {
                if(InfoCarro[playerid][TemCarro] ==1) return SendClientMessage(playerid, COR_ERRO, "Voce So Pode Comprar Um Carro Ou Uma Moto");
                if(GetPlayerMoney(playerid) < 10000) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce nao Tem Dinheiro Suficiente!");
                new Float:Pos[4];
                GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
                GetPlayerFacingAngle(playerid, Pos[3]);
                CarroCriado[playerid] = CreateVehicle(546, Pos[0], Pos[1], Pos[2], Pos[3], -0, -0, -1);
                SendClientMessage(playerid, 0xFFFFFFAA, "Veiculo Comprado com Sucesso!");
                GivePlayerMoney(playerid, -10000);
                InfoCarro[playerid][TemCarro] =1;
            }
            if(listitem == 11)
            {
                if(InfoCarro[playerid][TemCarro] ==1) return SendClientMessage(playerid, COR_ERRO, "Voce So Pode Comprar Um Carro Ou Uma Moto");
                if(GetPlayerMoney(playerid) < 11000) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce nao Tem Dinheiro Suficiente!");
                new Float:Pos[4];
                GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
                GetPlayerFacingAngle(playerid, Pos[3]);
                CarroCriado[playerid] = CreateVehicle(467, Pos[0], Pos[1], Pos[2], Pos[3], -0, -0, -1);
                SendClientMessage(playerid, 0xFFFFFFAA, "Veiculo Comprado com Sucesso!");
                GivePlayerMoney(playerid, -11000);
                InfoCarro[playerid][TemCarro] =1;
            }
            if(listitem == 12)
            {
                if(InfoCarro[playerid][TemCarro] ==1) return SendClientMessage(playerid, COR_ERRO, "Voce So Pode Comprar Um Carro Ou Uma Moto");
                if(GetPlayerMoney(playerid) < 12000) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce nao Tem Dinheiro Suficiente!");
                new Float:Pos[4];
                GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
                GetPlayerFacingAngle(playerid, Pos[3]);
                CarroCriado[playerid] = CreateVehicle(547, Pos[0], Pos[1], Pos[2], Pos[3], -0, -0, -1);
                SendClientMessage(playerid, 0xFFFFFFAA, "Veiculo Comprado com Sucesso!");
                GivePlayerMoney(playerid, -12000);
                InfoCarro[playerid][TemCarro] =1;
            }
            if(listitem == 13)
            {
                if(InfoCarro[playerid][TemCarro] ==1) return SendClientMessage(playerid, COR_ERRO, "Voce So Pode Comprar Um Carro Ou Uma Moto");
                if(GetPlayerMoney(playerid) < 13000) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce nao Tem Dinheiro Suficiente!");
                new Float:Pos[4];
                GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
                GetPlayerFacingAngle(playerid, Pos[3]);
                CarroCriado[playerid] = CreateVehicle(566, Pos[0], Pos[1], Pos[2], Pos[3], -0, -0, -1);
                SendClientMessage(playerid, 0xFFFFFFAA, "Veiculo Comprado com Sucesso!");
                GivePlayerMoney(playerid, -13000);
                InfoCarro[playerid][TemCarro] =1;
            }
            if(listitem == 14)
            {
                if(InfoCarro[playerid][TemCarro] ==1) return SendClientMessage(playerid, COR_ERRO, "Voce So Pode Comprar Um Carro Ou Uma Moto");
                if(GetPlayerMoney(playerid) < 14000) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce nao Tem Dinheiro Suficiente!");
                new Float:Pos[4];
                GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
                GetPlayerFacingAngle(playerid, Pos[3]);
                CarroCriado[playerid] = CreateVehicle(522, Pos[0], Pos[1], Pos[2], Pos[3], -0, -0, -1);
                SendClientMessage(playerid, 0xFFFFFFAA, "Veiculo Comprado com Sucesso!");
                GivePlayerMoney(playerid, -14000);
                InfoCarro[playerid][TemCarro] =1;
            }
            if(listitem == 15)
            {
                if(InfoCarro[playerid][TemCarro] ==1) return SendClientMessage(playerid, COR_ERRO, "Voce So Pode Comprar Um Carro Ou Uma Moto");
                if(GetPlayerMoney(playerid) < 15000) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce nao Tem Dinheiro Suficiente!");
                new Float:Pos[4];
                GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
                GetPlayerFacingAngle(playerid, Pos[3]);
                CarroCriado[playerid] = CreateVehicle(461, Pos[0], Pos[1], Pos[2], Pos[3], -0, -0, -1);
                SendClientMessage(playerid, 0xFFFFFFAA, "Veiculo Comprado com Sucesso!");
                GivePlayerMoney(playerid, -15000);
                InfoCarro[playerid][TemCarro] =1;
            }
            if(listitem == 16)
            {
                if(InfoCarro[playerid][TemCarro] ==1) return SendClientMessage(playerid, COR_ERRO, "Voce So Pode Comprar Um Carro Ou Uma Moto");
                if(GetPlayerMoney(playerid) < 16000) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce nao Tem Dinheiro Suficiente!");
                new Float:Pos[4];
                GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
                GetPlayerFacingAngle(playerid, Pos[3]);
                CarroCriado[playerid] = CreateVehicle(451, Pos[0], Pos[1], Pos[2], Pos[3], -0, -0, -1);
                SendClientMessage(playerid, 0xFFFFFFAA, "Veiculo Comprado com Sucesso!");
                GivePlayerMoney(playerid, -16000);
                InfoCarro[playerid][TemCarro] =1;
            }
            if(listitem == 17)
            {
                if(InfoCarro[playerid][TemCarro] ==1) return SendClientMessage(playerid, COR_ERRO, "Voce So Pode Comprar Um Carro Ou Uma Moto");
                if(GetPlayerMoney(playerid) < 17000) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce nao Tem Dinheiro Suficiente!");
                new Float:Pos[4];
                GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
                GetPlayerFacingAngle(playerid, Pos[3]);
                CarroCriado[playerid] = CreateVehicle(506, Pos[0], Pos[1], Pos[2], Pos[3], -0, -0, -1);
                SendClientMessage(playerid, 0xFFFFFFAA, "Veiculo Comprado com Sucesso!");
                GivePlayerMoney(playerid, -17000);
                InfoCarro[playerid][TemCarro] =1;
            }
            if(listitem == 18)
            {
                if(InfoCarro[playerid][TemCarro] ==1) return SendClientMessage(playerid, COR_ERRO, "Voce So Pode Comprar Um Carro Ou Uma Moto");
                if(GetPlayerMoney(playerid) < 18000) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce nao Tem Dinheiro Suficiente!");
                new Float:Pos[4];
                GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
                GetPlayerFacingAngle(playerid, Pos[3]);
                CarroCriado[playerid] = CreateVehicle(541, Pos[0], Pos[1], Pos[2], Pos[3], -0, -0, -1);
                SendClientMessage(playerid, 0xFFFFFFAA, "Veiculo Comprado com Sucesso!");
                GivePlayerMoney(playerid, -18000);
                InfoCarro[playerid][TemCarro] =1;
            }
            if(listitem == 19)
            {
                if(InfoCarro[playerid][TemCarro] ==1) return SendClientMessage(playerid, COR_ERRO, "Voce So Pode Comprar Um Carro Ou Uma Moto");
                if(GetPlayerMoney(playerid) < 19000) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce nao Tem Dinheiro Suficiente!");
                new Float:Pos[4];
                GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
                GetPlayerFacingAngle(playerid, Pos[3]);
                CarroCriado[playerid] = CreateVehicle(415, Pos[0], Pos[1], Pos[2], Pos[3], -0, -0, -1);
                SendClientMessage(playerid, 0xFFFFFFAA, "Veiculo Comprado com Sucesso!");
                GivePlayerMoney(playerid, -19000);
                InfoCarro[playerid][TemCarro] =1;
            }
            if(listitem == 20)
            {
                if(InfoCarro[playerid][TemCarro] ==1) return SendClientMessage(playerid, COR_ERRO, "Voce So Pode Comprar Um Carro Ou Uma Moto");
                if(GetPlayerMoney(playerid) < 20000) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce nao Tem Dinheiro Suficiente!");
                new Float:Pos[4];
                GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
                GetPlayerFacingAngle(playerid, Pos[3]);
                CarroCriado[playerid] = CreateVehicle(477, Pos[0], Pos[1], Pos[2], Pos[3], -0, -0, -1);
                SendClientMessage(playerid, 0xFFFFFFAA, "Veiculo Comprado com Sucesso!");
                GivePlayerMoney(playerid, -20000);
                InfoCarro[playerid][TemCarro] =1;
            }
        }
    }

    if(dialogid == Menu_Carro)
    {
        if(response)
        {
            if(listitem == 0)
            {
                if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,COR_ERRO,"[ERRO] Voce Nao Esta Em Um Veiculo");
                new Float:PosVeh[4],Float:RotVeh, arquivo[1000];
                GetVehiclePos(GetPlayerVehicleID(playerid),PosVeh[0],PosVeh[1],PosVeh[2]);
                GetVehicleZAngle(GetPlayerVehicleID(playerid),RotVeh);
                format(arquivo, sizeof(arquivo), "Veiculos/%s.ini", PlayerName(playerid)); //Formatamos o arquivo de acordo com o nome do player (Contas/NOME)
                if(!DOF2_FileExists(arquivo)) { DOF2_CreateFile(arquivo); }
                DOF2_SetInt(arquivo,"VeiculoID",GetVehicleModel(GetPlayerVehicleID(playerid)));
                DOF2_SetFloat(arquivo,"VehPosX",PosVeh[0]);
                DOF2_SetFloat(arquivo,"VehPosY",PosVeh[1]);
                DOF2_SetFloat(arquivo,"VehPosZ",PosVeh[2]);
                DOF2_SetFloat(arquivo,"VehPosR",RotVeh);
                DestroyVehicle(CarroCriado[playerid]);
                DOF2_SaveFile();
                SendClientMessage(playerid, -1,"Carro Salvo Com Sucesso");
            }
            if(listitem == 1)
            {
                new Float:CarregarVeh[6],IdVeh, arquivo[1000];
                format(arquivo, sizeof(arquivo), "Veiculos/%s.ini", PlayerName(playerid)); //Formatamos o arquivo de acordo com o nome do player (Contas/NOME)
                IdVeh = DOF2_GetInt(arquivo,"VeiculoID");
                CarregarVeh[0] = DOF2_GetFloat(arquivo,"VehPosX");
                CarregarVeh[1] = DOF2_GetFloat(arquivo,"VehPosY");
                CarregarVeh[2] = DOF2_GetFloat(arquivo,"VehPosZ");
                CarregarVeh[3] = DOF2_GetFloat(arquivo,"VehPosR");
                InfoCarro[playerid][Cor] = DOF2_GetInt(arquivo, "Cor");
                //Cor = DOF2_GetInt(arquivo,"Cor");
                DestroyVehicle(CarroCriado[playerid]);
                CarroCriado[playerid] = AddStaticVehicleEx(IdVeh,CarregarVeh[0],CarregarVeh[1],CarregarVeh[2],CarregarVeh[3],InfoCarro[playerid][Cor],InfoCarro[playerid][Cor],-1);
                SendClientMessage(playerid, -1, "Seu Veiculo Esta No Local Estacionado!");
                SetPlayerCheckpoint(playerid, CarregarVeh[0],CarregarVeh[1],CarregarVeh[2],3.0);
            }
            if(listitem == 2)
            {
                    new Str[250];
                    strcat(Str,  "1 {0080FF}Azul\n");
                    strcat(Str,  "2 {FF0000}Vermelho\n");
                    strcat(Str,  "3 Branco\n");
                    strcat(Str,  "4 {000000}Preto\n");
                    strcat(Str,  "5 {004000}Verde\n");
                    strcat(Str,  "6 {FF8000}Lanraja\n");
                    strcat(Str,  "7 {FFFF00}Amarelo\n");
                    ShowPlayerDialog(playerid, Pintarcarro, DIALOG_STYLE_LIST, "{FFFFFF}*-----Menu_Veiculo-----*", Str, "Confirmar ","Fechar");
            }
        }
    }
    if(dialogid == Pintarcarro)
    {
        if(response)
        {
            if(listitem == 0)
            {
            if(GetPlayerMoney(playerid) < 1000) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce nao Tem Dinheiro Suficiente!");
            new Str[222];
            format(Str,50,"Agora A Cor Do Seu Carro E Azul");
			InfoCarro[playerid][Cor] = 79;
            GivePlayerMoney(playerid,-1000);
            SendClientMessage(playerid,-1,Str);
            }
            if(listitem == 1)
            {
            if(GetPlayerMoney(playerid) < 1000) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce nao Tem Dinheiro Suficiente!");
            new Str[222];
            format(Str,50,"Agora A Cor Do Seu Carro E Vermelho");
			InfoCarro[playerid][Cor] = 3;
            GivePlayerMoney(playerid,-1000);
            SendClientMessage(playerid,-1,Str);
            }
            if(listitem == 2)
            {
            if(GetPlayerMoney(playerid) < 1000) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce nao Tem Dinheiro Suficiente!");
            new Str[222];
            format(Str,50,"Agora A Cor Do Seu Carro E Branco");
			InfoCarro[playerid][Cor] = 1;
            GivePlayerMoney(playerid,-1000);
            SendClientMessage(playerid,-1,Str);
            }
            if(listitem == 3)
            {
            if(GetPlayerMoney(playerid) < 1000) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce nao Tem Dinheiro Suficiente!");
            new Str[222];
            format(Str,50,"Agora A Cor Do Seu Carro E Preto");
			InfoCarro[playerid][Cor] = 0;
            GivePlayerMoney(playerid,-1000);
            SendClientMessage(playerid,-1,Str);
            }
            if(listitem == 4)
            {
            if(GetPlayerMoney(playerid) < 1000) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce nao Tem Dinheiro Suficiente!");
            new Str[222];
            format(Str,50,"Agora A Cor Do Seu Carro E Verde");
			InfoCarro[playerid][Cor] = 44;
            GivePlayerMoney(playerid,-1000);
            SendClientMessage(playerid,-1,Str);
            }
            if(listitem == 5)
            {
            if(GetPlayerMoney(playerid) < 1000) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce nao Tem Dinheiro Suficiente!");
            new Str[222];
            format(Str,50,"Agora A Cor Do Seu Carro E Lanraja");
			InfoCarro[playerid][Cor] = 6;
            GivePlayerMoney(playerid,-1000);
            SendClientMessage(playerid,-1,Str);
            }
            if(listitem == 6)
            {
            if(GetPlayerMoney(playerid) < 1000) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce nao Tem Dinheiro Suficiente!");
            new Str[222];
            format(Str,50,"Agora A Cor Do Seu Carro E Amarelo");
			InfoCarro[playerid][Cor] = 194;
            GivePlayerMoney(playerid,-1000);
            SendClientMessage(playerid,-1,Str);
            }

        }
    
    }
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

public OnPlayerCommandPerformed ( playerid , cmdtext[] , success )
{
    if ( success == 0 )
    {
        SendClientMessage(playerid, COR_ERRO, "{FF0000}[ERRO]:{FFFFFF}Comando Inexistente! use /comandos");
    }
    return 1;
}

/*===============================================================================================================================================================*/
//ADM Comandos
CMD:ativaradm(playerid, params[])
{
	new arquivo[180], string[440];
	if(IsPlayerAdmin(playerid))
	{
	    ShowPlayerDialog(playerid, DIALOG_CADASTRO_ADM, DIALOG_STYLE_PASSWORD, "Cadastro", "{FFFFFF}Insira uma senha para cadastrar-se:", "Cadastrar", "Sair");
	    pInfo[playerid][Admin] = 9;
        DOF2_SetInt(arquivo, "Admin", pInfo[playerid][Admin] = 9);
        SendClientMessage(playerid, -1, "{00FF00}ADMIN RCON ATIVADO COM SUCESSO");
		format(string, sizeof(string), "{00FF00}O ADMIN: {FFFFFF}%s{00FF00} ,ESTA ONLINE!!!", PlayerName(playerid));
		SendClientMessageToAll(playerid, string);
		print(string);
        SetPlayerSkin(playerid, 217);
        SetPlayerColor(playerid, COR_ADM);
		SaveAccount(playerid);
		DOF2_SaveFile();
		CarregarDados(playerid);
        SetPlayerHealth(playerid, 9.999);
	}
	else
	{
		SendClientMessage(playerid, -1, "{FF0000}ERRO!");
	}
	return 1;
}

CMD:daradmin(playerid, params[])
{
    new idadm, level, arquivo[400], strganhou[256], strdeu[256], nomedeu[MAX_PLAYER_NAME], nomeganhou[MAX_PLAYER_NAME];
    if(pInfo[playerid][Admin] < 9) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao tem autorizacao para usar este comando!");
    if(Ausente[playerid] == true) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao esta online na adm para usar este comando!");
    if(sscanf(params, "dd", idadm, level)) return SendClientMessage(playerid, 0xFF0000FF, "Use /daradmin [ID] [LEVEL]");

    GetPlayerName(playerid, nomedeu, MAX_PLAYER_NAME);
    GetPlayerName(playerid, nomeganhou, MAX_PLAYER_NAME);

    format(strganhou, sizeof(strganhou), "O Admin %s te deu Admin cargo: %s!", nomedeu, AdminLevel(idadm));
    format(strdeu, sizeof(strdeu), "Voce deu Admin Level %d cargo: %s para %s[%d]", level, AdminLevel(idadm) ,nomeganhou, idadm);
	print(strganhou);

    SendClientMessage(playerid, 0x00FF00FF, strdeu);
    SendClientMessage(idadm, 0x00FF00FF, strganhou);

    pInfo[idadm][Admin] = level;
    
    ShowPlayerDialog(idadm, DIALOG_CADASTRO_ADM, DIALOG_STYLE_PASSWORD, "Cadastro", "{FFFFFF}Insira uma senha para cadastrar-se:", "Cadastrar", "Sair");
    
    level = DOF2_SetInt(arquivo, "Admin", pInfo[playerid][Admin]);
    SetPlayerSkin(idadm, 217);
    SetPlayerColor(idadm, COR_ADM);
    SaveAccount(idadm); //Salva os Dados do Jogador!
    Ausente[idadm] = true;
    LogadoAdm[idadm] = false;

    SendClientMessage(idadm, COR_SUCESSO, "[INFO IMPORTANTE]: Lembre se da sua senha\nPara dar inicio use /Online");

    //Log
 	new String[500], Log [ ] = "Logs/Daradmin.log";
    format(String ,sizeof(String),"O administrador %s deu admin ao jogador: %s Nivel de admin setado[%d]", PlayerName(playerid), PlayerName(idadm), level);
    WriteLog(Log, String);
    return 1;
}

CMD:vips(playerid, params[])
{
	SendClientMessage(playerid, COR_SUCESSO, "VIP-ANJO [1], VIP-ARCANJO [2], VIP-DEUS [3], VIP-LENDARIO [4], VIP-MESTRE[5]");
    return 1;
}

CMD:darvip(playerid, params[])
{
    new id, days, mesv, anov, level, Datav[24], arquivo[400], strganhou[256], strdeu[256], nomedeu[MAX_PLAYER_NAME], nomeganhou[MAX_PLAYER_NAME];
    if(pInfo[playerid][Admin] < 9) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao tem autorizacao para usar este comando!");
    if(Ausente[playerid] == true) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao esta online na adm para usar este comando!");
    if(sscanf(params, "ddddd", id, level, days, mesv, anov)) return SendClientMessage(playerid, 0xFF0000FF, "Use /darvip [ID] [LEVEL] [DIAS]/[MESES]/[ANOS] (Nivel MAXIMO 3)");

    GetPlayerName(playerid, nomedeu, MAX_PLAYER_NAME);
    GetPlayerName(playerid, nomeganhou, MAX_PLAYER_NAME);

    format(strganhou, sizeof(strganhou), "O Admin %s te deu Vip Level %d por %d dias %d meses e %d anos!", nomedeu, level, days, mesv, anov);
    format(strdeu, sizeof(strdeu), "Voce deu VIP Level %d por %d dias %d meses e %d anos para %s[%d]", level, days, mesv, anov, nomeganhou, id);
	print(strganhou);

    SendClientMessage(playerid, 0x00FF00FF, strdeu);
    SendClientMessage(id, 0x00FF00FF, strganhou);

	if(level > 5)
	{
		SendClientMessage(playerid, COR_ERRO, "[ERRO] Os niveis de vip vao ate o 5(quinto) nivel");
		return 1;
	}

    pInfo[id][Vip] = level;
     
    level = DOF2_SetInt(arquivo, "VIP", pInfo[playerid][Vip]);
    format(Datav, 20, "%d/%d/%d", days, mesv, anov);
    DOF2_SetString(arquivo, "Dias-Vip", Datav);
    
    SaveAccount(id); //Salva os Dados do Jogador!
    
    //Log
 	new String[500], Log [ ] = "Logs/SetVip.log";
    format(String ,sizeof(String),"O administrador %s deu vip ao jogador: %s Nivel de vip setado[%d], Dias[%s]", PlayerName(playerid), PlayerName(id), level, Datav);
    WriteLog(Log, String);
    return 1;
}

CMD:setarmoney(playerid, params[])
{
    new id, money, arquivo[400], strganhou[256], strdeu[256], nomedeu[MAX_PLAYER_NAME], nomeganhou[MAX_PLAYER_NAME];
    if(pInfo[playerid][Admin] <= 4) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao tem autorizacao para usar este comando!");
    if(Ausente[playerid] == true) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao esta online na adm para usar este comando!");
    if(sscanf(params, "dd", id, money)) return SendClientMessage(playerid, 0xFF0000FF, "Use /setarmoney [ID] [Money]");

    GetPlayerName(playerid, nomedeu, MAX_PLAYER_NAME);
    GetPlayerName(id, nomeganhou, MAX_PLAYER_NAME);

    format(strganhou, sizeof(strganhou), "O Admin %s te deu money %d!", nomedeu, money);
    format(strdeu, sizeof(strdeu), "Voce deu Money %d para %s[%d]", money, nomeganhou, id);
	print(strganhou);

    SendClientMessage(playerid, 0x00FF00FF, strdeu);
    SendClientMessage(id, 0x00FF00FF, strganhou);

    GivePlayerMoney(id, money);
    pInfo[id][Dinheiro] = money;
    money = DOF2_SetInt(arquivo, "Dinheiro",  GetPlayerMoney(playerid));
    SaveAccount(id); //Salva os Dados do Jogador!
    
    //Log
 	new String[1240], Log [ ] = "Logs/SetMoney.log";
    format(String ,sizeof(String),"O administrador %s deu dinheiro ao jogador: %s quantidade de dinheiro setado[%d]", PlayerName(playerid), PlayerName(id), money);
    WriteLog(Log, String);
    return 1;
}

CMD:setarnivel(playerid, params[])
{
    new id, nivel, arquivo[400], strganhou[256], strdeu[256], nomedeu[MAX_PLAYER_NAME], nomeganhou[MAX_PLAYER_NAME];
    if(pInfo[playerid][Admin] <= 4) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao tem autorizacao para usar este comando!");
    if(Ausente[playerid] == true) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao esta online na adm para usar este comando!");
    if(sscanf(params, "dd", id, nivel)) return SendClientMessage(playerid, 0xFF0000FF, "Use /setarnivel [ID] [nivel]");

    GetPlayerName(playerid, nomedeu, MAX_PLAYER_NAME);
    GetPlayerName(id, nomeganhou, MAX_PLAYER_NAME);

    format(strganhou, sizeof(strganhou), "O Admin %s alterou seu nivel %d!", nomedeu, nivel);
    format(strdeu, sizeof(strdeu), "Voce alterou o nivel de %d para %s[%d]", nivel, nomeganhou, id);

	print(strganhou);
    SendClientMessage(playerid, 0x00FF00FF, strdeu);
    SendClientMessage(id, 0x00FF00FF, strganhou);

    SetPlayerScore(id, nivel);
    nivel = DOF2_SetInt(arquivo, "Score",  GetPlayerScore(id));
    SaveAccount(id); //Salva os Dados do Jogador!
    
    //Log
 	new String[1240], Log [ ] = "Logs/SetNivel.log";
    format(String ,sizeof(String),"O administrador %s deu nivel ao jogador: %s Nivel setado[%8d]", PlayerName(playerid), PlayerName(id), nivel);
    WriteLog(Log, String);
    return 1;
}

CMD:setarskin(playerid, params[])
{
    new id, skinn, arquivo[400], strganhou[256], strdeu[256], nomedeu[MAX_PLAYER_NAME], nomeganhou[MAX_PLAYER_NAME];
    if(pInfo[playerid][Admin] <= 4) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao tem autorizacao para usar este comando!");
    if(Ausente[playerid] == true) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao esta online na adm para usar este comando!");
    if(sscanf(params, "dd", id, skinn)) return SendClientMessage(playerid, 0xFF0000FF, "Use /setarskin [ID] [ID SKIN]");

    GetPlayerName(playerid, nomedeu, MAX_PLAYER_NAME);
    GetPlayerName(id, nomeganhou, MAX_PLAYER_NAME);

    format(strganhou, sizeof(strganhou), "O Admin %s Alterou sua skin para o id: %d!", nomedeu, skinn);
    format(strdeu, sizeof(strdeu), "Voce alterou a skin para o id: %d do jogador: %s[%d]", skinn, nomeganhou, id);
	print(strganhou);

    SendClientMessage(playerid, 0x00FF00FF, strdeu);
    SendClientMessage(id, 0x00FF00FF, strganhou);

    SetPlayerSkin(id, skinn);
    pInfo[id][Skin] = skinn;
    skinn = DOF2_SetInt(arquivo, "Skin",  GetPlayerSkin(id));
    SaveAccount(id); //Salva os Dados do Jogador!
    
    //Log
 	new String[500], Log [ ] = "Logs/SetSkin.log";
    format(String ,sizeof(String),"O administrador %s deu skin ao jogador: %s id da skin setado[%3d]", PlayerName(playerid), PlayerName(id), skinn);
    WriteLog(Log, String);
    return 1;
}

CMD:darlider(playerid, params[])
{
    new id, org, string[256], quemdeu[MAX_PLAYER_NAME], quemganhou[MAX_PLAYER_NAME]; //Cria váriaveis que irá armazenar o id do líder, a organização, o nome etc...
    if(pInfo[playerid][Admin] <= 6) return SendClientMessage(playerid, 0xAD0000AA, "{00E5FF}Voce nao esta autorizado a usar este Comando."); //Verifica se o player está logado na RCON, se não, returna a mensagem
    if(Ausente[playerid] == true) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao esta online na adm para usar este comando!");
    if(sscanf(params, "ii", id, org)) return SendClientMessage(playerid, 0xAD0000AA, "USE: /darlider [ID] [ORGANIZACAO]");
    if(!IsPlayerConnected(id)) return SendClientMessage(playerid, 0xAD0000AA, "Este jogador nao esta online."); //Verifica se o player que iria ser setado líder está online
    GetPlayerName(id, quemganhou, sizeof(quemganhou)); //Geta o nome de quem ganhou a lideança
    GetPlayerName(playerid, quemdeu, sizeof(quemdeu)); //Geta o nome do admin que deu o líder
    format(string, sizeof(string), "Voce deu Lider da Organizacao %s para %s(ID: %d)", GetOrgName(org), quemganhou, id); //Formata uma mensagem com o nome de quem ganhou a liderança, o nome da orgnização que foi setada e o "id"
    SendClientMessage(playerid, 0x00F6F6AA, string); //Manda a mensgem formatada para quem digitou o comando (quem deu o líder)
    format(string, sizeof(string), "%s(ID: %d) te deu lider da Organizacao %s.", quemdeu, playerid, GetOrgName(org)); //Formata uma mensgame com quem deu a liderança, o "playerid" e o nome organização setada
    SendClientMessage(id, 0x00F6F6AA, string); //Envia a mensgaem formatada para que recebeu a liderança
    format(string, sizeof(string), "%s(ID: %d) e o novo lider da Organizacao %s.", quemganhou, id, GetOrgName(org)); //Formata a mensagem...
    SendClientMessageToAll(0x00F6F6AA, string); //Envia a mensagem para todos Online
    pInfo[id][Organizacao] = org; //Seta a organização do "id"
    pInfo[id][Cargo] = 6; //Seta o cargo (liderança) do "id"
    SaveAccount(id);
    SpawnPlayer(id); //Spawna o player que rebeu a liderança
    CarregarDados(id);
    
    //Log
 	new String[500], Log [ ] = "Logs/SetLiderOrg.log";
    format(String ,sizeof(String),"O administrador %s deu lider ao jogador: %s org: %s", PlayerName(playerid), PlayerName(id), GetOrgName(org));
    WriteLog(Log, String);
    return 1; //Returnando a 1, nunca se esqueça!
}

CMD:limparchat(playerid, params[])
{
	new string[550];
    if(pInfo[playerid][Admin] <= 1) return SendClientMessage(playerid, COR_ERRO, "Voce nao tem autorizacao para usar este comando!");
    if(Ausente[playerid] == true) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao esta online na adm para usar este comando!");
    for(new b = 0; b <= 20; b++) SendClientMessage(playerid, -1, "");
    SendClientMessage(playerid, COR_SUCESSO, "CHAT LIMPO.");
    format(string, sizeof(string), "O CHAT FOI LIMPO POR: %s, %s", PlayerName(playerid), AdminLevel(playerid));
	SendClientMessageToAll(playerid, string);
	
 	//Log
 	new String[500], Log [ ] = "Logs/LimparChat.log";
    format(String ,sizeof(String),"O administrador %s limpou o chat", PlayerName(playerid));
    WriteLog(Log, String);
    return 1;
}

CMD:salvars(playerid, params[])
{
    if(pInfo[playerid][Admin] < 9) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao tem autorizacao para usar este comando!");
    if(Ausente[playerid] == true) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao esta online na adm para usar este comando!");
	new string[500];
	SaveBackup(playerid);
	SaveAccount(playerid);
	format(string, sizeof(string), "{00FF00}O Servidor Foi Salvo Com Sucesso! pelo Admin: {FFFFFF}%s:%s", PlayerName(playerid), AdminLevel(playerid));
	print(string);
	print("Contas Salvas com sucesso!");
	SendClientMessageToAll(playerid, string);
	
 	//Log
 	new String[500], Log [ ] = "Logs/SalvarS.log";
    format(String ,sizeof(String),"O administrador %s salvou o servidor", PlayerName(playerid));
    WriteLog(Log, String);
	return 1;
}

CMD:ativarbonus(playerid, params[])
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(pInfo[i][Admin]  < 7) return SendClientMessage(i, 0xFF0000FF, "Voce nao tem autorizacao para usar este comando!");
        if(Ausente[playerid] == true) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao esta online na adm para usar este comando!");
        if(pInfo[i][BonusLevel] == true) return SendClientMessage(i, -1, "{FF0000}[ERRO]: BONUS JA ESTA ATIVADO!");
        if(pInfo[i][BonusLevel] == false)
        {
            pInfo[i][BonusLevel] = true;
            SendClientMessageToAll(i, "{00FF00}[Bonus:PAY DAY]:{FF0000}BONUS AGORA ESTA ATIVADO PARA TODOS OS JOGADORES!");
        }
    }
    
    
    //Log
 	new String[500], Log [ ] = "Logs/BonusPayDay.log";
    format(String ,sizeof(String),"O administrador %s ativou o bonus PayDay ", PlayerName(playerid));
    WriteLog(Log, String);
	return 1;
}

CMD:desativarbonus(playerid, params[])
{
    if(pInfo[playerid][Admin] < 7) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao tem autorizacao para usar este comando!");
    if(Ausente[playerid] == true) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao esta online na adm para usar este comando!");
    if(pInfo[playerid][BonusLevel] == false) return SendClientMessage(playerid, -1, "{FF0000}[ERRO]: BONUS JA ESTA DESATIVADO!");
    if(pInfo[playerid][BonusLevel] == true)
    {
        pInfo[playerid][BonusLevel] = false;
        SendClientMessageToAll(playerid, "{00FF00}[Bonus:PAY DAY]:{FF0000}BONUS AGORA ESTA DESATIVADO PARA TODOS OS JOGADORES!");
    }
    
    //Log
 	new String[500], Log [ ] = "Logs/DesativoBonusPayDay.log";
    format(String ,sizeof(String),"O administrador %s desativou o bonus PayDay ", PlayerName(playerid));
    WriteLog(Log, String);
    return 1;
}

CMD:criarc(playerid, params[])
{
    if(pInfo[playerid][Admin] < 1) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao tem autorizacao para usar este comando!");
    if(Ausente[playerid] == true) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao esta online na adm para usar este comando!");
	new Float:x, Float:y, Float:z, idv;
	GetPlayerPos(playerid, x, y, z);
    if(sscanf(params, "d", idv)) return SendClientMessage(playerid, 0xFF0000FF, "Use /criarc [ID DO VEICULO]");
	CreateVehicle(idv, x, y, z, 5.5, 2, 2, 0, 0);
    
	//Log
 	new String[500], Log [ ] = "Logs/CriarV.log";
    format(String ,sizeof(String),"O administrador %s Criou um veiculo(/criarv)", PlayerName(playerid));
    WriteLog(Log, String);
	return 1;
}

CMD:infop(playerid, params[])
{
	new string[500], id;
    if(pInfo[playerid][Admin] < 5) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao tem autorizacao para usar este comando!");
    if(Ausente[playerid] == true) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao esta online na adm para usar este comando!");
    if(sscanf(params, "dd", id)) return SendClientMessage(playerid, 0xFF0000FF, "Use /infop [ID]");
    if(!IsPlayerConnected(id)) return SendClientMessage(playerid, 0xFF0000FF, "Jogador Nao Conectado!");
	format(string, sizeof(string), "{00FF00}[INFO]: Jogador:{FFFFFF}%s, {00FF00}ID:{FFFFFF}%d, {00FF00}DinheiroP:{FFFFFF}%d, {00FF00}SkinPID:{FFFFFF}%d", PlayerName(id), id, GetPlayerMoney(id), GetPlayerSkin(id));
	SendClientMessageToAll(playerid, string);
	
 	//Log
 	new String[500], Log [ ] = "Logs/DeuInfoP.log";
    format(String ,sizeof(String),"O administrador %s visualizou a info do jogador (/infop) %s", PlayerName(playerid), PlayerName(id));
    WriteLog(Log, String);
	return 1;
}

CMD:anadm(playerid, params[])
{
	new string[500], texto;
    if(pInfo[playerid][Admin] < 1) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao tem autorizacao para usar este comando!");
    if(Ausente[playerid] == true) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao esta online na adm para usar este comando!");
    if(sscanf(params, "s[500]", texto)) return SendClientMessage(playerid, 0xFF0000FF, "Use /anadm [texto]");
	format(string, sizeof(string), "{00FF00}[INFO]: MENSAGEM DOS ADMINS: {FF0000}%s diz: {FFFFFF}%s", PlayerName(playerid), texto);
	SendClientMessageToAll(playerid, string);
	print(string);
	
 	//Log
 	new String[500], Log [ ] = "Logs/AdmAnunciou.log";
    format(String ,sizeof(String),"O administrador %s Anunciou %s  (/anadm)", PlayerName(playerid), string);
    WriteLog(Log, String);
	return 1;
}

CMD:prisaoadm(playerid, params[])
{
    if(pInfo[playerid][Admin] < 3) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao tem autorizacao para usar este comando!");
    // Exemplo: /prison [id] [tempo]
    new id, time, motivo[500], String[500];
    if(sscanf(params, "dds", id, time, motivo)) return SendClientMessage(playerid, 0xFF0000FF, "Use /prisaoadm [ID] [TEMPO] [MOTIVO]");
    SendFormatMessageToAll(C_VERMELHO, "[PRISAO ADM] O Admin {FFFFFF}%s{FF0000} prendeu o jogador {FFFFFF}%s{FF0000} Tempo {FFFFFF}[%d]{FF0000}. Motivo: {FFFFFF}%s", PlayerName(playerid), PlayerName(id), time,  motivo);
	SendFormatMessage(id, C_VERMELHO, "[PRISAO ADM] O Admin prendeu voce. Motivo: {FFFFFF}%s", motivo);
    format(String, sizeof(String), "[PRISAO ADM] O Admin {FFFFFF}%s{FF0000} prendeu o jogador {FFFFFF}%s{FF0000}. Motivo: {FFFFFF}%s", PlayerName(playerid), PlayerName(id), motivo);
	print(String);
    if (IsPlayerConnected(id))
    {
        PrisonPlayer(id, time);
    }

    //Log
    new Log [ ] = "Logs/prisaoADM.log";
    format(String ,sizeof(String),"O administrador %s prendeu o jogador: %s. Motivo: %s  (/prisaoadm)", PlayerName(playerid), PlayerName(id), motivo);
    WriteLog(Log, String);
    return 1;
}

CMD:soltar(playerid, params[])
{
    if(pInfo[playerid][Admin] < 3) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao tem autorizacao para usar este comando!");
    new id, String[500];
    if(sscanf(params, "dd", id)) return SendClientMessage(playerid, C_CINZA, "USE: /soltar [ID]");
    //SendClientMessage(id, C_VERDE, "[AVISO] O Admin soltou voce da prisao. ");
    format(String, sizeof(String), "[AVISO] O Admin %s soltou o jogador %s da prisao.", PlayerName(playerid), PlayerName(id));
    SendFormatMessageToAll(C_VERDE, "[PRISAO ADM] O Admin {FFFFFF}%s{00FF00} soltou o jogador {FFFFFF} %s {00FF00} da prisao", PlayerName(playerid), PlayerName(id));
	print(String);
    if (IsPlayerConnected(id))
    {
        ReleasePlayer(id);
    }

    //Log
    new Log [ ] = "Logs/players_soltos_por_admin.log";
    format(String ,sizeof(String),"O administrador %s soltou o jogador da prisao: %s. (/soltar)", PlayerName(playerid), PlayerName(id));
    WriteLog(Log, String);
    return 1;
}

CMD:kick(playerid, params[])
{
    new id, Motivo[100], String[800];
    if(pInfo[playerid][Admin] < 3) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao tem autorizacao para usar este comando!");
    if(sscanf(params, "us[100]", id, Motivo)) return SendClientMessage(playerid, C_CINZA, "USE: /kick [ID] [Motivo]");
    if(!IsPlayerConnected(id)) return SendClientMessage(playerid, C_CINZA, "Esse jogador nao esta conectado!");
    SendFormatMessageToAll(C_VERMELHO, "[KICK] O Admin {FFFFFF}%s{FF0000} expulsou {FFFFFF}%s{FF0000}. Motivo: {FFFFFF}%s", PlayerName(playerid), PlayerName(id), Motivo);
	SendFormatMessage(id, C_VERMELHO, "[KICK] O Admin expulsou voce. Motivo: {FFFFFF}%s", Motivo);
    format(String, sizeof(String), "[KICK] O Admin {FFFFFF}%s{FF0000} expulsou {FFFFFF}%s{FF0000}. Motivo: {FFFFFF}%s", PlayerName(playerid), PlayerName(id), Motivo);
	print(String);
    Kick(id); 

    //Log
    new Log [ ] = "Logs/Kick.log";
    format(String ,sizeof(String),"O administrador %s expulsou: %s. Motivo: %s  (/kick)", PlayerName(playerid), PlayerName(id), Motivo);
    WriteLog(Log, String);
    return 1;
}

CMD:kickall(playerid, params[])
{
    for(new i = 0; i < MAX_PLAYERS; i++) // Um loop para pegar todos os Jogador Onlines!
    {
    	new String[800];
    	SetPlayerInterior(playerid, 0);
    	SaveAccount(i);
    	if(pInfo[playerid][Admin] < 9) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao tem autorizacao para usar este comando!");
        if(Ausente[playerid] == true) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao esta online na adm para usar este comando!");
		format(String,sizeof(String),"{FF0000}[KICK] O Servidor expulsou voce. Motivo: {FFFFFF}GMX");
		SendClientMessage(i, -1, String);
    	Kick(i);

    	
    	SendRconCommand("gmx");
	}
    return 1;
}


CMD:ban(playerid, params[])
{
    new id, Motivo[100], String[800];
    if(pInfo[playerid][Admin] < 3) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao tem autorizacao para usar este comando!");
    if(sscanf(params, "us[100]", id, Motivo)) return SendClientMessage(playerid, C_CINZA, "USE: /ban [ID] [Motivo]");
    if(!IsPlayerConnected(id)) return SendClientMessage(playerid, C_CINZA, "Esse jogador nao esta conectado!");
    SendFormatMessageToAll(C_VERMELHO, "[BAN] O Admin {FFFFFF}%s{FF0000} baniu {FFFFFF}%s{FF0000}. Motivo: {FFFFFF}%s", PlayerName(playerid), PlayerName(id), Motivo);
    format(String, sizeof(String), "[BAN] O Admin {FFFFFF}%s{FF0000} baniu {FFFFFF}%s{FF0000}. Motivo: {FFFFFF}%s", PlayerName(playerid), PlayerName(id), Motivo);
	print(String);
	kBan(id, Motivo);
    kBanIP(id);
    Kick(id);
    
    //Log
    new Log [ ] = "Logs/Ban.log";
    format(String ,sizeof(String),"O administrador %s baniu: %s. Motivo: %s", PlayerName(playerid), PlayerName(id), Motivo);
    WriteLog(Log, String);
    return 1;
}

CMD:desban(playerid, params[])
{
    new Conta[20], String[500];
    if(pInfo[playerid][Admin] < 6) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao tem autorizacao para usar este comando!");
    if(Ausente[playerid] == true) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao esta online na adm para usar este comando!");
    if(sscanf(params, "s[20]", Conta)) return SendClientMessage(playerid, C_CINZA, "USE: /desban [Conta]");
    format(String, sizeof(String), "Banidos/%s.ini", Conta);
    if(DOF2_FileExists(String))
    {
        DOF2_RemoveFile(String);
        SendFormatMessage(playerid, C_VERDE, "Voce desbaniu a conta de {FFFFFF}%s", Conta);
        return 1;
    }
    else SendClientMessage(playerid, C_VERMELHO, "Essa conta nao existe ou nao esta banida");
    
    //Log
    new Log [ ] = "Logs/Desban.log";
    format(String ,sizeof(String),"O administrador %s desbaniu: a conta %s. (/ban)", PlayerName(playerid), Conta);
    WriteLog(Log, String);
    return 1;
}

CMD:desbanip(playerid, params[])
{
    new IPBanido[20], String[500];
    if(pInfo[playerid][Admin] < 6) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao tem autorizacao para usar este comando!");
    if(Ausente[playerid] == true) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao esta online na adm para usar este comando!");
    if(sscanf(params, "s[20]", IPBanido)) return SendClientMessage(playerid, C_CINZA, "USE: /desbanip [IP]");
    format(String, sizeof(String), "IPs Banidos/%s.ini", IPBanido);
    if(DOF2_FileExists(String))
    {
        DOF2_RemoveFile(String);
        SendFormatMessage(playerid, C_VERDE, "Voce desbaniu o IP {FFFFFF}%s", IPBanido);
        return 1;
    }
    else SendClientMessage(playerid, C_VERMELHO, "Esse IP nao existe ou nao esta banido");
    
    //Log
    new Log [ ] = "Logs/DesbanIp.log";
    format(String ,sizeof(String),"O administrador %s desbaniu o ip: %s. (/desbanip)", PlayerName(playerid), IPBanido);
    WriteLog(Log, String);
    return 1;
}

CMD:ir(playerid, params[])
{
    if(Ausente[playerid] == true) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao esta online na adm para usar este comando!");
	if(pInfo[playerid][Admin] < 1)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando Invalido");
		return 1;
	}
	new id, string[128];
	if(sscanf(params, "u", id))
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso valido: /Ir [ID]");
		return 1;
	}
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Jogador(a) invalido(a)");
	else {
		new Float:Pos[3];
		GetPlayerPos(id, Pos[0], Pos[1], Pos[2]);
		SetPlayerPos(playerid, Pos[0], Pos[1]+1, Pos[2]);

		format(string, sizeof(string), "| ADM | O(A) %s %s veio ate voce.", AdminLevel(playerid), PlayerName(playerid));
		SendClientMessage(id, C_VERDE, string);

		format(string, sizeof(string), "| ADM | Voce foi ate o jogador(a) %s.", PlayerName(id));
		SendClientMessage(playerid, C_VERDE, string);
	}
	
 	//Log
    new String[500], Log [ ] = "Logs/TP.log";
    format(String ,sizeof(String),"O administrador %s foi ate o jogador: %s. (/ir)", PlayerName(playerid), PlayerName(id));
    WriteLog(Log, String);
	return 1;
}

CMD:calar(playerid, params[])
{
    if(Ausente[playerid] == true) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao esta online na adm para usar este comando!");
	if(pInfo[playerid][Admin] < 1 )
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando invalido");
		return 1;
	}
	new id, tempo, motivo[28], string[300];
	if(sscanf(params, "uis", id, tempo, motivo))
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso valido: /Calar [ID] [Tempo] [Motivo]");
		return 1;
	}
	if(id == INVALID_PLAYER_ID)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Jogador(a) invalido");
		return 1;
	}
	if(Calado[id] == 1)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Jogador(a) ja esta mutado");
		return 1;
	}
	if(tempo < 1 || tempo > 20)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Tempo de 1 a 20 minutos!");
		return 1;
	}
	Calado[id] = 1;

	format(string, sizeof(string), "| ADM | O(A) %s %s calou o jogador(a) %s por %i minutos. (Motivo: %s)", AdminLevel(playerid), PlayerName(playerid), PlayerName(id), tempo, motivo);
	SendClientMessageToAll(C_VERMELHO, string);
	print(string);

	format(string, sizeof(string), "| ADM | O(A) %s %s calou voca por %i minutos. (Motivo: %s)", AdminLevel(playerid), PlayerName(playerid), tempo, motivo);
	SendClientMessage(id, C_VERMELHO, string);

	format(string, sizeof(string), "| INFO | Voce calou o jogador(a) %s por %i minutos. (Motivo: %s)", PlayerName(id), tempo, motivo);
	SendClientMessage(playerid, COR_ADM, string);

	TimerCalado[id] = SetTimerEx("MutadoTimer", tempo *1000 *60, false, "i", id);
	
 	//Log
    new String[500], Log [ ] = "Logs/Mutados.log";
    format(String ,sizeof(String),"O administrador %s calou o jogador: %s. Motivo: %s", PlayerName(playerid), PlayerName(id), motivo);
    WriteLog(Log, String);
	return 1;
}

CMD:descalar(playerid, params[])
{
    if(Ausente[playerid] == true) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao esta online na adm para usar este comando!");
	if(pInfo[playerid][Admin] < 3)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando invalido");
		return 1;
	}
	new id, string[128];
	if(sscanf(params, "u", id))
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso valido: /Descalar [ID]");
		return 1;
	}
	if(id == INVALID_PLAYER_ID)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Jogador(a) invalido");
		return 1;
	}
	if(Calado[id] == 0)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Jogador(a) nao esta calado!");
		return 1;
	}
	Calado[id] = 0;

	format(string, sizeof(string), "| ADM | O(A) %s %s descalou voce.", AdminLevel(playerid), PlayerName(playerid));
	SendClientMessage(id, COR_ADM, string);

	format(string, sizeof(string), "| INFO | Voce descalou o jogador(a) %s", PlayerName(id));
	SendClientMessage(playerid, COR_ADM, string);

	KillTimer(TimerCalado[id]);
	
	    //Log
    new String[500], Log [ ] = "Logs/Desmutados.log";
    format(String ,sizeof(String),"O administrador %s descalou o jogador: %s. ", PlayerName(playerid), PlayerName(id));
    WriteLog(Log, String);
	return 1;
}

CMD:desbugarme(playerid, params[])
{
	if(GetPlayerInterior(playerid) | DOF2::GetInt(Account(playerid), "Interior") > 0)
    {
		SetPlayerInterior(playerid, 0);
		DOF2::SetInt(Account(playerid), "Interior", 0);
	}
	SpawnPlayer(playerid);
	new strd[540];
	format(strd, sizeof(strd), "{00ff00}O jogador: %s Tentou se desbugar.", PlayerName(playerid));
	SendClientMessageToAll(playerid, strd);
	CarregarDados(playerid);
	return 1;
}

CMD:demitirlider(playerid, params[])
{
    new id, motivo[128], string[128], playername[MAX_PLAYER_NAME], idname[MAX_PLAYER_NAME];
    if(pInfo[playerid][Admin] < 7) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao tem autorizacao para usar este comando!");
    if(Ausente[playerid] == true) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao esta online na adm para usar este comando!");
    if(sscanf(params, "ds[500]", id, motivo)) return SendClientMessage(playerid, 0xAD0000AA, "USE: /demitir [ID] [MOTIVO]");
    if(!IsPlayerConnected(id)) return SendClientMessage(playerid, 0xAD0000AA, "Este jogador nao esta online.");
    GetPlayerName(playerid, playername, sizeof(playername));
    GetPlayerName(id, idname, sizeof(idname));
    format(string, sizeof(string), "O Admin %s demitiu o Lider > %s da organizacao > %s.", PlayerName(playerid), idname, GetOrgName(id));
    SendFamilyMessage(pInfo[playerid][Organizacao], GetPlayerColor(playerid), string);
    format(string, sizeof(string), "o Admin %s te demitiu da Organizacao. Motivo: %s.", playername, motivo);
    SendClientMessage(id, GetPlayerColor(playerid), string);
    pInfo[id][Organizacao] = 0;
    pInfo[id][Cargo] = 0;
    SpawnPlayer(id);
    
    //Log
 	new String[500], Log [ ] = "Logs/DemissaoLider.log";
    format(String ,sizeof(String),"O administrador %s Demitiu o lider: %s. da org: %s Motivo: %s", PlayerName(playerid), idname, GetOrgName(id), motivo);
    WriteLog(Log, String);
    return 1;
}

CMD:ausente(playerid, params[])
{
	if(pInfo[playerid][Admin] < 1)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando invalido");
		return 1;
	}
	if(Ausente[playerid] == true)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce ja esta ausente");
		return 1;
	}
	SendClientMessage(playerid, COR_ERRO, "| ADM | Voce entrou em modo ausente! Para sair use (/Online)");
	Ausente[playerid] = true;
	TogglePlayerControllable(playerid, 0);
	
 	//Log
 	new String[500], Log [ ] = "Logs/AdminAusente.log";
    format(String ,sizeof(String),"O administrador %s ficou ausente", PlayerName(playerid));
    WriteLog(Log, String);
	return 1;
}

CMD:online(playerid, params[])
{
	if(pInfo[playerid][Admin] < 1)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Comando invalido");
		return 1;
	}

	if(Ausente[playerid] == false)
	{
		SendClientMessage(playerid, COR_ERRO, "| ERRO | Voce nao esta ausente");
		return 1;
	}

	SendClientMessage(playerid, COR_ERRO, "| ADM | Voce entrou em modo online novamente!");
	Ausente[playerid] = false;
	TogglePlayerControllable(playerid, 1);
    SetPlayerHealth(playerid, 9000.0);

    if(Ausente[playerid] == false)
    {
        ShowPlayerDialog(playerid, DIALOG_CONECTAR_ADM, DIALOG_STYLE_PASSWORD, "Conectando ADM", "{FFFFFF}Insira sua senha adm para conectar-se:", "Conectar", "Sair");
        StopAudioStreamForPlayer(playerid);
        LogadoAdm[playerid] = true;
        SetPlayerColor(playerid, COR_ADM);
        
        return 1;
    }
    
	
 	//Log
 	new String[500], Log [ ] = "Logs/AdminOnline.log";
    format(String ,sizeof(String),"O administrador %s esta trabalhando", PlayerName(playerid));
    WriteLog(Log, String);
	return 1;
}

CMD:irbanco(playerid,params[])
{
    if(Ausente[playerid] == true) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao esta online na adm para usar este comando!");
	if(IsPlayerAdmin(pInfo[playerid][Admin] > 0))
	{
    	SetPlayerPos(playerid,2305.6309,-16.1295,26.7496);
	}
	else
	{
	    SendClientMessage(playerid, -1, "Voce nao tem permissao para usar esse comando!");
	}
    return 1;
}

CMD:cadmin(playerid)
{
    if(pInfo[playerid][Admin] < 1) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao tem autorizacao para usar este comando!");
    if(Ausente[playerid] == true) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao esta online na adm para usar este comando!");
    ShowPlayerDialog(playerid, CADM, DIALOG_STYLE_LIST, "Comandos ADM","\n/ana nivel 1 \n/daradmin Nivel 9 \n/online nivel 1 \n/ausente nivel 1 \n/setarmoney nivel 4 \n/setarnivel nivel 4 \n/criarc nivel 1 \n/infop nivel 5 \n/ban nivel 3\n/desban nivel 6\n/ir nivel 1\n/desbanip nivel 6 \n/calar nivel 1 \n/descalar nivel 3 \n/salvars nivel 9 \n /irbanco nivel 1\n/kick nivel 3 \n/kickall nivel 9\n/darlider nivel 7 \n/ativarbonus e desativarbonus nivel 7\n/", "Informado", "Sair");
	return 1;
}

CMD:setarprocurado(playerid, params[])
{
    new id, nivelp, arquivo[400], strganhou[256], strdeu[256], nomedeu[MAX_PLAYER_NAME], nomeganhou[MAX_PLAYER_NAME];
    if(pInfo[playerid][Admin] <= 4) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao tem autorizacao para usar este comando!");
    if(Ausente[playerid] == true) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao esta online na adm para usar este comando!");
    if(sscanf(params, "dd", id, nivelp)) return SendClientMessage(playerid, 0xFF0000FF, "Use /setarprocurado [ID] [nivel]");

    GetPlayerName(playerid, nomedeu, MAX_PLAYER_NAME);
    GetPlayerName(playerid, nomeganhou, MAX_PLAYER_NAME);

    format(strganhou, sizeof(strganhou), "O Admin %s alterou seu nivel de procurado para{FFFFFF} %d!", nomedeu, nivelp);
    format(strdeu, sizeof(strdeu), "Voce alterou o nivel de procurado do jogador %s[%d] para [%d]", nomeganhou, id, nivelp);

	print(strganhou);
    SendClientMessage(playerid, 0x00FF00FF, strdeu);
    SendClientMessage(id, 0x00FF00FF, strganhou);

    SetPlayerWantedLevel(id, nivelp);
    nivelp = DOF2_SetInt(arquivo, "Estrelas",  GetPlayerWantedLevel(id));
    SaveAccount(id); //Salva os Dados do Jogador!

    //Log
 	new String[500], Log [ ] = "Logs/AdminSetProcurado.log";
    format(String ,sizeof(String),"O administrador %s deu procurado ao jogador: %s Nivel de procurado setado[%d]", PlayerName(playerid), nomeganhou, nivelp);
    WriteLog(Log, String);
	return 1;
}

/*================================================================================================================================================================================*/
//Comandos players
CMD:comandos(playerid)
{
    ShowPlayerDialog(playerid, COMANDOS, DIALOG_STYLE_LIST, "Comandos", "{FF0000}/admins \n{FF0000}/duvida \n{FF0000}/minhaorg \n{FF0000}/rg \n COMANDO ORGS: {FF0000}/membros \n{FF0000}/radio \n {FF0000}/convidar \n{FF0000}/promover \n{FF0000}/demirit \n{FF0000}/equipar \n{FF0000}/entrarbanco \n {FF0000}/sairbanco \n{FF0000}/bancomenu \n{FF0000}/infobanco \n{FF0000}/gpsbanco \n /menucarro \n /f(somente na concessionaria) ", "", "Sair");
	return 1;
}

CMD:setradio(playerid, params[])
{
    new Float:x, Float:y, Float:z, string:link[5000];
	GetPlayerPos(playerid, x, y, z);
    if(sscanf(params, "s[1000]", link)) return SendClientMessage(playerid, C_CINZA, "USE: /setradio [LINK DA MUSICA]");
	PlayAudioStreamForPlayer(playerid, string:link, x, y, z);
    //SendClientMessage(playerid, C_VERDE, "Tocando a musica: %s", link);
    return 1;
}

CMD:pararmusica(playerid, params[])
{
    StopAudioStreamForPlayer(playerid);
    SendClientMessage(playerid, C_VERDE, "[A musica parou.]");
    return 1;
}

CMD:f(playerid, params[]){
    if(IsPlayerInRangeOfPoint(playerid, 3.0, 2149.5764,-1172.2236,23.8203))
    {
	new Str[2000];
    strcat(Str,  "{FF8000}0  {FFFFFF}BMX\t\t{005500}$500\n");
    strcat(Str,  "{FF8000}1  {FFFFFF}Alfa\t\t\t{005500}$1000\n");
    strcat(Str,  "{FF8000}2  {FFFFFF}Bravura\t\t{005500}$2000\n");
    strcat(Str,  "{FF8000}3  {FFFFFF}Cadrona\t\t{005500}$3000\n");
    strcat(Str,  "{FF8000}4  {FFFFFF}esperanto\t\t{005500}$4000\n");
    strcat(Str,  "{FF8000}5  {FFFFFF}Fortuna\t\t{005500}$5000\n");
    strcat(Str,  "{FF8000}6  {FFFFFF}Hustler\t\t{005500}$6000\n");
    strcat(Str,  "{FF8000}7  {FFFFFF}Previon\t\t{005500}$7000\n");
    strcat(Str,  "{FF8000}8  {FFFFFF}Garanhao\t\t{005500}$8000\n");
    strcat(Str,  "{FF8000}9  {FFFFFF}Elegante\t\t{005500}$9000\n");
    strcat(Str,  "{FF8000}10 {FFFFFF}Intruso\t\t{005500}$10000\n");
    strcat(Str,  "{FF8000}11 {FFFFFF}Oceanico\t\t{005500}$11000\n");
    strcat(Str,  "{FF8000}12 {FFFFFF}Primo\t\t{005500}$12000\n");
    strcat(Str,  "{FF8000}13 {FFFFFF}Tahoma\t\t{005500}$13000\n");
    strcat(Str,  "{FF8000}14 {FFFFFF}NRG-500\t\t{005500}$14000\n");
    strcat(Str,  "{FF8000}15 {FFFFFF}PCJ-600\t\t{005500}$15000\n");
    strcat(Str,  "{FF8000}16 {FFFFFF}Turismo\t\t{005500}$16000\n");
    strcat(Str,  "{FF8000}17 {FFFFFF}Super GT\t\t{005500}$17000\n");
    strcat(Str,  "{FF8000}18 {FFFFFF}Bala\t\t{005500}$18000\n");
    strcat(Str,  "{FF8000}19 {FFFFFF}guepardo\t\t{005500}$19000\n");
    strcat(Str,  "{FF8000}20 {FFFFFF}ZR-350\t\t{005500}$20000\n");
	ShowPlayerDialog(playerid, Dialog_Carros, DIALOG_STYLE_LIST, "_________________________Concessionaria DE LS_____________________", Str, "Confirmar ","Fechar");
    }
    return 1;
}
CMD:menucarro(playerid){
    if(InfoCarro[playerid][TemCarro] <1) return SendClientMessage(playerid, COR_ERRO, "| ERRRO |Voce Nao Tem Nenhum Veiculo!");
    new Str[250];
    strcat(Str,  "SalvaCarro\n");
    strcat(Str,  "CarregaCarro\n");
    strcat(Str,  "Pintar Corro\t {FF8000}$1000 Para Todas As Cores\n");
    ShowPlayerDialog(playerid, Menu_Carro, DIALOG_STYLE_LIST, "{FFFFFF}*-----Menu_Veiculo-----*", Str, "Confirmar ","Fechar");
    return 1;
}

CMD:procurados(playerid)
{
    if(pInfo[playerid][Organizacao] < 1) return SendClientMessage(playerid, 0xAD0000AA, "voce nao pode usar esse comando!");
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        new string[150];
        if(GetPlayerWantedLevel(i))
        {
            format(string, sizeof(string), "{FF0000}[PROCURADO]:{FFFFFF}%s[{FF0000}ID:{FFFFFF}%d] {FF0000}Nivel De Procurado: {FFFFFF}[%d]", PlayerName(i), i,GetPlayerWantedLevel(i));
            SendClientMessage(playerid, -1,string);
        }
    }

    if(GetPlayerWantedLevel(playerid) == 0)
    {
        SendClientMessage(playerid, COR_SUCESSO,"[COPOM]:{FFFFFF}Nao Ha Procurados no momento!");
    }
    return 1;
}

CMD:rg(playerid, params[])
{
	new string[7000], string2[7000];
	format(string, sizeof(string), "{00FF00}[INFO]:{FFFFFF}%s, {00FF00}DinheiroP:{FFFFFF}%d, {00FF00}SkinPID:{FFFFFF}%d,", PlayerName(playerid), GetPlayerMoney(playerid), GetPlayerSkin(playerid));
	format(string2, sizeof(string2), "{00FF00}[INFO]:{00FF00}Anos da conta:{FFFFFF}: %d, {00FF00}Data e hora do Cadastro(Seu Aniversario no jogo): {FFFFFF}%s", DOF2::GetInt(Account(playerid), "AnosCadastrado"), DOF2_GetString(Account(playerid), "Data De Cadastro"));
	SendClientMessage(playerid, -1, string);
	SendClientMessage(playerid, -1, string2);
	return 1;
}

CMD:minhaorg(playerid)
{
	new string[900];
	format(string, sizeof(string), "{00FF00}Sua Organizacao e: {FFFFFF}%s, {00FF00} E voce esta no cargo:{FFFFFF}%d", GetOrgName(pInfo[playerid][Organizacao]), pInfo[playerid][Cargo]);
	SendClientMessage(playerid, 1, string);
	return 1;
}

CMD:admins(playerid, params[])
{
	new ajd, mod, adm, sub, staff,a ,b ,c ,d;
	new stg2[500], gStr[500], string[128];
	strcat(stg2, "Nome\tCargo\tStatus\n");
	foreach(Player, i)
	{
 		if(pInfo[i][Admin] == 9 && Ausente[i] == false)
		{
			d++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{228B22}GERENTE GERAL\t{32CD32}Online\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}

		if(pInfo[i][Admin] == 9 && Ausente[i] == true)
		{
			d++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{228B22}GERENTE GERAL\t{FF4500}Ausente\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}

 		if(pInfo[i][Admin] == 8 && Ausente[i] == false)
		{
			c++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{228B22}MAPPER\t{32CD32}Online\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}
		if(pInfo[i][Admin] == 8 && Ausente[i] == true)
		{
			c++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{228B22}MAPPER\t{FF4500}Ausente\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}

	    if(pInfo[i][Admin] == 7 && Ausente[i] == false)
		{
			b++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{228B22}GERENTE\t{32CD32}Online\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}
		if(pInfo[i][Admin] == 7 && Ausente[i] == true)
		{
			b++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{228B22}GERENTE\t{FF4500}Ausente\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}

	    if(pInfo[i][Admin] == 6 && Ausente[i] == false)
		{
			a++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{228B22}MODERADOR SENIOR\t{32CD32}Online\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}
		if(pInfo[i][Admin] == 6 && Ausente[i] == true)
		{
			a++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{228B22}MODERADOR SENIOR\t{FF4500}Ausente\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}

		if(pInfo[i][Admin] == 5 && Ausente[i] == false)
		{
			staff++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{228B22}MODERADOR\t{32CD32}Online\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}
		if(pInfo[i][Admin] == 5 && Ausente[i] == true)
		{
			staff++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{228B22}MODERADOR\t{FF4500}Ausente\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}
		if(pInfo[i][Admin] == 4 && Ausente[i] == false)
		{
			sub++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{B8860B}SUPORTE\t{32CD32}Online\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}
		if(pInfo[i][Admin] == 4 && Ausente[i] == true)
		{
			sub++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{B8860B}SUPORTE\t{FF4500}Ausente\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}
		if(pInfo[i][Admin] == 3 && Ausente[i] == false)
		{
			adm++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{1E90FF}ADMIN(a)\t{32CD32}Online\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}
		if(pInfo[i][Admin] == 3 && Ausente[i] == true)
		{
			adm++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{1E90FF}ADMIN(a)\t{FF4500}Ausente\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}
		if(pInfo[i][Admin] == 2 && Ausente[i] == false)
		{
			mod++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{FFA500}HELPER(a)\t{32CD32}Online\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}
		if(pInfo[i][Admin] == 2 && Ausente[i] == true)
		{
			mod++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{FFA500}HELPER(a)\t{FF4500}Ausente\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}
		if(pInfo[i][Admin] == 1 && Ausente[i] == false)
		{
			ajd++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{FFFF00}AUXILIAR\t{32CD32}Online\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}
		if(pInfo[i][Admin] == 1 && Ausente[i] == true)
		{
			ajd++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{FFFF00}AUXILIAR\t{FF4500}Ausente\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}
	}
	new teste = d + c + b + a + staff + sub + adm + mod + ajd;
	if(teste == 0) return ShowPlayerDialog(playerid, 9999, DIALOG_STYLE_MSGBOX, "{FFFFFF}Admins Offline", "\n{FF0000}Nenhum membro da administracao online no momento!\n\n", "Sair", "");
	format(string, sizeof(string), "{FFFFFF}Administradores Onlines [{32CD32}%d{FFFFFF}]", teste);
    ShowPlayerDialog(playerid, DIALOG_ADMINS, DIALOG_STYLE_TABLIST_HEADERS, string, stg2, "Fechar", "");
    return 1;
}
/*
CMD:admins(playerid, params[])
{
	new ajd, mod, adm, sub, staff,a ,b ,c ,d;
	new stg2[500], gStr[500], string[128];
	strcat(stg2, "Nome\tCargo\tStatus\n");
	foreach(Player, i)
	{
 		if(pInfo[i][Admin] == 9 && Ausente[i] == false)
		{
			d++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{228B22}GERENTE GERAL\t{32CD32}Online\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}

		if(pInfo[i][Admin] == 9 && Ausente[i] == true)
		{
			d++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{228B22}GERENTE GERAL\t{FF4500}Ausente\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}

 		if(pInfo[i][Admin] == 8 && Ausente[i] == false)
		{
			c++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{228B22}MAPPER\t{32CD32}Online\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}
		if(pInfo[i][Admin] == 8 && Ausente[i] == true)
		{
			c++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{228B22}MAPPER\t{FF4500}Ausente\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}

	    if(pInfo[i][Admin] == 7 && Ausente[i] == false)
		{
			b++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{228B22}GERENTE\t{32CD32}Online\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}
		if(pInfo[i][Admin] == 7 && Ausente[i] == true)
		{
			b++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{228B22}GERENTE\t{FF4500}Ausente\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}

	    if(pInfo[i][Admin] == 6 && Ausente[i] == false)
		{
			a++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{228B22}MODERADOR SENIOR\t{32CD32}Online\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}
		if(pInfo[i][Admin] == 6 && Ausente[i] == true)
		{
			a++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{228B22}MODERADOR SENIOR\t{FF4500}Ausente\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}

		if(pInfo[i][Admin] == 5 && Ausente[i] == false)
		{
			staff++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{228B22}MODERADOR\t{32CD32}Online\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}
		if(pInfo[i][Admin] == 5 && Ausente[i] == true)
		{
			staff++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{228B22}MODERADOR\t{FF4500}Ausente\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}
		if(pInfo[i][Admin] == 4 && Ausente[i] == false)
		{
			sub++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{B8860B}SUPORTE\t{32CD32}Online\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}
		if(pInfo[i][Admin] == 4 && Ausente[i] == true)
		{
			sub++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{B8860B}SUPORTE\t{FF4500}Ausente\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}
		if(pInfo[i][Admin] == 3 && Ausente[i] == false)
		{
			adm++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{1E90FF}ADMIN(a)\t{32CD32}Online\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}
		if(pInfo[i][Admin] == 3 && Ausente[i] == true)
		{
			adm++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{1E90FF}ADMIN(a)\t{FF4500}Ausente\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}
		if(pInfo[i][Admin] == 2 && Ausente[i] == false)
		{
			mod++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{FFA500}HELPER(a)\t{32CD32}Online\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}
		if(pInfo[i][Admin] == 2 && Ausente[i] == true)
		{
			mod++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{FFA500}HELPER(a)\t{FF4500}Ausente\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}
		if(pInfo[i][Admin] == 1 && Ausente[i] == false)
		{
			ajd++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{FFFF00}AUXILIAR\t{32CD32}Online\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}
		if(pInfo[i][Admin] == 1 && Ausente[i] == true)
		{
			ajd++;
			format(gStr, sizeof(gStr), "{FFFFFF}%s[%d]\t{FFFF00}AUXILIAR\t{FF4500}Ausente\n", PlayerName(i), i);
            strcat(stg2, gStr);
		}
	}
	new teste = d + c + b + a + staff + sub + adm + mod + ajd;
	if(teste == 0) return ShowPlayerDialog(playerid, 9999, DIALOG_STYLE_MSGBOX, "{FFFFFF}Admins Offline", "\n{FF0000}Nenhum membro da administracao online no momento!\n\n", "Sair", "");
	format(string, sizeof(string), "{FFFFFF}Administradores Onlines [{32CD32}%d{FFFFFF}]", teste);
    ShowPlayerDialog(playerid, DIALOG_ADMINS, DIALOG_STYLE_TABLIST_HEADERS, string, stg2, "Fechar", "");
    return 1;
}                */

CMD:duvida(playerid, params[])
{
	new duvida[550], string[1049];
	
	for(new i = 0; i < MAX_PLAYERS; i++) // Um loop para pegar todos os Jogador Onlines!
    {
        if(sscanf(params, "s[1049]", duvida))
        {
            SendClientMessage(i, COR_ERRO, "| ERRO | Uso valido: /Duvida [Texto]" );
            
            return 1;
        }

        if(pInfo[i][Admin] > 0)
		{
			format(string, sizeof(string), "| ADM | Duvida recebida de %s[%d]: %s", PlayerName(playerid), playerid, duvida);
			SendClientMessage(i, C_ROSA_CLARO, string);
			GameTextForPlayer(i, "~b~~h~DUVIDA", 5000, 4);
		}


        //Log
     	new String[500], Log [ ] = "Logs/DuvidaAdm.log";
        format(String ,sizeof(String),"DUVIDA RECEBIDA DE %s ID:[%d] MENSAGEM PARA ADM: [%s]", PlayerName(i), i, duvida);
        WriteLog(Log, String);
    }
    SendClientMessage(playerid, COR_SUCESSO, "[Duvida]: enviada com sucesso.");
	return 1;
}

CMD:rduvida(playerid, params[])
{
	new rduvida[550], id, string[1550];
	if(pInfo[playerid][Admin] <= 1) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao tem autorizacao para usar este comando!");
    if(Ausente[playerid] == true) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao esta online na adm para usar este comando!");
    if(sscanf(params, "ds[450]", id, rduvida)) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Uso valido: /rDuvida id [Texto]" );
    if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COR_ERRO, "| ERRO | Jogador n conectado!" );
	
	format(string, sizeof(string), "| ADM | RESPOSTA recebida de %s[%d]: %s", PlayerName(playerid), playerid, rduvida);
	SendClientMessage(id, C_ROSA_CLARO, string);
	GameTextForPlayer(id, "~b~~h~RESPOSTA", 5000, 4);
    SendClientMessage(playerid, COR_SUCESSO, "[RDuvida]: enviada com sucesso.");
    
    //Log
 	new String[500], Log [ ] = "Logs/RduvidaAdm.log";
    format(String ,sizeof(String),"DUVIDA RESPONDIDA DE ADM %s ID:[%d] PARA JOGADOR: %s[%d]: [%s]", PlayerName(playerid), playerid, PlayerName(id), id, rduvida);
    WriteLog(Log, String);
	return 1;
}

CMD:entrar(playerid,params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 2.0, EntradaBanco))
	{
	    SetPlayerPos(playerid,2307.8306,-15.3328,26.7496);
	    GameTextForPlayer(playerid, " ~>~ ~g~B~b~A~r~N~w~C~y~O ~<~", 5000, 3);
	}

    if(IsPlayerInRangeOfPoint(playerid, 2.0, EntradaPref))
    {
        SetPlayerPos(playerid, 384.808624,173.804992,1008.382812);
        SetPlayerInterior(playerid, 3);
        GameTextForPlayer(playerid, " ~>~ ~g~PREFEITURA~<~", 5000, 3);
    }

    if(IsPlayerInRangeOfPoint(playerid, 2.0, EntradaDP))
    {
        SetPlayerPos(playerid, 246.6382,64.0559,1003.6406);
        SetPlayerInterior(playerid, 6);
        GameTextForPlayer(playerid, " ~>~ ~g~Delegacia~<~", 5000, 3);
    }

    if(IsPlayerInRangeOfPoint(playerid, 2.0, GaragemDP))
    {
        SetPlayerPos(playerid, 1526.3118,-1678.3907,5.8906);
        SetPlayerInterior(playerid, 0);
        GameTextForPlayer(playerid, " ~>~ ~g~GARAGEM DP~<~", 5000, 3);
    }
    
    if(IsPlayerInRangeOfPoint(playerid, 2.0, LojaUm))
    {
		SetPlayerInterior(playerid, 17);
		SetPlayerPos(playerid, -25.884498,-185.868988,1003.546875);
		GameTextForPlayer(playerid, "~>~ ~g~Loja 1~<~", 5000, 3);
	}
	return 1;
}

CMD:sair(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 2.0, SaidaBanco))
	{
	    SetPlayerPos(playerid,1462.3464,-1013.2350,26.8438);
	}

    if(IsPlayerInRangeOfPoint(playerid, 2.0, SaidaPref))
    {
        SetPlayerPos(playerid, 1481.5785,-1766.4265,18.7958);
        SetPlayerInterior(playerid, 0);
    }
    
    if(IsPlayerInRangeOfPoint(playerid, 2.0, SaidaDP))
    {
        SetPlayerPos(playerid, 1552.4500,-1674.9900,16.1953);
        SetPlayerInterior(playerid, 0);
    }

    if(IsPlayerInRangeOfPoint(playerid, 2.0, IrDPPelaGaragem))
    {
        SetPlayerInterior(playerid, 6);
        SetPlayerPos(playerid, 246.3705,87.5277,1003.6406);
    }
    
    if(IsPlayerInRangeOfPoint(playerid, 2.0, LojaUmSaida))
    {
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid, 1352.3448,-1758.8737,13.5078);
	}
}

CMD:bancomenu(playerid,params[])
{
    GetPlayerName(playerid,nome,24);
    format(b_file,sizeof b_file,ContaBanco,nome);
    if(IsPlayerInRangeOfPoint(playerid,2.0,coord1) || IsPlayerInRangeOfPoint(playerid,2.0,coord2) || IsPlayerInRangeOfPoint(playerid,2.0,coord3) || IsPlayerInRangeOfPoint(playerid,2.0,coord4))
    {
        if(DOF2_GetBool(b_file,"Registro Bancario") == true) return ShowPlayerDialog(playerid,DSENHAL,DIALOG_STYLE_INPUT,"Menu bancario","Digite sua senha para acessar o banco de dados bancario.","Ok","Fechar");
        else SendClientMessage(playerid,-1,"Crie uma conta no banco para poder acessar os seus dados bancarios.");
    }
    return 1;
}

CMD:infobanco(playerid,params[])
{
    if(IsPlayerInRangeOfPoint(playerid,5.0,2309.9907,-2.3623,26.7422)) return ShowPlayerDialog(playerid,MENUBR,DIALOG_STYLE_LIST,"Menu bancario","Criar Conta Bancaria\nDeletar Conta Bancaria\nMudar Senha","Ok","Fechar");
	return 1;
}

CMD:gpsbanco(playerid,params[])
{
    SetPlayerCheckpoint(playerid, EntradaBanco,8.0);//Checkpoint Onde aparecerar
    SendClientMessage(playerid, 0xFFFFFFAA, "Va Ate o Checkpoint Vermelho em Seu Mapa.");
}

CMD:gps(playerid,params[])
{
    ShowPlayerDialog(playerid, GPS, DIALOG_STYLE_LIST, "GPS", "Banco \n Prefeitura \n Departamento De Policia \n Concessionaria LS", "Marcar", "Fechar");
    return 0;
}

//Comandos Das orgs

CMD:prender(playerid, params[])
{
    if(pInfo[playerid][Organizacao] == 0) return SendClientMessage(playerid, 0xFF0000FF, "Voce nao tem autorizacao para usar este comando!");
	else if(pInfo[playerid][Organizacao] == 6)  return SendClientMessage(playerid, 0xFF0000FF, "Voce nao tem autorizacao para usar este comando!");
	else if(pInfo[playerid][Organizacao] == 7)   return SendClientMessage(playerid, 0xFF0000FF, "Voce nao tem autorizacao para usar este comando!");
	else if(pInfo[playerid][Organizacao] == 8)  return SendClientMessage(playerid, 0xFF0000FF, "Voce nao tem autorizacao para usar este comando!");
    else if(pInfo[playerid][Organizacao] == 9)  return SendClientMessage(playerid, 0xFF0000FF, "Voce nao tem autorizacao para usar este comando!");
    // Exemplo: /prison [id] [tempo]
    new id, time, motivo[500], String[500];
    if(sscanf(params, "dds", id, time, motivo)) return SendClientMessage(playerid, 0xFF0000FF, "Use /prender [ID] [TEMPO] [MOTIVO]");
    SendFormatMessageToAll(C_VERMELHO, "[PRISAO] [%s] {FFFFFF}%s{FF0000} prendeu o jogador {FFFFFF}%s{FF0000} Tempo {FFFFFF}[%d]{FF0000}. Motivo {FFFFFF}[%s]", GetOrgName(pInfo[playerid][Organizacao]), PlayerName(playerid), PlayerName(id), time,  motivo);
	SendFormatMessage(id, C_VERMELHO, "[PRISAO] Voce foi preso. Motivo: {FFFFFF}%s", motivo);
    format(String, sizeof(String), "[PRISAO] [%s] {FFFFFF}%s{FF0000} prendeu o jogador {FFFFFF}%s{FF0000}. Motivo: {FFFFFF}%s", GetOrgName(pInfo[playerid][Organizacao]), PlayerName(playerid), PlayerName(id), motivo);
	print(String);
    if (IsPlayerConnected(id))
    {
        PrisonPlayer(id, time);
    }

    //Log
    new Log [ ] = "Logs/Prender.log";
    format(String ,sizeof(String),"O Policial [%s] da organizacao [%s] prendeu o jogador: [%]s. Motivo: [%]s  (/Prender)", GetOrgName(pInfo[playerid][Organizacao]), PlayerName(playerid), PlayerName(id), motivo);
    WriteLog(Log, String);
    return 1;
}

CMD:membros(playerid)
{
    new playername[MAX_PLAYER_NAME], string[128]; //Criamos variaveis que irão armazenar o nome e mensganes formatadas
    if(pInfo[playerid][Organizacao] >= 1)
    {
        SendClientMessage(playerid, 0xBFC0C2FF, "(=-=-=-=-=-=-=({FFD700}Membros Online{BFC0C2})=-=-=-=-=-=-=)");
        for(new i = 0; i < MAX_PLAYERS; i++) //Criamos um loop de acordo com o MAX_PLAYERS
        {
            if(IsPlayerConnected(i)) //Verifica se o "i" (player) do loop está online
            {
                if(pInfo[i][Organizacao] == pInfo[playerid][Organizacao]) //Verifica se a organização do player (do loop) é igual a do player que digitou o comando
                {
                    GetPlayerName(i, playername, sizeof(playername)); //Geta o nome do player(loop)...
                    if(pInfo[i][Cargo] <= 4) //Verifica se o player do loop e cargo 4 ou menos
                    {
                        format(string, sizeof(string), "Membro: %s, Cargo: %d", playername, pInfo[i][Cargo]); //Formata uma mensgaem com o nome e cargo do player (loop)
                        SendClientMessage(playerid, GetPlayerColor(playerid), string); //Envia a mensagem do player que digitou o comando
                    }
                    else
                    {
                        if(pInfo[i][Cargo] == 6) //Verifica se o player é Líder e formata/envia uma mensagem diferente/destacada
                        {
                            format(string, sizeof(string), "Membro: %s, Cargo: Lider", playername);
                            SendClientMessage(playerid, GetPlayerColor(playerid), string);
                        }
                        else if(pInfo[i][Cargo] == 5) //Verifica se o player é Líder e formata/envia uma mensagem diferente/destacada
                        {
                            format(string, sizeof(string), "Membro: %s, Cargo: Sub-Lider", playername);
                            SendClientMessage(playerid, GetPlayerColor(playerid), string);
                        }
                    }
                }
            }
        }
    }
    else
    {
        SendClientMessage(playerid, 0xAD0000AA, "Voce nao pertence a nenhuma organizacao.");
    }
    return 1; //Returnando a 1, nunca se esqueça!
}

CMD:radio(playerid, params[])
{
    new text[128], string[128], playername[MAX_PLAYER_NAME]; //Criando variavés...
    if(sscanf(params, "s", text)) return SendClientMessage(playerid, 0xAD0000AA, "USE: /radio [MENSAGEM]");
    if(pInfo[playerid][Organizacao] == 0) return SendClientMessage(playerid, 0xAD0000AA, "Voce nao participa de nenhuma organizacao!"); //Verifica se o player é CIVIL, se for, returna a mensagem
    GetPlayerName(playerid, playername, sizeof(playername)); //Geta o nome de quem usou o comando
    format(string, sizeof(string), "(Rádio) %s [Cargo: %d] diz: %s", playername, pInfo[playerid][Cargo], text); //Formata uma mensagem com o nome do player, cargo e a mensgem
    SendFamilyMessage(pInfo[playerid][Organizacao], COR_RAD, string); //Envia a mensagem a organização do player
    return 1; //Returnando a 1, nunca se esqueça!
}

CMD:convidar(playerid, params[])
{
    new id, playername[MAX_PLAYER_NAME], idname[MAX_PLAYER_NAME], string[128]; //Cria variaveis que irão armazenar id, nome e string
    if(pInfo[playerid][Cargo] != 6) return SendClientMessage(playerid, 0xAD0000AA, "Voce nao e o lider"); //Vê se quem digitou o comando é líder, se não, returna a mensagem
    if(sscanf(params, "d", id)) return SendClientMessage(playerid, 0xAD0000AA, "USE: /convidar [ID]");
    if(!IsPlayerConnected(id)) return SendClientMessage(playerid, 0xAD0000AA, "Este jogador nao esta online."); //Verifica se o "id" está online...
    if(pInfo[id][Organizacao] != 0) return SendClientMessage(playerid, 0xAD0000AA, "Este jogador ja esta em uma Organizacao."); //Verifica se o player já está em alguma organização, se estiver, returna a mensagem
    if(playerid == id) return SendClientMessage(playerid, 0xAD0000AA, "Voce nao pode convidar a voce mesmo."); //Verifica se o "id" = id de quem digitou (playerid)
    GetPlayerName(id, idname, sizeof(idname)); //Geta o nome do "id"
    format(string, sizeof(string), "Voce convidou %s para sua Organizacao.", idname); //Formata a mensagem com que foi convidado
    SendClientMessage(playerid, GetPlayerColor(playerid), string); //Envia a mensagem ao líder
    GetPlayerName(playerid, playername, sizeof(playername)); //Geta o nome de quem digitou o comando
    format(string, sizeof(string), "%s esta lhe Convidando para fazer parte da Organizacao: %s \nDeseja aceitar?", playername, GetOrgName(pInfo[playerid][Organizacao])); //Formata um dialog com o nome de que convidou e o nome da organização
    ShowPlayerDialog(id, 666, DIALOG_STYLE_MSGBOX, "Convite para organizacao", string, "Sim", "Nao");
    SetPVarInt(id, "OrgConvidado", pInfo[playerid][Organizacao]); //Setando PVarInt que será usar no OnDialogResponse
    SetPVarInt(id, "QuemConvidou", playerid); //Setando PVarInt que será usar no OnDialogResponse
    SaveAccount(id);
    return 1; //Returnando a 1, nunca se esqueça!
}

CMD:promover(playerid, params[])
{
    new id, cargo, string[128], playername[MAX_PLAYER_NAME], idname[MAX_PLAYER_NAME]; //Cria as váriveis...
    if(pInfo[playerid][Cargo] != 6) return SendClientMessage(playerid, 0xAD0000AA, "Voce nao e lider"); //Verifica se o player que digitou o comando é líder
    if(sscanf(params, "dd", id, cargo)) return SendClientMessage(playerid, 0xAD0000AA, "USE: /promover [ID]");
    if(!IsPlayerConnected(id)) return SendClientMessage(playerid, 0xAD0000AA, "Este jogador nao esta online."); //Verifica se o player que será promovido está online
    if(pInfo[id][Organizacao] != pInfo[playerid][Organizacao]) return SendClientMessage(playerid, 0xAD0000AA, "Este jogador nao e da mesma Organizacao que voce."); //Verifica se o "id" é da mesma organização do líder
    if(playerid == id) return SendClientMessage(playerid, 0xAD0000AA, "Voce nao pode promover a voce mesmo."); //Verifica se o "id" é ele mesmo (playerid)
    if(cargo >= 1 || cargo <= 5) //Verifica se o cargo está entre 1 a 5
    {
        pInfo[id][Cargo] = cargo; //Seta o cargo do player de acordo com o "cargo" que o líder digitou
        GetPlayerName(playerid, playername, sizeof(playername)); //Geta o nome do player que digitou o comando
        GetPlayerName(id, idname, sizeof(idname)); //Geta o nome de quem recebeu a promoção
        format(string, sizeof(string), "%s promoveu o membro %s para o Cargo %d.", playername, idname, cargo); //Formata a mesgaem com quem prommoveu, quem foi promovido e o cargo
        SendFamilyMessage(pInfo[playerid][Organizacao], GetPlayerColor(playerid), string); //Envia a mensagem para a organização
        format(string, sizeof(string), "%s te promoveu para o Cargo %d.", playername, cargo); //Formata a mensgame...
        SendClientMessage(id, GetPlayerColor(playerid), string); //Envia a mesngaem para quem foi promovido
        SaveAccount(id);
    }
    else //Caso o cargo não esta de 1 a 5, envia a mensagem abaixo:
    {
        SendClientMessage(playerid, 0xAD0000AA, "Cargos de 1 a 5");
        return 1;
    }
    return 1; //Returnando a 1, nunca se esqueça!
}

CMD:demitir(playerid, params[])
{
    new id, motivo[128], string[128], playername[MAX_PLAYER_NAME], idname[MAX_PLAYER_NAME]; //Criando variaveis :P
    if(pInfo[playerid][Cargo] != 6) return SendClientMessage(playerid, 0xAD0000AA, "Voce nao e o lider"); //Verifica se o player que digitou o comando é lider
    if(sscanf(params, "ds[65]", id, motivo)) return SendClientMessage(playerid, 0xAD0000AA, "USE: /demitir [ID] [MOTIVO]");
    if(!IsPlayerConnected(id)) return SendClientMessage(playerid, 0xAD0000AA, "Este jogador nao esta online."); //Verifica se quem será demitido está online
    if(pInfo[id][Organizacao] != pInfo[playerid][Organizacao]) return SendClientMessage(playerid, 0xAD0000AA, "Este jogador nao e da mesma Organizacao que voce."); //Verifica se o "id" é da mesma organização do líder
    if(playerid == id) return SendClientMessage(playerid, 0xAD0000AA, "Voce nao pode demitir a voce mesmo."); //Verifica se o "id" é ele mesmo (playerid)
    pInfo[id][Organizacao] = 0;
    pInfo[id][Cargo] = 0; //Seta o cargo od player a 0
    GetPlayerName(playerid, playername, sizeof(playername)); //Geta o nome de quem demitiu
    GetPlayerName(id, idname, sizeof(idname)); //Geta o nome de quem foi demitido
    format(string, sizeof(string), "%s demitiu o membro %s da Organizacao.", playername, idname); //Formata uma mensagem com o nome de quem demitiu e quem foi demitido
    SendFamilyMessage(pInfo[playerid][Organizacao], GetPlayerColor(playerid), string); //Envia a mensagem para a organização
    format(string, sizeof(string), "%s te demitiu da Organizacao. Motivo: %s.", playername, motivo); //Formata uma mensagem com o nome de quem demitiu e o motivo
    SendClientMessage(id, GetPlayerColor(playerid), string); //Envia a mensagem para quem foi demitido
    SpawnPlayer(id); //Spawn no nego!
    SaveAccount(id);
    return 1; //Returnando a 1, nunca se esqueça!
}

CMD:equipar(playerid)
{
    if(pInfo[playerid][Organizacao] == 0)
	{
 		SendClientMessage(playerid, 0xAD0000AA, "Voce e um Civil e nao pode equipar.");
	}
	else if(pInfo[playerid][Organizacao] == 1)
    {
           	if(!IsPlayerInRangeOfPoint(playerid, 3.0,1527.8973,-1667.4678,6.2188)) return SendClientMessage(playerid, 0xAD0000AA, "Voce nao esta no local para se equipar");
			new Armas_PoliciaM = 1000*pInfo[playerid][Cargo];
    		SetPlayerHealth(playerid, 100.0);
    		SetPlayerArmour(playerid, 100.0);
    		GivePlayerWeapon(playerid, 3, Armas_PoliciaM);
    		GivePlayerWeapon(playerid, 22, Armas_PoliciaM);
    		GivePlayerWeapon(playerid, 25, Armas_PoliciaM);
    		GivePlayerWeapon(playerid, 31, Armas_PoliciaM);
    		GivePlayerWeapon(playerid, 34, Armas_PoliciaM);
    		SetPlayerSkin(playerid, 280);
    }
	else if(pInfo[playerid][Organizacao] == 2)
    {       
           	if(!IsPlayerInRangeOfPoint(playerid, 3.0,855.1198,-1650.5101,13.5603)) return SendClientMessage(playerid, 0xAD0000AA, "Voce nao esta no local para se equipar");
			new Armas_PoliciaC = 1000*pInfo[playerid][Cargo];
    		SetPlayerHealth(playerid, 100.0);
    		SetPlayerArmour(playerid, 100.0);
    		GivePlayerWeapon(playerid, 43, Armas_PoliciaC);
    		GivePlayerWeapon(playerid, 22, Armas_PoliciaC);
    		GivePlayerWeapon(playerid, 25, Armas_PoliciaC);
    		GivePlayerWeapon(playerid, 29, Armas_PoliciaC);
    		GivePlayerWeapon(playerid, 31, Armas_PoliciaC);
    		GivePlayerWeapon(playerid, 34, Armas_PoliciaC);
    		SetPlayerSkin(playerid, 124);
    }
	else if(pInfo[playerid][Organizacao] == 3)
    {
           	if(!IsPlayerInRangeOfPoint(playerid, 3.0,302.9983,-1530.9955,24.9219)) return SendClientMessage(playerid, 0xAD0000AA, "Voce nao esta no local para se equipar");
			new Armas_PoliciaF = 1000*pInfo[playerid][Cargo];
    		SetPlayerHealth(playerid, 100.0);
    		SetPlayerArmour(playerid, 100.0);
    		GivePlayerWeapon(playerid, 22, Armas_PoliciaF);
    		GivePlayerWeapon(playerid, 25, Armas_PoliciaF);
    		GivePlayerWeapon(playerid, 29, Armas_PoliciaF);
    		GivePlayerWeapon(playerid, 31, Armas_PoliciaF);
    		GivePlayerWeapon(playerid, 34, Armas_PoliciaF);
    		SetPlayerSkin(playerid, 286);
    }
	else if(pInfo[playerid][Organizacao] == 4)
    {
           	if(!IsPlayerInRangeOfPoint(playerid, 3.0,261.3844,1856.2665,8.7578)) return SendClientMessage(playerid, 0xAD0000AA, "Voce nao esta no local para se equipar");
    		new Armas_Exercito = 1000*pInfo[playerid][Cargo];
			SetPlayerHealth(playerid, 100.0);
    		SetPlayerArmour(playerid, 100.0);
    		GivePlayerWeapon(playerid, 24, Armas_Exercito);
    		GivePlayerWeapon(playerid, 27, Armas_Exercito);
    		GivePlayerWeapon(playerid, 29, Armas_Exercito);
    		GivePlayerWeapon(playerid, 31, Armas_Exercito);
    		GivePlayerWeapon(playerid, 34, Armas_Exercito);
    		GivePlayerWeapon(playerid, 36, Armas_Exercito);
    		GivePlayerWeapon(playerid, 44, Armas_Exercito);
    		GivePlayerWeapon(playerid, 16, Armas_Exercito);
    		SetPlayerSkin(playerid, 287);
    }
	else if(pInfo[playerid][Organizacao] == 5)
    {
           	if(!IsPlayerInRangeOfPoint(playerid, 3.0,1403.7573,-1491.1599,20.4467)) return SendClientMessage(playerid, 0xAD0000AA, "Voce nao esta no local para se equipar");
			new Armas_Prefeito = 1000*pInfo[playerid][Cargo];
    		SetPlayerHealth(playerid, 100.0);
    		SetPlayerArmour(playerid, 100.0);
    		GivePlayerWeapon(playerid, 24, Armas_Prefeito);
    		GivePlayerWeapon(playerid, 27, Armas_Prefeito);
    		GivePlayerWeapon(playerid, 28, Armas_Prefeito);
    		GivePlayerWeapon(playerid, 31, Armas_Prefeito);
    		GivePlayerWeapon(playerid, 34, Armas_Prefeito);
    		GivePlayerWeapon(playerid, 35, Armas_Prefeito);
    		GivePlayerWeapon(playerid, 38, Armas_Prefeito);
    		SetPlayerSkin(playerid, 111);
    }
	else if(pInfo[playerid][Organizacao] == 6)
    {       
           	if(!IsPlayerInRangeOfPoint(playerid, 3.0,2529.2039,-1667.6077,15.1688)) return SendClientMessage(playerid, 0xAD0000AA, "Voce nao esta no local para se equipar");
			new Armas_Groove = 1000*pInfo[playerid][Cargo];
    		SetPlayerHealth(playerid, 100.0);
    		SetPlayerArmour(playerid, 100.0);
    		GivePlayerWeapon(playerid, 1, Armas_Groove);
    		GivePlayerWeapon(playerid, 22, Armas_Groove);
    		GivePlayerWeapon(playerid, 25, Armas_Groove);
    		GivePlayerWeapon(playerid, 30, Armas_Groove);
    		GivePlayerWeapon(playerid, 32, Armas_Groove);
    		GivePlayerWeapon(playerid, 34, Armas_Groove);
    		SetPlayerSkin(playerid, 107);
    }
	else if(pInfo[playerid][Organizacao] == 7)
    {
           	if(!IsPlayerInRangeOfPoint(playerid, 3.0,2104.3184,-1168.3340,25.5938)) return SendClientMessage(playerid, 0xAD0000AA, "Voce nao esta no local para se equipar");
			new Armas_Ballas = 1000*pInfo[playerid][Cargo];
    		SetPlayerHealth(playerid, 100.0);
    		SetPlayerArmour(playerid, 100.0);
    		GivePlayerWeapon(playerid, 1, Armas_Ballas);
    		GivePlayerWeapon(playerid, 22, Armas_Ballas);
    		GivePlayerWeapon(playerid, 25, Armas_Ballas);
    		GivePlayerWeapon(playerid, 30, Armas_Ballas);
    		GivePlayerWeapon(playerid, 32, Armas_Ballas);
    		GivePlayerWeapon(playerid, 34, Armas_Ballas);
    		SetPlayerSkin(playerid, 104);
    }
	else if(pInfo[playerid][Organizacao] == 8)
    {
           	if(!IsPlayerInRangeOfPoint(playerid, 3.0,2803.5425,-1427.3954,40.0625)) return SendClientMessage(playerid, 0xAD0000AA, "Voce nao esta no local para se equipar");
			new Armas_Vagos = 1000*pInfo[playerid][Cargo];
    		SetPlayerHealth(playerid, 100.0);
    		SetPlayerArmour(playerid, 100.0);
    		GivePlayerWeapon(playerid, 1, Armas_Vagos);
    		GivePlayerWeapon(playerid, 22, Armas_Vagos);
    		GivePlayerWeapon(playerid, 25, Armas_Vagos);
    		GivePlayerWeapon(playerid, 32, Armas_Vagos);
    		GivePlayerWeapon(playerid, 30, Armas_Vagos);
    		GivePlayerWeapon(playerid, 34, Armas_Vagos);
    		SetPlayerSkin(playerid, 116);
    }
	else if(pInfo[playerid][Organizacao] == 9)
    {
           	if(!IsPlayerInRangeOfPoint(playerid, 3.0,1040.8257,1305.5693,10.8203)) return SendClientMessage(playerid, 0xAD0000AA, "Voce nao esta no local para se equipar");
			new Armas_Alqaeda = 500*pInfo[playerid][Cargo];
    		SetPlayerHealth(playerid, 100.0);
    		SetPlayerArmour(playerid, 100.0);
    		GivePlayerWeapon(playerid, 30, Armas_Alqaeda);
    		GivePlayerWeapon(playerid, 32, Armas_Alqaeda);
    		GivePlayerWeapon(playerid, 34, Armas_Alqaeda);
    		GivePlayerWeapon(playerid, 27, Armas_Alqaeda);
    		GivePlayerWeapon(playerid, 24, Armas_Alqaeda);
    		GivePlayerWeapon(playerid, 16, Armas_Alqaeda);
    		SetPlayerSkin(playerid, 206);
    }
    return 1; //Returnando a 1, nunca se esqueça!
}

stock GetOrgName(orgid)
{
    new str[30];
    if(orgid == 0)
    {
        str = "[CIDADAO]";
    }
    if(orgid == 1)
    {
        str = "[POLICIA-MILITAR]";
    }
    if(orgid == 2)
    {
        str = "[POLICIA-CIVIL]";
    }
    if(orgid == 3)
    {
        str = "[POLICIA-FEDERAL]";
    }
    if(orgid == 4)
    {
        str = "[EXERCITO]";
    }
    if(orgid == 5)
    {
        str = "[ADMINS]";
    }
    if(orgid == 6)
    {
        str = "[GROOVE-STREET]";
    }
    if(orgid == 7)
    {
        str = "[BALLAS]";
    }
    if(orgid == 8)
    {
        str = "[LOS-VAGOS]";
    }
    if(orgid == 9)
    {
        str = "[AL'QAEDA]";
    }
    return str;
}

stock SendFamilyMessage(orgid, cor, mensagem[]) //stock que envia a mensagem para tal organização de acordo com "ogrid"
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            if(pInfo[i][Organizacao] == orgid)
            {
                SendClientMessage(i, cor, mensagem);
            }
        }
    }
    return 0;
}


// Função para prender um jogador
stock PrisonPlayer(playerid, time)
{
    PrisonTime[playerid] = time;
    // Aqui voce pode adicionar codigo para teletransportar o jogador para a prisao
    // e possivelmente mostrar uma mensagem de prisao.
    SendClientMessage(playerid, C_VERMELHO, "Voce foi preso!");
    return 0;
}

// Funcao para libertar um jogador
stock ReleasePlayer(playerid)
{
    PrisonTime[playerid] = 0;
    // Aqui voce pode adicionar codigo para teletransportar o jogador de volta para a localizacao anterior
    SendClientMessage(playerid, C_VERDE, "Voce foi libertado da prisao!");
    return 0;
}

// Funcao para atualizar o tempo de prisao
stock UpdatePrisonTime()
{
    for (new i = 0; i < MAX_PLAYERS; i++)
    {
        if (IsPlayerConnected(i) && PrisonTime[i] > 0)
        {
            PrisonTime[i]--;
            if (PrisonTime[i] <= 0)
            {
                ReleasePlayer(i);
            }
        }
    }
    return 0;
}
/*======================================================================================================================================================================================*/
