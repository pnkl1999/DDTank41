using Bussiness;
using Game.Logic;
using Game.Server.ConsortiaTask.Conditions;
using Game.Server.GameObjects;
using Game.Server.Managers;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Game.Server.Packets;
using Game.Server.ConsortiaTask.Data;
using Newtonsoft.Json;

namespace Game.Server.ConsortiaTask
{
    public static class ConsortiaTaskMgr
    {
        public static ConsortiaTaskPacketsOut Out;
        public static ConsortiaTaskData Data;
        private static readonly ILog Log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        public static List<Consortia> Consortiums;
        private static List<Mission> Missions;
        private static Timer _scanTimer;
        private static string[] stringMisRich;

        public static bool Init()
        {
            Consortiums = new List<Consortia>();
            Out = new ConsortiaTaskPacketsOut();
            Data = new ConsortiaTaskData();
            Missions = new List<Mission>();
            _scanTimer = new Timer(Scan, null, 30000, 60000);

            using(ProduceBussiness produce = new ProduceBussiness())
            {
                ConsortiaTaskConditions[] consortiaTasks = produce.GetAllConsortiaTask();
                ConsortiaTaskConditions[] array = consortiaTasks;
                foreach (ConsortiaTaskConditions consortiaTaskInfo in array)
                {
                    Data.AddTask(consortiaTaskInfo);
                }
            }

            using (PlayerBussiness _playerBussiness = new PlayerBussiness())
            {
                ConsortiaWithTaskInfo[] consortiaWithTasks = _playerBussiness.GetConsortiaTaskInfos();
                foreach (ConsortiaWithTaskInfo consortiaTaskInfo in consortiaWithTasks)
                {
                    CreateTask(consortiaTaskInfo);
                }
            }
            char[] separator = new char[1]
            {
                    '|'
            };
            stringMisRich = GameProperties.MissionRiches.Split(separator);
            //Console.WriteLine(GameProperties.HotSpringExp);

            return true;
        }

        public static int GetMissionRichesWithLevel(int grade)
        {
            try
            {
                if (grade <= stringMisRich.Length)
                {
                    return int.Parse(stringMisRich[grade - 1]);
                }
            }
            catch (Exception ex)
            {
                Log.Error("GetExpWithLevel Error: " + ex.ToString());
            }
            return 0;
        }

        public static void AddPlayer(GamePlayer player)
        {
            try
            {
                lock (Consortiums)
                {
                    var consortia = Consortiums.Find(c => c.ID == player.PlayerCharacter.ConsortiaID);
                    if (consortia == null) return;
                    consortia.Players.Add(player);

                    if (!consortia.RankTable.ContainsKey(player.PlayerId))
                    {
                        consortia.RankTable.Add(player.PlayerId, 0);
                    }

                    foreach (var taskCondition in consortia.Task.Conditions)
                    {
                        Condition condition = null;
                        switch (taskCondition.Type)
                        {
                            case 1:
                                condition = new PvPBattleCondition(player, consortia);
                                consortia.Conditions.Add(condition);
                                break;
                            case 2:
                                condition = new GuildBattleCondition(player, consortia);
                                consortia.Conditions.Add(condition);
                                break;
                            case 3:
                                condition = new UseItemCondition(player, consortia, taskCondition.TemplateID);
                                consortia.Conditions.Add(condition);
                                break;
                            case 4:
                                condition = new MissionCompleteCondition(player, consortia);
                                consortia.Conditions.Add(condition);
                                break;
                            case 5:
                                condition = new DonateRichesCondition(player, consortia);
                                consortia.Conditions.Add(condition);
                                break;
                        }
                        condition?.AddTrigger();
                    }
                }
            }
            catch (Exception e)
            {
                if (Log.IsErrorEnabled)
                    Log.Error("AddPlayer ConsortiaTask error", e);
            }
        }

