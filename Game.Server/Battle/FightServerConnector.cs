using Bussiness.Managers;
using Game.Base;
using Game.Base.Packets;
using Game.Logic;
using Game.Logic.Phy.Object;
using Game.Server.Buffer;
using Game.Server.Managers;
using Game.Server.RingStation;
using Game.Server.Rooms;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Threading;

namespace Game.Server.Battle
{
    public class FightServerConnector : BaseConnector
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private BattleServer m_server;

        private string m_key;

        protected override void OnDisconnect()
        {
            base.OnDisconnect();
        }

        public override void OnRecvPacket(GSPacketIn pkg)
        {
            ThreadPool.QueueUserWorkItem(AsynProcessPacket, pkg);
        }

        protected void AsynProcessPacket(object state)
        {
            try
            {
                GSPacketIn pkg = state as GSPacketIn;
                switch (pkg.Code)
                {
                    case 0:
                        HandleRSAKey(pkg);
                        break;
                    case 19:
                        HandlePlayerChatSend(pkg);
                        break;
                    case 32:
                        HandleSendToPlayer(pkg);
                        break;
                    case 33:
                        HandleUpdatePlayerGameId(pkg);
                        break;
                    case 34:
                        HandleDisconnectPlayer(pkg);
                        break;
                    case 35:
                        HandlePlayerOnGameOver(pkg);
                        break;
                    case 36:
                        HandlePlayerOnUsingItem(pkg);
                        break;
                    case 38:
                        HandlePlayerAddGold(pkg);
                        break;
                    case 39:
                        HandlePlayerAddGP(pkg);
                        break;
                    case 40:
                        HandlePlayerOnKillingLiving(pkg);
                        break;
                    case 41:
                        HandlePlayerOnMissionOver(pkg);
                        break;
                    case 42:
                        HandlePlayerConsortiaFight(pkg);
                        break;
                    case 43:
                        HandlePlayerSendConsortiaFight(pkg);
                        break;
                    case 44:
                        HandlePlayerRemoveGold(pkg);
                        break;
                    case 45:
                        HandlePlayerRemoveMoney(pkg);
                        break;
                    case 48:
                        HandlePlayerAddTemplate1(pkg);
                        break;
                    case 49:
                        HandlePlayerRemoveGP(pkg);
                        break;
                    case 50:
                        HandlePlayerRemoveOffer(pkg);
                        break;
                    case 51:
                        HandlePlayerAddOffer(pkg);
                        break;
                    case 52:
                        HandlePlayerAddRobRiches(pkg);
                        break;
                    case 65:
                        HandleRoomRemove(pkg);
                        break;
                    case 66:
                        HandleStartGame(pkg);
                        break;
                    case 67:
                        HandleSendToRoom(pkg);
                        break;
                    case 68:
                        HandleStopGame(pkg);
                        break;
                    case 73:
                        HandlePlayerHealstone(pkg);
                        break;
                    case 74:
                        HandlePlayerAddMoney(pkg);
                        break;
                    case 75:
                        HandlePlayerAddGiftToken(pkg);
                        break;
                    case 76:
                        HandlePlayerAddMedal(pkg);
                        break;
                    case 77:
                        HandleFindConsortiaAlly(pkg);
                        break;
                    case 84:
                        HandlePlayerAddLeagueMoney(pkg);
                        break;
                    case 85:
                        HandlePlayerAddPrestige(pkg);
                        break;
                    case 86:
                        HandlePlayerUpdateRestCount(pkg);
                        break;
                    case 88:
                        HandleFightNPC(pkg);
                        break;
                    case 89:
                        HandlePlayerAddActiveMoney(pkg);
                        break;
                    default:
                        Console.WriteLine("Not Found PKG {0}", pkg.Code);
                        break;
                }
            }
            catch (Exception exception)
            {
                GameServer.log.Error("AsynProcessPacket", exception);
            }
        }

        protected void HandleRSAKey(GSPacketIn packet)
        {
            RSAParameters parameters = default(RSAParameters);
            parameters.Modulus = packet.ReadBytes(128);
            parameters.Exponent = packet.ReadBytes();
            RSACryptoServiceProvider rSACryptoServiceProvider = new RSACryptoServiceProvider();
            rSACryptoServiceProvider.ImportParameters(parameters);
            SendRSALogin(rSACryptoServiceProvider, m_key);
        }

