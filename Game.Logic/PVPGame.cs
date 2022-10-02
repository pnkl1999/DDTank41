using Bussiness;
using Game.Base.Packets;
using Game.Logic.Actions;
using Game.Logic.Phy.Maps;
using Game.Logic.Phy.Object;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Drawing;
using System.Reflection;
using System.Text;

namespace Game.Logic
{
    public class PVPGame : BaseGame
    {
        private int BeginPlayerCount;

        private DateTime beginTime;

        private static readonly int MONEY_MIN_RATE_LOSE = int.Parse(ConfigurationManager.AppSettings["MONEY_MIN_RATE_LOSE"]);

        private static readonly int MONEY_MAX_RATE_LOSE = int.Parse(ConfigurationManager.AppSettings["MONEY_MAX_RATE_LOSE"]);

        private static readonly int MONEY_MIN_RATE_WIN = int.Parse(ConfigurationManager.AppSettings["MONEY_MIN_RATE_WIN"]);

        private static readonly int MONEY_MAX_RATE_WIN = int.Parse(ConfigurationManager.AppSettings["MONEY_MAX_RATE_WIN"]);

        private static readonly int EXP_MIN_RATE_LOSE = int.Parse(ConfigurationManager.AppSettings["EXP_MIN_RATE_LOSE"]);

        private static readonly int EXP_MAX_RATE_LOSE = int.Parse(ConfigurationManager.AppSettings["EXP_MAX_RATE_LOSE"]);

        private static readonly int EXP_MIN_RATE_WIN = int.Parse(ConfigurationManager.AppSettings["EXP_MIN_RATE_WIN"]);

        private static readonly int EXP_MAX_RATE_WIN = int.Parse(ConfigurationManager.AppSettings["EXP_MAX_RATE_WIN"]);

        private static readonly int GIFT_MIN_RATE_LOSE = int.Parse(ConfigurationManager.AppSettings["GIFT_MIN_RATE_LOSE"]);

        private static readonly int GIFT_MAX_RATE_LOSE = int.Parse(ConfigurationManager.AppSettings["GIFT_MAX_RATE_LOSE"]);

        private static readonly int GIFT_MIN_RATE_WIN = int.Parse(ConfigurationManager.AppSettings["GIFT_MIN_RATE_WIN"]);

        private static readonly int GIFT_MAX_RATE_WIN = int.Parse(ConfigurationManager.AppSettings["GIFT_MAX_RATE_WIN"]);

        private static readonly double GP_RATE = int.Parse(ConfigurationManager.AppSettings["GP_RATE"]);

        private static readonly int LeagueMoney_Lose = new Random().Next(1, int.Parse(ConfigurationManager.AppSettings["LeagueMoney_Lose"]));

        private static readonly int LeagueMoney_Win = new Random().Next(3, int.Parse(ConfigurationManager.AppSettings["LeagueMoney_Win"]));

        private new static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private float m_blueAvgLevel;

        private List<Player> m_blueTeam;

        private float m_redAvgLevel;

        private List<Player> m_redTeam;

        private string teamAStr;

        private string teamBStr;

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

        public Player CurrentPlayer => m_currentLiving as Player;

