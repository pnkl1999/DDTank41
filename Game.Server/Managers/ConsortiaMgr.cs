using Bussiness;
using Game.Logic;
using Game.Logic.Phy.Object;
using Game.Server.Buffer;
using Game.Server.Packets;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;

namespace Game.Server.Managers
{
    public class ConsortiaMgr
    {
        private static Dictionary<string, int> _ally;

        private static Dictionary<int, ConsortiaInfo> _consortia;

        private static Dictionary<int, ConsortiaBossConfigInfo> _consortiaBossConfigInfos;

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static ReaderWriterLock m_lock;

        public static bool AddConsortia(int consortiaID)
        {
            m_lock.AcquireWriterLock(-1);
            try
            {
                if (!_consortia.ContainsKey(consortiaID))
                {
                    ConsortiaInfo value = new ConsortiaInfo
                    {
                        BuildDate = DateTime.Now,
                        Level = 1,
                        IsExist = true,
                        ConsortiaName = "",
                        ConsortiaID = consortiaID
                    };
                    _consortia.Add(consortiaID, value);
                }
            }
            catch (Exception exception)
            {
                log.Error("ConsortiaUpGrade", exception);
            }
            finally
            {
                m_lock.ReleaseWriterLock();
            }
            return false;
        }

        public static int CanConsortiaFight(int consortiaID1, int consortiaID2)
        {
            if (consortiaID1 == 0 || consortiaID2 == 0 || consortiaID1 == consortiaID2)
            {
                return -1;
            }
            ConsortiaInfo consortiaInfo = FindConsortiaInfo(consortiaID1);
            ConsortiaInfo consortiaInfo2 = FindConsortiaInfo(consortiaID2);
            if (consortiaInfo == null || consortiaInfo2 == null || consortiaInfo.Level < 3 || consortiaInfo2.Level < 3)
            {
                return -1;
            }
            return FindConsortiaAlly(consortiaID1, consortiaID2);
        }

        public static int ConsortiaFight(int consortiaWin, int consortiaLose, Dictionary<int, Player> players, eRoomType roomType, eGameType gameClass, int totalKillHealth, int playercount)
        {
            if (roomType != 0)
            {
                return 0;
            }
            int num = playercount / 2;
            int riches = 0;
            int state = 2;
            int num2 = 1;
            int num3 = 3;
            if (gameClass == eGameType.Guild)
            {
                num3 = 10;
                num2 = (int)RateMgr.GetRate(eRateType.Offer_Rate);
            }
            float rate = RateMgr.GetRate(eRateType.Riches_Rate);
            using ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness();
            if (gameClass == eGameType.Free)
            {
                num = 0;
            }
            else
            {
                consortiaBussiness.ConsortiaFight(consortiaWin, consortiaLose, num, out riches, state, totalKillHealth, rate);
            }
            List<string> list = new List<string>();
            ConsortiaInfo consortiaSingle = consortiaBussiness.GetConsortiaSingle(consortiaWin);
            ConsortiaInfo consortiaSingle2 = consortiaBussiness.GetConsortiaSingle(consortiaLose);
            if (riches <= 0)
            {
                riches = 1;
            }
            consortiaBussiness.ConsortiaRichAdd(consortiaWin, ref riches);
            foreach (KeyValuePair<int, Player> player in players)
            {
                if (player.Value != null)
                {
                    if (player.Value.PlayerDetail.PlayerCharacter.ConsortiaID == consortiaWin)
                    {
                        player.Value.PlayerDetail.AddOffer((num + num3) * num2);
                        player.Value.PlayerDetail.PlayerCharacter.RichesRob += riches;
                        list.Add("[" + player.Value.PlayerDetail.PlayerCharacter.NickName + "]");
                    }
                    else if (player.Value.PlayerDetail.PlayerCharacter.ConsortiaID == consortiaLose)
                    {
                        player.Value.PlayerDetail.AddOffer((int)Math.Round((double)num * 0.5) * num2);
                        player.Value.PlayerDetail.RemoveOffer(num3);
                    }
                }
            }
            return riches;
        }

        public static bool ConsortiaShopUpGrade(int consortiaID, int shopLevel)
        {
            m_lock.AcquireWriterLock(-1);
            try
            {
                if (_consortia.ContainsKey(consortiaID) && _consortia[consortiaID].IsExist)
                {
                    _consortia[consortiaID].ShopLevel = shopLevel;
                }
            }
            catch (Exception exception)
            {
                log.Error("ConsortiaUpGrade", exception);
            }
            finally
            {
                m_lock.ReleaseWriterLock();
            }
            return false;
        }

