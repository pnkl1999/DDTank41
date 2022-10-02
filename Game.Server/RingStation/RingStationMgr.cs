using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;
using Bussiness;
using Bussiness.Managers;
using Game.Server.Battle;
using Game.Server.GameObjects;
using Game.Server.RingStation.Battle;
using log4net;
using SqlDataProvider.Data;
using static System.Int32;

namespace Game.Server.RingStation
{
    public class RingStationMgr
    {
        private static Random rand = new Random();
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        protected static object m_lock = new object();
        private static Dictionary<int, VirtualGamePlayer> m_ringPlayers = new Dictionary<int, VirtualGamePlayer>();
        private static RingStationBattleServer m_server;

        private static readonly string weaklessGuildProgressStr =
            "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

        private static VirtualPlayerInfo m_normalPlayer = new VirtualPlayerInfo();
        private static string[] _names;
        private static List<VirtualPlayerInfo> m_vplayers = new List<VirtualPlayerInfo>();
        private static Dictionary<int, UserRingStationInfo> m_ringstation = new Dictionary<int, UserRingStationInfo>();
        private static List<UserRingStationInfo> m_ranks = new List<UserRingStationInfo>();

        private static Dictionary<int, List<RingstationBattleFieldInfo>> m_battleFields =
            new Dictionary<int, List<RingstationBattleFieldInfo>>();

        private static RingstationConfigInfo m_congfig;

        public static RingstationConfigInfo ConfigInfo
        {
            get { return m_congfig; }
        }

        public static VirtualPlayerInfo NormalPlayer
        {
            get { return m_normalPlayer; }
            set { m_normalPlayer = value; }
        }

        public static RingStationBattleServer RingStationBattle
        {
            get { return m_server; }
        }

        public static bool Init()
        {
            bool result = false;
            try
            {
                BattleServer bs = BattleMgr.GetServer(4);
                if (bs == null)
                    return false;
                m_server = new RingStationBattleServer(RingStationConfiguration.ServerID, bs.Ip, bs.Port, "1,7road");
                if (m_server != null)
                {
                    _names = GameProperties.VirtualName.Split(',');
                    lock (m_lock)
                    {
                        m_ringPlayers.Clear();
                    }

                    m_server.Start();
                    if (!SetupVirtualPlayer())
                        return false;

                    //using (PlayerBussiness pb = new PlayerBussiness())
                    //{
                    //    m_congfig = null;
                    //    if (m_congfig == null)
                    //    {
                    //        m_congfig = new RingstationConfigInfo
                    //        {
                    //            buyCount = 10,
                    //            buyPrice = 8000,
                    //            cdPrice = 10000,
                    //            AwardTime = DateTime.Now.AddDays(3),
                    //            AwardNum = 450,
                    //            AwardFightWin = "1-50,25|51-100,20|101-1000000,15",
                    //            AwardFightLost = "1-50,15|51-100,10|101-1000000,5",
                    //            ChampionText = "",
                    //            ChallengeNum = 10,
                    //            IsFirstUpdateRank = true
                    //        };
                    //        //pb.AddRingstationConfig(m_congfig);
                    //    }
                    //}

                    //BeginTimer();
                    //ReLoadUserRingStation();
                    //ReLoadBattleField();
                    result = true;
                }
            }
            catch (Exception exception)
            {
                RingStationMgr.log.Error("RingStationMgr Init", exception);
            }

            return result;
        }

        public static bool ReLoadBattleField()
        {
            try
            {
                RingstationBattleFieldInfo[] tempRingstationBattleField = LoadRingstationBattleFieldDb();
                Dictionary<int, List<RingstationBattleFieldInfo>> tempRingstationBattleFields =
                    LoadRingstationBattleFields(tempRingstationBattleField);
                if (tempRingstationBattleField.Length > 0)
                {
                    Interlocked.Exchange(ref m_battleFields, tempRingstationBattleFields);
                }
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("ReLoad RingstationBattleField", e);
                return false;
            }

            return true;
        }

        public static RingstationBattleFieldInfo[] LoadRingstationBattleFieldDb()
        {
            using (PlayerBussiness pb = new PlayerBussiness())
            {
                //RingstationBattleFieldInfo[] infos = pb.GetAllRingstationBattleField();
                return null;
            }
        }