        public PVPGame(int id, int roomId, List<IGamePlayer> red, List<IGamePlayer> blue, Map map, eRoomType roomType, eGameType gameType, int timeType)
            : base(id, roomId, map, roomType, gameType, timeType)
        {
            GameProperties.Refresh();
            m_redTeam = new List<Player>();
            m_blueTeam = new List<Player>();
            StringBuilder sbTeampA = new StringBuilder();
            m_redAvgLevel = 0f;
            foreach (IGamePlayer player in red)
            {
                PlayerConfig config = new PlayerConfig();
                Player fp = new Player(player, PhysicalId++, this, 1, player.PlayerCharacter.hp);
                sbTeampA.Append(player.PlayerCharacter.ID).Append(",");
                fp.Reset();
                fp.Direction = ((m_random.Next(0, 1) == 0) ? 1 : (-1));
                fp.Config = config;
                AddPlayer(player, fp);
                m_redTeam.Add(fp);
                m_redAvgLevel += player.PlayerCharacter.Grade;
                if (!FrozenWind && player.PlayerCharacter.Grade <= 9)
                {
                    FrozenWind = true;
                }
                //tân thủ
                if (!FreeFatal && player.PlayerCharacter.Grade <= 15)
                {
                    FreeFatal = true;
                }
            }
            m_redAvgLevel /= m_redTeam.Count;
            teamAStr = sbTeampA.ToString();
            StringBuilder sbTeampB = new StringBuilder();
            m_blueAvgLevel = 0f;
            foreach (IGamePlayer player2 in blue)
            {
                PlayerConfig config = new PlayerConfig();
                Player fp = new Player(player2, PhysicalId++, this, 2, player2.PlayerCharacter.hp);
                sbTeampB.Append(player2.PlayerCharacter.ID).Append(",");
                fp.Reset();
                fp.Direction = ((m_random.Next(0, 1) == 0) ? 1 : (-1));
                fp.Config = config;
                AddPlayer(player2, fp);
                m_blueTeam.Add(fp);
                m_blueAvgLevel += player2.PlayerCharacter.Grade;
                if (!FrozenWind && player2.PlayerCharacter.Grade <= 9)
                {
                    FrozenWind = true;
                }
                //tân thủ
                if (!FreeFatal && player2.PlayerCharacter.Grade <= 15)
                {
                    FreeFatal = true;
                }
            }
            m_blueAvgLevel /= blue.Count;
            teamBStr = sbTeampB.ToString();
            BeginPlayerCount = m_redTeam.Count + m_blueTeam.Count;
            beginTime = DateTime.Now;
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
            if (player.CanTakeOut == 0 || index < 0 || index > Cards.Length || player.FinishTakeCard || Cards[index] > 0)
            {
                return false;
            }
            player.CanTakeOut--;
            int templateID = 0;
            int count = 0;
            List<ItemInfo> infos = null;
            if (DropInventory.CardDrop(base.RoomType, ref infos))
            {
                if (infos != null)
                {
                    foreach (ItemInfo info in infos)
                    {
                        if (info != null && info.TemplateID > 0)
                        {
                            templateID = info.TemplateID;
                            count = info.Count;
                            player.PlayerDetail.AddTemplate(info, eBageType.TempBag, info.Count, eGameView.BatleTypeGet);
                        }
                        if (!info.IsTips)
                        {
                        }
                    }
                    if (infos.Count == 0)
                    {
                        log.ErrorFormat("Have not DropItem for RoomType.{0}", base.RoomType);
                    }
                }
            }
            else
            {
                log.ErrorFormat("Have not DropCondition for RoomType.{0}", base.RoomType);
            }
            if (player.CanTakeOut == 0)
            {
                player.FinishTakeCard = true;
            }
            Cards[index] = 1;
            SendGamePlayerTakeCard(player, isAuto, index, templateID, count);
            return true;
        }

        private int CalculateExperience(Player player, int winTeam, ref int reward, ref int rewardServer)
        {
            if (m_roomType == eRoomType.Match)
            {
                float avgLevel = player.Team == 1 ? m_blueAvgLevel : m_redAvgLevel;
                float teamCount = player.Team == 1 ? m_blueTeam.Count : m_redTeam.Count;
                Math.Abs(avgLevel - player.PlayerDetail.PlayerCharacter.Grade);
                if (player.TotalHurt == 0)
                {
                    if (avgLevel - (float)player.PlayerDetail.PlayerCharacter.Grade >= 5f && TotalHurt > 0)
                    {
                        SendMessage(player.PlayerDetail, LanguageMgr.GetTranslation("GetGPreward"), null, 2);
                        reward = 200;
                        return 201;
                    }
                    return 1;
                }
                float isWin = player.Team == winTeam ? 2f : 0.0f;
                player.TotalShootCount = player.TotalShootCount == 0 ? 1 : player.TotalShootCount;
                if (player.TotalShootCount < player.TotalHitTargetCount)
                {
                    player.TotalShootCount = player.TotalHitTargetCount;
                }
                int maxHurt = (int)((player.Team == 1) ? ((float)m_blueTeam.Count * m_blueAvgLevel * 300f) : (m_redAvgLevel * (float)m_redTeam.Count * 300f));
                int totalHurt = ((player.TotalHurt > maxHurt) ? maxHurt : player.TotalHurt);
                int gp = (int)Math.Ceiling(((double)isWin + (double)totalHurt * 0.001 + (double)player.TotalKill * 0.5 + (double)(player.TotalHitTargetCount / player.TotalShootCount * 2)) * (double)avgLevel * (0.9 + (double)(teamCount - 1f) * 0.3));
                if (avgLevel - (float)player.PlayerDetail.PlayerCharacter.Grade >= 5f && TotalHurt > 0)
                {
                    SendMessage(player.PlayerDetail, LanguageMgr.GetTranslation("GetGPreward"), null, 2);
                    reward = 200;
                    gp += 200;
                }
                gp = GainCoupleGP(player, gp);
                if (Convert.ToBoolean(ConfigurationManager.AppSettings["DoubleEvent"]))
                {
                    gp *= 2;
                    rewardServer = gp / 2;
                }
                if (gp > 12000)
                {
                    log.Error($"pvpgame ====== player.nickname : {player.PlayerDetail.PlayerCharacter.NickName}, add gp : {gp} ======== gp > 10000");
                    log.Error($"pvpgame ====== player.nickname : {player.PlayerDetail.PlayerCharacter.NickName}, parameters winPlus: {isWin}, totalHurt : {player.TotalHurt}, totalKill : {player.TotalKill}, totalHitTargetCount : {player.TotalHitTargetCount}, totalShootCount : {player.TotalShootCount}, againstTeamLevel : {avgLevel}, againstTeamCount : {teamCount}");
                    gp = 12000;
                }
                return (gp < 1) ? 1 : gp;
            }
            return 0;
        }

