using Bussiness;
using Game.Base;
using Game.Base.Packets;
using Game.Server.GameUtils;
using Game.Server.Packets;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Reflection;
using System.Security.Cryptography;
using System.Threading;

namespace Game.Server.Managers
{
    public sealed class WorldMgr
    {
        private static readonly ILog ilog_0;

        private static ReaderWriterLock m_clientLocker;

        private static Dictionary<int, GamePlayer> m_players;

        public static Dictionary<int, UsersExtraInfo> CaddyRank;

        private static Dictionary<int, AreaConfigInfo> dictionary_1;

        private static Dictionary<int, EdictumInfo> dictionary_2;

        private static Dictionary<int, ShopFreeCountInfo> dictionary_3;

        private static Dictionary<int, UserExitRoomLogInfo> dictionary_4;

        private static AreaConfigInfo areaConfigInfo_0;

        public static DateTime LastTimeUpdateCaddyRank;

        public static Scene _marryScene;

        public static Scene _hotSpringScene;

        private static RSACryptoServiceProvider rsacryptoServiceProvider_0;

        private static string[] string_0;

        public static Scene MarryScene => _marryScene;

        public static Scene HotSpringScene => _hotSpringScene;

        public static RSACryptoServiceProvider RsaCryptor => rsacryptoServiceProvider_0;

        public static bool Init()
        {
            bool result = false;
            try
            {
                rsacryptoServiceProvider_0 = new RSACryptoServiceProvider();
                rsacryptoServiceProvider_0.FromXmlString(GameServer.Instance.Configuration.PrivateKey);
                m_players.Clear();
                using (ServiceBussiness serviceBussiness = new ServiceBussiness())
                {
                    ServerInfo serviceSingle = serviceBussiness.GetServiceSingle(GameServer.Instance.Configuration.ServerID);
                    if (serviceSingle != null)
                    {
                        _marryScene = new Scene(serviceSingle);
                        _hotSpringScene = new Scene(serviceSingle);
                        result = true;
                    }
                }
                Dictionary<int, EdictumInfo> dictionary = smethod_0();
                if (dictionary.Values.Count > 0)
                {
                    Interlocked.Exchange(ref dictionary_2, dictionary);
                }
                UpdateCaddyRank();
                smethod_2();
                return result;
            }
            catch (Exception exception)
            {
                ilog_0.Error("WordMgr Init", exception);
                return result;
            }
        }

        public static bool ReloadEdictum()
        {
            bool result = false;
            try
            {
                Dictionary<int, EdictumInfo> dictionary = smethod_0();
                if (dictionary.Values.Count > 0)
                {
                    Interlocked.Exchange(ref dictionary_2, dictionary);
                }
                result = true;
                return result;
            }
            catch (Exception exception)
            {
                ilog_0.Error("WordMgr ReloadEdictum Init", exception);
                return result;
            }
        }

        private static Dictionary<int, EdictumInfo> smethod_0()
        {
            Dictionary<int, EdictumInfo> dictionary = new Dictionary<int, EdictumInfo>();
            using ProduceBussiness produceBussiness = new ProduceBussiness();
            EdictumInfo[] allEdictum = produceBussiness.GetAllEdictum();
            EdictumInfo[] array = allEdictum;
            foreach (EdictumInfo edictumInfo in array)
            {
                if (!dictionary.ContainsKey(edictumInfo.ID))
                {
                    dictionary.Add(edictumInfo.ID, edictumInfo);
                }
            }
            return dictionary;
        }

        public static bool AddPlayer(int playerId, GamePlayer player)
        {
            m_clientLocker.AcquireWriterLock(-1);
            try
            {
                if (m_players.ContainsKey(playerId))
                {
                    return false;
                }
                m_players.Add(playerId, player);
            }
            finally
            {
                m_clientLocker.ReleaseWriterLock();
            }
            return true;
        }

        public static bool RemovePlayer(int playerId)
        {
            m_clientLocker.AcquireWriterLock(-1);
            GamePlayer gamePlayer = null;
            try
            {
                if (m_players.ContainsKey(playerId))
                {
                    gamePlayer = m_players[playerId];
                    m_players.Remove(playerId);
                }
            }
            finally
            {
                m_clientLocker.ReleaseWriterLock();
            }
            if (gamePlayer == null)
            {
                return false;
            }
            GameServer.Instance.LoginServer.SendUserOffline(playerId, gamePlayer.PlayerCharacter.ConsortiaID);
            return true;
        }