        public static Dictionary<int, List<RingstationBattleFieldInfo>> LoadRingstationBattleFields(
            RingstationBattleFieldInfo[] RingstationBattleField)
        {
            Dictionary<int, List<RingstationBattleFieldInfo>> infos =
                new Dictionary<int, List<RingstationBattleFieldInfo>>();
            foreach (RingstationBattleFieldInfo info in RingstationBattleField)
            {
                if (!infos.Keys.Contains(info.UserID))
                {
                    IEnumerable<RingstationBattleFieldInfo> temp =
                        RingstationBattleField.Where(s => s.UserID == info.UserID);
                    infos.Add(info.UserID, temp.ToList());
                }
            }

            return infos;
        }

        public static UserRingStationInfo[] GetRingStationRanks()
        {
            List<UserRingStationInfo> list = new List<UserRingStationInfo>();
            //lock (m_lock)
            {
                foreach (UserRingStationInfo rank in m_ranks)
                {
                    list.Add(rank);
                    if (list.Count >= 50)
                        break;
                }
            }
            return list.ToArray();
        }

        public static bool UpdateRingBattleFields(RingstationBattleFieldInfo dareFlag,
            RingstationBattleFieldInfo successFlag)
        {
            List<RingstationBattleFieldInfo> list;
            int dareId = -1;
            int successId = -1;
            int dareRank = 0;
            int successRank = 0;
            bool saveTodb = false;
            using (PlayerBussiness pb = new PlayerBussiness())
            {
                if (dareFlag != null)
                {
                    dareId = dareFlag.UserID;
                }

                if (successFlag != null)
                {
                    successId = successFlag.UserID;
                }

                //Console.WriteLine("dareId: {0}, successId: {1}", dareId, successId);
                UserRingStationInfo dareRing = GetSingleRingStationInfos(dareId);
                if (dareRing != null)
                {
                    if (dareRing.Rank == 0)
                    {
                        dareRing.Rank = m_ranks.Count + 1;
                    }

                    if (dareRing.ChallengeNum > 0)
                    {
                        dareRing.ChallengeNum--;
                        dareRing.ChallengeTime = DateTime.Now;
                        dareRing.ChallengeTime = DateTime.Now.AddMinutes(10);
                    }

                    if (dareFlag != null && dareFlag.SuccessFlag)
                    {
                        dareRing.Total++;
                    }

                    dareRank = dareRing.Rank;
                }

                UserRingStationInfo successRing = GetSingleRingStationInfos(successId);
                if (successRing != null)
                {
                    successRank = successRing.Rank;
                }

                if (dareFlag != null)
                {
                    if (dareRing != null)
                    {
                        if (dareFlag.SuccessFlag && successRing != null && dareRing.Rank > successRing.Rank)
                        {
                            dareRing.Rank = successRank;
                            successRing.Rank = dareRank;
                            saveTodb = true;
                        }

                        UpdateRingStationInfo(dareRing);
                    }

                    lock (m_lock)
                    {
                        if (m_battleFields.ContainsKey(dareId))
                        {
                            //pb.AddRingstationBattleField(dareFlag);
                            m_battleFields[dareId].Add(dareFlag);
                        }
                        else
                        {
                            //pb.AddRingstationBattleField(dareFlag);
                            list = new List<RingstationBattleFieldInfo> { dareFlag };
                            m_battleFields.Add(dareId, list);
                        }
                    }
                }

                if (successFlag != null)
                {
                    if (successRing != null)
                    {
                        successRing.OnFight = false;
                        UpdateRingStationFight(successRing);
                    }

                    lock (m_lock)
                    {
                        if (m_battleFields.ContainsKey(successId))
                        {
                            //pb.AddRingstationBattleField(successFlag);
                            m_battleFields[successId].Add(successFlag);
                        }
                        else
                        {
                            //pb.AddRingstationBattleField(successFlag);
                            list = new List<RingstationBattleFieldInfo> { successFlag };
                            m_battleFields.Add(successId, list);
                        }
                    }
                }

                if (saveTodb)
                {
                    if (dareFlag.Level == dareRing.Rank)
                    {
                        dareFlag.Level = 0;
                    }
                    else
                    {
                        dareFlag.Level = dareRing.Rank;
                    }

                    UpdateRingStationInfo(dareRing);
                    if (successFlag != null)
                    {
                        successFlag.Level = successFlag.Level == successRing.Rank ? 0 : successRing.Rank;
                    }

                    UpdateRingStationInfo(successRing);
                }
            }

            return true;
        }