        private int CalculateGuildMatchResult(List<Player> players, int winTeam)
        {
            if (RoomType == eRoomType.Match)
            {
                StringBuilder winStr = new StringBuilder(LanguageMgr.GetTranslation("Game.Server.SceneGames.OnStopping.Msg5"));
                StringBuilder loseStr = new StringBuilder(LanguageMgr.GetTranslation("Game.Server.SceneGames.OnStopping.Msg5"));

                IGamePlayer winPlayer = null;
                IGamePlayer losePlayer = null;
                int count = 0;

                foreach (Player p in players)
                {
                    if (p.Team == winTeam)
                    {
                        winStr.Append(string.Format("[{0}]", p.PlayerDetail.PlayerCharacter.NickName));
                        winPlayer = p.PlayerDetail;
                    }
                    else
                    {
                        loseStr.Append(string.Format("{0}", p.PlayerDetail.PlayerCharacter.NickName));
                        losePlayer = p.PlayerDetail;
                        count++;
                    }
                }
                if (losePlayer != null)
                {
                    winStr.Append(LanguageMgr.GetTranslation("Game.Server.SceneGames.OnStopping.Msg1") + losePlayer.PlayerCharacter.ConsortiaName + LanguageMgr.GetTranslation("Game.Server.SceneGames.OnStopping.Msg2"));
                    loseStr.Append(LanguageMgr.GetTranslation("Game.Server.SceneGames.OnStopping.Msg3") + winPlayer.PlayerCharacter.ConsortiaName + LanguageMgr.GetTranslation("Game.Server.SceneGames.OnStopping.Msg4"));

                    int riches = 0;
                    if (GameType == eGameType.Guild)
                    {
                        riches = count + TotalHurt / 2000;
                    }
                    winPlayer.ConsortiaFight(winPlayer.PlayerCharacter.ConsortiaID, losePlayer.PlayerCharacter.ConsortiaID, Players, RoomType, GameType, TotalHurt, players.Count);
                    if (winPlayer.ServerID != losePlayer.ServerID)
                        losePlayer.ConsortiaFight(winPlayer.PlayerCharacter.ConsortiaID, losePlayer.PlayerCharacter.ConsortiaID, Players, RoomType, GameType, TotalHurt, players.Count);
                    if (GameType == eGameType.Guild)
                    {
                        winPlayer.SendConsortiaFight(winPlayer.PlayerCharacter.ConsortiaID, riches, winStr.ToString());
                        //losePlayer.SendConsortiaFight(losePlayer.PlayerCharacter.ConsortiaID, -riches, loseStr.ToString());
                    }
                    return riches;
                }

            }
            return 0;
        }

        public bool CanGameOver()
        {
            bool red = true;
            bool blue = true;
            foreach (Player item in m_redTeam)
            {
                if (item.IsLiving)
                {
                    red = false;
                    break;
                }
            }
            foreach (Player item2 in m_blueTeam)
            {
                if (item2.IsLiving)
                {
                    blue = false;
                    break;
                }
            }
            return red || blue;
        }

        public override void CheckState(int delay)
        {
            AddAction(new CheckPVPGameStateAction(delay));
        }