        public static GamePlayer GetPlayerById(int playerId)
        {
            GamePlayer result = null;
            m_clientLocker.AcquireReaderLock(-1);
            try
            {
                if (m_players.ContainsKey(playerId))
                {
                    return m_players[playerId];
                }
                return result;
            }
            finally
            {
                m_clientLocker.ReleaseReaderLock();
            }
        }

        public static GamePlayer GetClientByPlayerNickName(string nickName)
        {
            GamePlayer[] allPlayers = GetAllPlayers();
            GamePlayer[] array = allPlayers;
            foreach (GamePlayer gamePlayer in array)
            {
                if (gamePlayer.PlayerCharacter.NickName == nickName)
                {
                    return gamePlayer;
                }
            }
            return null;
        }

        public static GamePlayer GetClientByPlayerUserName(string userName)
        {
            GamePlayer[] allPlayers = GetAllPlayers();
            GamePlayer[] array = allPlayers;
            foreach (GamePlayer gamePlayer in array)
            {
                if (gamePlayer.PlayerCharacter.UserName == userName)
                {
                    return gamePlayer;
                }
            }
            return null;
        }

        public static GamePlayer[] GetAllPlayers()
        {
            List<GamePlayer> list = new List<GamePlayer>();
            m_clientLocker.AcquireReaderLock(-1);
            try
            {
                foreach (GamePlayer value in m_players.Values)
                {
                    if (value != null && value.PlayerCharacter != null)
                    {
                        list.Add(value);
                    }
                }
            }
            finally
            {
                m_clientLocker.ReleaseReaderLock();
            }
            return list.ToArray();
        }

        public static string getAddress(GamePlayer p)
        {
            return (p.Client.Socket.RemoteEndPoint as IPEndPoint)?.Address.ToString();
        }

        public static bool IsAccountLimit(GamePlayer p)
        {
            if (p.Client == null)
            {
                return false;
            }
            bool result = false;
            string hWID = p.Client.HWID;
            if (hWID != null && hWID.Length > 0)
            {
                GamePlayer[] allPlayerWithHWID = GetAllPlayerWithHWID(hWID);
                if (allPlayerWithHWID.Length >= GameProperties.CountHWIDLimit)
                {
                    p.BlockReceiveMoney = true;
                    p.Out.SendMessage(eMessageType.ALERT, "Đạt giới hạn số tài khoản một máy cho phép là " + GameProperties.CountHWIDLimit + ", bạn có thể bị đá ra khỏi game");
                    string text = "";
                    GamePlayer[] array = allPlayerWithHWID;
                    GamePlayer[] array2 = array;
                    foreach (GamePlayer gamePlayer in array2)
                    {
                        gamePlayer.BlockReceiveMoney = true;
                        text = text + gamePlayer.PlayerCharacter.UserName + "(" + gamePlayer.PlayerCharacter.NickName + ").";
                    }
                    p.AddLog("checkonline", "LAUNCHER Username: " + p.PlayerCharacter.UserName + "|NickName: " + p.PlayerCharacter.NickName + "|ListAccountSameIP: " + text);
                    result = true;
                }
            }
            else
            {
                string IP = getAddress(p);
                if (IP != null)
                {
                    GamePlayer[] allPlayerWithIP = GetAllPlayerWithIP(IP);
                    if (allPlayerWithIP.Length >= GameProperties.CountIPLimit)
                    {
                        GamePlayer[] array3 = allPlayerWithIP;
                        foreach (GamePlayer gamePlayer2 in array3)
                        {
                            gamePlayer2.BlockReceiveMoney = true;
                            gamePlayer2.Out.SendMessage(eMessageType.ALERT, "Đạt giới hạn số tài khoản cho phép là " + GameProperties.CountIPLimit + ", bạn có thể không nhận được xu");
                        }
                        string text3 = "";
                        GamePlayer[] array4 = allPlayerWithIP;
                        GamePlayer[] array5 = array4;
                        foreach (GamePlayer gamePlayer3 in array5)
                        {
                            text3 = text3 + gamePlayer3.PlayerCharacter.UserName + "(" + gamePlayer3.PlayerCharacter.NickName + ").";
                        }
                        p.AddLog("checkonline", "Username: " + p.PlayerCharacter.UserName + "|NickName: " + p.PlayerCharacter.NickName + "|ListAccountSameIP: " + text3);
                        result = true;
                    }
                }
            }
            return result;
        }