        public static bool ConsortiaSmithUpGrade(int consortiaID, int smithLevel)
        {
            m_lock.AcquireWriterLock(-1);
            try
            {
                if (_consortia.ContainsKey(consortiaID) && _consortia[consortiaID].IsExist)
                {
                    _consortia[consortiaID].SmithLevel = smithLevel;
                }
            }
            catch (Exception exception)
            {
                log.Error("ConsortiaUpGrade", exception);
            }
            finally
            {
                m_lock.ReleaseWriterLock();
            }
            return false;
        }

        public static bool ConsortiaSkillUpGrade(int consortiaID, int skillLevel)
        {
            bool result = false;
            if (_consortia.ContainsKey(consortiaID) && _consortia[consortiaID].IsExist)
            {
                _consortia[consortiaID].SkillLevel = skillLevel;
            }
            return result;
        }

        public static bool ConsortiaStoreUpGrade(int consortiaID, int storeLevel)
        {
            m_lock.AcquireWriterLock(-1);
            try
            {
                if (_consortia.ContainsKey(consortiaID) && _consortia[consortiaID].IsExist)
                {
                    _consortia[consortiaID].StoreLevel = storeLevel;
                }
            }
            catch (Exception exception)
            {
                log.Error("ConsortiaUpGrade", exception);
            }
            finally
            {
                m_lock.ReleaseWriterLock();
            }
            return false;
        }

        public static bool ConsortiaUpGrade(int consortiaID, int consortiaLevel)
        {
            bool result = false;
            m_lock.AcquireWriterLock(-1);
            try
            {
                if (_consortia.ContainsKey(consortiaID) && _consortia[consortiaID].IsExist)
                {
                    _consortia[consortiaID].Level = consortiaLevel;
                    return result;
                }
                ConsortiaInfo value = new ConsortiaInfo
                {
                    BuildDate = DateTime.Now,
                    Level = consortiaLevel,
                    IsExist = true
                };
                _consortia.Add(consortiaID, value);
                return result;
            }
            catch (Exception exception)
            {
                log.Error("ConsortiaUpGrade", exception);
                return result;
            }
            finally
            {
                m_lock.ReleaseWriterLock();
            }
        }

        public static int FindConsortiaAlly(int cosortiaID1, int consortiaID2)
        {
            if (cosortiaID1 == 0 || consortiaID2 == 0 || cosortiaID1 == consortiaID2)
            {
                return -1;
            }
            string key = ((cosortiaID1 >= consortiaID2) ? (consortiaID2 + "&" + cosortiaID1) : (cosortiaID1 + "&" + consortiaID2));
            m_lock.AcquireReaderLock(10000);
            try
            {
                if (_ally.ContainsKey(key))
                {
                    return _ally[key];
                }
            }
            catch
            {
            }
            finally
            {
                m_lock.ReleaseReaderLock();
            }
            return 0;
        }

        public static int FindConsortiaBossBossMaxLevel(int param1, ConsortiaInfo info)
        {
            int num = ((param1 != 0) ? param1 : (info.Level + info.SmithLevel + info.ShopLevel + info.StoreLevel + info.SkillLevel));
            for (int num2 = _consortiaBossConfigInfos.Count; num2 >= 0; num2--)
            {
                if (num >= _consortiaBossConfigInfos[num2].Level)
                {
                    return num2;
                }
            }
            return 1;
        }

        public static ConsortiaBossConfigInfo FindConsortiaBossConfig(int level)
        {
            m_lock.AcquireReaderLock(10000);
            try
            {
                if (_consortiaBossConfigInfos.ContainsKey(level))
                {
                    return _consortiaBossConfigInfos[level];
                }
            }
            catch
            {
            }
            finally
            {
                m_lock.ReleaseReaderLock();
            }
            return null;
        }

        public static ConsortiaInfo FindConsortiaInfo(int consortiaID)
        {
            m_lock.AcquireReaderLock(10000);
            try
            {
                if (_consortia.ContainsKey(consortiaID))
                {
                    return _consortia[consortiaID];
                }
            }
            catch
            {
            }
            finally
            {
                m_lock.ReleaseReaderLock();
            }
            return null;
        }

        private static int GetOffer(int state, eGameType gameType)
        {
            switch (gameType)
            {
                case eGameType.Free:
                    switch (state)
                    {
                        case 0:
                            return 1;
                        case 1:
                            return 0;
                        case 2:
                            return 3;
                    }
                    break;
                case eGameType.Guild:
                    switch (state)
                    {
                        case 0:
                            return 5;
                        case 1:
                            return 0;
                        case 2:
                            return 10;
                    }
                    break;
            }
            return 0;
        }

