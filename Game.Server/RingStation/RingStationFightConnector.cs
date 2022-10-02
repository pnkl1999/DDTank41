using System;
using System.Collections.Generic;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Threading;
using Game.Base;
using Game.Base.Packets;
using Game.Logic;
using Game.Logic.Protocol;
using log4net;

namespace Game.Server.RingStation.Battle
{
    public class RingStationFightConnector : BaseConnector
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private string m_key;

        private RingStationBattleServer m_server;

        public RingStationFightConnector(RingStationBattleServer server, string ip, int port, string key) : base(ip,
            port, true, new byte[8192], new byte[8192])
        {
            m_server = server;
            m_key = key;
            Strict = true;
        }

        protected void AsynProcessPacket(object state)
        {
            try
            {
                GSPacketIn gSPacketIn = state as GSPacketIn;
                switch (gSPacketIn.Code)
                {
                    case 0:
                        HandleRSAKey(gSPacketIn);
                        break;
                    case 19:
                        HandlePlayerChatSend(gSPacketIn);
                        break;
                    case 32:
                        HandleSendToPlayer(gSPacketIn);
                        break;
                    case 33:
                        HandleUpdatePlayerGameId(gSPacketIn);
                        break;
                    case 34:
                        HandleDisconnectPlayer(gSPacketIn);
                        break;
                    case 35:
                        HandlePlayerOnGameOver(gSPacketIn);
                        break;
                    case 36:
                        HandlePlayerOnUsingItem(gSPacketIn);
                        break;
                    case 38:
                        HandlePlayerAddGold(gSPacketIn);
                        break;
                    case 39:
                        HandlePlayerAddGP(gSPacketIn);
                        break;
                    case 40:
                        HandlePlayerOnKillingLiving(gSPacketIn);
                        break;
                    case 41:
                        HandlePlayerOnMissionOver(gSPacketIn);
                        break;
                    case 42:
                        HandlePlayerConsortiaFight(gSPacketIn);
                        break;
                    case 43:
                        HandlePlayerSendConsortiaFight(gSPacketIn);
                        break;
                    case 44:
                        HandlePlayerRemoveGold(gSPacketIn);
                        break;
                    case 45:
                        HandlePlayerRemoveMoney(gSPacketIn);
                        break;
                    case 48:
                        HandlePlayerAddTemplate1(gSPacketIn);
                        break;
                    case 49:
                        HandlePlayerRemoveGP(gSPacketIn);
                        break;
                    case 50:
                        HandlePlayerRemoveOffer(gSPacketIn);
                        break;
                    case 52:
                        HandPlayerAddRobRiches(gSPacketIn);
                        break;
                    case 53:
                        HandleClearBag(gSPacketIn);
                        break;
                    case 65:
                        HandleRoomRemove(gSPacketIn);
                        break;
                    case 66:
                        HandleStartGame(gSPacketIn);
                        break;
                    case 67:
                        HandleSendToRoom(gSPacketIn);
                        break;
                    case 68:
                        HandleStopGame(gSPacketIn);
                        break;
                    case 69:
                        HandleUpdateRoomId(gSPacketIn);
                        break;
                    case 70:
                        HandlePlayerRemove(gSPacketIn);
                        break;
                    case 73:
                        HandlePlayerHealstone(gSPacketIn);
                        break;
                    case 74:
                        HandlePlayerAddMoney(gSPacketIn);
                        break;
                    case 75:
                        HandlePlayerAddGiftToken(gSPacketIn);
                        break;
                    case 76:
                        HandlePlayerAddMedal(gSPacketIn);
                        break;
                    case 77:
                        HandleFindConsortiaAlly(gSPacketIn);
                        break;
                    case 84:
                        HandlePlayerAddLeagueMoney(gSPacketIn);
                        break;
                    case 85:
                        HandlePlayerAddPrestige(gSPacketIn);
                        break;
                    case 86:
                        HandlePlayerUpdateRestCount(gSPacketIn);
                        break;
                }
            }
            catch (Exception value)
            {
                Console.WriteLine(value);
            }
        }

        private void HandleClearBag(GSPacketIn pkg)
        {
        }

        private void HandleDisconnectPlayer(GSPacketIn pkg)
        {
        }

        public void HandleFindConsortiaAlly(GSPacketIn pkg)
        {
        }

        private void HandlePlayerAddGold(GSPacketIn pkg)
        {
        }

        private void HandlePlayerAddGP(GSPacketIn pkg)
        {
        }

        private void HandlePlayerAddGiftToken(GSPacketIn pkg)
        {
        }

        private void HandlePlayerAddLeagueMoney(GSPacketIn pkg)
        {
        }