        public static GamePlayer[] GetAllPlayerWithHWID(string hwid)
        {
            List<GamePlayer> list = new List<GamePlayer>();
            m_clientLocker.AcquireReaderLock(-1);
            try
            {
                foreach (GamePlayer value in m_players.Values)
                {
                    if (value != null && value.PlayerCharacter != null && value.Client != null && value.Client.IsConnected && value.Client.HWID != null && value.Client.HWID.Length > 0 && value.Client.HWID == hwid)
                    {
                        list.Add(value);
                    }
                }
            }
            finally
            {
                m_clientLocker.ReleaseReaderLock();
            }
            return list.ToArray();
        }

        public static GamePlayer[] GetAllPlayerWithIP(string ip)
        {
            List<GamePlayer> list = new List<GamePlayer>();
            m_clientLocker.AcquireReaderLock(-1);
            try
            {
                foreach (GamePlayer value in m_players.Values)
                {
                    if (value != null && value.PlayerCharacter != null && value.Client != null && value.Client.Socket != null && value.Client.IsConnected && ((value.Client.Socket.RemoteEndPoint as IPEndPoint)?.Address.ToString().Contains(ip) ?? false))
                    {
                        list.Add(value);
                    }
                }
            }
            finally
            {
                m_clientLocker.ReleaseReaderLock();
            }
            return list.ToArray();
        }

        public static GamePlayer[] GetAllPlayersNoGame()
        {
            List<GamePlayer> list = new List<GamePlayer>();
            m_clientLocker.AcquireReaderLock(-1);
            try
            {
                GamePlayer[] allPlayers = GetAllPlayers();
                GamePlayer[] array = allPlayers;
                foreach (GamePlayer gamePlayer in array)
                {
                    if (gamePlayer.CurrentRoom == null)
                    {
                        list.Add(gamePlayer);
                    }
                }
            }
            finally
            {
                m_clientLocker.ReleaseReaderLock();
            }
            return list.ToArray();
        }

        public static GamePlayer GetSinglePlayerWithConsortia(int ConsortiaID)
        {
            GamePlayer result = null;
            m_clientLocker.AcquireReaderLock(-1);
            try
            {
                foreach (GamePlayer value in m_players.Values)
                {
                    if (value != null && value.PlayerCharacter != null && value.PlayerCharacter.ConsortiaID == ConsortiaID)
                    {
                        result = value;
                    }
                }
                return result;
            }
            finally
            {
                m_clientLocker.ReleaseReaderLock();
            }
        }

        public static GamePlayer[] GetAllPlayersWithConsortia(int ConsortiaID)
        {
            List<GamePlayer> list = new List<GamePlayer>();
            m_clientLocker.AcquireReaderLock(-1);
            try
            {
                foreach (GamePlayer value in m_players.Values)
                {
                    if (value != null && value.PlayerCharacter != null && value.PlayerCharacter.ConsortiaID == ConsortiaID)
                    {
                        list.Add(value);
                    }
                }
            }
            finally
            {
                m_clientLocker.ReleaseReaderLock();
            }
            return list.ToArray();
        }

        public static string GetPlayerStringByPlayerNickName(string nickName)
        {
            GamePlayer[] allPlayers = GetAllPlayers();
            GamePlayer[] array = allPlayers;
            foreach (GamePlayer gamePlayer in array)
            {
                if (gamePlayer.PlayerCharacter.NickName == nickName)
                {
                    return gamePlayer.ToString();
                }
            }
            return nickName + " is not online!";
        }

        public static string DisconnectPlayerByName(string nickName)
        {
            GamePlayer[] allPlayers = GetAllPlayers();
            GamePlayer[] array = allPlayers;
            foreach (GamePlayer gamePlayer in array)
            {
                if (gamePlayer.PlayerCharacter.NickName == nickName)
                {
                    gamePlayer.Disconnect();
                    return "OK";
                }
            }
            return nickName + " is not online!";
        }

