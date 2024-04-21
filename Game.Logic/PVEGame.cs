using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Logic.Actions;
using Game.Logic.AI;
using Game.Logic.AI.Game;
using Game.Logic.AI.Mission;
using Game.Logic.Phy.Maps;
using Game.Logic.Phy.Object;
using Game.Server.Managers;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Text;

namespace Game.Logic
{
    public class PVEGame : BaseGame
    {
        public long AllWorldDameBoss;

        private int BeginPlayersCount;

        private DateTime beginTime;

        public int[] BossCards;

        public bool CanEnterGate;

        public bool CanShowBigBox;

        public bool IsKillWorldBoss;

        public bool IsWin;

        public bool CanEndGame;

        private int m_bossCardCount;

        private APVEGameControl m_gameAI;

        private List<string> m_gameOverResources;

        private eHardLevel m_hardLevel;

        private PveInfo m_info;

        private string m_IsBossType;

        private List<int> m_mapHistoryIds;

        private AMissionControl m_missionAI;

        private MissionInfo m_missionInfo;

        private int m_pveGameDelay;

        private MapPoint mapPos;

        public Dictionary<int, MissionInfo> Misssions;

        public int Param1;

        public int Param2;

        public int Param3;

        public int Param4;

        public Living ParamLiving;

        public string Pic;

        public int SessionId;

        public int TotalCount;

        public int TotalKillCount;

        public int TotalMissionCount;

        public double TotalNpcExperience;

        public double TotalNpcGrade;

        public int TotalTurn;

        public int WantTryAgain;

        public long WorldbossBood;

        private bool m_isPassDrama;

        public int TakeCardId;

        private Dictionary<int, int> m_NpcTurnQueue = new Dictionary<int, int>();

        private int m_countAward;

        public Dictionary<int, int> NpcTurnQueue => m_NpcTurnQueue;

        public bool IsPassDrama
        {
            get
            {
                return m_isPassDrama;
            }
            set
            {
                m_isPassDrama = value;
            }
        }

        public PveInfo Info => m_info;

        public int BossCardCount
        {
            get
            {
                return m_bossCardCount;
            }
            set
            {
                if (value > 0)
                {
                    BossCards = new int[9];
                    m_bossCardCount = value;
                }
            }
        }

        public Player CurrentPlayer => m_currentLiving as Player;

        public TurnedLiving CurrentTurnLiving => m_currentLiving;

        public List<string> GameOverResources => m_gameOverResources;

        public eHardLevel HandLevel => m_hardLevel;

        public string IsBossWar
        {
            get
            {
                return m_IsBossType;
            }
            set
            {
                m_IsBossType = value;
            }
        }

        public List<int> MapHistoryIds
        {
            get
            {
                return m_mapHistoryIds;
            }
            set
            {
                m_mapHistoryIds = value;
            }
        }

        public MapPoint MapPos => mapPos;

        public AMissionControl MissionAI => m_missionAI;

        public MissionInfo MissionInfo
        {
            get
            {
                return m_missionInfo;
            }
            set
            {
                m_missionInfo = value;
            }
        }

        public int PveGameDelay
        {
            get
            {
                return m_pveGameDelay;
            }
            set
            {
                m_pveGameDelay = value;
            }
        }

        public int CountMosterPlace
        {
            get
            {
                return m_countAward;
            }
            set
            {
                m_countAward = value;
            }
        }
        public string m_continuousNick;

        public string ContinuousRunningPlayer
        {
            get
            {
                return m_continuousNick;
            }
            set
            {
                m_continuousNick = value;
            }
        }

        public PVEGame(int id, int roomId, PveInfo info, List<IGamePlayer> players, Map map, eRoomType roomType, eGameType gameType, int timeType, eHardLevel hardLevel, int currentFloor)
            : base(id, roomId, map, roomType, gameType, timeType)
        {
            foreach (IGamePlayer player in players)
            {
                PlayerConfig config = new PlayerConfig();
                Player fp = new Player(player, PhysicalId++, this, 1, player.PlayerCharacter.hp)
                {
                    Direction = ((m_random.Next(0, 1) == 0) ? 1 : (-1))
                };
                AddPlayer(player, fp);
                WorldbossBood = player.WorldbossBood;
                AllWorldDameBoss = player.AllWorldDameBoss;
                fp.Config = config;
            }
            m_isPassDrama = false;
            m_info = info;
            BeginPlayersCount = players.Count;
            TotalKillCount = 0;
            TotalNpcGrade = 0.0;
            TotalNpcExperience = 0.0;
            TotalHurt = 0;
            ParamLiving = null;
            m_IsBossType = "";
            WantTryAgain = 0;
            if (currentFloor > 0)
            {
                SessionId = currentFloor - 1;
            }
            else
            {
                SessionId = 0;
            }
            m_gameOverResources = new List<string>();
            Misssions = new Dictionary<int, MissionInfo>();
            m_mapHistoryIds = new List<int>();
            m_hardLevel = hardLevel;
            string script = GetScript(info, hardLevel);
            m_gameAI = ScriptMgr.CreateInstance(script) as APVEGameControl;
            if (m_gameAI == null)
            {
                BaseGame.log.ErrorFormat("Can't create game ai :{0}", script);
                m_gameAI = SimplePVEGameControl.Simple;
            }
            m_gameAI.Game = this;
            m_gameAI.OnCreated();
            m_missionAI = SimpleMissionControl.Simple;
            beginTime = DateTime.Now;
            m_bossCardCount = 0;
            CanEndGame = false;
            foreach (Player value in m_players.Values)
            {
                value.MissionEventHandle += m_missionAI.OnMissionEvent;
            }
        }

        public void AddAllPlayerToTurn()
        {
            foreach (Player player in base.Players.Values)
            {
                base.TurnQueue.Add(player);
            }
        }

        public override void AddLiving(Living living)
        {
            base.AddLiving(living);
            living.Died += living_Died;
        }

        public override Player AddPlayer(IGamePlayer gp)
        {
            if (CanAddPlayer())
            {
                Player fp = new Player(gp, PhysicalId++, this, 1, gp.PlayerCharacter.hp)
                {
                    Direction = ((m_random.Next(0, 1) == 0) ? 1 : (-1))
                };
                AddPlayer(gp, fp);
                SendCreateGameToSingle(this, gp);
                SendPlayerInfoInGame(this, gp, fp);
                return fp;
            }
            return null;
        }

        public LivingConfig BaseLivingConfig()
        {
            return new LivingConfig
            {
                isBotom = 1,
                IsTurn = true,
                isShowBlood = true,
                isShowSmallMapPoint = true,
                ReduceBloodStart = 1,
                DamageForzen = false,
                CanTakeDamage = true,
                HaveShield = false,
                CancelGuard = false,
                CanCountKill = true,
                CanCollied = true,
                IsShowBloodBar = false,
                FriendlyBoss = new LivingConfig.FriendlyLiving(0, false)
            };
        }

        public SimpleNpc CreateNpc(int npcId, int x, int y, int type)
        {
            return CreateNpc(npcId, x, y, type, -1, "", BaseLivingConfig());
        }

        public SimpleNpc CreateNpc(int npcId, int x, int y, int type, int direction)
        {
            return CreateNpc(npcId, x, y, type, direction, "", BaseLivingConfig());
        }

        public SimpleNpc CreateNpc(int npcId, int x, int y, int type, int direction, string action)
        {
            return CreateNpc(npcId, x, y, type, direction, action, BaseLivingConfig());
        }

        public SimpleNpc CreateNpc(int npcId, int x, int y, int type, int direction, LivingConfig config)
        {
            return CreateNpc(npcId, x, y, type, direction, "", config);
        }

        public SimpleNpc CreateNpc(int npcId, int x, int y, int type, int direction, string action, LivingConfig config)
        {
            NpcInfo npcInfoById = NPCInfoMgr.GetNpcInfoById(npcId);
            SimpleNpc simpleNpc = new SimpleNpc(PhysicalId++, this, npcInfoById, type, direction, action);
            if (config == null)
            {
                simpleNpc.Config = BaseLivingConfig();
            }
            else
                simpleNpc.Config = config;
            simpleNpc.Reset();
            if (simpleNpc.Config.ReduceBloodStart > 1)
            {
                simpleNpc.Blood = npcInfoById.Blood / simpleNpc.Config.ReduceBloodStart;
            }
            simpleNpc.SetXY(x, y);
            AddLiving(simpleNpc);
            simpleNpc.StartMoving();
            return simpleNpc;
        }

        private int CalculateExperience(Player p)
        {
            if (TotalKillCount == 0)
            {
                return 1;
            }
            double num = Math.Abs((double)p.Grade - TotalNpcGrade / (double)TotalKillCount);
            if (num >= 7.0)
            {
                return 1;
            }
            double num2 = 0.0;
            if (TotalKillCount > 0)
            {
                num2 += (double)p.TotalKill / (double)TotalKillCount * 0.4;
            }
            if (TotalHurt > 0)
            {
                num2 += (double)p.TotalHurt / (double)TotalHurt * 0.4;
            }
            if (p.IsLiving)
            {
                num2 += 0.4;
            }
            double num3 = 1.0;
            if (num >= 3.0 && num <= 4.0)
            {
                num3 = 0.7;
            }
            else if (num >= 5.0 && num <= 6.0)
            {
                num3 = 0.4;
            }
            double num4 = (0.9 + (double)(BeginPlayersCount - 1) * 0.4) / (double)base.PlayerCount;
            double num5 = TotalNpcExperience * num2 * num3 * num4;
            num5 = ((num5 == 0.0) ? 1.0 : num5);
            return (int)num5;
        }

