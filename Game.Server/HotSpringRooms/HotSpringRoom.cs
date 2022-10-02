using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;
using Game.Server.Packets;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;

namespace Game.Server.HotSpringRooms
{
    public class HotSpringRoom
    {
        private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        private static object _syncStop = new object();
        private List<GamePlayer> m_players;
        private IHotSpringRoomsProcessor processor;
        private int count;
        public HotSpringRoomInfo Info;

        public int Count => this.count;

        public HotSpringRoom(HotSpringRoomInfo info, IHotSpringRoomsProcessor processor)
        {
            this.Info = info;
            this.processor = processor;
            this.m_players = new List<GamePlayer>();
            this.count = 0;
        }

        public GamePlayer[] GetAllPlayers()
        {
            lock (HotSpringRoom._syncStop)
                return this.m_players.ToArray();
        }

        public GamePlayer GetPlayerWithID(int playerId)
        {
            lock (HotSpringRoom._syncStop)
            {
                foreach (GamePlayer gamePlayer in this.m_players)
                {
                    if (gamePlayer.PlayerCharacter.ID == playerId)
                        return gamePlayer;
                }
                return (GamePlayer)null;
            }
        }

        public void SendToRoomPlayer(GSPacketIn packet)
        {
            GamePlayer[] allPlayers = this.GetAllPlayers();
            if (allPlayers == null)
                return;
            foreach (GamePlayer gamePlayer in allPlayers)
                gamePlayer.Out.SendTCP(packet);
        }

        public void SendToAll(GSPacketIn packet) => this.SendToAll(packet, (GamePlayer)null, false);

        public void SendToAll(GSPacketIn packet, GamePlayer self, bool isChat)
        {
            GamePlayer[] allPlayers = this.GetAllPlayers();
            if (allPlayers == null)
                return;
            foreach (GamePlayer gamePlayer in allPlayers)
            {
                if (!isChat || !gamePlayer.IsBlackFriend(self.PlayerCharacter.ID))
                    gamePlayer.Out.SendTCP(packet);
            }
        }

        public void SendToPlayerExceptSelf(GSPacketIn packet, GamePlayer self)
        {
            GamePlayer[] allPlayers = this.GetAllPlayers();
            if (allPlayers == null)
                return;
            foreach (GamePlayer gamePlayer in allPlayers)
            {
                if (gamePlayer != self)
                    gamePlayer.Out.SendTCP(packet);
            }
        }

        public void ProcessData(GamePlayer player, GSPacketIn data)
        {
            lock (HotSpringRoom._syncStop)
                this.processor.OnGameData(this, player, data);
        }

        public bool AddPlayer(GamePlayer player)
        {
            lock (HotSpringRoom._syncStop)
            {
                if (player.CurrentRoom != null || player.CurrentHotSpringRoom != null)
                    return false;
                if (this.m_players.Count > this.Info.maxCount)
                {
                    player.Out.SendMessage(eMessageType.Normal, "Phòng đầy");
                    return false;
                }
                if (player.Extra.Info.MinHotSpring <= 0)
                {
                    player.Out.SendMessage(eMessageType.Normal, "Bạn đã hết giờ tham gia ngày hôm nay");
                    return false;
                }
                ++this.count;
                this.m_players.Add(player);
                player.CurrentHotSpringRoom = this;
                player.Extra.Info.LastTimeHotSpring = DateTime.Now;
                this.SetDefaultPostion(player);
                if (player.CurrentRoom != null)
                    player.CurrentRoom.RemovePlayerUnsafe(player);
                player.Extra.BeginHotSpringTimer();
                player.OnEnterHotSpring();
                HotSpringMgr.SendUpdateAllRoom((GamePlayer)null, new HotSpringRoom[1]
                {
                    player.CurrentHotSpringRoom
                });
                GSPacketIn packet = new GSPacketIn((short)ePackageType.HOTSPRING_ROOM_PLAYER_ADD);
                packet.WriteInt(player.PlayerCharacter.ID);
                packet.WriteInt(player.PlayerCharacter.Grade);
                packet.WriteInt(player.PlayerCharacter.Hide);
                packet.WriteInt(player.PlayerCharacter.Repute);
                packet.WriteString(player.PlayerCharacter.NickName);
                packet.WriteByte(player.PlayerCharacter.typeVIP);
                packet.WriteInt(player.PlayerCharacter.VIPLevel);
                packet.WriteBoolean(player.PlayerCharacter.Sex);
                packet.WriteString(player.PlayerCharacter.Style);
                packet.WriteString(player.PlayerCharacter.Colors);
                packet.WriteString(player.PlayerCharacter.Skin);
                packet.WriteInt(player.Hot_X);
                packet.WriteInt(player.Hot_Y);
                packet.WriteInt(player.PlayerCharacter.FightPower);
                packet.WriteInt(player.PlayerCharacter.Win);
                packet.WriteInt(player.PlayerCharacter.Total);
                packet.WriteInt(player.Hot_Direction);
                this.SendToPlayerExceptSelf(packet, player);
            }
            return true;
        }

        public void RemovePlayer(GamePlayer player)
        {
            lock (HotSpringRoom._syncStop)
            {
                if (player.CurrentHotSpringRoom == null)
                    return;
                --this.count;
                this.m_players.Remove(player);
                player.Extra.StopHotSpringTimer();
                GSPacketIn packet = new GSPacketIn((short)ePackageType.HOTSPRING_ROOM_PLAYER_REMOVE_NOTICE, player.PlayerCharacter.ID);
                packet.WriteInt(player.PlayerCharacter.ID);
                packet.WriteString("");
                player.CurrentHotSpringRoom.SendToAll(packet);
                this.SetDefaultPostion(player);
                HotSpringMgr.SendUpdateAllRoom((GamePlayer)null, new HotSpringRoom[1]
                {
                    player.CurrentHotSpringRoom
                });
                player.CurrentHotSpringRoom = (HotSpringRoom)null;
            }
        }

        public void SetDefaultPostion(GamePlayer p)
        {
            p.Hot_X = 480;
            p.Hot_Y = 560;
            p.Hot_Direction = 3;
        }
    }
}