        public static RingstationBattleFieldInfo[] GetRingBattleFields(int playerId)
        {
            List<RingstationBattleFieldInfo> list = new List<RingstationBattleFieldInfo>();
            lock (m_lock)
            {
                if (m_battleFields.ContainsKey(playerId))
                {
                    List<RingstationBattleFieldInfo> fields = m_battleFields[playerId];
                    list.AddRange(fields);
                }
            }

            return (from pair in list
                    orderby pair.BattleTime descending
                    select pair).Take(10).ToArray();
        }

        public static bool ReLoadUserRingStation()
        {
            try
            {
                UserRingStationInfo[] tempUserRingStationArr = LoadUserRingStationDb();
                Dictionary<int, UserRingStationInfo>
                    tempUserRingStations = LoadUserRingStations(tempUserRingStationArr);
                if (tempUserRingStationArr.Length > 0)
                {
                    Interlocked.Exchange(ref m_ringstation, tempUserRingStations);
                    m_ranks = (from pair in tempUserRingStationArr
                               where pair.Rank != 0
                               orderby pair.Rank ascending
                               select pair).ToList();
                }
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("ReLoad All UserRingStation", e);
                return false;
            }

            return true;
        }

        public static UserRingStationInfo[] LoadUserRingStationDb()
        {
            using (PlayerBussiness pb = new PlayerBussiness())
            {
                //UserRingStationInfo[] infos = pb.GetAllUserRingStation();
                return null;
            }
        }

        public static Dictionary<int, UserRingStationInfo> LoadUserRingStations(UserRingStationInfo[] UserRingStation)
        {
            Dictionary<int, UserRingStationInfo> infos = new Dictionary<int, UserRingStationInfo>();
            using (PlayerBussiness pb = new PlayerBussiness())
            {
                foreach (UserRingStationInfo ring in UserRingStation)
                {
                    if (!infos.Keys.Contains(ring.UserID))
                    {
                        try
                        {
                            ring.Info = pb.GetUserSingleByUserID(ring.UserID);
                            if (ring.Info != null)
                            {
                                ring.WeaponID = GetWeaponId(ring.Info.Style);
                                infos.Add(ring.UserID, ring);
                            }
                        }
                        catch
                        {
                            // ignored
                        }
                    }
                }
            }

            return infos;
        }

        public static void LoadRingStationInfo(PlayerInfo player, int dame, int guard)
        {
            if (player == null)
                return;
            using (PlayerBussiness pb = new PlayerBussiness())
            {
                if (m_ringstation.ContainsKey(player.ID))
                {
                    bool saveToDb = false;
                    UserRingStationInfo ring = m_ringstation[player.ID];
                    if (dame != ring.BaseDamage && ring.BaseGuard != guard)
                    {
                        ring.BaseDamage = dame;
                        ring.BaseGuard = guard;
                        ring.BaseEnergy = (int)(1 - player.Agility * 0.001);
                        saveToDb = true;
                    }

                    int weponId = GetWeaponId(player.Style);
                    if (ring.WeaponID != weponId)
                    {
                        ring.WeaponID = weponId;
                        saveToDb = true;
                    }

                    if (saveToDb)
                    {
                        //pb.UpdateUserRingStation(ring);
                    }
                }
                else
                {
                    UserRingStationInfo info = new UserRingStationInfo
                    {
                        UserID = player.ID,
                        WeaponID = GetWeaponId(player.Style),
                        BaseDamage = dame,
                        BaseGuard = guard,
                        BaseEnergy = (int)(1 - player.Agility * 0.001),
                        signMsg = LanguageMgr.GetTranslation("RingStation.signMsg"),
                        ChallengeNum = ConfigInfo.ChallengeNum,
                        buyCount = ConfigInfo.buyCount,
                        ChallengeTime = DateTime.Now,
                        LastDate = DateTime.Now,
                        Info = player
                    };
                    //pb.AddUserRingStation(info);
                    m_ringstation.Add(player.ID, info);
                }
            }
        }

        public static int GetWeaponId(string style)
        {
            if (!string.IsNullOrEmpty(style))
            {
                string[] styles = style.Split(',');
                string weapon = styles[6];
                if (weapon.IndexOf("|", StringComparison.Ordinal) != -1)
                {
                    return Parse(weapon.Split('|')[0]);
                }
            }

            return 7008;
        }