        private void HandlePlayerChatSend(GSPacketIn pkg)
        {
            WorldMgr.GetPlayerById(pkg.ClientID)?.SendMessage(pkg.ReadString());
        }

        protected void HandleSendToPlayer(GSPacketIn pkg)
        {
            int clientID = pkg.ClientID;
            try
            {
                GSPacketIn pkg2 = pkg.ReadPacket();
                m_server.SendToUser(clientID, pkg2);
            }
            catch (Exception exception)
            {
                log.Error($"pkg len:{pkg.Length}", exception);
                log.Error(Marshal.ToHexDump("pkg content:", pkg.Buffer, 0, pkg.Length));
            }
        }

        private void HandleUpdatePlayerGameId(GSPacketIn pkg)
        {
            m_server.UpdatePlayerGameId(pkg.Parameter1, pkg.Parameter2);
        }

        private void HandleDisconnectPlayer(GSPacketIn pkg)
        {
            WorldMgr.GetPlayerById(pkg.ClientID)?.Disconnect();
        }

        private void HandlePlayerOnGameOver(GSPacketIn pkg)
        {
            GamePlayer playerById = WorldMgr.GetPlayerById(pkg.ClientID);
            if (playerById != null && playerById.CurrentRoom != null && playerById.CurrentRoom.Game != null)
            {
                playerById.OnGameOver(playerById.CurrentRoom.Game, pkg.ReadBoolean(), pkg.ReadInt(), pkg.ReadBoolean(), pkg.ReadBoolean(), pkg.ReadInt(), pkg.ReadInt());
            }
        }

        private void HandlePlayerOnUsingItem(GSPacketIn pkg)
        {
            GamePlayer playerById = WorldMgr.GetPlayerById(pkg.ClientID);
            if (playerById != null)
            {
                int templateId = pkg.ReadInt();
                bool result = playerById.UsePropItem(null, pkg.Parameter1, pkg.Parameter2, templateId, pkg.ReadBoolean());
                SendUsingPropInGame(playerById.CurrentRoom.Game.Id, playerById.GamePlayerId, templateId, result);
            }
        }

        private void HandlePlayerAddGold(GSPacketIn pkg)
        {
            WorldMgr.GetPlayerById(pkg.ClientID)?.AddGold(pkg.Parameter1);
        }

        private void HandlePlayerAddGP(GSPacketIn pkg)
        {
            WorldMgr.GetPlayerById(pkg.ClientID)?.AddGP(pkg.Parameter1);
        }

        private void HandlePlayerOnKillingLiving(GSPacketIn pkg)
        {
            GamePlayer playerById = WorldMgr.GetPlayerById(pkg.ClientID);
            AbstractGame game = playerById.CurrentRoom.Game;
            playerById?.OnKillingLiving(game, pkg.ReadInt(), pkg.ClientID, pkg.ReadBoolean(), pkg.ReadInt());
        }

        private void HandlePlayerOnMissionOver(GSPacketIn pkg)
        {
            GamePlayer playerById = WorldMgr.GetPlayerById(pkg.ClientID);
            AbstractGame game = playerById.CurrentRoom.Game;
            playerById?.OnMissionOver(game, pkg.ReadBoolean(), pkg.ReadInt(), pkg.ReadInt());
        }

        private void HandlePlayerConsortiaFight(GSPacketIn pkg)
        {
            GamePlayer playerById = WorldMgr.GetPlayerById(pkg.ClientID);
            Dictionary<int, Player> dictionary = new Dictionary<int, Player>();
            int consortiaWin = pkg.ReadInt();
            int consortiaLose = pkg.ReadInt();
            int num = pkg.ReadInt();
            int num2 = 0;
            for (int i = 0; i < num; i++)
            {
                GamePlayer playerById2 = WorldMgr.GetPlayerById(pkg.ReadInt());
                if (playerById2 != null)
                {
                    Player value = new Player(playerById2, 0, null, 0, playerById2.PlayerCharacter.hp);
                    dictionary.Add(i, value);
                }
            }
            eRoomType roomType = (eRoomType)pkg.ReadByte();
            eGameType gameClass = (eGameType)pkg.ReadByte();
            int totalKillHealth = pkg.ReadInt();
            if (playerById != null)
            {
                num2 = playerById.ConsortiaFight(consortiaWin, consortiaLose, dictionary, roomType, gameClass, totalKillHealth, num);
            }
            if (num2 == 0)
            {
            }
        }