        private void HandlePlayerAddMedal(GSPacketIn pkg)
        {
        }

        private void HandlePlayerAddMoney(GSPacketIn pkg)
        {
        }

        private void HandlePlayerAddPrestige(GSPacketIn pkg)
        {
        }

        private void HandlePlayerAddTemplate1(GSPacketIn pkg)
        {
        }

        private void HandlePlayerConsortiaFight(GSPacketIn pkg)
        {
        }

        private void HandlePlayerChatSend(GSPacketIn pkg)
        {
        }

        private void HandlePlayerHealstone(GSPacketIn pkg)
        {
        }

        private void HandlePlayerOnGameOver(GSPacketIn pkg)
        {
        }

        private void HandlePlayerOnKillingLiving(GSPacketIn pkg)
        {
        }

        private void HandlePlayerOnMissionOver(GSPacketIn pkg)
        {
        }

        private void HandlePlayerOnUsingItem(GSPacketIn pkg)
        {
        }

        private void HandlePlayerRemove(GSPacketIn pkg)
        {
        }

        private void HandlePlayerRemoveGold(GSPacketIn pkg)
        {
        }

        private void HandlePlayerRemoveGP(GSPacketIn pkg)
        {
        }

        private void HandlePlayerRemoveMoney(GSPacketIn pkg)
        {
        }

        private void HandlePlayerRemoveOffer(GSPacketIn pkg)
        {
        }

        private void HandlePlayerSendConsortiaFight(GSPacketIn pkg)
        {
        }

        private void HandlePlayerUpdateRestCount(GSPacketIn pkg)
        {
        }

        protected void HandleRoomRemove(GSPacketIn packet)
        {
            m_server.RemoveRoomImp(packet.ClientID);
        }

        protected void HandleRSAKey(GSPacketIn packet)
        {
            RSAParameters parameters = new RSAParameters
            {
                Modulus = packet.ReadBytes(128),
                Exponent = packet.ReadBytes()
            };
            RSACryptoServiceProvider rSACryptoServiceProvider = new RSACryptoServiceProvider();
            rSACryptoServiceProvider.ImportParameters(parameters);
            SendRSALogin(rSACryptoServiceProvider, m_key);
        }

        protected void HandleSendToPlayer(GSPacketIn pkg)
        {
        }

        protected void HandleSendToRoom(GSPacketIn pkg)
        {
            int clientID = pkg.ClientID;
            GSPacketIn pkg2 = pkg.ReadPacket();
            m_server.SendToRoom(clientID, pkg2, pkg.Parameter1, pkg.Parameter2);
        }

        protected void HandleStartGame(GSPacketIn pkg)
        {
            ProxyRingStationGame game = new ProxyRingStationGame(pkg.Parameter2, this, (eRoomType) pkg.ReadInt(),
                (eGameType) pkg.ReadInt(), pkg.ReadInt());
            m_server.StartGame(pkg.Parameter1, game);
        }

        protected void HandleStopGame(GSPacketIn pkg)
        {
            int parameter = pkg.Parameter1;
            int parameter2 = pkg.Parameter2;
            m_server.StopGame(parameter, parameter2);
        }

        private void HandleUpdatePlayerGameId(GSPacketIn pkg)
        {
            m_server.UpdatePlayerGameId(pkg.Parameter1, pkg.Parameter2);
        }

        private void HandleUpdateRoomId(GSPacketIn pkg)
        {
        }

        private void HandPlayerAddRobRiches(GSPacketIn pkg)
        {
        }

        protected override void OnDisconnect()
        {
            base.OnDisconnect();
        }

        public override void OnRecvPacket(GSPacketIn pkg)
        {
            ThreadPool.QueueUserWorkItem(AsynProcessPacket, pkg);
        }