        private int CalculateHitRate(int hitTargetCount, int shootCount)
        {
            double num = 0.0;
            if (shootCount > 0)
            {
                num = (double)hitTargetCount / (double)shootCount;
            }
            return (int)(num * 100.0);
        }

        private int CalculateScore(Player p)
        {
            int num = (200 - base.TurnIndex) * 5 + p.TotalKill * 5 + (int)((double)p.Blood / (double)p.MaxBlood) * 10;
            if (!IsWin)
            {
                num -= 400;
            }
            return num;
        }

        public override bool CanAddPlayer()
        {
            lock (m_players)
            {
                return (base.GameState == eGameState.SessionPrepared || GameState == eGameState.TryAgain) && m_players.Count < 4;
            }
        }

        public bool CanGameOver()
        {
            if (base.PlayerCount == 0)
            {
                return true;
            }
            if (GetDiedPlayerCount() == base.PlayerCount)
            {
                IsWin = false;
                return true;
            }
            try
            {
                return m_missionAI.CanGameOver();
            }
            catch (Exception ex)
            {
                BaseGame.log.ErrorFormat("game ai script {0} error:{1}", base.GameState, ex);
            }
            return true;
        }

        public int GetLivingCamp(Living living)
        {
            int camp = 0;
            if (living is Player)
            {
                camp = 0;
            }
            if (living is SimpleNpc)
            {
                camp = ((SimpleNpc)living).NpcInfo.Camp;
            }
            if (living is SimpleBoss)
            {
                camp = ((SimpleBoss)living).NpcInfo.Camp;
            }
            if (living is SimpleWingBoss)
            {
                camp = ((SimpleWingBoss)living).NpcInfo.Camp;
            }
            return camp;
        }

        public bool CanAddBlood(Living addBloodLiving, Living byaddLiving)
        {
            bool isAddBlood = false;
            int addBlood = GetLivingCamp(addBloodLiving);
            int byaddBlood = GetLivingCamp(byaddLiving);
            if (addBlood == 0 || addBlood == 1 || addBlood == 3)
            {
                isAddBlood = byaddBlood != 2;
            }
            if (addBlood == 2)
            {
                isAddBlood = byaddBlood == 2 || byaddBlood == 4;
            }
            return isAddBlood;
        }

        public bool CanStartNewSession()
        {
            if (base.m_turnIndex != 0)
            {
                return IsAllReady();
            }
            return true;
        }

        public void CanStopGame()
        {
            if (!IsWin)
            {
                if ((base.GameType == eGameType.Dungeon))// && SessionId > 1)
                {
                    ClearWaitTimer();
                }
            }
            else
            {
                int nextSessionId = 1 + this.SessionId;
                if (this.Misssions.ContainsKey(nextSessionId) && (m_info.ID == 5 || m_info.ID == 14))
                {
                    this.WantTryAgain = 1;
                }
            }
            SetupStyle(0);
        }

        public bool IsShowLargeCards()
        {
            if (!IsWin)
            {
                return false;
            }
            if (Misssions.ContainsKey(1 + SessionId) && (m_info.ID == 5 || m_info.ID == 14))
            {
                return true;
            }
            return false;
        }

        public void SetupStyle()
        {
            SetupStyle((m_info != null) ? m_info.ID : 0);
        }