        public void GameOver()
        {
            if (base.GameState != eGameState.Playing)
            {
                return;
            }
            m_gameState = eGameState.GameOver;
            ClearWaitTimer();
            CurrentTurnTotalDamage = 0;
            List<Player> players = GetAllFightPlayers();
            int winTeam = -1;
            int canBlueTakeOut = 0;
            int canRedTakeOut = 0;
            foreach (Player p in players)
            {
                if (p.IsLiving)
                {
                    winTeam = p.Team;
                    break;
                }
            }
            foreach (Player p in players)
            {
                if (p.TotalHurt > 0)
                {
                    if (p.Team == 1)
                    {
                        canRedTakeOut = 1;
                    }
                    else
                    {
                        canBlueTakeOut = 1;
                    }
                }
            }
            if (winTeam == -1 && CurrentPlayer != null)
            {
                winTeam = CurrentPlayer.Team;
            }
            int riches = CalculateGuildMatchResult(players, winTeam);
            if (base.RoomType == eRoomType.Match && base.GameType == eGameType.Guild)
            {
                int losebaseoffer = -10;
                _ = players.Count / 2;
                _ = losebaseoffer + (int)Math.Round((double)(players.Count / 2) * 0.5);
            }
            GSPacketIn pkg = new GSPacketIn((short)ePackageTypeLogic.GAME_CMD);
            pkg.WriteByte((byte)eTankCmdType.GAME_OVER);
            pkg.WriteInt(base.PlayerCount);
            int beginPlayerCount = BeginPlayerCount;
            foreach (Player p in players)
            {
                double num8 = ((p.Team == 1) ? ((double)m_blueAvgLevel) : ((double)m_redAvgLevel));
                if (p.Team != 1)
                {
                    int count1 = m_redTeam.Count;
                }
                else
                {
                    int count2 = m_blueTeam.Count;
                }
                double grade1 = p.PlayerDetail.PlayerCharacter.Grade;
                float num9 = Math.Abs((float)(num8 - grade1));
                int team = p.Team;
                int num11 = 0;
                int val1 = 0;
                int reward = 0;
                int rewardServer = 0;
                if (p.TotalShootCount != 0)
                {
                    int totalShootCount = p.TotalShootCount;
                }
                if (m_roomType == eRoomType.Match || (double)num9 < 5.0)
                {
                    val1 = CalculateOffer(p, winTeam);
                    num11 = CalculateExperience(p, winTeam, ref reward, ref rewardServer);
                }
                if (p.FightBuffers.ConsortionAddPercentGoldOrGP > 0)
                {
                    num11 += num11 * p.FightBuffers.ConsortionAddPercentGoldOrGP / 100;
                }
                if (p.FightBuffers.ConsortionAddOfferRate > 0)
                {
                    riches *= p.FightBuffers.ConsortionAddOfferRate;
                }
                double num2 = Math.Ceiling((double)num11 * p.PlayerDetail.GPApprenticeOnline);
                double num3 = Math.Ceiling((double)num11 * p.PlayerDetail.GPApprenticeTeam);
                double GPSTeam = Math.Ceiling((double)num11 * p.PlayerDetail.GPSpouseTeam);
                int num4 = ((num11 == 0) ? 1 : num11);
                string msg = "";
                bool isWin = p.Team == winTeam;
                if (base.RoomType == eRoomType.Match)
                {
                    int moneyPVP = 0;
                    int expPVP = 0;
                    int giftPVP = 0;
                    int timex2 = 1;
                    Random random = new Random();
                    DateTime GoldTimeStart = Convert.ToDateTime("19:30:00");
                    DateTime GoldTimeEnd = Convert.ToDateTime("21:30:00");
                    DateTime GoldTimeStart1 = Convert.ToDateTime("12:30:00");
                    DateTime GoldTimeEnd1 = Convert.ToDateTime("14:30:00");
                    DateTime GoldTimeStart2 = Convert.ToDateTime("23:30:00");
                    DateTime GoldTimeEnd2 = Convert.ToDateTime("03:30:00");
                    GoldTimeStart = Convert.ToDateTime(GameProperties.GoldTimeStart.Split('|')[0]);
                    GoldTimeStart1 = Convert.ToDateTime(GameProperties.GoldTimeStart.Split('|')[1]);
                    GoldTimeStart2 = Convert.ToDateTime(GameProperties.GoldTimeStart.Split('|')[2]);
                    GoldTimeEnd = Convert.ToDateTime(GameProperties.GoldTimeEnd.Split('|')[0]);
                    GoldTimeEnd1 = Convert.ToDateTime(GameProperties.GoldTimeEnd.Split('|')[1]);
                    GoldTimeEnd2 = Convert.ToDateTime(GameProperties.GoldTimeEnd.Split('|')[2]);
                    if (p.TotalHurt > 0)
                    {
                        p.PlayerDetail.AddPrestige(isWin, RoomType);
                        if (DateTime.Now >= GoldTimeStart && DateTime.Now <= GoldTimeEnd)
                        {
                            timex2 = GameProperties.TimeX2;
                            p.PlayerDetail.SendHideMessage($"Bạn đang thi đấu trong khung giờ vàng nên nhận được x{timex2} Xu & Exp!");
                        }
                        if (DateTime.Now >= GoldTimeStart1 && DateTime.Now <= GoldTimeEnd1)
                        {
                            timex2 = GameProperties.TimeX2;
                            p.PlayerDetail.SendHideMessage($"Bạn đang thi đấu trong khung giờ vàng nên nhận được x{timex2} Xu & Exp!");
                        }
                        if (DateTime.Now >= GoldTimeStart2 && DateTime.Now <= GoldTimeEnd2)
                        {
                            timex2 = GameProperties.TimeX2;
                            p.PlayerDetail.SendHideMessage($"Bạn đang thi đấu trong khung giờ vàng nên nhận được x{timex2} Xu & Exp!");
                        }
                        if (isWin)
                        {
                            if (base.GameType == eGameType.Guild)
                            {
                                moneyPVP = (random.Next(MONEY_MIN_RATE_WIN, MONEY_MAX_RATE_WIN) * timex2) + random.Next(30, 35);
                                expPVP = (random.Next(EXP_MIN_RATE_WIN, EXP_MAX_RATE_WIN) * timex2) + random.Next(50, 55);
                                giftPVP = random.Next(GIFT_MIN_RATE_WIN, GIFT_MAX_RATE_WIN) * 2;
                            }
                            else
                            {
                                moneyPVP = random.Next(MONEY_MIN_RATE_WIN, MONEY_MAX_RATE_WIN) * timex2;
                                expPVP = random.Next(EXP_MIN_RATE_WIN, EXP_MAX_RATE_WIN) * timex2;
                                giftPVP = random.Next(GIFT_MIN_RATE_WIN, GIFT_MAX_RATE_WIN);
                            }
                        }
                        else
                        {
                            if (base.GameType == eGameType.Guild)
                            {
                                moneyPVP = (random.Next(MONEY_MIN_RATE_LOSE, MONEY_MAX_RATE_LOSE) * timex2) + random.Next(30, 35);
                                expPVP = (random.Next(EXP_MIN_RATE_LOSE, EXP_MAX_RATE_LOSE) * timex2) + random.Next(50, 55);
                                giftPVP = random.Next(GIFT_MIN_RATE_LOSE, GIFT_MAX_RATE_LOSE) * 2;
                            }
                            else
                            {
                                moneyPVP = random.Next(MONEY_MIN_RATE_LOSE, MONEY_MAX_RATE_LOSE) * timex2;
                                expPVP = random.Next(EXP_MIN_RATE_LOSE, EXP_MAX_RATE_LOSE) * timex2;
                                giftPVP = random.Next(GIFT_MIN_RATE_LOSE, GIFT_MAX_RATE_LOSE);
                            }
                        }
                        p.PlayerDetail.AddMoney(moneyPVP, igroneAll: false);
                        p.PlayerDetail.AddGiftToken(giftPVP);
                        string noticePVP = string.Format("Bạn nhận được {0} xu, {2} lễ kim & {1} exp khi chiến đấu.", new object[3]
                        {
                            moneyPVP,
                            expPVP,
                            giftPVP
                        });
                        p.PlayerDetail.SendHideMessage(noticePVP);
                    }
                    else
                    {
                        p.PlayerDetail.SendMessage("Không có sát thương, không nhận được thưởng.");
                    }
                    num4 += expPVP;
                    if (msg != "" && msg != null)
                    {
                        p.PlayerDetail.SendHideMessage(msg);
                    }
                    if (base.GameType == eGameType.Guild)
                    {
                        new ConsortiaBussiness().ConsortiaRichAdd(p.PlayerDetail.PlayerCharacter.ConsortiaID, ref riches);
                    }
                    int restCount = p.PlayerDetail.MatchInfo.restCount;
                    int maxCount = p.PlayerDetail.MatchInfo.maxCount;
                    int grade2 = p.PlayerDetail.PlayerCharacter.Grade;
                }
                if (p.PlayerDetail.PlayerCharacter.typeVIP > 0)
                {
                    num4 += 10;
                    val1++;
                }
                p.GainGP = p.PlayerDetail.AddGP(num4);
                p.GainOffer = p.PlayerDetail.AddOffer(val1);
                p.CanTakeOut = ((p.Team == 1) ? canRedTakeOut : canBlueTakeOut);
                pkg.WriteInt(p.Id);
                pkg.WriteBoolean(isWin);
                pkg.WriteInt(p.PlayerDetail.PlayerCharacter.Grade);
                pkg.WriteInt(p.PlayerDetail.PlayerCharacter.GP);
                pkg.WriteInt(p.TotalKill);
                pkg.WriteInt(num4);
                pkg.WriteInt(p.TotalHitTargetCount);
                pkg.WriteInt(p.psychic);
                pkg.WriteInt((p.PlayerDetail.PlayerCharacter.typeVIP > 0) ? 10 : 0);
                pkg.WriteInt(0);
                pkg.WriteInt((int)GPSTeam);
                pkg.WriteInt(rewardServer);
                pkg.WriteInt((int)num2);
                pkg.WriteInt((int)num3);
                pkg.WriteInt(0);
                pkg.WriteInt(reward);
                pkg.WriteInt(0);
                pkg.WriteInt(rewardServer);
                pkg.WriteInt(p.GainGP);
                pkg.WriteInt(val1);
                pkg.WriteInt(0);
                pkg.WriteInt((p.PlayerDetail.PlayerCharacter.typeVIP > 0) ? 1 : 0);
                pkg.WriteInt(0);
                pkg.WriteInt(0);
                pkg.WriteInt(0);
                pkg.WriteInt(rewardServer);
                pkg.WriteInt(p.GainOffer);
                pkg.WriteInt(p.CanTakeOut);
            }
            pkg.WriteInt(riches);
            SendToAll(pkg);
            StringBuilder stringBuilder = new StringBuilder();
            foreach (Player player in players)
            {
                player.PlayerDetail.OnGameOver(this, player.Team == winTeam, player.GainGP, isSpanArea: false, player.PlayerDetail.GPSpouseTeam > 0.0, player.Blood, BeginPlayerCount);
            }
            OnGameOverLog(base.RoomId, base.RoomType, base.GameType, 0, beginTime, DateTime.Now, BeginPlayerCount, base.Map.Info.ID, teamAStr, teamBStr, "", winTeam, BossWarField);
            WaitTime(20000);
            OnGameOverred();
        }