        public static UserRingStationInfo GetRingStationChallenge(int playerId, int rank, ref bool isAutoBot)
        {
            lock (m_lock)
            {
                if (m_ringstation.ContainsKey(playerId) && rank != 0)
                {
                    return m_ringstation[playerId];
                }
            }

            isAutoBot = true;
            return BaseRingStationChallenges(playerId);
        }

        public static void SetChallenge(int playerId, bool onFight)
        {
            lock (m_lock)
            {
                if (m_ringstation.ContainsKey(playerId))
                {
                    m_ringstation[playerId].OnFight = onFight;
                    //Console.WriteLine("playerId {0}, OnFight {1}", playerId, m_ringstation[playerId].OnFight);
                }
            }
        }

        public static UserRingStationInfo GetSingleRingStationInfos(int playerId)
        {
            lock (m_lock)
            {
                if (m_ringstation.ContainsKey(playerId))
                {
                    return m_ringstation[playerId];
                }
            }

            return null;
        }

        public static bool UpdateRingStationInfo(UserRingStationInfo ring)
        {
            return false;
            if (ring == null)
                return false;
            using (PlayerBussiness pb = new PlayerBussiness())
            {
                lock (m_lock)
                {
                    if (m_ringstation.ContainsKey(ring.UserID))
                    {
                        m_ringstation[ring.UserID] = ring;
                        //return pb.UpdateUserRingStation(ring);
                    }
                }
            }

            return false;
        }

        public static bool UpdateRingStationFight(UserRingStationInfo ring)
        {
            if (ring == null)
                return false;
            lock (m_lock)
            {
                if (m_ringstation.ContainsKey(ring.UserID))
                {
                    m_ringstation[ring.UserID] = ring;
                    return true;
                }
            }

            return false;
        }

        public static List<UserRingStationInfo> FindRingStationInfoByRank(int userId, int min, int max)
        {
            return m_ringstation.Values.Where(info => info.UserID != userId)
                .Where(info => info.Rank >= min && info.Rank <= max).ToList();
        }

        public static UserRingStationInfo[] GetRingStationInfos(int userId, int rank)
        {
            NormalPlayer = GetVirtualPlayerInfo();
            Dictionary<int, UserRingStationInfo> list = new Dictionary<int, UserRingStationInfo>();
            int baseValue = 5;
            if (rank > 0)
            {
                int minValue = rank;
                int maxValue = rank - baseValue;

                if (minValue <= 0)
                {
                    minValue = m_ranks.Count;
                    maxValue = m_ranks.Count - baseValue;
                }
                else if (maxValue <= 0)
                {
                    minValue = 1;
                    maxValue = baseValue;
                }

                //else if (maxValue > baseValue)
                //{
                //    minValue = 1;
                //    maxValue = rank;
                //}
                List<UserRingStationInfo> infos = FindRingStationInfoByRank(userId, minValue, maxValue);
                if (infos.Count == 4)
                {
                    for (int i = 0; list.Count < 4; i++)
                    {
                        UserRingStationInfo info = infos[rand.Next(infos.Count)];
                        if (info == null)
                            continue;
                        if (!list.ContainsKey(info.UserID))
                        {
                            list.Add(info.UserID, info);
                        }

                        infos.Remove(info);
                    }
                }
            }

            if (list.Count == 0)
            {
                UserRingStationInfo boot = BaseRingStationChallenges(0);
                list.Add(boot.Info.ID, boot);
            }

            return list.Values.ToArray();
        }

        public static bool AddPlayer(int playerId, VirtualGamePlayer player)
        {
            lock (m_lock)
            {
                if (m_ringPlayers.ContainsKey(playerId))
                {
                    return true;
                }

                m_ringPlayers.Add(playerId, player);
            }

            return true;
        }

        public static bool RemovePlayer(int playerId)
        {
            lock (m_lock)
            {
                if (m_ringPlayers.ContainsKey(playerId))
                {
                    return m_ringPlayers.Remove(playerId);
                }
            }

            return false;
        }

        public static VirtualGamePlayer GetPlayerById(int playerId)
        {
            VirtualGamePlayer result = null;
            lock (m_lock)
            {
                if (m_ringPlayers.ContainsKey(playerId))
                {
                    result = m_ringPlayers[playerId];
                }
            }

            return result;
        }