        public static void OnPlayerOffline(int playerid, int consortiaID)
        {
            ChangePlayerState(playerid, 0, consortiaID);
        }

        public static void OnPlayerOnline(int playerid, int consortiaID)
        {
            ChangePlayerState(playerid, 1, consortiaID);
        }

        public static bool CheckUserOnline(int userid)
        {
            GamePlayer[] allPlayers = GetAllPlayers();
            GamePlayer[] array = allPlayers;
            foreach (GamePlayer gamePlayer in array)
            {
                if (gamePlayer.PlayerCharacter.ID == userid)
                {
                    return true;
                }
            }
            return false;
        }

        public static void ChangePlayerState(int playerID, int state, int consortiaID)
        {
            GSPacketIn gSPacketIn = null;
            GamePlayer[] allPlayers = GetAllPlayers();
            GamePlayer[] array = allPlayers;
            foreach (GamePlayer gamePlayer in array)
            {
                if ((gamePlayer.Friends != null && gamePlayer.Friends.ContainsKey(playerID) && gamePlayer.Friends[playerID] == 0) || (gamePlayer.PlayerCharacter.ConsortiaID != 0 && gamePlayer.PlayerCharacter.ConsortiaID == consortiaID))
                {
                    if (gSPacketIn == null)
                    {
                        gSPacketIn = gamePlayer.Out.SendFriendState(playerID, state, gamePlayer.PlayerCharacter.typeVIP, gamePlayer.PlayerCharacter.VIPLevel);
                    }
                    else
                    {
                        gamePlayer.SendTCP(gSPacketIn);
                    }
                }
            }
        }

        public static void UpdateExitGame(int userId)
        {
            lock (dictionary_4)
            {
                if (dictionary_4.ContainsKey(userId))
                {
                    if (dictionary_4[userId].TotalExitTime <= 3)
                    {
                        dictionary_4[userId].TotalExitTime++;
                    }
                    else
                    {
                        dictionary_4[userId].TimeBlock = DateTime.Now.AddMinutes(30.0);
                    }
                    dictionary_4[userId].LastLogout = DateTime.Now;
                }
                else
                {
                    dictionary_4.Add(userId, new UserExitRoomLogInfo
                    {
                        UserID = userId,
                        TimeBlock = DateTime.MinValue,
                        TotalExitTime = 1,
                        LastLogout = DateTime.Now
                    });
                }
            }
        }

        public static DateTime CheckTimeEnterRoom(int userid)
        {
            lock (dictionary_4)
            {
                if (dictionary_4.ContainsKey(userid))
                {
                    if (dictionary_4[userid].TimeBlock > DateTime.Now)
                    {
                        return dictionary_4[userid].TimeBlock;
                    }
                    if (dictionary_4[userid].TotalExitTime > 3)
                    {
                        dictionary_4[userid].TotalExitTime = 0;
                    }
                }
                return DateTime.MinValue;
            }
        }

        public static bool UpdateShopFreeCount(int shopId, int total)
        {
            bool result = false;
            lock (dictionary_3)
            {
                if (dictionary_3.ContainsKey(shopId))
                {
                    if (dictionary_3[shopId].Count <= 0)
                    {
                        return result;
                    }
                    dictionary_3[shopId].Count--;
                    return true;
                }
                dictionary_3.Add(shopId, new ShopFreeCountInfo
                {
                    ShopID = shopId,
                    Count = total - 1,
                    CreateDate = DateTime.Now
                });
                return true;
            }
        }

        private static void smethod_2()
        {
            WorldMgrDataInfo worldMgrDataInfo = Marshal.LoadDataFile<WorldMgrDataInfo>("shopfreecount", isEncrypt: true);
            if (worldMgrDataInfo != null && worldMgrDataInfo.ShopFreeCount != null)
            {
                dictionary_3 = worldMgrDataInfo.ShopFreeCount;
            }
        }

        private static void smethod_3()
        {
            Marshal.SaveDataFile(new WorldMgrDataInfo
            {
                ShopFreeCount = dictionary_3
            }, "shopfreecount", isEncrypt: true);
        }