        private int CalculateOffer(Player player, int winTeam)
        {
            if (base.RoomType != 0)
            {
                return 0;
            }
            int appendOffer = 0;
            if (base.GameType == eGameType.Guild)
            {
                int againstTeamCount = ((player.Team == 1) ? m_blueTeam.Count : m_redTeam.Count);
                appendOffer = ((player.Team != winTeam) ? ((int)((double)againstTeamCount * 0.5)) : againstTeamCount);
            }
            int baseOffer = player.GainOffer;
            int offer = (int)(double)((float)baseOffer + (float)appendOffer);
            offer -= player.KilledPunishmentOffer;
            if (Convert.ToBoolean(ConfigurationManager.AppSettings["DoubleEvent"]))
            {
                offer *= 2;
            }
            if (offer > 1000)
            {
                log.Error($"pvegame ====== player.nickname : {player.PlayerDetail.PlayerCharacter.NickName}, add offer : {offer} ======== offer > 1000");
                log.Error($"pvegame ====== player.nickname : {player.PlayerDetail.PlayerCharacter.NickName}, parameters RoomType : {base.RoomType}, baseOffer : {baseOffer}, appendOffer : {appendOffer}");
            }
            return offer;
        }

        public void NextTurn()
        {
            if (base.GameState != eGameState.Playing)
            {
                return;
            }
            ClearWaitTimer();
            ClearDiedPhysicals();
            CheckBox();
            base.m_turnIndex++;
            List<Box> newBoxes = CreateBox();
            foreach (Physics item in m_map.GetAllPhysicalSafe())
            {
                item.PrepareNewTurn();
            }
            LastTurnLiving = m_currentLiving;
            m_currentLiving = FindNextTurnedLiving();
            if (m_currentLiving.VaneOpen)
            {
                UpdateWind(GetNextWind(), sendToClient: false);
            }
            if (m_currentLiving is Player && (m_currentLiving as Player).PlayerDetail.PlayerCharacter.NickName == ContinuousRunningPlayer)
            {
                foreach (Player allFightPlayer in GetAllFightPlayers())
                {
                    allFightPlayer.PlayerDetail.SendMessage($"Người chơi {ContinuousRunningPlayer} nhận được thêm 1 lần tấn công");
                }
            }
            MinusDelays(m_currentLiving.Delay);
            m_currentLiving.PrepareSelfTurn();
            if (!base.CurrentLiving.IsFrost && m_currentLiving.IsLiving)
            {
                m_currentLiving.StartAttacking();
                SendGameNextTurn(m_currentLiving, this, newBoxes);
                if (m_currentLiving.IsAttacking)
                {
                    AddAction(new WaitLivingAttackingAction(m_currentLiving, base.m_turnIndex, (m_timeType + 20) * 1000));
                }
            }
            //if (m_currentLiving is Player && FindNextTurnedLiving(true) is Player)
            //{
            //	ContinuousRunningPlayer = (m_currentLiving as Player).PlayerDetail.PlayerCharacter.NickName;
            //}
            ContinuousRunningPlayer = (m_currentLiving as Player).PlayerDetail.PlayerCharacter.NickName;
            OnBeginNewTurn();
        }