        protected static Timer m_statusScanTimer;

        public static void BeginTimer()
        {
            int interval = 60 * 1000;
            if (m_statusScanTimer == null)
            {
                m_statusScanTimer = new Timer(new TimerCallback(StatusScan), null, interval, interval);
            }
            else
            {
                m_statusScanTimer.Change(interval, interval);
            }
        }

        protected static void StatusScan(object sender)
        {
            try
            {
                log.Info("Begin Scan RingStation Info....");
                int startTick = Environment.TickCount;
                ThreadPriority oldprio = Thread.CurrentThread.Priority;
                Thread.CurrentThread.Priority = ThreadPriority.Lowest;
                //begin code  
                bool saveToDb = false;
                if (ReLoadUserRingStation())
                {
                    List<UserRingStationInfo> list = m_ringstation.Values.ToList();

                    if (ConfigInfo.IsFirstUpdateRank && list.Count > 10)
                    {
                        List<UserRingStationInfo> infos = (from pair in list
                                                           orderby pair.Total descending
                                                           select pair).ToList();

                        for (int i = 0; i < infos.Count; i++)
                        {
                            UserRingStationInfo ring = infos[i];
                            ring.Rank = i + 1;
                            UpdateRingStationInfo(ring);
                        }

                        ConfigInfo.IsFirstUpdateRank = false;
                        saveToDb = true;
                    }

                    m_ranks = (from pair in list
                               where pair.Rank != 0
                               orderby pair.Rank ascending
                               select pair).ToList();
                    if (m_ranks.Count > 0)
                    {
                        UserRingStationInfo champion = m_ranks[0];
                        if (champion.Info != null)
                        {
                            ConfigInfo.ChampionText = champion.Info.NickName;
                            saveToDb = true;
                        }
                    }

                    if (ConfigInfo.IsEndTime())
                    {
                        lock (m_lock)
                        {
                            m_congfig.AwardTime = DateTime.Now;
                            m_congfig.AwardTime = DateTime.Now.AddDays(3);
                            saveToDb = true;
                        }

                        if (list.Count > 0)
                        {
                            foreach (UserRingStationInfo p in list)
                            {
                                p.ReardEnable = true;
                                UpdateRingStationInfo(p);
                            }
                        }
                    }

                    if (saveToDb)
                    {
                        //using (PlayerBussiness pb = new PlayerBussiness())
                        //{
                        //    pb.UpdateRingstationConfig(ConfigInfo);
                        //}
                    }
                }

                //end code
                Thread.CurrentThread.Priority = oldprio;
                startTick = Environment.TickCount - startTick;
                log.Info("End Scan RingStation Info....");
            }
            catch (Exception e)
            {
                log.Error("StatusScan ", e);
            }
        }