        internal void SetupStyle(int ID)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageTypeLogic.GAME_CMD);
            pkg.WriteByte(134);
            List<Player> allFightPlayers = GetAllFightPlayers();
            int place = 0;
            pkg.WriteInt(allFightPlayers.Count);
            foreach (Player item in allFightPlayers)
            {
                IGamePlayer playerDetail = item.PlayerDetail;
                string style = playerDetail.PlayerCharacter.Style;
                if (ID == 6)
                {
                    pkg.WriteString(GuluOlympics(style, place));
                }
                else
                {
                    pkg.WriteString(style);
                }
                place++;
                pkg.WriteInt(playerDetail.PlayerCharacter.Hide);
                pkg.WriteBoolean(playerDetail.PlayerCharacter.Sex);
                pkg.WriteString(playerDetail.PlayerCharacter.Skin);
                pkg.WriteString(playerDetail.PlayerCharacter.Colors);
                pkg.WriteInt(playerDetail.PlayerCharacter.ID);
            }
            SendToAll(pkg);
        }

        public string GuluOlympics(string style, int place)
        {
            string[] strArray1 = style.Split(',');
            string[] strArray2 = new string[4]
            {
                "13300|suits100",
                "13301|suits101",
                "13302|suits102",
                "13303|suits103"
            };
            string str1 = strArray1[0];
            for (int index = 1; index < EquipPlace.Length; index++)
            {
                string str2 = str1 + ",";
                str1 = ((EquipPlace[index] != 11) ? (str2 + strArray1[index]) : (str2 + strArray1[index] + "," + strArray2[place]));
            }
            return str1;
        }

        public void ClearMissionData()
        {
            foreach (Living living4 in m_livings)
            {
                living4.Dispose();
            }
            m_livings.Clear();
            List<TurnedLiving> list = new List<TurnedLiving>();
            foreach (TurnedLiving living2 in base.TurnQueue)
            {
                if (living2 is Player)
                {
                    if (living2.IsLiving)
                    {
                        list.Add(living2);
                    }
                }
                else
                {
                    living2.Dispose();
                }
            }
            base.TurnQueue.Clear();
            foreach (TurnedLiving living3 in list)
            {
                base.TurnQueue.Add(living3);
            }
            if (m_map == null)
            {
                return;
            }
            foreach (PhysicalObj item in m_map.GetAllPhysicalObjSafe())
            {
                item.Dispose();
            }
        }

        public LayerTop CreateLayerTop(int x, int y, string name, string model, string defaultAction, int scale, int rotation)
        {
            LayerTop phy = new LayerTop(PhysicalId++, name, model, defaultAction, scale, rotation);
            phy.SetXY(x, y);
            AddPhysicalObj(phy, sendToClient: true);
            return phy;
        }

        public SimpleBoss CreateBoss(int npcId, int x, int y, int direction, int type)
        {
            return CreateBoss(npcId, x, y, direction, type, "", BaseLivingConfig());
        }

        public SimpleBoss CreateBoss(int npcId, int x, int y, int direction, int type, string action)
        {
            return CreateBoss(npcId, x, y, direction, type, action, BaseLivingConfig());
        }

        public SimpleBoss CreateBoss(int npcId, int x, int y, int direction, int type, string action, LivingConfig config)
        {
            NpcInfo npcInfoById = NPCInfoMgr.GetNpcInfoById(npcId);
            SimpleBoss simpleBoss = new SimpleBoss(PhysicalId++, this, npcInfoById, direction, type, action);
            if (config != null)
            {
                simpleBoss.Config = config;
            }
            else
                simpleBoss.Config = BaseLivingConfig();
            simpleBoss.Reset();
            if (simpleBoss.Config.ReduceBloodStart > 1)
            {
                simpleBoss.Blood = npcInfoById.Blood / simpleBoss.Config.ReduceBloodStart;
            }
            else if (simpleBoss.Config.isConsortiaBoss)
            {
                simpleBoss.Blood = (int)AllWorldDameBoss;
            }
            simpleBoss.SetXY(x, y);
            AddLiving(simpleBoss);
            simpleBoss.StartMoving();
            return simpleBoss;
        }

        public SimpleWingBoss CreateWingBoss(int npcId, int x, int y, int direction, int type)
        {
            return CreateWingBoss(npcId, x, y, direction, type, 100);
        }

        public SimpleWingBoss CreateWingBoss(int npcId, int x, int y, int direction, int type, int bloodInver)
        {
            NpcInfo npcInfo = NPCInfoMgr.GetNpcInfoById(npcId);
            SimpleWingBoss boss = new SimpleWingBoss(PhysicalId++, this, npcInfo, direction, type);
            boss.Reset();
            boss.Blood = boss.Blood / 100 * bloodInver;
            boss.SetXY(x, y);
            AddLiving(boss);
            return boss;
        }

        public PhysicalObj CreatePhysicalObj(int x, int y, string name, string model, string defaultAction, int scale, int rotation)
        {
            PhysicalObj phy = new PhysicalObj(PhysicalId++, name, model, defaultAction, scale, rotation, 0);
            phy.SetXY(x, y);
            AddPhysicalObj(phy, sendToClient: true);
            return phy;
        }

        public PhysicalObj CreatePhysicalObj(int x, int y, string name, string model, string defaultAction, int scale, int rotation, int typeEffect)
        {
            PhysicalObj phy = new PhysicalObj(PhysicalId++, name, model, defaultAction, scale, rotation, typeEffect);
            phy.SetXY(x, y);
            AddPhysicalObj(phy, sendToClient: true);
            return phy;
        }

        public Layer Createlayer(int x, int y, string name, string model, string defaultAction, int scale, int rotation)
        {
            Layer phy = new Layer(PhysicalId++, name, model, defaultAction, scale, rotation);
            phy.SetXY(x, y);
            AddPhysicalObj(phy, sendToClient: true);
            return phy;
        }

        public Layer Createlayer(int x, int y, string name, string model, string defaultAction, int scale, int rotation, bool CanPenetrate)
        {
            Layer phy = new Layer(PhysicalId++, name, model, defaultAction, scale, rotation, CanPenetrate);
            phy.SetXY(x, y);
            AddPhysicalObj(phy, sendToClient: true);
            return phy;
        }
        public Ball CreateBall(int x, int y, string action)
        {
            Ball ball = new Ball(this.PhysicalId++, action);
            ball.SetXY(x, y);
            this.m_map.AddPhysical(ball);
            base.AddBall(ball, true);
            return ball;
        }
        public Ball CreateBall(int x, int y, string name, string defaultAction, int scale, int rotation)
        {
            Ball ball = new Ball(PhysicalId++, name, defaultAction, scale, rotation);
            ball.SetXY(x, y);
            AddPhysicalObj(ball, sendToClient: true);
            SendLivingActionMapping(ball.Id, "pick", name);
            return ball;
        }

        public override void CheckState(int delay)
        {
            AddAction(new CheckPVEGameStateAction(delay));
        }

        protected override void Dispose(bool disposing)
        {
            base.Dispose(disposing);
            foreach (Living living in m_livings)
            {
                living.Dispose();
            }
            try
            {
                m_missionAI.Dispose();
            }
            catch (Exception exception)
            {
                BaseGame.log.ErrorFormat("game ai script m_missionAI.Dispose() error:{1}", exception);
            }
            try
            {
                m_gameAI.Dispose();
            }
            catch (Exception exception2)
            {
                BaseGame.log.ErrorFormat("game ai script m_gameAI.Dispose() error:{1}", exception2);
            }
        }

        public void DoOther()
        {
            try
            {
                m_missionAI.DoOther();
            }
            catch (Exception exception)
            {
                BaseGame.log.ErrorFormat("game ai script m_gameAI.DoOther() error:{1}", exception);
            }
        }

        public void GameOver()
        {
            if (base.GameState != eGameState.Playing && base.GameState != eGameState.PrepareGameOver)
            {
                return;
            }
            m_gameState = eGameState.GameOver;
            SendUpdateUiData();
            try
            {
                m_missionAI.OnGameOver();
            }
            catch (Exception arg)
            {
                BaseGame.log.ErrorFormat("game ai script {0} error:{1}", base.GameState, arg);
            }
            List<Player> allFightPlayers = GetAllFightPlayers();
            CurrentTurnTotalDamage = 0;
            m_bossCardCount = 1;
            TakeCardId = m_missionInfo.Id;
            bool isEndSession = HasNextSession();
            if (!IsWin || !isEndSession)
            {
                m_bossCardCount = 0;
            }
            if (IsWin && !isEndSession && !isTrainer())
            {
                m_bossCardCount = 2;
            }
            if (base.GameType == eGameType.FightLab && IsWin)
            {
                foreach (Player item in allFightPlayers)
                {
                    item.PlayerDetail.SetFightLabPermission(m_info.ID, m_hardLevel, MissionInfo.Id);
                }
            }
            GSPacketIn gSPacketIn = new GSPacketIn((byte)ePackageTypeLogic.GAME_CMD);
            gSPacketIn.WriteByte((byte)eTankCmdType.MISSION_OVE);
            gSPacketIn.WriteInt(BossCardCount);
            if (!isEndSession && !IsShowLargeCards())
            {
                gSPacketIn.WriteBoolean(val: false);
                gSPacketIn.WriteBoolean(val: false);
            }
            else
            {
                gSPacketIn.WriteBoolean(val: true);
                gSPacketIn.WriteString($"show{1 + SessionId}.jpg");
                gSPacketIn.WriteBoolean(val: true);
            }
            gSPacketIn.WriteInt(PlayerCount);
            foreach (Player item2 in allFightPlayers)
            {
                bool canNextToHardLevel = m_hardLevel != getNextHardLevel(m_hardLevel);
                if (canNextToHardLevel && IsWin && !isEndSession && false)
                {
                    item2.PlayerDetail.SetPvePermission(m_info.ID, getNextHardLevel(m_hardLevel));
                }
                //item2.PlayerDetail.ClearFightBuffOneMatch();
                item2.OnPlayerClearBuffSkillPet();
                item2.EffectList.StopAllEffect();
                if (!IsWin && IsLabyrinth())
                {
                    item2.PlayerDetail.OutLabyrinth(IsWin);
                }
                int num = CalculateExperience(item2);
                if (item2.FightBuffers.ConsortionAddPercentGoldOrGP > 0)
                {
                    num += num * item2.FightBuffers.ConsortionAddPercentGoldOrGP / 100;
                }
                int num2 = CalculateScore(item2);
                m_missionAI.CalculateScoreGrade(item2.TotalAllScore);
                item2.CanTakeOut = BossCardCount;
                if (item2.CurrentIsHitTarget)
                {
                    item2.TotalHitTargetCount++;
                }
                CalculateHitRate(item2.TotalHitTargetCount, item2.TotalShootCount);
                item2.TotalAllHurt += item2.TotalHurt;
                item2.TotalAllCure += item2.TotalCure;
                item2.TotalAllHitTargetCount += item2.TotalHitTargetCount;
                item2.TotalAllShootCount += item2.TotalShootCount;
                item2.GainGP = item2.PlayerDetail.AddGP(num);
                item2.TotalAllExperience += item2.GainGP;
                item2.TotalAllScore += num2;
                item2.BossCardCount = m_bossCardCount;
                gSPacketIn.WriteInt(item2.PlayerDetail.PlayerCharacter.ID);
                gSPacketIn.WriteInt(item2.PlayerDetail.PlayerCharacter.Grade);
                gSPacketIn.WriteInt(0);
                gSPacketIn.WriteInt((item2.GainGP > 10000) ? 10000 : item2.GainGP);
                gSPacketIn.WriteBoolean(IsWin);
                gSPacketIn.WriteInt(BossCardCount);
                gSPacketIn.WriteInt(item2.BossCardCount);
                gSPacketIn.WriteBoolean(val: false);
                gSPacketIn.WriteBoolean(val: false);
            }
            if (BossCardCount > 0)
            {
                gSPacketIn.WriteInt(m_gameOverResources.Count);
                foreach (string gameOverResource in m_gameOverResources)
                {
                    gSPacketIn.WriteString(gameOverResource);
                }
            }
            SendToAll(gSPacketIn);
            StringBuilder stringBuilder = new StringBuilder();
            foreach (Player item3 in allFightPlayers)
            {
                stringBuilder.Append(item3.PlayerDetail.PlayerCharacter.ID).Append(",");
                item3.Ready = false;
                item3.PlayerDetail.OnMissionOver(item3.Game, IsWin, MissionInfo.Id, item3.TurnNum);
            }
            int winTeam = (IsWin ? 1 : 2);
            string teamA = stringBuilder.ToString();
            string teamB = "";
            string playResult = "";
            if (!IsWin && !m_missionInfo.TryAgain)
            {
                OnGameStopped();
            }
            StringBuilder stringBuilder2 = new StringBuilder();
            if (IsWin && IsBossWar != "")
            {
                stringBuilder2.Append(IsBossWar).Append(",");
                foreach (Player item4 in allFightPlayers)
                {
                    stringBuilder2.Append("PlayerCharacter ID: ").Append(item4.PlayerDetail.PlayerCharacter.ID).Append(",");
                    stringBuilder2.Append("Grade: ").Append(item4.PlayerDetail.PlayerCharacter.Grade).Append(",");
                    stringBuilder2.Append("TurnNum): ").Append(item4.TurnNum).Append(",");
                    stringBuilder2.Append("Attack: ").Append(item4.PlayerDetail.PlayerCharacter.Attack).Append(",");
                    stringBuilder2.Append("Defence: ").Append(item4.PlayerDetail.PlayerCharacter.Defence).Append(",");
                    stringBuilder2.Append("Agility: ").Append(item4.PlayerDetail.PlayerCharacter.Agility).Append(",");
                    stringBuilder2.Append("Luck: ").Append(item4.PlayerDetail.PlayerCharacter.Luck).Append(",");
                    stringBuilder2.Append("BaseAttack: ").Append(item4.PlayerDetail.GetBaseAttack()).Append(",");
                    stringBuilder2.Append("MaxBlood: ").Append(item4.MaxBlood).Append(",");
                    stringBuilder2.Append("BaseDefence: ").Append(item4.PlayerDetail.GetBaseDefence()).Append(",");
                    if (item4.PlayerDetail.SecondWeapon != null)
                    {
                        stringBuilder2.Append("SecondWeapon TemplateID: ").Append(item4.PlayerDetail.SecondWeapon.TemplateID).Append(",");
                        stringBuilder2.Append("SecondWeapon StrengthenLevel: ").Append(item4.PlayerDetail.SecondWeapon.StrengthenLevel).Append(".");
                    }
                }
            }
            BossWarField = stringBuilder2.ToString();
            OnGameOverLog(base.RoomId, base.RoomType, base.GameType, 0, beginTime, DateTime.Now, BeginPlayersCount, MissionInfo.Id, teamA, teamB, playResult, winTeam, BossWarField);
            OnGameOverred();
        }

        public bool IsLabyrinth()
        {
            return base.RoomType == eRoomType.Labyrinth;
        }

        public void PrepareFightingLivings()
        {
            if (base.GameState == eGameState.GameStart)
            {
                m_gameState = eGameState.Playing;
                SendSyncLifeTime();
                WaitTime(base.PlayerCount * 1000);
                try
                {
                    m_missionAI.OnPrepareNewGame();
                }
                catch (Exception ex)
                {
                    BaseGame.log.ErrorFormat("game ai script {0} error:{1}", base.GameState, ex);
                }
            }
        }

        public void GameOverAllSession()
        {
            if (base.GameState != eGameState.GameOver)
            {
                return;
            }
            m_gameState = eGameState.ALLSessionStopped;
            try
            {
                m_gameAI.OnGameOverAllSession();
            }
            catch (Exception exception)
            {
                BaseGame.log.ErrorFormat("game ai script {0} error:{1}", base.GameState, exception);
            }
            List<Player> allFightPlayers = GetAllFightPlayers();
            GSPacketIn pkg = new GSPacketIn((byte)ePackageTypeLogic.GAME_CMD);
            pkg.WriteByte(115);
            int num = 1;
            if (!IsWin)
            {
                num = 0;
            }
            else
            {
                eRoomType roomType = base.RoomType;
                if (roomType == eRoomType.Dungeon)
                {
                    num = 2;
                }
            }
            pkg.WriteInt(base.PlayerCount);
            foreach (Player player in allFightPlayers)
            {
                player.CanTakeOut = num;
                player.PlayerDetail.OnGameOver(this, IsWin, player.GainGP, isSpanArea: false, CoupleFight(player), player.Blood, base.PlayerCount);
                pkg.WriteInt(player.PlayerDetail.PlayerCharacter.ID);
                pkg.WriteInt(player.TotalAllKill);  //_loc7_.killGP = _loc2_.readInt();
                pkg.WriteInt(player.TotalAllHurt); //_loc7_.hertGP = _loc2_.readInt();
                pkg.WriteInt(player.TotalAllScore); //_loc7_.fightGP = _loc2_.readInt();
                pkg.WriteInt(player.TotalAllCure); //_loc7_.ghostGP = _loc2_.readInt();
                pkg.WriteInt(0); //_loc7_.gpForVIP = _loc2_.readInt();
                pkg.WriteInt(0); //_loc7_.gpForSpouse = _loc2_.readInt();
                pkg.WriteInt(0); //_loc7_.gpForServer = _loc2_.readInt();
                pkg.WriteInt(0); //_loc7_.gpForApprenticeOnline = _loc2_.readInt();
                pkg.WriteInt(0); //_loc7_.gpForApprenticeTeam = _loc2_.readInt();
                pkg.WriteInt(0); //_loc7_.gpForDoubleCard = _loc2_.readInt();
                pkg.WriteInt(0); //_loc7_.consortiaSkill = _loc2_.readInt();
                pkg.WriteInt(0);  //_loc7_.luckyExp = _loc2_.readInt();
                pkg.WriteInt(player.TotalAllExperience); //_loc7_.gainGP = _loc2_.readInt();
                pkg.WriteBoolean(IsWin); //_loc9_.isWin = _loc2_.readBoolean();
            }
            pkg.WriteInt(m_gameOverResources.Count);
            foreach (string str in m_gameOverResources)
            {
                pkg.WriteString(str);
            }
            SendToAll(pkg);
            if (IsShowLargeCards())
            {
                WaitTime(16000);
            }
            else
            {
                WaitTime(23000);
            }
            CanStopGame();
        }

        private bool LabyrinthAward(string string_1)
        {
            bool flag = false;
            if (string_1.Length > 0)
            {
                char[] chArray = new char[1]
                {
                    '-'
                };
                string[] array = string_1.Split(chArray);
                for (int i = 0; i < array.Length; i++)
                {
                    if (array[i] == SessionId.ToString())
                    {
                        flag = true;
                        break;
                    }
                }
            }
            return flag;
        }

        public void GameOverMovie()
        {
            if (base.GameState != eGameState.Playing)
            {
                return;
            }
            m_gameState = eGameState.GameOver;
            ClearWaitTimer();
            ClearDiedPhysicals();
            List<Player> allFightPlayers = GetAllFightPlayers();
            foreach (Player player in allFightPlayers)
            {
                if (LabyrinthAward(player.PlayerDetail.ProcessLabyrinthAward))
                {
                    player.PlayerDetail.UpdateLabyrinth(SessionId, m_missionInfo.Id, bigAward: false);
                }
            }
            try
            {
                m_missionAI.OnGameOverMovie();
            }
            catch (Exception exception)
            {
                BaseGame.log.ErrorFormat("game ai script {0} error:{1}", base.GameState, exception);
            }
            bool val = HasNextSession();
            if (!val)
            {
                GSPacketIn pkg = new GSPacketIn((byte)ePackageTypeLogic.GAME_CMD);
                pkg.WriteByte((byte)eTankCmdType.MISSION_OVE);
                pkg.WriteInt(0);
                pkg.WriteBoolean(val);
                pkg.WriteBoolean(val: false);
                pkg.WriteInt(PlayerCount);
                foreach (Player player2 in allFightPlayers)
                {
                    if (IsLabyrinth())
                    {
                        player2.PlayerDetail.OutLabyrinth(IsWin);
                    }
                    player2.OnPlayerClearBuffSkillPet();
                    //player2.PlayerDetail.ClearFightBuffOneMatch();
                    int gp = CalculateExperience(player2);
                    int num2 = CalculateScore(player2);
                    m_missionAI.CalculateScoreGrade(player2.TotalAllScore);
                    if (player2.CurrentIsHitTarget)
                    {
                        player2.TotalHitTargetCount++;
                    }
                    CalculateHitRate(player2.TotalHitTargetCount, player2.TotalShootCount);
                    player2.TotalAllHurt += player2.TotalHurt;
                    player2.TotalAllCure += player2.TotalCure;
                    player2.TotalAllHitTargetCount += player2.TotalHitTargetCount;
                    player2.TotalAllShootCount += player2.TotalShootCount;
                    player2.GainGP = player2.PlayerDetail.AddGP(gp);
                    player2.TotalAllExperience += player2.GainGP;
                    player2.TotalAllScore += num2;
                    player2.BossCardCount = BossCardCount;
                    pkg.WriteInt(player2.PlayerDetail.PlayerCharacter.ID);
                    pkg.WriteInt(player2.PlayerDetail.PlayerCharacter.Grade);
                    pkg.WriteInt(0);
                    pkg.WriteInt(player2.GainGP);
                    pkg.WriteBoolean(IsWin);
                    pkg.WriteInt(BossCardCount);
                    pkg.WriteInt(player2.BossCardCount);
                    pkg.WriteBoolean(val: false);
                    pkg.WriteBoolean(val: false);
                }
                if (BossCardCount > 0)
                {
                    pkg.WriteInt(m_gameOverResources.Count);
                    foreach (string str in m_gameOverResources)
                    {
                        pkg.WriteString(str);
                    }
                }
                SendToAll(pkg);
                OnGameStopped();
                OnGameOverred();
                return;
            }
            foreach (Physics item in m_map.GetAllPhysicalSafe())
            {
                item.PrepareNewTurn();
            }
            m_currentLiving = FindNextTurnedLiving();
            if (m_currentLiving != null && CanEnterGate)
            {
                base.m_turnIndex++;
                m_currentLiving.PrepareSelfTurn();
                List<Box> newBoxes = new List<Box>();
                SendGameNextTurn(m_currentLiving, this, newBoxes);
                CanEnterGate = false;
                CanShowBigBox = false;
                EnterNextFloor();
            }
            base.OnBeginNewTurn();
            try
            {
                m_missionAI.OnBeginNewTurn();
            }
            catch (Exception exception2)
            {
                BaseGame.log.ErrorFormat("game ai script {0} error:{1}", base.GameState, exception2);
            }
        }

        public void EnterNextFloor()
        {
            int foregroundWidth = base.Map.Info.ForegroundWidth;
            Player player = FindRandomPlayer();
            int num = 150;
            int x1 = player.X;
            int y = player.Y;
            int x2 = ((x1 + 150 <= foregroundWidth) ? (x1 + num) : (x1 - num));
            Point point = m_map.FindYLineNotEmptyPointDown(x2, y);
            if (point == Point.Empty)
            {
                point = new Point(x2, base.Map.Bound.Height + 1);
            }
            CreateTransmissionGate(point.X, point.Y - 60, "transmitted", "asset.game.transmitted", "out", 1, 1);
        }

        public TransmissionGate CreateTransmissionGate(int x, int y, string name, string model, string defaultAction, int scale, int rotation)
        {
            TransmissionGate transmissionGate = new TransmissionGate(PhysicalId++, name, model, defaultAction, scale, rotation);
            transmissionGate.SetXY(x, y);
            AddPhysicalObj(transmissionGate, sendToClient: true);
            return transmissionGate;
        }

        public new SimpleNpc[] GetNPCLivingWithID(int id)
        {
            List<SimpleNpc> list = new List<SimpleNpc>();
            foreach (Living living in m_livings)
            {
                if (living is SimpleNpc && living.IsLiving && (living as SimpleNpc).NpcInfo.ID == id)
                {
                    list.Add(living as SimpleNpc);
                }
            }
            return list.ToArray();
        }

        private string GetScript(PveInfo pveInfo, eHardLevel hardLevel)
        {
            return hardLevel switch
            {
                eHardLevel.Easy => pveInfo.SimpleGameScript,
                eHardLevel.Normal => pveInfo.NormalGameScript,
                eHardLevel.Hard => pveInfo.HardGameScript,
                eHardLevel.Terror => pveInfo.TerrorGameScript,
                eHardLevel.Epic => pveInfo.EpicGameScript,
                _ => pveInfo.SimpleGameScript,
            };
        }

        private eHardLevel getNextHardLevel(eHardLevel hardLevel)
        {
            if (hardLevel == eHardLevel.Easy)
            {
                return eHardLevel.Normal;
            }
            if (hardLevel == eHardLevel.Normal)
            {
                return eHardLevel.Hard;
            }
            if (hardLevel == eHardLevel.Hard)
            {
                return eHardLevel.Terror;
            }
            if (hardLevel == eHardLevel.Terror)
            {
                return eHardLevel.Epic;
            }
            return eHardLevel.Epic;
        }

        public bool HasNextSession()
        {
            if (base.PlayerCount == 0 || !IsWin || IsShowLargeCards())
            {
                return false;
            }
            if (Misssions.ContainsKey(1 + SessionId))
            {
                return true;
            }
            return false;
        }

        public bool IsAllReady()
        {
            foreach (Player value in base.Players.Values)
            {
                if (!value.Ready)
                {
                    return false;
                }
            }
            return true;
        }

        private void living_Died(Living living)
        {
            if (base.CurrentLiving != null && base.CurrentLiving is Player && !(living is Player) && living != base.CurrentLiving && living.Config.CanCountKill)
            {
                TotalKillCount++;
                TotalNpcExperience += living.Experience;
                TotalNpcGrade += living.Grade;
            }
        }

        internal void method_67()
        {
            try
            {
                m_missionAI.OnDied();
            }
            catch (Exception ex)
            {
                BaseGame.log.ErrorFormat("game ai script m_gameAI.OnDied() error:{0}", ex);
            }
        }

        public void LoadNpcGameOverResources(int[] npcIds)
        {
            if (npcIds == null || npcIds.Length == 0)
            {
                return;
            }
            for (int i = 0; i < npcIds.Length; i++)
            {
                NpcInfo npcInfoById = NPCInfoMgr.GetNpcInfoById(npcIds[i]);
                if (npcInfoById == null)
                {
                    BaseGame.log.Error("LoadGameOverResources npcInfo resoure is not exits");
                }
                else
                {
                    m_gameOverResources.Add(npcInfoById.ModelID);
                }
            }
        }

        public void LoadResources(int[] npcIds)
        {
            if (npcIds == null || npcIds.Length == 0)
            {
                return;
            }
            for (int i = 0; i < npcIds.Length; i++)
            {
                NpcInfo npcInfoById = NPCInfoMgr.GetNpcInfoById(npcIds[i]);
                if (npcInfoById == null)
                {
                    BaseGame.log.Error("LoadResources npcInfo resoure is not exits");
                }
                else
                {
                    AddLoadingFile(2, npcInfoById.ResourcesPath, npcInfoById.ModelID);
                }
            }
        }

        public override void MinusDelays(int lowestDelay)
        {
            m_pveGameDelay -= lowestDelay;
            if (m_pveGameDelay < 0)
            {
                m_pveGameDelay = 0;
            }
            base.MinusDelays(lowestDelay);
        }

        public override void MissionStart(IGamePlayer host)
        {
            if (base.GameState != eGameState.SessionPrepared && base.GameState != eGameState.GameOver)
            {
                return;
            }
            foreach (Player value in base.Players.Values)
            {
                value.Ready = true;
            }
            CheckState(0);
        }

        public void ConfigLivingSayRule()
        {
            if (m_livings == null || m_livings.Count == 0)
            {
                return;
            }
            int livCount = m_livings.Count;
            foreach (Living living in m_livings)
            {
                living.IsSay = false;
            }
            if (base.TurnIndex % 2 == 0)
            {
                return;
            }
            int sayCount = ((livCount <= 5) ? base.Random.Next(0, 2) : ((livCount <= 5 || livCount > 10) ? base.Random.Next(1, 4) : base.Random.Next(1, 3)));
            if (sayCount <= 0)
            {
                return;
            }
            _ = new int[sayCount];
            int i = 0;
            while (i < sayCount)
            {
                int index = base.Random.Next(0, livCount);
                if (!m_livings[index].IsSay)
                {
                    m_livings[index].IsSay = true;
                    i++;
                }
            }
        }

        public int FindTurnNpcRank()
        {
            int turnNpc = int.MaxValue;
            int rank = 0;
            foreach (int i in m_NpcTurnQueue.Keys)
            {
                if (m_NpcTurnQueue[i] < turnNpc)
                {
                    turnNpc = m_NpcTurnQueue[i];
                    rank = i;
                }
            }
            return rank;
        }

        public void GeneralCommand(GSPacketIn packet)
        {
            if (base.GameState == eGameState.Playing)
            {
                m_gameState = eGameState.Playing;
                try
                {
                    m_missionAI.OnGeneralCommand(packet);
                }
                catch (Exception ex)
                {
                    BaseGame.log.ErrorFormat("game ai script {0} error:{1}", base.GameState, ex);
                }
            }
        }

        public void NextTurn()
        {
            if (base.GameState == eGameState.Playing)
            {

                IsPassDrama = false;
                ClearWaitTimer();
                ClearDiedPhysicals();
                CheckBox();
                ConfigLivingSayRule();
                foreach (Physics item4 in m_map.GetAllPhysicalSafe())
                {
                    item4?.PrepareNewTurn();
                    if (item4 is Living living && living.Config.isShowBlood && living.Blood > 0)
                        living.AddBlood(0, 1);
                }
                List<Box> newBoxes = CreateBox();
                try
                {
                    m_missionAI.OnNewTurnStarted();
                }
                catch (Exception arg)
                {
                    BaseGame.log.ErrorFormat("game ai script {0} error:{1}", base.GameState, arg);
                }
                this.LastTurnLiving = this.m_currentLiving;
                //m_currentLiving = FindNextTurnedLiving();
                m_currentLiving = FindNextTurnedLiving();
                if (m_currentLiving != null)
                {
                    base.m_turnIndex++;
                    this.SendUpdateUiData();
                    if (m_currentLiving is SimpleBoss && m_currentLiving.Config.IsShowBloodBar)
                        ChangeTarget(m_currentLiving.Id);

                    List<Living> livedLivingsHadTurn = GetLivedLivingsHadTurn();
                    if (livedLivingsHadTurn.Count > 0 && this.m_currentLiving.Delay >= m_pveGameDelay)
                    {
                        this.MinusDelays(m_pveGameDelay);
                        foreach (Living living in this.m_livings)
                        {
                            living.PrepareSelfTurn();
                            if (!living.IsFrost)
                            {
                                living.StartAttacking();
                            }
                        }
                        base.SendGameNextTurn(livedLivingsHadTurn[0], this, newBoxes);

                        foreach (Living living2 in this.m_livings)
                        {
                            if (living2.IsAttacking)
                            {
                                living2.StopAttacking();
                            }
                        }
                        PveGameDelay += this.MissionInfo.IncrementDelay;
                        this.CheckState(0);
                    }
                    else
                    {
                        if (this.CanShowBigBox)
                        {
                            this.ShowBigBox();
                            this.CanEnterGate = true;
                        }
                        this.MinusDelays(m_currentLiving.Delay);
                        if (this.m_currentLiving is Player)
                        {
                            base.UpdateWind(base.GetNextWind(), false);
                            if ((m_currentLiving as Player).PlayerDetail.PlayerCharacter.NickName == ContinuousRunningPlayer && (m_currentLiving as Player).IsAddQuipTurn)
                            {
                                foreach (Player allFightPlayer in GetAllFightPlayers())
                                {
                                    allFightPlayer.PlayerDetail.SendMessage($"Người chơi {ContinuousRunningPlayer} nhận được thêm 1 lần tấn công");
                                }
                            }

                        }
                        this.CurrentTurnTotalDamage = 0;
                        this.m_currentLiving.PrepareSelfTurn();
                        if (!this.m_currentLiving.IsFrost && !this.m_currentLiving.BlockTurn && this.m_currentLiving.IsLiving)
                        {
                            this.m_currentLiving.StartAttacking();
                            base.SendSyncLifeTime();
                            base.SendGameNextTurn(this.m_currentLiving, this, newBoxes);
                            if (this.m_currentLiving.IsAttacking)
                            {
                                base.AddAction(new WaitLivingAttackingAction(this.m_currentLiving, base.m_turnIndex, (base.getTurnTime() + 20) * 1000));
                            }
                        }
                        if (m_currentLiving is Player)
                            ContinuousRunningPlayer = (m_currentLiving as Player).PlayerDetail.PlayerCharacter.NickName;
                    }

                }
                base.OnBeginNewTurn();
                try
                {
                    this.m_missionAI.OnBeginNewTurn();
                }
                catch (Exception arg2)
                {
                    BaseGame.log.ErrorFormat("game ai script {0} error:{1}", base.GameState, arg2);
                }
            }
        }

        public void ShowBigBox()
        {
            List<ItemInfo> info = null;
            DropInventory.CopyDrop(m_missionInfo.Id, SessionId, ref info);
            List<int> BhV2sgMkjBpUnK7WcH = new List<int>();
            if (info != null)
            {
                foreach (ItemInfo itemInfo in info)
                {
                    BhV2sgMkjBpUnK7WcH.Add(itemInfo.TemplateID);
                }
            }
            foreach (Player allFightPlayer in GetAllFightPlayers())
            {
                if (LabyrinthAward(allFightPlayer.PlayerDetail.ProcessLabyrinthAward))
                {
                    method_34(allFightPlayer, BhV2sgMkjBpUnK7WcH);
                    allFightPlayer.PlayerDetail.UpdateLabyrinth(SessionId, m_missionInfo.Id, bigAward: true);
                }
            }
        }

        internal void OnShooted()
        {
            try
            {
                m_missionAI.OnShooted();
            }
            catch (Exception exception)
            {
                BaseGame.log.ErrorFormat("game ai script m_gameAI.OnShooted() error:{1}", exception);
            }
        }

        internal void OnCalculatePoint(int point, bool isDouble)
        {
            try
            {
                m_missionAI.OnCalculatePoint(point, isDouble);
            }
            catch (Exception ex)
            {
                log.ErrorFormat(ex.ToString());
            }
        }

        public void Prepare()
        {
            if (GetAllPlayers().Length == 0)
            {
                m_gameState = eGameState.Stopped;
                BaseGame.log.Error("Prepare GetAllPlayers().Length == 0");
            }
            else if (base.GameState == eGameState.Inited)
            {
                m_gameState = eGameState.Prepared;
                SendCreateGame();
                CheckState(0);
                try
                {
                    m_gameAI.OnPrepated();
                }
                catch (Exception ex)
                {
                    BaseGame.log.ErrorFormat("game ai script {0} error:{1}", base.GameState, ex);
                }
            }
        }

        public void PrepareNewGame()
        {
            if (base.GameState == eGameState.GameStart)
            {
                m_gameState = eGameState.Playing;
                BossCardCount = 0;
                SendSyncLifeTime();
                WaitTime(base.PlayerCount * 1000);
                try
                {
                    m_missionAI.OnPrepareNewGame();
                }
                catch (Exception ex)
                {
                    BaseGame.log.ErrorFormat("game ai script {0} error:{1}", base.GameState, ex);
                }
                try
                {
                    m_missionAI.OnStartGame();
                }
                catch (Exception exception)
                {
                    BaseGame.log.ErrorFormat("game ai script {0} error:{1}", base.GameState, exception);
                }
            }
        }

        public void WaitingGameState()
        {
            if (base.GameState == eGameState.Playing || GameState == eGameState.Waiting)
            {
                m_gameState = m_gameStateModify;
                try
                {
                    m_missionAI.OnWaitingGameState();
                }
                catch (Exception ex)
                {
                    BaseGame.log.ErrorFormat("game ai script {0} error:{1}", base.GameState, ex);
                }
            }
        }
        public void PrepareGameOver()
        {
            if (base.GameState == eGameState.Playing)
            {
                m_gameState = eGameState.PrepareGameOver;
                try
                {
                    m_missionAI.OnPrepareGameOver();
                }
                catch (Exception ex)
                {
                    BaseGame.log.ErrorFormat("game ai script {0} error:{1}", base.GameState, ex);
                }
            }
        }

        public void PrepareNewSession()
        {
            if (base.GameState != eGameState.Prepared && base.GameState != eGameState.GameOver && base.GameState != eGameState.ALLSessionStopped && GameState != eGameState.TryAgain)
            {
                return;
            }
            m_gameState = eGameState.SessionPrepared;
            SessionId++;
            ClearLoadingFiles();
            ClearMissionData();
            m_gameOverResources.Clear();
            this.WantTryAgain = 0;
            m_missionInfo = Misssions[SessionId];
            if (m_missionInfo == null)
            {
                m_gameState = eGameState.ALLSessionStopped;
                base.IsWrong = true;
                return;
            }
            //WantTryAgain = (m_missionInfo.TryAgain ? m_missionInfo.TryAgainCost : 0);// ((SessionId > 1) ? num : 0);
            m_pveGameDelay = m_missionInfo.Delay;
            TotalCount = m_missionInfo.TotalCount;
            TotalTurn = m_missionInfo.TotalTurn;
            Param1 = m_missionInfo.Param1;
            Param2 = m_missionInfo.Param2;
            Param3 = -1;
            Param4 = -1;
            foreach (Player value in m_players.Values)
            {
                value.MissionEventHandle -= m_missionAI.OnMissionEvent;
            }
            m_missionAI = ScriptMgr.CreateInstance(m_missionInfo.Script) as AMissionControl;
            foreach (Player value2 in m_players.Values)
            {
                value2.MissionEventHandle += m_missionAI.OnMissionEvent;
            }
            if (m_missionAI == null)
            {
                BaseGame.log.ErrorFormat("Can't create game mission ai :{0}", m_missionInfo.Script);
                m_missionAI = SimpleMissionControl.Simple;
            }
            if (base.RoomType == eRoomType.Dungeon)
            {
                Pic = $"show{SessionId}.jpg";
                foreach (Player allFightPlayer in GetAllFightPlayers())
                {
                    allFightPlayer.PlayerDetail.UpdateBarrier(SessionId, Pic);
                }
            }
            m_missionAI.Game = this;
            try
            {
                m_missionAI.OnPrepareNewSession();
            }
            catch (Exception arg)
            {
                BaseGame.log.ErrorFormat("game ai script {0} error:{1}", base.GameState, arg);
            }
        }

        public override Player RemovePlayer(IGamePlayer gp, bool isKick)
        {
            Player player = GetPlayer(gp);
            if (player != null)
            {
                player.PlayerDetail.RemoveGP(gp.PlayerCharacter.Grade * 12);
                player.PlayerDetail.ClearFightBuffOneMatch();
                string msg = null;
                if (player.IsLiving && (base.GameState == eGameState.GameStart || base.GameState == eGameState.Playing))
                {
                    msg = LanguageMgr.GetTranslation("AbstractPacketLib.SendGamePlayerLeave.Msg4", gp.PlayerCharacter.Grade * 12);
                    string translation2 = LanguageMgr.GetTranslation("AbstractPacketLib.SendGamePlayerLeave.Msg5", gp.PlayerCharacter.NickName, gp.PlayerCharacter.Grade * 12);
                    SendMessage(gp, msg, translation2, 3);
                }
                else
                {
                    string translation = LanguageMgr.GetTranslation("AbstractPacketLib.SendGamePlayerLeave.Msg1", gp.PlayerCharacter.NickName);
                    SendMessage(gp, msg, translation, 3);
                }
                base.RemovePlayer(gp, isKick);
            }
            return player;
        }

        private void SendCreateGameToSingle(PVEGame game, IGamePlayer gamePlayer)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageTypeLogic.GAME_CMD);
            pkg.WriteByte((byte)eTankCmdType.GAME_ROOM_INFO);
            pkg.WriteInt(game.Map.Info.ID);
            pkg.WriteInt((byte)game.RoomType);
            pkg.WriteInt((byte)game.GameType);
            pkg.WriteInt(game.TimeType);
            List<Player> allFightPlayers = game.GetAllFightPlayers();
            pkg.WriteInt(allFightPlayers.Count);
            foreach (Player player in allFightPlayers)
            {
                IGamePlayer playerDetail = player.PlayerDetail;
                pkg.WriteInt(playerDetail.PlayerCharacter.ID);
                pkg.WriteString(playerDetail.PlayerCharacter.NickName);
                pkg.WriteBoolean(playerDetail.IsViewer);
                pkg.WriteByte(playerDetail.PlayerCharacter.typeVIP);
                pkg.WriteInt(playerDetail.PlayerCharacter.VIPLevel);
                pkg.WriteBoolean(playerDetail.PlayerCharacter.Sex);
                pkg.WriteInt(playerDetail.PlayerCharacter.Hide);
                pkg.WriteString(playerDetail.PlayerCharacter.Style);
                pkg.WriteString(playerDetail.PlayerCharacter.Colors);
                pkg.WriteString(playerDetail.PlayerCharacter.Skin);
                pkg.WriteInt(playerDetail.PlayerCharacter.Grade);
                pkg.WriteInt(playerDetail.PlayerCharacter.Repute);
                if (playerDetail.MainWeapon == null)
                {
                    pkg.WriteInt(0);
                }
                else
                {
                    pkg.WriteInt(playerDetail.MainWeapon.TemplateID);
                    pkg.WriteInt(playerDetail.MainWeapon.Template.RefineryLevel);
                    pkg.WriteString(playerDetail.MainWeapon.Template.Name);
                    pkg.WriteDateTime(DateTime.MinValue);
                }
                if (playerDetail.SecondWeapon == null)
                {
                    pkg.WriteInt(0);
                }
                else
                {
                    pkg.WriteInt(playerDetail.SecondWeapon.TemplateID);
                }
                pkg.WriteInt(playerDetail.PlayerCharacter.ConsortiaID);
                pkg.WriteString(playerDetail.PlayerCharacter.ConsortiaName);
                pkg.WriteInt(playerDetail.PlayerCharacter.badgeID);
                pkg.WriteInt(playerDetail.PlayerCharacter.ConsortiaLevel);
                pkg.WriteInt(playerDetail.PlayerCharacter.ConsortiaRepute);
                pkg.WriteBoolean(val: false);
                pkg.WriteInt(0);
                pkg.WriteInt(player.Team);
                pkg.WriteInt(player.Id);
                pkg.WriteInt(player.MaxBlood);
                pkg.WriteBoolean(player.Ready);
            }
            int sessionId = game.SessionId;
            MissionInfo info = game.Misssions[sessionId];
            pkg.WriteString(info.Name);
            pkg.WriteString($"show{sessionId}.jpg");
            pkg.WriteString(info.Success);
            pkg.WriteString(info.Failure);
            pkg.WriteString(info.Description);
            pkg.WriteInt(game.TotalMissionCount);
            pkg.WriteInt(sessionId);
            gamePlayer.SendTCP(pkg);
        }

        public void SendFreeFocus(int x, int y, int type, int delay, int finishTime)
        {
            AddAction(new FocusFreeAction(x, y, type, delay, finishTime));
        }

        public Layer Createlayerboss(int x, int y, string name, string model, string defaultAction, int scale, int rotation)
        {
            Layer layer = new Layer(PhysicalId++, name, model, defaultAction, scale, rotation);
            layer.SetXY(x, y);
            AddPhysicalObj(layer, sendToClient: true);
            return layer;
        }

        public void SendGameFocus(int x, int y, int type, int delay, int finishTime)
        {
            Createlayer(x, y, "pic", "", "", 1, 0);
            SendGameObjectFocus(1, "pic", delay, finishTime);
        }

        public void SendGameObjectFocus(int type, string name, int delay, int finishTime)
        {
            Physics[] array2 = FindPhysicalObjByName(name);
            Physics[] array = array2;
            Physics[] array3 = array;
            foreach (Physics obj in array3)
            {
                AddAction(new FocusAction(obj, type, delay, finishTime));
            }
        }

        public void SendHideBlood(Living living, int hide)
        {
            SendLivingShowBlood(living, hide);
        }

        public void SendLivingActionMapping(Living liv, string source, string value)
        {
            if (liv != null)
            {
                SendLivingActionMapping(liv.Id, source, value);
            }
        }
        public void SendLivingActionMapping(PhysicalObj liv, string source, string value)
        {
            if (liv != null)
            {
                SendLivingActionMapping(liv.Id, source, value);
            }
        }

        public void SendLoadResource(List<LoadingFileInfo> loadingFileInfos)
        {
            if (loadingFileInfos == null || loadingFileInfos.Count <= 0)
            {
                return;
            }
            GSPacketIn pkg = new GSPacketIn((byte)ePackageTypeLogic.GAME_CMD);
            pkg.WriteByte((byte)eTankCmdType.LOAD_RESOURCE);
            pkg.WriteInt(loadingFileInfos.Count);
            foreach (LoadingFileInfo info in loadingFileInfos)
            {
                pkg.WriteInt(info.Type);
                pkg.WriteString(info.Path);
                pkg.WriteString(info.ClassName);
            }
            SendToAll(pkg);
        }

        public void SendMissionInfo()
        {
            if (m_missionInfo != null)
            {
                GSPacketIn pkg = new GSPacketIn((byte)ePackageTypeLogic.GAME_CMD);
                pkg.WriteByte((byte)eTankCmdType.GAME_MISSION_INFO);
                pkg.WriteInt(m_missionInfo.Id);
                pkg.WriteString(m_missionInfo.Name);
                pkg.WriteString(m_missionInfo.Success);
                pkg.WriteString(m_missionInfo.Failure);
                pkg.WriteString(m_missionInfo.Description);
                pkg.WriteString(m_missionInfo.Title);
                pkg.WriteInt(TotalMissionCount);
                pkg.WriteInt(SessionId);
                pkg.WriteInt(TotalTurn);
                pkg.WriteInt(TotalCount);
                pkg.WriteInt(Param2);
                pkg.WriteInt(Param4);
                pkg.WriteInt(WantTryAgain);
                pkg.WriteString(Pic);
                SendToAll(pkg);
            }
        }

        public void SendMissionTryAgain()
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageTypeLogic.GAME_CMD);
            pkg.WriteByte((byte)eTankCmdType.GAME_MISSION_TRY_AGAIN);
            pkg.WriteInt(WantTryAgain);
            SendToAll(pkg);
        }

        public void SendObjectFocus(Physics m_helper, int p1, int p2, int p3)
        {
            AddAction(new FocusAction(m_helper, p1, p2, p3));
        }

        public void SendPlayerInfoInGame(PVEGame game, IGamePlayer gp, Player p)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageTypeLogic.GAME_CMD)
            {
                Parameter2 = base.LifeTime
            };
            pkg.WriteByte((byte)eTankCmdType.PLAY_INFO_IN_GAME);
            pkg.WriteInt(gp.ZoneId);
            pkg.WriteInt(gp.PlayerCharacter.ID);
            pkg.WriteInt(p.Team);
            pkg.WriteInt(p.Id);
            pkg.WriteInt(p.MaxBlood);
            pkg.WriteBoolean(p.Ready);
            game.SendToAll(pkg);
        }

        public void SendPlayersPicture(Living living, int type, bool state)
        {
            method_47(living, type, state);
        }

        public void SendPlaySound(string playStr)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageTypeLogic.GAME_CMD);
            pkg.WriteByte((byte)eTankCmdType.PLAY_SOUND);
            pkg.WriteString(playStr);
            SendToAll(pkg);
        }

        internal void SendShowCards()
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageTypeLogic.GAME_CMD);
            pkg.WriteByte((byte)eTankCmdType.SHOW_CARDS);
            int val = 0;
            List<int> list = new List<int>();
            for (int i = 0; i < Cards.Length; i++)
            {
                if (Cards[i] == 0)
                {
                    list.Add(i);
                    val++;
                }
            }
            int templateID = 0;
            int count = 0;
            pkg.WriteInt(val);
            int id = m_missionInfo.Id;
            foreach (int num6 in list)
            {
                List<ItemInfo> list2 = DropInventory.CopySystemDrop(id, list.Count);
                if (list2 != null)
                {
                    foreach (ItemInfo item in list2)
                    {
                        templateID = item.TemplateID;
                        count = item.Count;
                    }
                }
                pkg.WriteByte((byte)num6);
                pkg.WriteInt(templateID);
                pkg.WriteInt(count);
            }
            SendToAll(pkg);
        }

        public void SendUpdateUiData()
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageTypeLogic.GAME_CMD);
            pkg.WriteByte(104);
            int val = 0;
            try
            {
                val = m_missionAI.UpdateUIData();
            }
            catch (Exception exception)
            {
                BaseGame.log.ErrorFormat("game ai script {0} error:{1}", "m_missionAI.UpdateUIData()", exception);
            }
            pkg.WriteInt(turnIndex);
            pkg.WriteInt(val);
            pkg.WriteInt(Param1);
            pkg.WriteInt(Param3);
            SendToAll(pkg);
        }

        public void SetupMissions(string missionIds)
        {
            if (!string.IsNullOrEmpty(missionIds))
            {
                int key = 0;
                string[] array = missionIds.Split(',');
                string[] array2 = array;
                foreach (string s in array2)
                {
                    key++;
                    MissionInfo missionInfo = MissionInfoMgr.GetMissionInfo(int.Parse(s));
                    Misssions.Add(key, missionInfo);
                }
            }
        }

        public void ShowDragonLairCard()
        {
            if (base.GameState != eGameState.ALLSessionStopped || !IsWin)
            {
                return;
            }
            foreach (Player player in GetAllFightPlayers())
            {
                if (player.IsActive && player.CanTakeOut > 0)
                {
                    //player.HasPaymentTakeCard = true;
                    int canTakeOut = player.CanTakeOut;
                    for (int i = 0; i < canTakeOut; i++)
                    {
                        TakeCard(player);
                    }
                }
            }
            SendShowCards();
        }

        public bool IsCanPrepareGameOver()
        {
            if (Map == null) return false;
            if (Map.Info == null) return false;
            if (Map.Info.ID == 1166 || m_map.Info.ID == 1207 || m_map.Info.ID == 1209 || m_map.Info.ID == 1216) return true;
            return false;
        }

        public void StartGame()
        {
            if (base.GameState != eGameState.Loading)
            {
                return;
            }
            m_gameState = eGameState.GameStart;
            SendSyncLifeTime();
            TotalKillCount = 0;
            TotalNpcGrade = 0.0;
            TotalNpcExperience = 0.0;
            TotalHurt = 0;
            m_bossCardCount = 0;
            BossCards = null;
            List<Player> allFightPlayers = GetAllFightingPlayers();
            mapPos = MapMgr.GetPVEMapRandomPos(m_map.Info.ID);
            GSPacketIn pkg = new GSPacketIn((byte)ePackageTypeLogic.GAME_CMD);
            pkg.WriteByte(99);
            pkg.WriteInt(allFightPlayers.Count);
            foreach (Player player2 in allFightPlayers)
            {
                if (!player2.IsLiving)
                {
                    AddLiving(player2);
                }
                player2.Reset();
                Point playerPoint = GetPlayerPoint(mapPos, player2.Team);
                player2.SetXY(playerPoint);
                m_map.AddPhysical(player2);
                player2.StartMoving();
                player2.StartGame();
                pkg.WriteInt(player2.Id);
                pkg.WriteInt(player2.X);
                pkg.WriteInt(player2.Y);
                if (playerPoint.X < 600)
                {
                    player2.Direction = 1;
                }
                else
                {
                    player2.Direction = -1;
                }
                pkg.WriteInt(player2.Direction);
                pkg.WriteInt(player2.Blood);
                pkg.WriteInt(player2.MaxBlood);
                pkg.WriteInt(player2.Team);
                pkg.WriteInt(player2.Weapon.RefineryLevel);
                pkg.WriteInt(50);
                pkg.WriteInt(player2.Dander);
                pkg.WriteInt(player2.PlayerDetail.FightBuffs.Count);
                foreach (BufferInfo fightBuff in player2.PlayerDetail.FightBuffs)
                {
                    pkg.WriteInt(fightBuff.Type);
                    pkg.WriteInt(fightBuff.Value);
                }
                pkg.WriteInt(0);
                pkg.WriteBoolean(player2.IsFrost);
                pkg.WriteBoolean(player2.IsHide);
                pkg.WriteBoolean(player2.IsNoHole);
                pkg.WriteBoolean(val: false);
                pkg.WriteInt(0);
            }
            pkg.WriteDateTime(DateTime.Now);
            SendToAll(pkg);
            try
            {
                m_missionAI.OnPrepareStartGame();
                //foreach (Player player in allFightPlayers)
                //{
                //	player.StartMoving();
                //	player.BoltMove(player.X, player.Y, 1000);
                //}
            }
            catch (Exception ex)
            {
                BaseGame.log.ErrorFormat("game ai script {0} error:{1}", base.GameState, ex);
            }
            SendUpdateUiData();
            WaitTime(base.PlayerCount * 2500 + 1000);
            OnGameStarted();
        }

        public void StartLoading()
        {
            if (base.GameState == eGameState.SessionPrepared)
            {
                m_gameState = eGameState.Loading;
                base.m_turnIndex = 0;
                SendMissionInfo();
                SendStartLoading(60);
                VaneLoading();
                AddAction(new WaitPlayerLoadingAction(this, 61000));
            }
        }

        public override void Stop()
        {
            if (base.GameState != eGameState.ALLSessionStopped)
            {
                return;
            }
            m_gameState = eGameState.Stopped;
            List<Player> allFightPlayers = GetAllFightPlayers();
            if (IsWin)
            {
                foreach (Player player in allFightPlayers)
                {
                    if (player.IsActive && player.CanTakeOut > 0)
                    {
                        player.HasPaymentTakeCard = true;
                        int canTakeOut = player.CanTakeOut;
                        for (int i = 0; i < canTakeOut; i++)
                        {
                            TakeCard(player);
                        }
                    }
                }
                if (base.RoomType == eRoomType.Dungeon)
                {
                    SendShowCards();
                }
                if (base.RoomType == eRoomType.Dungeon)
                {
                    foreach (Player item in allFightPlayers)
                    {
                        //Console.WriteLine("SetPvePermission");
                        item.PlayerDetail.SetPvePermission(m_info.ID, getNextHardLevel(m_hardLevel));
                    }
                }
            }
            bool nextMission = Misssions.ContainsKey(1 + SessionId);
            foreach (Player p in allFightPlayers)
            {
                p.PlayerDetail.ResetRoom(IsWin, nextMission.ToString());
            }
            lock (m_players)
            {
                m_players.Clear();
            }
            OnGameStopped();
        }
        public override void StopTimeOut()
        {
            m_gameState = eGameState.Stopped;
            List<Player> allFightPlayers = GetAllFightPlayers();
            bool nextMission = Misssions.ContainsKey(1 + SessionId);
            foreach (Player p in allFightPlayers)
            {
                p.PlayerDetail.ResetRoom(IsWin, nextMission.ToString());
            }
            lock (m_players)
            {
                m_players.Clear();
            }
            OnGameStopped();
        }

        public override bool TakeCard(Player player)
        {
            int index = 0;
            for (int i = 0; i < Cards.Length; i++)
            {
                if (Cards[i] == 0)
                {
                    index = i;
                    break;
                }
            }
            return TakeCard(player, index, isAuto: true);
        }

        public override bool TakeCard(Player player, int index, bool isAuto)
        {
            if (player.CanTakeOut == 0)
            {
                player.PlayerDetail.AddLog("PVE", "Error No. 1");
                return false;
            }
            if (!player.IsActive || index < 0 || index > Cards.Length || player.FinishTakeCard || Cards[index] > 0)
            {
                player.PlayerDetail.AddLog("PVE", "Error No. 2");
                return false;
            }
            int gold = 0;
            int money = 0;
            int giftToken = 0;
            int medal = 0;
            int honor = 0;
            int hardCurrency = 0;
            int token = 0;
            int dragonToken = 0;
            int magicStonePoint = 0;
            int templateID = 0;
            int count = 0;
            List<ItemInfo> list = null;
            int id = 0;
            id = ((TakeCardId == 0) ? m_missionInfo.Id : TakeCardId);
            if (DropInventory.CopyDrop(id, 1, ref list))
            {
                if (list != null)
                {
                    foreach (ItemInfo info in list)
                    {
                        ShopMgr.FindSpecialItemInfo(info, ref gold, ref money, ref giftToken, ref medal, ref honor, ref hardCurrency, ref token, ref dragonToken, ref magicStonePoint);
                        if (info != null && info.TemplateID > 0)
                        {
                            templateID = info.TemplateID;
                            count = info.Count;
                            player.PlayerDetail.AddTemplate(info, eBageType.TempBag, info.Count, eGameView.dungeonTypeGet);
                        }
                        if (info.IsTips)
                        {
                            player.PlayerDetail.PVERewardNotice($"[{player.PlayerDetail.ZoneName}] Chúc mừng người chơi [{player.PlayerDetail.PlayerCharacter.NickName}] tại phó bản {MissionInfo.Name} nhận được vật phẩm {info.TemplateID} x{info.Count}. ", info.ItemID, info.TemplateID);
                            player.PlayerDetail.AddLog("TakeCard PVE: ", "MissionName: " + MissionInfo.Name + "|Name: " + info.Name + "|Count: " + info.Count);
                        }
                    }
                }
                player.PlayerDetail.AddGold(gold);
                player.PlayerDetail.AddMoney(money);
                player.PlayerDetail.LogAddMoney(AddMoneyType.Award, AddMoneyType.Award_TakeCard, player.PlayerDetail.PlayerCharacter.ID, money, player.PlayerDetail.PlayerCharacter.Money);
                player.PlayerDetail.AddGiftToken(giftToken);
                player.PlayerDetail.AddHonor(honor);
                if (templateID == 0 && gold > 0)
                {
                    templateID = -100;
                    count = gold;
                }
            }
            if (base.RoomType == eRoomType.Dungeon)
            {
                player.CanTakeOut--;
                if (player.CanTakeOut == 0)
                {
                    player.FinishTakeCard = true;
                }
            }
            else
            {
                player.FinishTakeCard = true;
            }
            Cards[index] = 1;
            SendGamePlayerTakeCard(player, isAuto, index, templateID, count);
            return true;
        }

        public void SendPlayBackgroundSound(bool isPlay)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageTypeLogic.GAME_CMD);
            pkg.WriteByte(71);
            pkg.WriteBoolean(isPlay);
            base.SendToAll(pkg);
        }

        public void ChangeTarget(int id)//doi thanh mau boss
        {
            SendGameChangeTarget(id);
        }
        public void SendGameFocus(Physics p, int delay, int finishTime)
        {
            AddAction(new FocusAction(p, 1, delay, finishTime));
        }

        public void ResetForTry()
        {
            base.m_turnIndex = 0;
            foreach (Player allFightPlayer in GetAllFightPlayers())
            {
                allFightPlayer.Ready = true;
            }
            m_gameState = eGameState.TryAgain;
        }

        internal void OnTakeDamage()
        {
            try
            {
                m_missionAI.OnTakeDamage();
            }
            catch (Exception ex)
            {
                log.ErrorFormat("game ai script m_gameAI.OnTakeDamage() error:{0}", ex);
            }
        }

        internal void OnMoving()
        {
            try
            {
                m_missionAI.OnMoving();
            }
            catch (Exception ex)
            {
                log.ErrorFormat("game ai script m_gameAI.OnMoving() error:{0}", ex);
            }
        }
    }
}