        public void Prepare()
        {
            if (base.GameState == eGameState.Inited)
            {
                SendCreateGame();
                m_gameState = eGameState.Prepared;
                CheckState(0);
            }
        }

        public override Player RemovePlayer(IGamePlayer gp, bool IsKick)
        {
            Player player = base.RemovePlayer(gp, IsKick);
            if (player != null && player.IsLiving && base.GameState != eGameState.Loading)
            {
                gp.RemoveGP(gp.PlayerCharacter.Grade * 12);
                string msg = null;
                string translation = null;
                if (base.RoomType == eRoomType.Match)
                {
                    if (base.GameType == eGameType.Guild)
                    {
                        msg = LanguageMgr.GetTranslation("AbstractPacketLib.SendGamePlayerLeave.Msg6", gp.PlayerCharacter.Grade * 12, 15);
                        gp.RemoveOffer(15);
                        translation = LanguageMgr.GetTranslation("AbstractPacketLib.SendGamePlayerLeave.Msg7", gp.PlayerCharacter.NickName, gp.PlayerCharacter.Grade * 12, 15);
                    }
                    else if (base.GameType == eGameType.Free)
                    {
                        msg = LanguageMgr.GetTranslation("AbstractPacketLib.SendGamePlayerLeave.Msg6", gp.PlayerCharacter.Grade * 12, 5);
                        gp.RemoveOffer(5);
                        translation = LanguageMgr.GetTranslation("AbstractPacketLib.SendGamePlayerLeave.Msg7", gp.PlayerCharacter.NickName, gp.PlayerCharacter.Grade * 12, 5);
                    }
                }
                else
                {
                    msg = LanguageMgr.GetTranslation("AbstractPacketLib.SendGamePlayerLeave.Msg4", gp.PlayerCharacter.Grade * 12);
                    translation = LanguageMgr.GetTranslation("AbstractPacketLib.SendGamePlayerLeave.Msg5", gp.PlayerCharacter.NickName, gp.PlayerCharacter.Grade * 12);
                }
                SendMessage(gp, msg, translation, 3);
                if (GetSameTeam())
                {
                    base.CurrentLiving.StopAttacking();
                    CheckState(0);
                }
            }
            return player;
        }