        private void HandlePlayerSendConsortiaFight(GSPacketIn pkg)
        {
            WorldMgr.GetPlayerById(pkg.ClientID)?.SendConsortiaFight(pkg.ReadInt(), pkg.ReadInt(), pkg.ReadString());
        }

        private void HandlePlayerRemoveGold(GSPacketIn pkg)
        {
            WorldMgr.GetPlayerById(pkg.ClientID)?.RemoveGold(pkg.ReadInt());
        }

        private void HandlePlayerRemoveMoney(GSPacketIn pkg)
        {
            WorldMgr.GetPlayerById(pkg.ClientID)?.RemoveMoney(pkg.ReadInt());
        }

        private void HandlePlayerAddTemplate1(GSPacketIn pkg)
        {
            GamePlayer playerById = WorldMgr.GetPlayerById(pkg.ClientID);
            if (playerById == null)
            {
                return;
            }
            ItemTemplateInfo itemTemplateInfo = ItemMgr.FindItemTemplate(pkg.ReadInt());
            eBageType bagType = (eBageType)pkg.ReadByte();
            if (itemTemplateInfo == null)
            {
                return;
            }
            int count = pkg.ReadInt();
            ItemInfo itemInfo = ItemInfo.CreateFromTemplate(itemTemplateInfo, count, 118);
            itemInfo.Count = count;
            itemInfo.ValidDate = pkg.ReadInt();
            itemInfo.IsBinds = pkg.ReadBoolean();
            itemInfo.IsUsed = pkg.ReadBoolean();
            itemInfo.StrengthenLevel = pkg.ReadInt();
            itemInfo.AttackCompose = pkg.ReadInt();
            itemInfo.DefendCompose = pkg.ReadInt();
            itemInfo.AgilityCompose = pkg.ReadInt();
            itemInfo.LuckCompose = pkg.ReadInt();
            if (pkg.ReadBoolean())
            {
                GoldEquipTemplateInfo goldEquipTemplateInfo = GoldEquipMgr.FindGoldEquipByTemplate(itemTemplateInfo.TemplateID);
                if (goldEquipTemplateInfo != null)
                {
                    ItemTemplateInfo itemTemplateInfo2 = ItemMgr.FindItemTemplate(goldEquipTemplateInfo.NewTemplateId);
                    if (itemTemplateInfo2 != null)
                    {
                        itemInfo.GoldEquip = itemTemplateInfo2;
                        itemInfo.goldBeginTime = pkg.ReadDateTime();
                        itemInfo.goldValidDate = pkg.ReadInt();
                    }
                }
            }
            playerById.AddTemplate(itemInfo, bagType, itemInfo.Count, eGameView.BatleTypeGet);
        }

        private void HandlePlayerRemoveGP(GSPacketIn pkg)
        {
            WorldMgr.GetPlayerById(pkg.ClientID)?.RemoveGP(pkg.Parameter1);
        }

        private void HandlePlayerRemoveOffer(GSPacketIn pkg)
        {
            WorldMgr.GetPlayerById(pkg.ClientID)?.RemoveOffer(pkg.ReadInt());
        }

        private void HandlePlayerAddOffer(GSPacketIn pkg)
        {
            WorldMgr.GetPlayerById(pkg.ClientID)?.AddOffer(pkg.ReadInt(), IsRate: false);
        }

        private void HandlePlayerAddRobRiches(GSPacketIn pkg)
        {
            GamePlayer playerById = WorldMgr.GetPlayerById(pkg.ClientID);
            int num = pkg.ReadInt();
            if (playerById != null && num == pkg.Parameter1)
            {
                playerById.AddRobRiches(pkg.Parameter1);
            }
        }