        public static void ScanShopFreeVaildDate()
        {
            lock (dictionary_3)
            {
                bool flag = false;
                foreach (ShopFreeCountInfo value in dictionary_3.Values)
                {
                    DateTime date = value.CreateDate.Date;
                    DateTime date2 = DateTime.Now.Date;
                    if (date != date2)
                    {
                        flag = true;
                        break;
                    }
                }
                if (flag)
                {
                    dictionary_3.Clear();
                }
            }
        }

        public static List<ShopFreeCountInfo> GetAllShopFreeCount()
        {
            List<ShopFreeCountInfo> list = new List<ShopFreeCountInfo>();
            lock (dictionary_3)
            {
                foreach (ShopFreeCountInfo value in dictionary_3.Values)
                {
                    list.Add(value);
                }
                return list;
            }
        }

        public static GSPacketIn SendSysNotice(eMessageType type, string msg, int ItemID, int TemplateID, string key)
        {
            int val = msg.IndexOf(TemplateID.ToString(), StringComparison.Ordinal);
            GSPacketIn gSPacketIn = new GSPacketIn(10);
            gSPacketIn.WriteInt((int)type);
            gSPacketIn.WriteString(msg.Replace(TemplateID.ToString(), ""));
            gSPacketIn.WriteByte(1);
            gSPacketIn.WriteInt(val);
            gSPacketIn.WriteInt(TemplateID);
            gSPacketIn.WriteInt(ItemID);
            if (!string.IsNullOrEmpty(key))
            {
                gSPacketIn.WriteString(key);
            }
            SendToAll(gSPacketIn);
            return gSPacketIn;
        }

        public static GSPacketIn SendSysTipNotice(string msg)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(10);
            gSPacketIn.WriteInt(2);
            gSPacketIn.WriteString(msg);
            SendToAll(gSPacketIn);
            return gSPacketIn;
        }