        private int Load_Kill_Suit(int userid)
        {
            List<int> allkill = new List<int>();
            using (PlayerBussiness A = new PlayerBussiness())
            {
                try
                {
                    Suit_Manager S = new Suit_Manager();
                    S = A.Get_Suit_Manager(userid);
                    if (S.UserID > 0)
                    {
                        string chuoi = S.Kill_List;
                        if (chuoi.Length > 2)
                        {
                            while (chuoi.Contains(","))
                            {
                                int kq2 = 0;
                                int.TryParse(chuoi.Substring(0, chuoi.IndexOf(",")), out kq2);
                                if (kq2 == 0)
                                {
                                    break;
                                }
                                allkill.Add(kq2);
                                chuoi = chuoi.Remove(0, chuoi.IndexOf(",") + 1);
                            }
                            if (!chuoi.Contains(","))
                            {
                                int kq = 0;
                                int.TryParse(chuoi, out kq);
                                if (kq > 0)
                                {
                                    allkill.Add(kq);
                                }
                            }
                        }
                    }
                }
                catch
                {
                }
            }
            if (allkill.Count > 0)
            {
                List<int> B = allkill;
                int kill = 0;
                using (List<int>.Enumerator enumerator = B.GetEnumerator())
                {
                    while (enumerator.MoveNext())
                    {
                        switch (enumerator.Current)
                        {
                            case 1010807:
                                kill += 5;
                                break;
                            case 1010808:
                                kill += 5;
                                break;
                            case 1010812:
                                kill++;
                                break;
                            case 1010814:
                                kill++;
                                break;
                            case 1010813:
                                kill += 2;
                                break;
                            case 1010815:
                                kill += 2;
                                break;
                            case 1010816:
                                kill += 2;
                                break;
                            case 1010822:
                                kill += 2;
                                break;
                            case 1010809:
                                kill += 5;
                                break;
                        }
                    }
                }
                return kill;
            }
            return 0;
        }