        protected void HandleRoomRemove(GSPacketIn packet)
        {
            m_server.RemoveRoomImp(packet.ClientID);
        }

        protected void HandleStartGame(GSPacketIn pkg)
        {
            ProxyGame game = new ProxyGame(pkg.Parameter2, this, (eRoomType)pkg.ReadInt(), (eGameType)pkg.ReadInt(), pkg.ReadInt());
            m_server.StartGame(pkg.Parameter1, game);
        }

        protected void HandleSendToRoom(GSPacketIn pkg)
        {
            int clientID = pkg.ClientID;
            GSPacketIn pkg2 = pkg.ReadPacket();
            m_server.SendToRoom(clientID, pkg2, pkg.Parameter1, pkg.Parameter2);
        }

        protected void HandleStopGame(GSPacketIn pkg)
        {
            int parameter = pkg.Parameter1;
            int parameter2 = pkg.Parameter2;
            m_server.StopGame(parameter, parameter2);
        }

        private void HandlePlayerHealstone(GSPacketIn pkg)
        {
            WorldMgr.GetPlayerById(pkg.ClientID)?.RemoveHealstone();
        }

        private void HandlePlayerAddMoney(GSPacketIn pkg)
        {
            WorldMgr.GetPlayerById(pkg.ClientID)?.AddMoney(pkg.Parameter1, (pkg.Parameter2 == 1) ? true : false);
        }

        private void HandlePlayerAddGiftToken(GSPacketIn pkg)
        {
            WorldMgr.GetPlayerById(pkg.ClientID)?.AddGiftToken(pkg.Parameter1);
        }

        private void HandlePlayerAddMedal(GSPacketIn pkg)
        {
            WorldMgr.GetPlayerById(pkg.ClientID)?.AddMedal(pkg.Parameter1);
        }

        public void HandleFindConsortiaAlly(GSPacketIn pkg)
        {
            int state = ConsortiaMgr.FindConsortiaAlly(pkg.ReadInt(), pkg.ReadInt());
            SendFindConsortiaAlly(state, pkg.ReadInt());
        }

        private void HandlePlayerAddLeagueMoney(GSPacketIn pkg)
        {
            WorldMgr.GetPlayerById(pkg.ClientID)?.AddLeagueMoney(pkg.Parameter1);
        }

        //private void HandlePlayerAddPrestige(GSPacketIn pkg)
        //{
        //    WorldMgr.GetPlayerById(pkg.ClientID)?.AddPrestige(pkg.ReadBoolean());
        //}

        private void HandlePlayerAddPrestige(GSPacketIn pkg)  //trminhpc
        {
            GamePlayer player = WorldMgr.GetPlayerById(pkg.ClientID);
            if (player != null)
            {
                player.AddPrestige(pkg.ReadBoolean(), (eRoomType)pkg.Parameter1);
            }
        }

        private void HandlePlayerUpdateRestCount(GSPacketIn pkg)
        {
            WorldMgr.GetPlayerById(pkg.ClientID)?.UpdateRestCount();
        }

        private void HandleFightNPC(GSPacketIn pkg)
        {
            int roomtype = pkg.ReadInt();
            int gametype = pkg.ReadInt();
            int npcId = pkg.ReadInt();
            int countPlayer = pkg.ReadInt();
            GamePlayer playerById = WorldMgr.GetPlayerById(pkg.Parameter1);
            if (playerById == null)
            {
                //RingStationMgr.CreateAutoBot(WorldMgr.GetPlayerById(1), roomtype, gametype, npcId, countPlayer);
                Console.WriteLine("Create autobot by default");
            }
            else
            {
                RingStationMgr.CreateAutoBot(playerById, roomtype, gametype, npcId, countPlayer);
                Console.WriteLine("Create " + countPlayer.ToString() + " bot by " + playerById.PlayerCharacter.NickName);
            }
        }