        public static bool SetupVirtualPlayer()
        {
            int[] weaponArr = new int[]//Danh sách vũ khí
            {
                //71664,
                //71854,
                //71914,
                //71941,
                //71961,
                //70234,
                //71991,
                //72054,
                //72104,
                //72194,
                //75484,
                //702413
                //75484,
                7008
            };
            int[] headArr = new int[]
            {
                //1147,
                //1149,
                //1150,
                //1165,
                //1166,
                //1173,
                //1174,
                //1175,
                //1176,
                //1177,
                //1186,
                //1763,
                //52000510
                1142,
                1214
            };
            int[] glassArr = new int[]
            {
                //2117,
                //2119,
                //2120,
                //2121,
                //2123,
                //2126,
                //2134,
                //2142,
                //2147,
                //2149,
                //2176,
                //2186,
                //2191,
                //2198
                2104,
                2204
            };
            int[] hairArr = new int[]
            {
                //3111,
                //3114,
                //3119,
                //3122,
                //3125,
                //3127,
                //3129,
                //3131,
                //3135,
                //3136,
                //3139,
                //3142,
                //3143,
                //3144,
                //3150,
                //3163,
                //3165,
                //3169,
                //3180
                3158,
                3244
            };
            int[] effArr = new int[]
            {
                //4120,
                //4121,
                //4122,
                //4123,
                //4124,
                //4125,
                //4126,
                //4129,
                //4130,
                //4131,
                //4132,
                //4133,
                //4134,
                //4135,
                //4136,
                //4137,
                //4138,
                //4139
                4101,
                4201
            };
            int[] clothArr = new int[]
            {
                //5131,
                //5142,
                //5143,
                //5144,
                //5145,
                //5150,
                //5156,
                //5164,
                //5165,
                //5175,
                //5178,
                //5180,
                //5181,
                //5182,
                //5196,
                //5198,
                //5199
                5104,
                5207
            };
            int[] faceArr = new int[]//Mắt
            {
                //6110,
                //6112,
                //6113,
                //6114,
                //6115,
                //6116,
                //6117,
                //6125,
                //6127,
                //6130,
                //6131,
                //6132,
                //6139,
                //6141,
                //6145
                6101,
                6202
            };
            int[] wingArr = new int[]
            {
                //15064,
                //15065,
                //15066,
                //15070,
                //15075,
                //15076,
                //15081,
                //15093,
                //15127,
                //15128,
                //15129,
                //15137,
                //15138,
                //15139,
                //15140
                15001
            };
            int count = weaponArr.Length;
            int h = 0, g = 0, ha = 0, e = 0, c = 0, f = 0, w = 0;
            for (int i = 0; i < count; i++)
            {
                ItemTemplateInfo temwe = ItemMgr.FindItemTemplate(weaponArr[i]);
                ItemTemplateInfo temhe = ItemMgr.FindItemTemplate(headArr[h]);
                ItemTemplateInfo temgl = ItemMgr.FindItemTemplate(glassArr[g]);
                ItemTemplateInfo temha = ItemMgr.FindItemTemplate(hairArr[ha]);
                ItemTemplateInfo temef = ItemMgr.FindItemTemplate(effArr[e]);
                ItemTemplateInfo temcl = ItemMgr.FindItemTemplate(clothArr[c]);
                ItemTemplateInfo temfa = ItemMgr.FindItemTemplate(faceArr[f]);
                ItemTemplateInfo temwi = ItemMgr.FindItemTemplate(wingArr[w]);
                if (temwe != null && temhe != null && temgl != null && temha != null && temef != null &&
                    temcl != null && temfa != null && temwi != null)
                {
                    string swe = $"{weaponArr[i]}|{temwe.Pic}";
                    string she = $"{headArr[h]}|{temhe.Pic}";
                    string sgl = $"{glassArr[g]}|{temgl.Pic}";
                    string sha = $"{hairArr[ha]}|{temha.Pic}";
                    string sef = $"{effArr[e]}|{temef.Pic}";
                    string scl = $"{clothArr[c]}|{temcl.Pic}";
                    string sfa = $"{faceArr[f]}|{temfa.Pic}";
                    string swi = $"{wingArr[w]}|{temwi.Pic}";
                    string style = $"{she},{sgl},{sha},{sef},{scl},{sfa},{swe},,{swi},,,,,,,,,";

                    VirtualPlayerInfo info = new VirtualPlayerInfo
                    {
                        Style = style,
                        Weapon = weaponArr[i]
                    };
                    m_vplayers.Add(info);
                }

                h++;
                g++;
                ha++;
                e++;
                c++;
                f++;
                w++;
                if (h > headArr.Length - 1)
                    h = 0;
                if (g > glassArr.Length - 1)
                    g = 0;
                if (ha > hairArr.Length - 1)
                    ha = 0;
                if (e > effArr.Length - 1)
                    e = 0;
                if (c > clothArr.Length - 1)
                    c = 0;
                if (f > faceArr.Length - 1)
                    f = 0;
                if (w > wingArr.Length - 1)
                    w = 0;
            }

            return m_vplayers.Count > Math.Abs(count / 2);
        }

        public static VirtualPlayerInfo GetVirtualPlayerInfo()
        {
            int i = rand.Next(m_vplayers.Count);
            return m_vplayers[i];
        }