        public static void RemovePlayer(GamePlayer player)
        {
            try
            {
                lock (Consortiums)
                {
                    var consortia = Consortiums.Find(c => c.ID == player.PlayerCharacter.ConsortiaID);
                    if (consortia == null) return;
                    {
                        consortia.Players.Remove(player);
                        foreach (var condition in consortia.Conditions.FindAll(c => c.Player == player))
                        {
                            condition.RemoveTrigger();
                        }
                    }
                }
            }
            catch (Exception e)
            {
                if (Log.IsErrorEnabled)
                    Log.Error("Remove ConsortiaTask error", e);
            }
        }

        private static void Scan(object state)
        {
            try
            {
                lock (Consortiums)
                {
                    foreach (var consortia in Consortiums.Where(consortia => consortia != null).ToList())
                    {
                        if (consortia.Task.BeginTime.AddMinutes(consortia.Task.Time) < DateTime.Now)
                        {
                            consortia.Players.ForEach(t => { Out.SendTaskComplete(t); });
                            RemoveConsortiaForm(consortia);
                        }
                        else
                        {
                            if (!consortia.Task.Completed && !CanConditionCompleted(consortia)) continue;

                            ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness();
                            ConsortiaInfo consortiaInfo = consortiaBussiness.GetConsortiaSingle(consortia.ID);
                            int addrich = ConsortiaTaskMgr.GetMissionRichesWithLevel(consortiaInfo.Level) * 3 / 2;
                            if (consortiaBussiness.ConsortiaRichAdd(consortia.ID, ref addrich))
                            {
                                consortia.Players.ForEach(t =>
                                {
                                    var taskExpirience = consortia.Task.Expirience * consortia.RankTable[t.PlayerId] / consortia.Task.Points;
                                    var taskPoints = consortia.Task.Offer * consortia.RankTable[t.PlayerId] / consortia.Task.Points;
                                    var taskContribution = consortia.Task.Contribution * consortia.RankTable[t.PlayerId] / consortia.Task.Points;

                                    t.AddGP(taskExpirience);
                                    t.AddOffer(taskPoints);
                                    t.AddRichesOffer(taskContribution);
                                    t.SendMessage(eMessageType.ChatNormal, @"Bạn nhận được thưởng từ Guild.");

                                    var content = $"Bao gồm: \n" +
                                                  $"{taskExpirience} kinh nghiệm.\n" +
                                                  $"{taskPoints} cống hiến";

                                    t.SendMailToUser(new PlayerBussiness(), content, "Sứ mệnh Guild",
                                        eMailType.ConsortionEmail);

                                    Out.SendTaskComplete(t);
                                });
                                RemoveConsortiaForm(consortia);
                            }
                            
                        }
                    }
                }
            }
            catch (Exception e)
            {
                if (Log.IsErrorEnabled)
                    Log.Error("Scan ConsortiaTask error", e);
            }

        }

        private static void RemoveConsortiaForm(Consortia consortia)
        {
            Consortiums.Remove(consortia);
            foreach (var condition in consortia.Conditions)
            {
                condition.RemoveTrigger();
            }
            consortia.Players.Clear();
            consortia.Players = null;
            consortia.Conditions = null;
            consortia.Task = null;
            SaveConsortiaTask(consortia);
        }