        public void SendAddRoom(BaseRoomRingStation room)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(64);
            gSPacketIn.WriteInt(room.RoomId);
            gSPacketIn.WriteInt(room.RoomType);
            gSPacketIn.WriteInt(room.GameType);
            gSPacketIn.WriteInt(room.GuildId);
            gSPacketIn.WriteInt(room.PickUpNpcId);
            gSPacketIn.WriteBoolean(val: false);
            gSPacketIn.WriteBoolean(room.IsAutoBot);
            gSPacketIn.WriteBoolean(val: false);
            List<VirtualGamePlayer> players = room.GetPlayers();
            gSPacketIn.WriteInt(players.Count);
            foreach (VirtualGamePlayer item in players)
            {
                gSPacketIn.WriteInt(item.ID);
                gSPacketIn.WriteString("");
                gSPacketIn.WriteBoolean(false);
                gSPacketIn.WriteInt(GameServer.Instance.Configuration.ZoneId);
                gSPacketIn.WriteString(GameServer.Instance.Configuration.ZoneName);
                gSPacketIn.WriteInt(0);
                gSPacketIn.WriteString(item.NickName);
                gSPacketIn.WriteBoolean(item.Sex);
                gSPacketIn.WriteInt(item.Hide);
                gSPacketIn.WriteString(item.Style);
                gSPacketIn.WriteString(item.Colors);
                gSPacketIn.WriteString(item.Skin);
                gSPacketIn.WriteInt(item.Offer);
                gSPacketIn.WriteInt(item.GP);
                gSPacketIn.WriteInt(item.Grade);
                gSPacketIn.WriteInt(item.Repute);
                gSPacketIn.WriteInt(item.ConsortiaID);
                gSPacketIn.WriteString(item.ConsortiaName);
                gSPacketIn.WriteInt(item.ConsortiaLevel);
                gSPacketIn.WriteInt(item.ConsortiaRepute);
                gSPacketIn.WriteBoolean(val: false);
                gSPacketIn.WriteInt(item.badgeID);
                gSPacketIn.WriteString(item.Honor);
                gSPacketIn.WriteInt(0);
                gSPacketIn.WriteString(item.WeaklessGuildProgressStr);
                gSPacketIn.WriteInt(0);
                gSPacketIn.WriteInt(0);
                gSPacketIn.WriteInt(0);
                gSPacketIn.WriteInt(0);
                gSPacketIn.WriteInt(0);
                gSPacketIn.WriteString("");
                gSPacketIn.WriteInt(item.Attack);
                gSPacketIn.WriteInt(item.Defence);
                gSPacketIn.WriteInt(item.Agility);
                gSPacketIn.WriteInt(item.Luck);
                gSPacketIn.WriteInt(item.hp);
                gSPacketIn.WriteDouble(item.BaseAttack);
                gSPacketIn.WriteDouble(item.BaseDefence);
                gSPacketIn.WriteDouble(item.BaseAgility);
                gSPacketIn.WriteDouble(item.BaseBlood);
                gSPacketIn.WriteInt(item.TemplateID);
                gSPacketIn.WriteInt(item.StrengthLevel);
                gSPacketIn.WriteInt(0);
                gSPacketIn.WriteBoolean(item.CanUserProp);
                gSPacketIn.WriteInt(item.SecondWeapon);
                gSPacketIn.WriteInt(item.StrengthLevel);
                gSPacketIn.WriteInt(0);
                gSPacketIn.WriteInt(0);
                gSPacketIn.WriteDouble(item.GPAddPlus);
                gSPacketIn.WriteDouble(item.GMExperienceRate);
                gSPacketIn.WriteDouble(0.0);
                gSPacketIn.WriteDouble(0.0);
                gSPacketIn.WriteDouble(0.0);
                gSPacketIn.WriteInt(RingStationConfiguration.ServerID);
                gSPacketIn.WriteInt(0);
                gSPacketIn.WriteInt(0);
                gSPacketIn.WriteInt(0);
                gSPacketIn.WriteByte(item.typeVIP);
                gSPacketIn.WriteInt(item.VIPLevel);
                gSPacketIn.WriteDateTime(DateTime.Now);
                gSPacketIn.WriteBoolean(val: false);
                gSPacketIn.WriteInt(0);
                gSPacketIn.WriteBoolean(val: false);
                gSPacketIn.WriteInt(0);
            }
            SendTCP(gSPacketIn);
        }

        public void SendChangeGameType()
        {
        }

        public void SendChatMessage()
        {
        }

        public void SendFightNotice()
        {
        }

        public void SendFindConsortiaAlly(int state, int gameid)
        {
        }

        public void SendKitOffPlayer(int playerid)
        {
        }

        public void SendPlayerDisconnet(int gameId, int playerId, int roomid)
        {
        }

        public void SendRemoveRoom(BaseRoomRingStation room)
        {
            GSPacketIn pkg = new GSPacketIn(65)
            {
                Parameter1 = room.RoomId
            };
            SendTCP(pkg);
        }

        public void SendRSALogin(RSACryptoServiceProvider rsa, string key)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(1);
            gSPacketIn.Write(rsa.Encrypt(Encoding.UTF8.GetBytes(key), false));
            SendTCP(gSPacketIn);
        }

        public void SendToGame(int gameId, GSPacketIn pkg)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(2, gameId);
            gSPacketIn.WritePacket(pkg);
            SendTCP(gSPacketIn);
        }

        private void SendUsingPropInGame(int gameId, int playerId, int templateId, bool result)
        {
        }
    }
}