        public static int CreateRingStationChallenge(UserRingStationInfo player, int roomtype, int gametype)
        {
            int npcId = player.Info.ID;
            BaseRoomRingStation room = new BaseRoomRingStation(RingStationConfiguration.NextRoomId())
            {
                RoomType = roomtype,
                GameType = gametype,
                PickUpNpcId = npcId,
                IsAutoBot = true,
                IsFreedom = false
            };

            VirtualGamePlayer rp = new VirtualGamePlayer
            {
                NickName = player.Info.NickName,
                GP = player.Info.GP > MaxValue ? MaxValue : Convert.ToInt32(player.Info.GP),
                Grade = player.Info.Grade,
                Attack = player.Info.Attack,
                Defence = player.Info.Defence,
                Luck = player.Info.Luck,
                Agility = player.Info.Agility,
                hp = player.Info.hp,
                FightPower = player.Info.FightPower,
                BaseAttack = player.BaseDamage,
                BaseDefence = player.BaseGuard,
                BaseAgility = player.BaseEnergy,
                BaseBlood = player.Info.hp,
                Style = player.Info.Style,
                Colors = player.Info.Colors,
                Hide = player.Info.Hide,
                TemplateID = player.WeaponID,
                StrengthLevel = 1,
                WeaklessGuildProgressStr = weaklessGuildProgressStr,
                ID = npcId
            };

            if (m_server != null)
            {
                AddPlayer(rp.ID, rp);
                room.AddPlayer(rp);
                m_server.AddRoom(room);
            }

            return npcId;
        }

        public static void CreateAutoBot(GamePlayer player, int roomtype, int gametype, int npcId, int playerCount)
        {
            BaseRoomRingStation room = new BaseRoomRingStation(RingStationConfiguration.NextRoomId())
            {
                RoomType = roomtype,
                GameType = gametype,
                PickUpNpcId = npcId,
                IsAutoBot = true,
                IsFreedom = true
            };
            for (int x = 0; x < playerCount; x++)
            {
                VirtualGamePlayer rp = new VirtualGamePlayer
                {
                    NickName = _names[rand.Next(_names.Length)] + npcId + x,
                    GP = player.PlayerCharacter.GP > MaxValue ? MaxValue : Convert.ToInt32(player.PlayerCharacter.GP),
                    Grade = player.PlayerCharacter.Grade,
                    Attack = player.PlayerCharacter.Attack * 4 / 8,
                    Defence = player.PlayerCharacter.Defence * 4 / 8,
                    Luck = player.PlayerCharacter.Luck * 2 / 8,
                    Agility = player.PlayerCharacter.Agility,
                    hp = player.PlayerCharacter.hp * 2 / 8,
                    FightPower = player.PlayerCharacter.FightPower,
                    BaseAttack = player.GetBaseAttack() * 4 / 8,
                    BaseDefence = player.GetBaseDefence() * 4 / 8,
                    BaseAgility = player.GetBaseAgility(),
                    BaseBlood = player.GetBaseBlood() * 2 / 8,
                };
                VirtualPlayerInfo vp = GetVirtualPlayerInfo();
                rp.Style = vp.Style;
                rp.Colors = ",,,,,,,,,,,,,,,";
                rp.Hide = 1111111111;
                rp.TemplateID = vp.Weapon;
                rp.StrengthLevel = player.MainWeapon.StrengthenLevel;
                rp.WeaklessGuildProgressStr = weaklessGuildProgressStr;
                rp.ID = RingStationConfiguration.NextPlayerID();
                AddPlayer(rp.ID, rp);
                room.AddPlayer(rp);
            }

            if (m_server != null)
            {
                m_server.AddRoom(room);
            }
        }

        public static int GetAutoBot(GamePlayer player, int roomtype, int gametype, int playerCount)
        {
            int npcId = RingStationConfiguration.NextPlayerID();
            BaseRoomRingStation room = new BaseRoomRingStation(RingStationConfiguration.NextRoomId())
            {
                RoomType = roomtype,
                GameType = gametype,
                PickUpNpcId = npcId,
                IsAutoBot = true,
                IsFreedom = false
            };
            for (int x = 0; x < playerCount; x++)
            {
                VirtualGamePlayer rp = new VirtualGamePlayer();
                rp.GP = player.PlayerCharacter.GP > MaxValue
                    ? MaxValue
                    : Convert.ToInt32(player.PlayerCharacter.GP);
                rp.Grade = player.PlayerCharacter.Grade;
                rp.Attack = player.PlayerCharacter.Attack;
                rp.Defence = player.PlayerCharacter.Defence;
                rp.Luck = player.PlayerCharacter.Luck;
                rp.Agility = player.PlayerCharacter.Agility;
                rp.hp = player.PlayerCharacter.hp;
                rp.FightPower = player.PlayerCharacter.FightPower;

                rp.BaseAttack = player.GetBaseAttack();
                rp.BaseDefence = player.GetBaseDefence();

                rp.BaseAgility = player.GetBaseAgility();

                rp.BaseBlood = Convert.ToDouble(player.PlayerCharacter.hp);

                rp.NickName = _names[rand.Next(_names.Length)] + npcId + x;

                VirtualPlayerInfo vp = GetVirtualPlayerInfo();

                rp.Style = vp.Style;
                rp.Colors = ",,,,,,,,,,,,,,,";
                rp.Hide = 1111111111;
                rp.TemplateID = vp.Weapon;
                rp.StrengthLevel = 0;
                rp.WeaklessGuildProgressStr = weaklessGuildProgressStr;
                rp.ID = npcId + x;
                AddPlayer(rp.ID, rp);
                room.AddPlayer(rp);
            }

            m_server?.AddRoom(room);

            return npcId;
        }