        public static bool CreateTask(ConsortiaWithTaskInfo consortiaWithTaskInfo)
        {
            try
            {
                lock (Consortiums)
                {
                    var consortiaId = consortiaWithTaskInfo.ConsortiaID;
                    var consortia = Consortiums.Find(c => c.ID == consortiaId);
                    if (consortia != null) return true;

                    if(string.IsNullOrEmpty(consortiaWithTaskInfo.ConditionData)) //khong co su menh thi ko can add, vut me di
                    {
                        return false;
                    }
                    List<GamePlayer> listPlayer = WorldMgr.GetAllConsortiaPlayers(consortiaId).ToList();
                    consortia = new Consortia
                    {
                        ID = consortiaWithTaskInfo.ConsortiaID,
                        Players = listPlayer,
                        Conditions = new List<Condition>(),
                        RankTable = FormatRankTable(listPlayer, consortiaWithTaskInfo.RankTable)
                    };
                    var task = new ConsortiaTaskInfo
                    {
                        ID = 0,
                        BeginTime = consortiaWithTaskInfo.BeginTime,
                        Contribution = consortiaWithTaskInfo.Contribution,
                        Expirience = consortiaWithTaskInfo.Expirience,
                        Offer = consortiaWithTaskInfo.Offer,
                        BuffID = consortiaWithTaskInfo.BuffID,
                        Level = consortiaWithTaskInfo.Level,
                        Riches = consortiaWithTaskInfo.Riches,
                        Time = consortiaWithTaskInfo.Time,
                        Conditions = CreateTaskConditions(consortiaWithTaskInfo.ConditionData),
                    };
                    consortia.Task = task;
                    if (consortia.Task.Conditions == null) return false;//tao task loi thi ko can add vao list
                    consortia.Task.Conditions.ForEach(t => consortia.Task.Points += t.Target);
                    CreateTaskEvents(consortia);
                    Consortiums.Add(consortia);
                    return true;
                }
            }
            catch (Exception e)
            {
                if (Log.IsErrorEnabled)
                    Log.Error("CreateConsortiaWithTaskInfo error", e);
            }
            return false;
        }

        public static Dictionary<int, int> FormatRankTable(List<GamePlayer> listPlayer, string RankTable)
        {
            var _RankTable = new Dictionary<int, int>();
            if(!string.IsNullOrEmpty(RankTable))
            {
                _RankTable = JsonConvert.DeserializeObject<Dictionary<int, int>>(RankTable);
            }

            listPlayer.ForEach(t => {
                if(!_RankTable.ContainsKey(t.PlayerId)) {
                    _RankTable.Add(t.PlayerId, 0);
                }
            });
            return _RankTable;
        }

        public static bool CreateTask(GamePlayer player, int level, bool reset = false)
        {
            try
            {
                lock (Consortiums)
                {
                    var consortiaId = player.PlayerCharacter.ConsortiaID;
                    var consortia = Consortiums.Find(c => c.ID == consortiaId);
                    if (consortia != null) return true;

                    List<GamePlayer> listPlayer = WorldMgr.GetAllConsortiaPlayers(consortiaId).ToList();

                    consortia = new Consortia
                    {
                        ID = player.PlayerCharacter.ConsortiaID,
                        Players = listPlayer,
                        Conditions = new List<Condition>(),
                        RankTable = FormatRankTable(listPlayer, null)
                    };
                    int taskcost = ConsortiaTaskMgr.GetMissionRichesWithLevel(level);
                    if (taskcost == 0) taskcost = 3000;
                    var task = new ConsortiaTaskInfo
                    {
                        ID = 0,
                        BeginTime = DateTime.Now,
                        Contribution = level * 5000,
                        Expirience = level * 10000,
                        Offer = level * 1000,
                        BuffID = -1,
                        Level = level,
                        Riches = taskcost * 3 / 2,
                        Time = 120,
                        Conditions = CreateTaskConditions(level, 0),
                    };
                    consortia.Task = task;
                    consortia.Task.Conditions.ForEach(t => consortia.Task.Points += t.Target);
                    CreateTaskEvents(consortia);
                    Consortiums.Add(consortia);
                    SaveConsortiaTask(consortia);
                    if (reset) return true;
                    //using (var consortiaBussiness = new ConsortiaBussiness())
                    //    consortiaBussiness.ConsortiaEventAdd(player.PlayerCharacter.ConsortiaID, 3, player.PlayerCharacter.NickName, player.PlayerCharacter.NickName, (level + 1) / 2);
                    return true;
                }
            }
            catch (Exception e)
            {
                if (Log.IsErrorEnabled)
                    Log.Error("CreateTask error", e);
            }
            return false;
        }