        public void SendFindConsortiaAlly(int state, int gameid)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(77, gameid);
            gSPacketIn.WriteInt(state);
            gSPacketIn.WriteInt((int)RateMgr.GetRate(eRateType.Riches_Rate));
            SendTCP(gSPacketIn);
        }

        private void SendUsingPropInGame(int gameId, int playerId, int templateId, bool result)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(36, gameId);
            gSPacketIn.Parameter1 = playerId;
            gSPacketIn.Parameter2 = templateId;
            gSPacketIn.WriteBoolean(result);
            SendTCP(gSPacketIn);
        }

        public void SendRSALogin(RSACryptoServiceProvider rsa, string key)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(1);
            gSPacketIn.Write(rsa.Encrypt(Encoding.UTF8.GetBytes(key), fOAEP: false));
            SendTCP(gSPacketIn);
        }

        public void HandleTakeCardTemp(GSPacketIn pkg)
        {
            WorldMgr.GetPlayerById(pkg.ClientID)?.OnTakeCard(pkg.ReadInt(), pkg.ReadInt(), pkg.ReadInt(), pkg.ReadInt());
        }

        private void method_3(GSPacketIn gspacketIn_0)
        {
            WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.AddEliteScore(gspacketIn_0.Parameter1);
        }

        private void method_4(GSPacketIn gspacketIn_0)
        {
            WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.RemoveEliteScore(gspacketIn_0.Parameter1);
        }

        private void method_5(GSPacketIn gspacketIn_0)
        {
            WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.SendWinEliteChampion();
        }

        private void method_7(GSPacketIn gspacketIn_0)
        {
            WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.OnFightOneBloodIsWin((eRoomType)gspacketIn_0.Parameter1, isWin: true);
        }

        private void method_8(GSPacketIn gspacketIn_0)
        {
            WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.OnFightAddOffer(gspacketIn_0.Parameter1);
        }

        private void method_9(GSPacketIn gspacketIn_0)
        {
            WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.SendMessage(gspacketIn_0.ReadString());
        }

        private void method_10(GSPacketIn gspacketIn_0)
        {
            GamePlayer playerById = WorldMgr.GetPlayerById(gspacketIn_0.ClientID);
            AbstractGame game = playerById.CurrentRoom.Game;
            playerById?.OnKillingLiving(game, gspacketIn_0.ReadInt(), gspacketIn_0.ClientID, gspacketIn_0.ReadBoolean(), gspacketIn_0.ReadInt());
        }

        private void method_11(GSPacketIn gspacketIn_0)
        {
            GamePlayer playerById = WorldMgr.GetPlayerById(gspacketIn_0.ClientID);
            AbstractGame game = playerById.CurrentRoom.Game;
            playerById?.OnMissionOver(game, gspacketIn_0.ReadBoolean(), gspacketIn_0.ReadInt(), gspacketIn_0.ReadInt());
        }

        private void method_12(GSPacketIn gspacketIn_0)
        {
            GamePlayer playerById = WorldMgr.GetPlayerById(gspacketIn_0.ClientID);
            Dictionary<int, Player> dictionary = new Dictionary<int, Player>();
            int consortiaWin = gspacketIn_0.ReadInt();
            int consortiaLose = gspacketIn_0.ReadInt();
            int num = gspacketIn_0.ReadInt();
            for (int i = 0; i < num; i++)
            {
                GamePlayer playerById2 = WorldMgr.GetPlayerById(gspacketIn_0.ReadInt());
                if (playerById2 != null)
                {
                    Player value = new Player(playerById2, 0, null, 0, playerById2.PlayerCharacter.hp);
                    dictionary.Add(i, value);
                }
            }
            eRoomType roomType = (eRoomType)gspacketIn_0.ReadByte();
            eGameType gameClass = (eGameType)gspacketIn_0.ReadByte();
            int totalKillHealth = gspacketIn_0.ReadInt();
            playerById?.ConsortiaFight(consortiaWin, consortiaLose, dictionary, roomType, gameClass, totalKillHealth, num);
        }

        private void method_13(GSPacketIn gspacketIn_0)
        {
            WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.SendConsortiaFight(gspacketIn_0.ReadInt(), gspacketIn_0.ReadInt(), gspacketIn_0.ReadString());
        }

        private void method_14(GSPacketIn gspacketIn_0)
        {
            WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.RemoveGold(gspacketIn_0.ReadInt());
        }

        private void method_15(GSPacketIn gspacketIn_0)
        {
            WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.RemoveMoney(gspacketIn_0.ReadInt());
        }

        private void method_16(GSPacketIn gspacketIn_0)
        {
            WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.RemoveOffer(gspacketIn_0.ReadInt());
        }

        private void method_17(GSPacketIn gspacketIn_0)
        {
            GamePlayer playerById = WorldMgr.GetPlayerById(gspacketIn_0.ClientID);
            if (playerById != null)
            {
                ItemTemplateInfo itemTemplateInfo = ItemMgr.FindItemTemplate(gspacketIn_0.ReadInt());
                eBageType bagType = (eBageType)gspacketIn_0.ReadByte();
                if (itemTemplateInfo != null)
                {
                    int count = gspacketIn_0.ReadInt();
                    ItemInfo itemInfo = ItemInfo.CreateFromTemplate(itemTemplateInfo, count, 118);
                    itemInfo.Count = count;
                    itemInfo.ValidDate = gspacketIn_0.ReadInt();
                    itemInfo.IsBinds = gspacketIn_0.ReadBoolean();
                    itemInfo.IsUsed = gspacketIn_0.ReadBoolean();
                    playerById.AddTemplate(itemInfo, bagType, itemInfo.Count, backToMail: true);
                }
            }
        }

        private void method_18(GSPacketIn gspacketIn_0)
        {
            WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.AddGP(gspacketIn_0.Parameter1);
        }

        private void method_22(GSPacketIn gspacketIn_0)
        {
            WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.RemoveGP(gspacketIn_0.Parameter1);
        }

        private void method_23(GSPacketIn gspacketIn_0)
        {
            WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.AddGold(gspacketIn_0.Parameter1);
        }

        private void method_24(GSPacketIn gspacketIn_0)
        {
            GamePlayer playerById = WorldMgr.GetPlayerById(gspacketIn_0.ClientID);
            if (playerById != null)
            {
                int num = gspacketIn_0.ReadInt();
                bool bool_ = playerById.UsePropItem(null, gspacketIn_0.Parameter1, gspacketIn_0.Parameter2, num, gspacketIn_0.ReadBoolean());
                method_25(playerById.CurrentRoom.Game.Id, playerById.GameId, num, bool_);
            }
        }

        private void method_25(int int_2, int int_3, int int_4, bool bool_4)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(36, int_2);
            gSPacketIn.Parameter1 = int_3;
            gSPacketIn.Parameter2 = int_4;
            gSPacketIn.WriteBoolean(bool_4);
            SendTCP(gSPacketIn);
        }

        public void SendPlayerDisconnet(int gameId, int playerId, int roomid)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(83, gameId);
            gSPacketIn.Parameter1 = playerId;
            SendTCP(gSPacketIn);
        }

        private void method_27(GSPacketIn gspacketIn_0)
        {
            WorldMgr.GetPlayerById(gspacketIn_0.ClientID)?.Disconnect();
        }

        public FightServerConnector(BattleServer server, string ip, int port, string key)
            : base(ip, port, autoReconnect: true, new byte[8192], new byte[8192])
        {
            m_server = server;
            m_key = key;
            base.Strict = true;
        }

        public void SendAddRoom(BaseRoom room)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(64);
            gSPacketIn.WriteInt(room.RoomId);
            gSPacketIn.WriteInt((int)room.RoomType);
            gSPacketIn.WriteInt((int)room.GameType);
            gSPacketIn.WriteInt(room.GuildId);
            gSPacketIn.WriteInt(room.PickUpNpcId);
            gSPacketIn.WriteBoolean(room.StartWithNpc);
            gSPacketIn.WriteBoolean(val: false);
            gSPacketIn.WriteBoolean(room.isCrosszone);
            List<GamePlayer> players = room.GetPlayers();
            gSPacketIn.WriteInt(players.Count);
            foreach (GamePlayer item in players)
            {
                gSPacketIn.WriteInt(item.PlayerCharacter.ID);
                gSPacketIn.WriteString(item.PlayerCharacter.UserName);
                gSPacketIn.WriteBoolean(item.IsViewer);
                gSPacketIn.WriteInt(item.ZoneId);
                gSPacketIn.WriteString(item.ZoneName);
                gSPacketIn.WriteInt(item.CurrentEnemyId);
                gSPacketIn.WriteString(item.PlayerCharacter.NickName);
                gSPacketIn.WriteBoolean(item.PlayerCharacter.Sex);
                gSPacketIn.WriteInt(item.PlayerCharacter.Hide);
                gSPacketIn.WriteString(item.PlayerCharacter.Style);
                gSPacketIn.WriteString(item.PlayerCharacter.Colors);
                gSPacketIn.WriteString(item.PlayerCharacter.Skin);
                gSPacketIn.WriteInt(item.PlayerCharacter.Offer);
                gSPacketIn.WriteInt(item.PlayerCharacter.GP);
                gSPacketIn.WriteInt(item.PlayerCharacter.Grade);
                gSPacketIn.WriteInt(item.PlayerCharacter.Repute);
                gSPacketIn.WriteInt(item.PlayerCharacter.ConsortiaID);
                gSPacketIn.WriteString(item.PlayerCharacter.ConsortiaName);
                gSPacketIn.WriteInt(item.PlayerCharacter.ConsortiaLevel);
                gSPacketIn.WriteInt(item.PlayerCharacter.ConsortiaRepute);
                gSPacketIn.WriteBoolean(item.PlayerCharacter.IsShowConsortia);
                gSPacketIn.WriteInt(item.PlayerCharacter.badgeID);
                gSPacketIn.WriteString(item.PlayerCharacter.Honor);
                gSPacketIn.WriteInt(item.PlayerCharacter.AchievementPoint);
                gSPacketIn.WriteString(item.PlayerCharacter.WeaklessGuildProgressStr);
                gSPacketIn.WriteInt(item.PlayerCharacter.MoneyPlus);
                gSPacketIn.WriteInt(item.PlayerCharacter.FightPower);
                gSPacketIn.WriteInt(item.PlayerCharacter.Nimbus);
                gSPacketIn.WriteInt(item.PlayerCharacter.apprenticeshipState);
                gSPacketIn.WriteInt(item.PlayerCharacter.masterID);
                gSPacketIn.WriteString(item.PlayerCharacter.masterOrApprentices);
                gSPacketIn.WriteInt(item.PlayerCharacter.Attack);
                gSPacketIn.WriteInt(item.PlayerCharacter.Defence);
                gSPacketIn.WriteInt(item.PlayerCharacter.Agility);
                gSPacketIn.WriteInt(item.PlayerCharacter.Luck);
                gSPacketIn.WriteInt(item.PlayerCharacter.hp);
                gSPacketIn.WriteDouble(item.GetBaseAttack());
                gSPacketIn.WriteDouble(item.GetBaseDefence());
                gSPacketIn.WriteDouble(item.GetBaseAgility());
                gSPacketIn.WriteDouble(item.GetBaseBlood());
                gSPacketIn.WriteInt(item.MainWeapon.TemplateID);
                gSPacketIn.WriteInt(item.MainWeapon.StrengthenLevel);
                if (item.MainWeapon.GoldEquip == null)
                {
                    gSPacketIn.WriteInt(0);
                }
                else
                {
                    gSPacketIn.WriteInt(item.MainWeapon.GoldEquip.TemplateID);
                    gSPacketIn.WriteDateTime(item.MainWeapon.goldBeginTime);
                    gSPacketIn.WriteInt(item.MainWeapon.goldValidDate);
                }
                gSPacketIn.WriteBoolean(item.CanUseProp);
                if (item.SecondWeapon != null)
                {
                    gSPacketIn.WriteInt(item.SecondWeapon.TemplateID);
                    gSPacketIn.WriteInt(item.SecondWeapon.StrengthenLevel);
                }
                else
                {
                    gSPacketIn.WriteInt(0);
                    gSPacketIn.WriteInt(0);
                }
                if (item.Healstone != null)
                {
                    gSPacketIn.WriteInt(item.Healstone.TemplateID);
                    gSPacketIn.WriteInt(item.Healstone.Count);
                }
                else
                {
                    gSPacketIn.WriteInt(0);
                    gSPacketIn.WriteInt(0);
                }
                gSPacketIn.WriteDouble((item.GPAddPlus == 0.0) ? 1.0 : item.GPAddPlus);
                gSPacketIn.WriteDouble((item.OfferAddPlus == 0.0) ? 1.0 : item.OfferAddPlus);
                gSPacketIn.WriteDouble(item.GPApprenticeOnline);
                gSPacketIn.WriteDouble(item.GPApprenticeTeam);
                gSPacketIn.WriteDouble(item.GPSpouseTeam);
                gSPacketIn.WriteInt(GameServer.Instance.Configuration.ServerID);
                List<AbstractBuffer> allBuffer = item.BufferList.GetAllBuffer();
                gSPacketIn.WriteInt(allBuffer.Count);
                foreach (AbstractBuffer item2 in allBuffer)
                {
                    BufferInfo info = item2.Info;
                    gSPacketIn.WriteInt(info.Type);
                    gSPacketIn.WriteBoolean(info.IsExist);
                    gSPacketIn.WriteDateTime(info.BeginDate);
                    gSPacketIn.WriteInt(info.ValidDate);
                    gSPacketIn.WriteInt(info.Value);
                }
                gSPacketIn.WriteInt(item.EquipEffect.Count);
                foreach (int item3 in item.EquipEffect)
                {
                    gSPacketIn.WriteInt(item3);
                }
                gSPacketIn.WriteInt(item.FightBuffs.Count);
                foreach (BufferInfo fightBuff in item.FightBuffs)
                {
                    gSPacketIn.WriteInt(fightBuff.Type);
                    gSPacketIn.WriteInt(fightBuff.Value);
                }
                gSPacketIn.WriteByte(item.PlayerCharacter.typeVIP);
                gSPacketIn.WriteInt(item.PlayerCharacter.VIPLevel);
                gSPacketIn.WriteDateTime(item.PlayerCharacter.VIPExpireDay);
                gSPacketIn.WriteBoolean(item.MatchInfo.DailyLeagueFirst);
                gSPacketIn.WriteInt(item.MatchInfo.DailyLeagueLastScore);
                bool flag = item.Pet != null;
                gSPacketIn.WriteBoolean(flag);
                if (flag)
                {
                    gSPacketIn.WriteInt(item.Pet.Place);
                    gSPacketIn.WriteInt(item.Pet.TemplateID);
                    gSPacketIn.WriteInt(item.Pet.ID);
                    gSPacketIn.WriteString(item.Pet.Name);
                    gSPacketIn.WriteInt(item.Pet.UserID);
                    gSPacketIn.WriteInt(item.Pet.Level);
                    gSPacketIn.WriteString(item.Pet.Skill);
                    gSPacketIn.WriteString(item.Pet.SkillEquip);
                }
                gSPacketIn.WriteInt(item.CardBuff.Count);
                foreach (int item4 in item.CardBuff)
                {
                    gSPacketIn.WriteInt(item4);
                }
            }
            SendTCP(gSPacketIn);
        }

        public void SendRemoveRoom(BaseRoom room)
        {
            SendTCP(new GSPacketIn(65)
            {
                Parameter1 = room.RoomId
            });
        }

        public void SendToGame(int gameId, GSPacketIn pkg)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(2, gameId);
            gSPacketIn.WritePacket(pkg);
            SendTCP(gSPacketIn);
        }

        private void method_29(GSPacketIn gspacketIn_0)
        {
            m_server.UpdatePlayerGameId(gspacketIn_0.Parameter1, gspacketIn_0.Parameter2);
        }

        public void SendChatMessage(string msg, GamePlayer player, bool team)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(19, player.CurrentRoom.Game.Id);
            gSPacketIn.WriteInt(player.GamePlayerId);
            gSPacketIn.WriteBoolean(team);
            gSPacketIn.WriteString(msg);
            SendTCP(gSPacketIn);
        }

        public void SendFightNotice(GamePlayer player, int GameId)
        {
            SendTCP(new GSPacketIn(3, GameId)
            {
                Parameter1 = player.GameId
            });
        }

        private void HandlePlayerAddActiveMoney(GSPacketIn pkg)
        {
            GamePlayer player = WorldMgr.GetPlayerById(pkg.ClientID);
            if (player != null)
            {
                player.AddActiveMoney(pkg.Parameter1);
            }
        }
    }
}