        public static void CreateBaseAutoBot(int roomtype, int gametype, int npcId)
        {
            BaseRoomRingStation room = new BaseRoomRingStation(RingStationConfiguration.NextRoomId())
            {
                RoomType = roomtype,
                GameType = gametype,
                PickUpNpcId = npcId,
                IsAutoBot = true,
                IsFreedom = true
            };
            VirtualGamePlayer rp = new VirtualGamePlayer
            {
                NickName = _names[rand.Next(_names.Length)] + npcId,
                GP = 1283,
                Grade = 5,
                Attack = 100,
                Defence = 100,
                Luck = 100,
                Agility = 100,
                hp = 3000,
                FightPower = 1200,
                BaseAttack = 200,
                BaseDefence = 120,
                BaseAgility = 240,
                BaseBlood = 1000
            };
            VirtualPlayerInfo vp = GetVirtualPlayerInfo();
            rp.Style = vp.Style;
            rp.Colors = ",,,,,,,,,,,,,,,";
            rp.Hide = 1111111111;
            rp.TemplateID = vp.Weapon;
            rp.StrengthLevel = 0;
            rp.WeaklessGuildProgressStr =
                "R/O/DeABAtgWdWsIAAAAAAAAgCAECwAAAAAAABgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
            rp.ID = npcId;
            if (m_server != null)
            {
                AddPlayer(rp.ID, rp);
                room.AddPlayer(rp);
                m_server.AddRoom(room);
            }
        }

        public static UserRingStationInfo BaseRingStationChallenges(int id)
        {
            UserRingStationInfo ur = new UserRingStationInfo
            {
                Rank = 0,
                WeaponID = NormalPlayer.Weapon,
                signMsg = LanguageMgr.GetTranslation("BaseRingStationChallenges.Msg2"),
                BaseDamage = 242,
                BaseGuard = 120,
                BaseEnergy = 240
            };
            PlayerInfo info = new PlayerInfo
            {
                ID = id == 0 ? RingStationConfiguration.NextPlayerID() : id,
                UserName = "NormalInfo",
                NickName = LanguageMgr.GetTranslation("BaseRingStationChallenges.Msg1"),
                typeVIP = 1,
                VIPLevel = 1,
                Grade = 25,
                Sex = false,
                Style = NormalPlayer.Style,
                Colors = ",,,,,,,,,,,,,,,",
                Skin = "",
                ConsortiaName = "",
                Hide = 1111111111,
                Offer = 0,
                Win = 0,
                Total = 0,
                Escape = 0,
                Repute = 0,
                Nimbus = 0,
                GP = 1437053,
                FightPower = 14370,
                AchievementPoint = 0,
                Attack = 225,
                Defence = 160,
                Agility = 50,
                Luck = 60,
                hp = 3500,
                IsAutoBot = true
            };
            ur.Info = info;
            return ur;
        }

        public static void StopAllTimer()
        {
            if (m_statusScanTimer != null)
            {
                m_statusScanTimer.Change(Timeout.Infinite, Timeout.Infinite);
                m_statusScanTimer.Dispose();
                m_statusScanTimer = null;
            }
        }

        public static List<VirtualGamePlayer> GetAllPlayer()
        {
            List<VirtualGamePlayer> list = new List<VirtualGamePlayer>();
            lock (m_lock)
            {
                foreach (VirtualGamePlayer current in m_ringPlayers.Values)
                {
                    list.Add(current);
                }
            }

            return list;
        }
    }
}