        public static int GetOffer(int cosortiaID1, int consortiaID2, eGameType gameType)
        {
            return GetOffer(FindConsortiaAlly(cosortiaID1, consortiaID2), gameType);
        }

        public static bool Init()
        {
            try
            {
                m_lock = new ReaderWriterLock();
                _ally = new Dictionary<string, int>();
                if (!Load(_ally))
                {
                    return false;
                }
                _consortia = new Dictionary<int, ConsortiaInfo>();
                _consortiaBossConfigInfos = new Dictionary<int, ConsortiaBossConfigInfo>();
                if (!LoadConsortia(_consortia, _consortiaBossConfigInfos))
                {
                    return false;
                }
                return true;
            }
            catch (Exception exception)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("ConsortiaMgr", exception);
                }
                return false;
            }
        }

        public static int KillPlayer(GamePlayer win, GamePlayer lose, Dictionary<GamePlayer, Player> players, eRoomType roomType, eGameType gameClass)
        {
            if (roomType != 0)
            {
                return -1;
            }
            int num = FindConsortiaAlly(win.PlayerCharacter.ConsortiaID, lose.PlayerCharacter.ConsortiaID);
            if (num != -1)
            {
                int offer = GetOffer(num, gameClass);
                if (lose.PlayerCharacter.Offer < offer)
                {
                    offer = lose.PlayerCharacter.Offer;
                }
                if (offer != 0)
                {
                    players[win].GainOffer = offer;
                    players[lose].GainOffer = -offer;
                }
            }
            return num;
        }

        private static bool Load(Dictionary<string, int> ally)
        {
            using (ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness())
            {
                ConsortiaAllyInfo[] consortiaAllyAll = consortiaBussiness.GetConsortiaAllyAll();
                ConsortiaAllyInfo[] array = consortiaAllyAll;
                foreach (ConsortiaAllyInfo consortiaAllyInfo in array)
                {
                    if (consortiaAllyInfo.IsExist)
                    {
                        string key = ((consortiaAllyInfo.Consortia1ID >= consortiaAllyInfo.Consortia2ID) ? (consortiaAllyInfo.Consortia2ID + "&" + consortiaAllyInfo.Consortia1ID) : (consortiaAllyInfo.Consortia1ID + "&" + consortiaAllyInfo.Consortia2ID));
                        if (!ally.ContainsKey(key))
                        {
                            ally.Add(key, consortiaAllyInfo.State);
                        }
                    }
                }
            }
            return true;
        }

        private static bool LoadConsortia(Dictionary<int, ConsortiaInfo> consortia, Dictionary<int, ConsortiaBossConfigInfo> consortiaBossConfig)
        {
            using (ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness())
            {
                ConsortiaInfo[] consortiaAll = consortiaBussiness.GetConsortiaAll();
                ConsortiaInfo[] array = consortiaAll;
                foreach (ConsortiaInfo consortiaInfo in array)
                {
                    if (consortiaInfo.IsExist && !consortia.ContainsKey(consortiaInfo.ConsortiaID))
                    {
                        consortia.Add(consortiaInfo.ConsortiaID, consortiaInfo);
                    }
                }
                ConsortiaBossConfigInfo[] consortiaBossConfigAll = consortiaBussiness.GetConsortiaBossConfigAll();
                ConsortiaBossConfigInfo[] array2 = consortiaBossConfigAll;
                foreach (ConsortiaBossConfigInfo consortiaBossConfigInfo in array2)
                {
                    if (!consortiaBossConfig.ContainsKey(consortiaBossConfigInfo.BossLevel))
                    {
                        consortiaBossConfig.Add(consortiaBossConfigInfo.BossLevel, consortiaBossConfigInfo);
                    }
                }
            }
            return true;
        }

        public static bool ReLoad()
        {
            try
            {
                Dictionary<string, int> ally = new Dictionary<string, int>();
                Dictionary<int, ConsortiaInfo> consortia = new Dictionary<int, ConsortiaInfo>();
                Dictionary<int, ConsortiaBossConfigInfo> dictionary = new Dictionary<int, ConsortiaBossConfigInfo>();
                if (Load(ally) && LoadConsortia(consortia, dictionary))
                {
                    m_lock.AcquireWriterLock(-1);
                    try
                    {
                        _ally = ally;
                        _consortia = consortia;
                        _consortiaBossConfigInfos = dictionary;
                        return true;
                    }
                    catch
                    {
                    }
                    finally
                    {
                        m_lock.ReleaseWriterLock();
                    }
                }
            }
            catch (Exception exception)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("ConsortiaMgr", exception);
                }
            }
            return false;
        }

        public static int UpdateConsortiaAlly(int cosortiaID1, int consortiaID2, int state)
        {
            string key = ((cosortiaID1 >= consortiaID2) ? (consortiaID2 + "&" + cosortiaID1) : (cosortiaID1 + "&" + consortiaID2));
            m_lock.AcquireWriterLock(-1);
            try
            {
                if (!_ally.ContainsKey(key))
                {
                    _ally.Add(key, state);
                }
                else
                {
                    _ally[key] = state;
                }
            }
            catch
            {
            }
            finally
            {
                m_lock.ReleaseWriterLock();
            }
            return 0;
        }

        public static bool AddBuffConsortia(GamePlayer Player, ConsortiaBuffTempInfo buffInfo, int consortiaId, int id, int validate)
        {
            switch (buffInfo.group)
            {
                case 1:
                    BufferList.CreatePayBuffer(101, buffInfo.value, validate, id)?.Start(Player);
                    break;
                case 3:
                    BufferList.CreatePayBuffer(103, buffInfo.value, validate, id)?.Start(Player);
                    break;
                case 6:
                    BufferList.CreatePayBuffer(106, buffInfo.value, validate, id)?.Start(Player);
                    break;
                case 8:
                    Player.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("Consortia.Msg2"));
                    return false;
                case 11:
                    BufferList.CreatePayBuffer(111, buffInfo.value, validate, id)?.Start(Player);
                    break;
                case 12:
                    BufferList.CreatePayBuffer(112, buffInfo.value, validate, id)?.Start(Player);
                    break;
                default:
                    {
                        using (PlayerBussiness pb = new PlayerBussiness())
                        {
                            ConsortiaUserInfo[] allMembers = pb.GetAllMemberByConsortia(consortiaId);
                            AbstractBuffer buffer = null;
                            switch (buffInfo.group)
                            {
                                case 2:
                                    buffer = BufferList.CreatePayBuffer(102, buffInfo.value, validate, id);
                                    break;
                                case 4:
                                    buffer = BufferList.CreatePayBuffer(104, buffInfo.value, validate, id);
                                    break;
                                case 5:
                                    buffer = BufferList.CreatePayBuffer(105, buffInfo.value, validate, id);
                                    break;
                                case 7:
                                    buffer = BufferList.CreatePayBuffer(107, buffInfo.value, validate, id);
                                    break;
                                case 9:
                                    buffer = BufferList.CreatePayBuffer(109, buffInfo.value, validate, id);
                                    break;
                                case 10:
                                    buffer = BufferList.CreatePayBuffer(110, buffInfo.value, validate, id);
                                    break;
                            }
                            //ConsortiaUserInfo[] array = allMembers;
                            for (int i = 0; i < allMembers.Length; i++)
                            {
                                GamePlayer member = WorldMgr.GetPlayerById(allMembers[i].UserID);
                                if (member != null)
                                {
                                    buffer?.Start(member);
                                    if (member != Player)
                                    {
                                        member.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("Consortia.Msg3"));
                                    }
                                }
                            }
                            if (buffer != null)
                            {
                                // COPY thì nhờ chạy QUERRY SP_SKILLGUILD trong folder QUERRY nha Lâm ei - baolt
                                ConsortiaBufferInfo conBuff = pb.GetUserConsortiaBufferSingle(buffInfo.id, Player.PlayerCharacter.ConsortiaID);
                                if (conBuff == null)
                                {
                                    conBuff = new ConsortiaBufferInfo();
                                    conBuff.ConsortiaID = consortiaId;
                                    conBuff.IsOpen = true;
                                    conBuff.BufferID = buffInfo.id;
                                    conBuff.Type = buffer.Info.Type;
                                    conBuff.Value = buffer.Info.Value;
                                    conBuff.ValidDate = buffer.Info.ValidDate;
                                    conBuff.BeginDate = buffer.Info.BeginDate;
                                }
                                else
                                {
                                    conBuff.ValidDate += buffer.Info.ValidDate;
                                    conBuff.Value = buffer.Info.Value;
                                    conBuff.Type = buffer.Info.Type;
                                    conBuff.BufferID = buffInfo.id;
                                    
                                }
                                pb.SaveConsortiaBuffer(conBuff);
                            }
                        }
                        break;
                    }
            }
            return true;
        }
    }
}