        public static bool SaveConsortiaTask(Consortia consortia)
        {
            try
            {
                //var consortia = Consortiums.Find(c => c.ID == consortiaId);
                if (consortia != null)
                {
                    if (consortia.Task != null)
                    {
                        ConsortiaWithTaskInfo info = new ConsortiaWithTaskInfo();
                        info.ConsortiaID = consortia.ID;
                        info.BeginTime = consortia.Task.BeginTime;
                        info.Contribution = consortia.Task.Contribution;
                        info.Expirience = consortia.Task.Expirience;
                        info.Offer = consortia.Task.Offer;
                        info.BuffID = consortia.Task.BuffID;
                        info.Level = consortia.Task.Level;
                        info.Riches = consortia.Task.Riches;
                        info.Time = consortia.Task.Time;
                        info.ConditionData = consortia.Task.Conditions != null ? JsonConvert.SerializeObject(consortia.Task.Conditions) : null;
                        info.RankTable = consortia.RankTable != null ? JsonConvert.SerializeObject(consortia.RankTable) : null;
                        using (PlayerBussiness _playerBussiness = new PlayerBussiness())
                        {
                            _playerBussiness.CreateOrUpdateConsortiaTaskInfo(info);
                        }
                    } else
                    {
                        using (PlayerBussiness _playerBussiness = new PlayerBussiness())
                        {
                            _playerBussiness.RemoveConsortiaTaskInfo(consortia.ID);
                        }
                    }
                }
                    
                return true;
            }
            catch (Exception e)
            {
                if (Log.IsErrorEnabled)
                    Log.Error("SaveConsortiaTask error", e);
            }
            return false;
        }

        public static void ResetTask(GamePlayer player, bool isBand)
        {
            lock (Consortiums)
            {
                try
                {
                    var consortiaId = player.PlayerCharacter.ConsortiaID;
                    var consortia = Consortiums.Find(c => c.ID == consortiaId);
                    if (consortia != null)
                    {
                        Consortiums.Remove(consortia);
                        var level = consortia.Task.Level;
                        foreach (var condition in consortia.Conditions)
                        {
                            condition.RemoveTrigger();
                        }
                        consortia.Conditions = null;
                        consortia.Task = null;
                        consortia = null;
                        CreateTask(player, level, true);
                    }
                    else
                    {
                        CreateTask(player, 1, true);
                    }
                }
                catch (Exception e)
                {
                    if (Log.IsErrorEnabled)
                        Log.Error("ResetTask error", e);
                }
            }

        }


        private static void CreateTaskEvents(Consortia consortia)
        {
            try
            {
                foreach (var player in consortia.Players)
                {
                    foreach (var taskCondition in consortia.Task.Conditions)
                    {
                        Condition condition = null;
                        switch (taskCondition.Type)
                        {
                            case 1:
                                condition = new PvPBattleCondition(player, consortia);
                                consortia.Conditions.Add(condition);
                                break;
                            case 2:
                                condition = new GuildBattleCondition(player, consortia);
                                consortia.Conditions.Add(condition);
                                break;
                            case 3:
                                condition = new UseItemCondition(player, consortia, taskCondition.TemplateID);
                                consortia.Conditions.Add(condition);
                                break;
                            case 4:
                                condition = new MissionCompleteCondition(player, consortia);
                                consortia.Conditions.Add(condition);
                                break;
                            case 5:
                                condition = new DonateRichesCondition(player, consortia);
                                consortia.Conditions.Add(condition);
                                break;
                        }
                        condition?.AddTrigger();
                    }

                }
            }
            catch (Exception e)
            {
                if (Log.IsErrorEnabled)
                    Log.Error(@"CreateTaskEvent error", e);
            }

        }

