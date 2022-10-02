using System;
using System.Collections.Generic;
using System.Linq;
using Bussiness;
using Bussiness.Protocol;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;
using Game.Server.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Rooms
{
    public class BaseWorldBossRoom
    {
        private Dictionary<int, GamePlayer> _mList;

        private Dictionary<int, RankingPersonInfo> _ranklist;

        public int MaxBlood { get; set; }

        public int Blood { get; set; }

        public string Name { get; set; }

        public string BossResourceId { get; set; }

        public DateTime BeginTime { get; set; }

        public DateTime EndTime { get; set; }

        public int CurrentPve { get; set; }

        public bool FightOver { get; set; }

        public bool RoomClose { get; set; }

        public bool WorldOpen { get; set; }

        public int FightTime { get; set; }

        public bool IsDie { get; set; }

        public int PlayerDefaultPosX = 265;
        public int PlayerDefaultPosY = 1030;
        public int TicketId = 11573;
        public int NeedTicketCount = 0;
        public int TimeCd = 15;
        public int ReviveMoney = 1000;
        public int ReFightMoney = 1200;
        public int addInjureBuffMoney = 30;//30000;
        public int addInjureValue = 200;

        public BaseWorldBossRoom()
        {
            _mList = new Dictionary<int, GamePlayer>();
            _ranklist = new Dictionary<int, RankingPersonInfo>();
            IsDie = false;
            WorldOpen = false;
            FightOver = true;
            RoomClose = true;
            Name = "boss";
            BossResourceId = "0";
            CurrentPve = 0;
        }

        public void ResetConfigRoom()
        {
            _mList = new Dictionary<int, GamePlayer>();
            _ranklist = new Dictionary<int, RankingPersonInfo>();
            IsDie = false;
            WorldOpen = false;
            FightOver = true;
            RoomClose = true;
            Name = "boss";
            BossResourceId = "0";
            CurrentPve = 0;
        }

        public void UpdateRank(GamePlayer p, int damage, int honor)
        {
            lock (_ranklist)
            {
                RankingPersonInfo urank = new RankingPersonInfo();
                urank = _ranklist[p.PlayerCharacter.ID];
                urank.Damage = _ranklist[p.PlayerCharacter.ID].Damage + damage;
                urank.TotalDamage = _ranklist[p.PlayerCharacter.ID].TotalDamage + damage;
                urank.Honor = _ranklist[p.PlayerCharacter.ID].Honor + honor;
                _ranklist[p.PlayerCharacter.ID] = urank;
                this.RankPlayerCommit();
            }
        }

        //public void UpdateWorldBoss(GSPacketIn pkg)
        //{
        //    return;
        //}

        public void UpdateWorldBoss(GSPacketIn pkg)
        {
            int maxBlood = pkg.ReadInt();
            int revert_blood = pkg.ReadInt();
            string t_name = pkg.ReadString();
            string t_bossResourceId = pkg.ReadString();
            int t_currentPVE = pkg.ReadInt();
            FightOver = pkg.ReadBoolean();
            RoomClose = pkg.ReadBoolean();
            BeginTime = pkg.ReadDateTime();
            EndTime = pkg.ReadDateTime();
            FightTime = pkg.ReadInt();
            bool isOpen = pkg.ReadBoolean();

            MaxBlood = maxBlood;
            Blood = revert_blood;
            Name = t_name;
            BossResourceId = t_bossResourceId;
            CurrentPve = t_currentPVE;
            WorldOpen = isOpen;
            GamePlayer[] players = WorldMgr.GetAllPlayers();
            foreach (GamePlayer p in players)
            {
                p.Out.SendOpenWorldBoss(p.X, p.Y);
            }

        }

        public void WorldBossClose()
        {
            WorldOpen = false;
            var players = GetPlayersSafe();
            foreach (var p in players)
                RemovePlayer(p);
        }

        public void SendGiftForUserJoined()
        {
            List<RankingPersonInfo> list_Top10 = new List<RankingPersonInfo>();
            lock (_ranklist)
            {
                IOrderedEnumerable<KeyValuePair<int, RankingPersonInfo>> enumerable = _ranklist.OrderByDescending((KeyValuePair<int, RankingPersonInfo> pair) => pair.Value.TotalDamage);
                foreach (KeyValuePair<int, RankingPersonInfo> pair2 in enumerable)
                {
                    if (list_Top10.Count == 10)
                    {
                        break;
                    }
                    list_Top10.Add(pair2.Value);
                }
            }
            //foreach(RankingPersonInfo top10 in list_Top10)
            //{
            //    // Quà đá tăng cấp
            //    WorldMgr.GetPlayerById(top10.UserID).SendItemToMail(11150, "Phần thưởng bonus cho top 10 event BOSS Thế giới", "Quà Top 10");
            //}
        }

        public void FightOvered()
        {
            var pkg = new GSPacketIn((byte)eChatServerPacket.WORLD_BOSS_FIGHTOVER);
            GameServer.Instance.LoginServer.SendPacket(pkg);
        }

        public bool ReduceBlood(int value)
        {
            bool result = true;
            if (this.Blood <= 0 || value <= 0)
            {
                result = false;
            }
            else if (this.Blood >= value)
            {
                this.Blood -= value;
            }
            else
            {
                this.Blood = 0;
            }
            var pkg = new GSPacketIn((byte)ePackageType.WORLDBOSS_CMD);
            pkg.WriteByte((byte)WorldBossPackageType.WORLDBOSS_BLOOD_UPDATE);
            pkg.WriteBoolean(false);
            pkg.WriteInt(this.MaxBlood);
            pkg.WriteInt(this.Blood);
            SendToAllPlayers(pkg);
            return result;
        }

        public void SendFightOver()
        {
            var pkg = new GSPacketIn((byte)ePackageType.WORLDBOSS_CMD);
            pkg.WriteByte((byte)WorldBossPackageType.WORLDBOSS_FIGHTOVER);
            pkg.WriteBoolean(true);
            SendToAllPlayers(pkg);
        }

        public void SendRoomClose()
        {
            var pkg = new GSPacketIn((byte)ePackageType.WORLDBOSS_CMD);
            pkg.WriteByte((byte)WorldBossPackageType.WORLDBOSS_ROOM_CLOSE);
            SendToAllPlayers(pkg);
        }

        public void SendEndedBossYouGotNotThing()
        {
            var players = GetPlayersSafe();

        }

        public void SendAllOver()
        {
            this.ResetConfigRoom();
            var pkg = new GSPacketIn((byte)ePackageType.WORLDBOSS_CMD);
            pkg.WriteByte((byte)WorldBossPackageType.OVER);
            SendToAllPlayers(pkg);
        }

        public void UpdateWorldBossRankCrosszone(GSPacketIn packet)
        {
            var pkg = new GSPacketIn((byte)ePackageType.WORLDBOSS_CMD);
            pkg.WriteByte((byte)WorldBossPackageType.WORLDBOSS_RANKING);
            var type = packet.ReadBoolean();
            var count = packet.ReadInt();
            pkg.WriteBoolean(type);
            pkg.WriteInt(count);
            for (var i = 0; i < count; i++)
            {
                var id = packet.ReadInt();
                var name = packet.ReadString();
                var damage = packet.ReadInt();
                pkg.WriteInt(id); //_loc_6.id = event.pkg.readInt();
                pkg.WriteString(name); //_loc_6.name = event.pkg.readUTF();
                pkg.WriteInt(damage); //_loc_6.damage = event.pkg.readInt();
            }

            if (type)
                SendToAllPlayers(pkg);
            else
                SendToAll(pkg);
        }

        public void SendPrivateInfo(string name)
        {
            var pkg = new GSPacketIn((byte)eChatServerPacket.WORLDBOSS_PRIVATE_INFO);
            pkg.WriteString(name);
            GameServer.Instance.LoginServer.SendPacket(pkg);
        }

        public void SendPrivateInfo(string name, int damage, int honor)
        {
            var pkg = new GSPacketIn((byte)ePackageType.WORLDBOSS_CMD);
            pkg.WriteByte((byte)WorldBossPackageType.WORLDBOSS_PRIVATE_INFO);
            pkg.WriteInt(damage); //_loc_6.damage = event.pkg.readInt();
            pkg.WriteInt(honor); //_loc_6.honor = event.pkg.readInt();
            var players = GetPlayersSafe();
            foreach (var p in players)
                if (p.PlayerCharacter.NickName == name)
                {
                    p.Out.SendTCP(pkg);
                    break;
                }
        }

        public void SendUpdateBlood(GSPacketIn packet)
        {
            var maxBlood = packet.ReadInt();
            Blood = packet.ReadInt();
            var pkg = new GSPacketIn((byte)ePackageType.WORLDBOSS_CMD);
            pkg.WriteByte((byte)WorldBossPackageType.WORLDBOSS_BLOOD_UPDATE);
            pkg.WriteBoolean(false); //_autoBlood = event.pkg.readBoolean();
            pkg.WriteInt(maxBlood); //_bossInfo.total_Blood = event.pkg.readLong();
            pkg.WriteInt(Blood); //_bossInfo.current_Blood = event.pkg.readLong();
            SendToAll(pkg);
        }

        public bool AddPlayer(GamePlayer player)
        {
            var result = false;
            lock (_mList)
            {
                if (!_mList.ContainsKey(player.PlayerId))
                {
                    _mList.Add(player.PlayerId, player);
                    result = true;
                    //ShowRank();
                    SendPrivateInfo(player.PlayerCharacter.NickName);
                }
                RankPlayerCommit(player);
            }
            if (result)
            {
                var pkg = new GSPacketIn((byte)ePackageType.WORLDBOSS_CMD);
                pkg.WriteByte((byte)WorldBossPackageType.ENTER);
                pkg.WriteInt(player.PlayerCharacter.Grade);
                pkg.WriteInt(player.PlayerCharacter.Hide);
                pkg.WriteInt(player.PlayerCharacter.Repute);
                pkg.WriteInt(player.PlayerCharacter.ID);
                pkg.WriteString(player.PlayerCharacter.NickName);
                pkg.WriteByte(player.PlayerCharacter.typeVIP);
                pkg.WriteInt(player.PlayerCharacter.VIPLevel);
                pkg.WriteBoolean(player.PlayerCharacter.Sex);
                pkg.WriteString(player.PlayerCharacter.Style);
                pkg.WriteString(player.PlayerCharacter.Colors);
                pkg.WriteString(player.PlayerCharacter.Skin);
                pkg.WriteInt(player.X);
                pkg.WriteInt(player.Y);
                pkg.WriteInt(player.PlayerCharacter.FightPower);
                pkg.WriteInt(player.PlayerCharacter.Win);
                pkg.WriteInt(player.PlayerCharacter.Total);
                pkg.WriteInt(player.PlayerCharacter.Offer);
                pkg.WriteByte(player.States);
                pkg.WriteInt(0); //_loc_2.readInt();
                pkg.WriteInt(0); //_loc_6.playerInfo.MountsType = _loc_2.readInt();
                pkg.WriteInt(0); //_loc_6.playerInfo.PetsID = _loc_2.readInt();
                SendToAll(pkg);
            }

            return result;
        }

        public void ViewOtherPlayerRoom(GamePlayer player)
        {
            var players = GetPlayersSafe();
            foreach (var p in players)
                if (p != player)
                {
                    var pkg = new GSPacketIn((byte)ePackageType.WORLDBOSS_CMD);
                    pkg.WriteByte((byte)WorldBossPackageType.ENTER);
                    pkg.WriteInt(p.PlayerCharacter.Grade);
                    pkg.WriteInt(p.PlayerCharacter.Hide);
                    pkg.WriteInt(p.PlayerCharacter.Repute);
                    pkg.WriteInt(p.PlayerCharacter.ID);
                    pkg.WriteString(p.PlayerCharacter.NickName);
                    pkg.WriteByte(p.PlayerCharacter.typeVIP);
                    pkg.WriteInt(p.PlayerCharacter.VIPLevel);
                    pkg.WriteBoolean(p.PlayerCharacter.Sex);
                    pkg.WriteString(p.PlayerCharacter.Style);
                    pkg.WriteString(p.PlayerCharacter.Colors);
                    pkg.WriteString(p.PlayerCharacter.Skin);
                    pkg.WriteInt(p.X);
                    pkg.WriteInt(p.Y);
                    pkg.WriteInt(p.PlayerCharacter.FightPower);
                    pkg.WriteInt(p.PlayerCharacter.Win);
                    pkg.WriteInt(p.PlayerCharacter.Total);
                    pkg.WriteInt(p.PlayerCharacter.Offer);
                    pkg.WriteByte(p.States);
                    pkg.WriteInt(0); //_loc_2.readInt();
                    pkg.WriteInt(0); //_loc_6.playerInfo.MountsType = _loc_2.readInt();
                    pkg.WriteInt(p.Pet.PetID); //_loc_6.playerInfo.PetsID = _loc_2.readInt();
                    player.SendTCP(pkg);
                }
        }

        public bool RankPlayerCommit(GamePlayer player = null)
        {
            lock (_ranklist)
            {
                var pkg = new GSPacketIn((byte)ePackageType.WORLDBOSS_CMD);
                pkg.WriteByte((byte)WorldBossPackageType.WORLDBOSS_RANKING);
                pkg.WriteBoolean(false);
                if (player != null && !_ranklist.ContainsKey(player.PlayerCharacter.ID))
                {
                    RankingPersonInfo urinfo = new RankingPersonInfo();
                    urinfo.Damage = 0;
                    urinfo.Honor = 0;
                    urinfo.ID = player.PlayerCharacter.ID;
                    urinfo.Name = player.PlayerCharacter.NickName;
                    urinfo.TotalDamage = 0;
                    urinfo.UserID = player.PlayerCharacter.ID;
                    _ranklist.Add(player.PlayerCharacter.ID, urinfo);

                }
                //pkg.WriteInt(_ranklist.Count);

                List<RankingPersonInfo> list_Top10 = new List<RankingPersonInfo>();
                IOrderedEnumerable<KeyValuePair<int, RankingPersonInfo>> enumerable = _ranklist.OrderByDescending((KeyValuePair<int, RankingPersonInfo> pair) => pair.Value.TotalDamage);
                foreach (KeyValuePair<int, RankingPersonInfo> pair2 in enumerable)
                {
                    if (list_Top10.Count == 10)
                    {
                        break;
                    }
                    list_Top10.Add(pair2.Value);
                }
                pkg.WriteInt(list_Top10.Count);
                foreach (RankingPersonInfo uranking in list_Top10)
                {
                    pkg.WriteInt(uranking.ID); //_loc5_.id = param1.readInt();
                    pkg.WriteString(uranking.Name); //_loc5_.name = param1.readUTF();
                    pkg.WriteInt(uranking.Damage); //_loc5_.damage = param1.readInt();
                }
                SendToAll(pkg);
            }
            return true;
        }
        public bool RemovePlayer(GamePlayer player)
        {
            var result = false;
            lock (_mList)
            {
                result = _mList.Remove(player.PlayerId);
                var response = new GSPacketIn((byte)ePackageType.WORLDBOSS_CMD);
                response.WriteByte((byte)WorldBossPackageType.WORLDBOSS_EXIT);
                response.WriteInt(player.PlayerId);
                SendToAll(response);
            }

            if (result)
            {
                var pkg = player.Out.SendSceneRemovePlayer(player);
                SendToAll(pkg, player);
                if (player.CurrentRoom != null)
                {
                    player.CurrentRoom.RemovePlayerUnsafe(player);
                }
            }

            return true;
        }

        public GamePlayer[] GetPlayersSafe()
        {
            GamePlayer[] temp = null;

            lock (_mList)
            {
                temp = new GamePlayer[_mList.Count];
                _mList.Values.CopyTo(temp, 0);
            }

            return temp;
        }

        public void SendToAllPlayers(GSPacketIn packet)
        {
            var players = WorldMgr.GetAllPlayers();
            foreach (var p in players) p.SendTCP(packet);
        }

        public void SendToAll(GSPacketIn packet)
        {
            SendToAll(packet, null);
        }

        public void SendToAll(GSPacketIn packet, GamePlayer except)
        {
            GamePlayer[] temp = null;
            lock (_mList)
            {
                temp = new GamePlayer[_mList.Count];
                _mList.Values.CopyTo(temp, 0);
            }

            foreach (var p in temp)
                if (p != null && p != except)
                    p.Out.SendTCP(packet);
        }
    }
}