        public static GSPacketIn SendSysNotice(string msg)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(10);
            gSPacketIn.WriteInt(3);
            gSPacketIn.WriteString(msg);
            SendToAll(gSPacketIn);
            return gSPacketIn;
        }

        public static void SendSysNotice(string msg, int consortiaId)
        {
            GamePlayer[] allPlayersWithConsortia = GetAllPlayersWithConsortia(consortiaId);
            GamePlayer[] array = allPlayersWithConsortia;
            foreach (GamePlayer gamePlayer in array)
            {
                GSPacketIn gSPacketIn = new GSPacketIn(10);
                gSPacketIn.WriteInt(3);
                gSPacketIn.WriteString(msg);
                GSPacketIn pkg = gSPacketIn;
                gamePlayer.SendTCP(pkg);
            }
        }

        public static GSPacketIn SendSysNotice(eMessageType type, string msg, List<ItemInfo> items, int zoneID)
        {
            List<int> list = smethod_4(msg, "@");
            GSPacketIn gSPacketIn = null;
            if (list.Count == items.Count)
            {
                gSPacketIn = new GSPacketIn(10);
                gSPacketIn.WriteInt((int)type);
                gSPacketIn.WriteString(msg.Replace("@", ""));
                if (type == eMessageType.CROSS_NOTICE)
                {
                    gSPacketIn.WriteInt(zoneID);
                }
                int num = 0;
                gSPacketIn.WriteByte((byte)list.Count);
                foreach (int item in list)
                {
                    ItemInfo itemInfo = items[num];
                    gSPacketIn.WriteInt(item);
                    gSPacketIn.WriteInt(itemInfo.TemplateID);
                    gSPacketIn.WriteInt(itemInfo.ItemID);
                    gSPacketIn.WriteString("");
                    num++;
                }
                SendToAll(gSPacketIn);
            }
            else
            {
                ilog_0.Error("wrong msg: " + msg + ": itemcount: " + items.Count);
            }
            return gSPacketIn;
        }

        private static List<int> smethod_4(string string_1, string string_2)
        {
            List<int> list = new List<int>();
            int length = string_2.Length;
            int num = -length;
            while (true)
            {
                num = string_1.IndexOf(string_2, num + length);
                if (num == -1)
                {
                    break;
                }
                list.Add(num);
            }
            return list;
        }

        public static void UpdateCaddyRank()
        {
            using PlayerBussiness playerBussiness = new PlayerBussiness();
            UsersExtraInfo[] rankCaddy = playerBussiness.GetRankCaddy();
            CaddyRank = new Dictionary<int, UsersExtraInfo>();
            UsersExtraInfo[] array = rankCaddy;
            UsersExtraInfo[] array2 = array;
            foreach (UsersExtraInfo usersExtraInfo in array2)
            {
                if (!CaddyRank.ContainsKey(usersExtraInfo.UserID))
                {
                    CaddyRank.Add(usersExtraInfo.UserID, usersExtraInfo);
                }
            }
            LastTimeUpdateCaddyRank = DateTime.Now;
        }

        public static void AddAreaConfig(AreaConfigInfo[] Areas)
        {
            foreach (AreaConfigInfo areaConfigInfo in Areas)
            {
                if (!dictionary_1.ContainsKey(areaConfigInfo.AreaID))
                {
                    if (areaConfigInfo.AreaID == GameServer.Instance.Configuration.ZoneId)
                    {
                        areaConfigInfo_0 = areaConfigInfo;
                    }
                    dictionary_1.Add(areaConfigInfo.AreaID, areaConfigInfo);
                }
            }
        }

        public static AreaConfigInfo FindAreaConfig(int zoneId)
        {
            m_clientLocker.AcquireWriterLock(-1);
            try
            {
                if (dictionary_1.ContainsKey(zoneId))
                {
                    return dictionary_1[zoneId];
                }
            }
            finally
            {
                m_clientLocker.ReleaseWriterLock();
            }
            return null;
        }

        public static AreaConfigInfo[] GetAllAreaConfig()
        {
            List<AreaConfigInfo> list = new List<AreaConfigInfo>();
            foreach (AreaConfigInfo value in dictionary_1.Values)
            {
                list.Add(value);
            }
            return list.ToArray();
        }

        public static EdictumInfo[] GetAllEdictumVersion()
        {
            List<EdictumInfo> list = new List<EdictumInfo>();
            foreach (EdictumInfo value in dictionary_2.Values)
            {
                DateTime date = value.EndDate.Date;
                DateTime date2 = DateTime.Now.Date;
                if (date > date2)
                {
                    list.Add(value);
                }
            }
            return list.ToArray();
        }

        public static void SendToAll(GSPacketIn pkg)
        {
            GamePlayer[] allPlayers = GetAllPlayers();
            for (int i = 0; i < allPlayers.Length; i++)
            {
                allPlayers[i].SendTCP(pkg);
            }
        }

        public static bool CheckBadWord(string msg)
        {
            string[] array = string_0;
            string[] array2 = array;
            foreach (string text in array2)
            {
                if (msg.ToLower().Contains(text.ToLower()))
                {
                    return true;
                }
            }
            return false;
        }

        public static void Stop()
        {
            smethod_3();
        }

        static WorldMgr()
        {
            ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
            m_clientLocker = new ReaderWriterLock();
            m_players = new Dictionary<int, GamePlayer>();
            CaddyRank = new Dictionary<int, UsersExtraInfo>();
            dictionary_1 = new Dictionary<int, AreaConfigInfo>();
            dictionary_2 = new Dictionary<int, EdictumInfo>();
            dictionary_3 = new Dictionary<int, ShopFreeCountInfo>();
            dictionary_4 = new Dictionary<int, UserExitRoomLogInfo>();
            LastTimeUpdateCaddyRank = DateTime.Now;
            string_0 = new string[17]
            {
                "gunny",
                "gun",
                "gunn",
                "g u n n y",
                "g unny",
                "g u nny",
                "g u n ny",
                "g un",
                "g u n",
                "com",
                "c om",
                "c o m",
                "net",
                "n et",
                "n e t",
                "ᶰ",
                "¥"
            };
        }

        public static GamePlayer[] GetAllConsortiaPlayers(int consortiaId)
        {
            List<GamePlayer> gamePlayers = new List<GamePlayer>();
            m_clientLocker.AcquireReaderLock(-1);
            try
            {
                gamePlayers.AddRange(m_players.Values.Where(value => value?.PlayerCharacter != null && value.PlayerCharacter.ConsortiaID == consortiaId));
            }
            finally
            {
                m_clientLocker.ReleaseReaderLock();
            }
            return gamePlayers.ToArray();
        }
    }
}