        public void StartGame()
        {
            if (base.GameState != eGameState.Loading)
            {
                return;
            }
            m_gameState = eGameState.Playing;
            ClearWaitTimer();
            SendSyncLifeTime();
            List<Player> allFightPlayers = GetAllFightingPlayers();
            MapPoint mapRandomPos = MapMgr.GetMapRandomPos(m_map.Info.ID);
            //GSPacketIn pkg2 = new GSPacketIn(3);
            //pkg2.WriteInt(2);
            //pkg2.WriteString($"Kết hợp trận đấu thành công.");
            //SendToAll(pkg2, null);
            GSPacketIn pkg = new GSPacketIn(91);
            pkg.WriteByte(99);
            pkg.WriteInt(allFightPlayers.Count);
            foreach (Player player in allFightPlayers)
            {
                int kill = Load_Kill_Suit(player.PlayerDetail.PlayerCharacter.ID);
                if (kill > 0)
                {
                    GSPacketIn pkg3 = new GSPacketIn(3);
                    pkg3.WriteInt(2);
                    pkg3.WriteString($"Trang bị VIP giúp [{player.PlayerDetail.PlayerCharacter.NickName}] giảm thương thêm {kill}%");
                    SendToAll(pkg3, null);
                }
                player.Reset();
                Point playerPoint = GetPlayerPoint(mapRandomPos, player.Team);
                player.SetXY(playerPoint);
                m_map.AddPhysical(player);
                player.StartMoving();
                player.StartGame();
                pkg.WriteInt(player.Id);
                pkg.WriteInt(player.X);
                pkg.WriteInt(player.Y);
                pkg.WriteInt(player.Direction);
                pkg.WriteInt(player.Blood);
                pkg.WriteInt(player.MaxBlood);
                pkg.WriteInt(player.Team);
                pkg.WriteInt(player.Weapon.RefineryLevel);
                pkg.WriteInt(50);
                pkg.WriteInt(player.Dander);
                pkg.WriteInt(player.PlayerDetail.FightBuffs.Count);
                foreach (BufferInfo fightBuff in player.PlayerDetail.FightBuffs)
                {
                    pkg.WriteInt(fightBuff.Type);
                    pkg.WriteInt(fightBuff.Value);
                }
                pkg.WriteInt(0);
                pkg.WriteBoolean(player.IsFrost);
                pkg.WriteBoolean(player.IsHide);
                pkg.WriteBoolean(player.IsNoHole);
                pkg.WriteBoolean(val: false);
                pkg.WriteInt(0);
            }
            pkg.WriteDateTime(DateTime.Now);
            SendToAll(pkg);
            foreach (Player p in allFightPlayers)
            {
                if (p.PlayerDetail.IsViewer)
                {
                    p.Die();
                }
            }
            VaneLoading();
            WaitTime(allFightPlayers.Count * 1000);
            OnGameStarted();
        }

        public void StartLoading()
        {
            if (base.GameState == eGameState.Prepared)
            {
                ClearWaitTimer();
                SendStartLoading(60);
                VaneLoading();
                AddAction(new WaitPlayerLoadingAction(this, 61000));
                m_gameState = eGameState.Loading;
            }
        }

        public override void Stop()
        {
            if (base.GameState != eGameState.GameOver)
            {
                return;
            }
            m_gameState = eGameState.Stopped;
            List<Player> players = GetAllFightPlayers();
            foreach (Player p in players)
            {
                if (p.IsActive && !p.FinishTakeCard && p.CanTakeOut > 0)
                {
                    TakeCard(p);
                }
            }
            lock (m_players)
            {
                m_players.Clear();
            }
            base.Stop();
        }
    }
}