        private static List<ConsortiaTaskConditionInfo> CreateTaskConditions(int level, int taskId)
        {
            var result = new List<ConsortiaTaskConditionInfo>();
            var taskType = new List<int>();

            try
            {
                while (taskType.Count < 3)
                {
                    var random = ThreadSafeRandom.NextStatic(1, 50);
                    int type;
                    if (random < 10)
                        type = 1;
                    else if (random >= 10 && random < 20)
                        type = 2;
                    else if (random >= 20 && random < 30)
                        type = 3;
                    else if (random >= 30 && random < 40)
                        type = 4;
                    else
                        type = 5;

                    if (!taskType.Contains(type))
                        taskType.Add(type);
                }

                for (var i = 0; i < taskType.Count; i++)
                {
                    var taskCondition = Data.GetTaskConditionDataInfo(taskType[i], level);
                    var item = new ConsortiaTaskConditionInfo
                    {
                        ID = i,
                        TaskID = taskId,
                        Content = string.Format(taskCondition.Content, taskCondition.TargetCount),
                        Type = taskType[i],
                        Value = 0,
                        Target = taskCondition.TargetCount,
                        Finish = 0,
                        TemplateID = taskCondition.Target,
                        MustWin = Convert.ToBoolean(taskCondition.Para2),
                        MissionID = taskCondition.Target
                    };
                    item.Complete += ConditionCompleted;
                    result.Add(item);
                }
            }
            catch (Exception e)
            {
                if (Log.IsErrorEnabled)
                    Log.Error(@"CreateTaskCondition error", e);
            }
            return result;
        }

        private static List<ConsortiaTaskConditionInfo> CreateTaskConditions(string initialConditions)
        {
            var result = new List<ConsortiaTaskConditionInfo>();
            try
            {
                if (string.IsNullOrEmpty(initialConditions))//khong co du lieu nhiem vu guild thi k can add smg
                {
                    return null;
                }

                result = JsonConvert.DeserializeObject<List<ConsortiaTaskConditionInfo>>(initialConditions);
                result.ForEach(consortiaWithTaskItem => {
                    consortiaWithTaskItem.Complete += ConditionCompleted;//set event
                });
            }
            catch (Exception e)
            {
                if (Log.IsErrorEnabled)
                    Log.Error(@"CreateTaskCondition error", e);
                result = null;
            }
            return result;
        }

        private static void ConditionCompleted(Consortia consortia, ConsortiaTaskConditionInfo condition)
        {
            lock (Consortiums)
            {
                foreach (var player in consortia.Players)
                {
                    Out.SendTaskConditionCompleted(player, condition.Content);
                }

                var allCompleted = true;
                consortia.Task.Conditions.ForEach(t =>
                {
                    if (!t.Completed)
                        allCompleted = false;
                });

                if (allCompleted)
                    consortia.Task.Completed = true;
            }
        }

        private static bool CanConditionCompleted(Consortia consortia)
        {
            lock (Consortiums)
            {
                var canComplete = true;
                consortia.Task.Conditions.ForEach(t =>
                {
                    if (!t.Completed)
                        canComplete = false;
                });

                return canComplete;
            }
        }

        /// <summary>
        /// Возвращает слова в падеже, зависимом от заданного числа 
        /// </summary>
        /// <param name="number">Число от которого зависит выбранное слово</param>
        /// <param name="nominativ">Именительный падеж слова. Например "день"</param>
        /// <param name="genetiv">Родительный падеж слова. Например "дня"</param>
        /// <param name="plural">Множественное число слова. Например "дней"</param>
        /// <returns></returns>
        public static string GetDeclension(int number, string nominativ, string genetiv, string plural)
        {
            number = number % 100;
            if (number >= 11 && number <= 19) return plural;

            var i = number % 10;
            switch (i)
            {
                case 1:
                    return nominativ;
                case 2:
                case 3:
                case 4:
                    return genetiv;
                default:
                    return plural;
            }
        }

        public static void Shuffle<T>(this IList<T> list)
        {
            var provider = new RNGCryptoServiceProvider();
            var n = list.Count;
            while (n > 1)
            {
                var box = new byte[1];
                do
                {
                    provider.GetBytes(box);
                } while (!(box[0] < n * (byte.MaxValue / n)));
                var k = box[0] % n;
                n--;
                var value = list[k];
                list[k] = list[n];
                list[n] = value;
            }
        }
    }
}
