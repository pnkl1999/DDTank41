using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using Game.Logic.Actions;
using Bussiness;
using Game.Server.Rooms;
using SqlDataProvider.Data;
using Bussiness.Managers;
using System.Drawing;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class InsectTwo : AMissionControl
    {
        private SimpleBoss boss = null;
        private int bossID = 71009;
        private List<SimpleNpc> someNpc = new List<SimpleNpc>();
        private int npcID1 = 71006;
        private int npcID2 = 71007;
        private int npcID3 = 71008;
        private int kill = 0;
        private int limitTurn = 5;
        private Point[] brithPoint = {   new Point(180, 147), new Point(375, 117), new Point(105, 242), new Point(277, 234), new Point(155, 338),
                                         new Point(313, 356), new Point(426, 295), new Point(517, 149), new Point(543, 268), new Point(291, 468),
                                         new Point(152, 500), new Point(419, 572), new Point(507, 441), new Point(508, 342), new Point(631, 514),
                                         new Point(809, 605), new Point(707, 392), new Point(684, 271), new Point(697, 111), new Point(833, 126),
                                         new Point(810, 263), new Point(875, 370), new Point(874, 485), new Point(1054, 483),new Point(944, 192),
                                         new Point(1000, 297), new Point(1088, 360), new Point(1246, 325), new Point(1127, 171), new Point(987, 564) };
        public override int CalculateScoreGrade(int score)
        {
            base.CalculateScoreGrade(score);
            if (score > 1750)
            {
                return 3;
            }
            else if (score > 1675)
            {
                return 2;
            }
            else if (score > 1600)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }

        public override void OnPrepareNewSession()
        {
            base.OnPrepareNewSession();
            int[] resources = { bossID, npcID1, npcID2, npcID3 };
            int[] gameOverResource = { bossID, npcID1, npcID2, npcID3 };
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(gameOverResource);
            Game.AddLoadingFile(1, "bombs/128.swf", "tank.resource.bombs.Bomb128");
            Game.AddLoadingFile(1, "bombs/129.swf", "tank.resource.bombs.Bomb129");
            Game.SetMap(70003);
        }

        public override void OnStartGame()
        {
            base.OnStartGame();
            Player[] players = Game.GetAllPlayers();
            int[] props = new int[] { 10615, 10616 };
            foreach (Player p in players)
            {
                for (int i = 0; i < props.Length; i++)
                {
                    ItemTemplateInfo info = ItemMgr.FindItemTemplate(props[i]);
                    ItemInfo item = ItemInfo.CreateFromTemplate(info, 1, 101);
                    p.PlayerDetail.AddTemplate(item, eBageType.FightBag, 1, eGameView.OtherTypeGet);
                }
                if (p.BatleConfig.CakeStatus)
                {
                    LivingConfig config = Game.BaseConfig();
                    config.IsInsectBoss = true;
                    config.KeepLife = true;
                    boss = Game.CreateBoss(bossID, 1184, 645, -1, (int)eLivingType.SimpleBoss1, "", config);
                    boss.SetRelateDemagemRect(boss.NpcInfo.X, boss.NpcInfo.Y, boss.NpcInfo.Width, boss.NpcInfo.Height);
                    break;
                }
            }
            int num = 0;
            LivingConfig configNpc = Game.BaseConfig();
            configNpc.IsInsectNpc = true;
            configNpc.IsFly = true;
            configNpc.isShowBlood = false;
            foreach (Point p in brithPoint)
            {
                if (num < 10)
                {
                    someNpc.Add(Game.CreateNpc(npcID1, p.X, p.Y, 1, -1, configNpc));
                }
                else if (num < 20)
                {
                    someNpc.Add(Game.CreateNpc(npcID2, p.X, p.Y, 1, -1, configNpc));
                }
                else
                {
                    someNpc.Add(Game.CreateNpc(npcID3, p.X, p.Y, 1, -1, configNpc));
                }
                num++;
            }
        }

        public override void OnNewTurnStarted()
        {
            base.OnNewTurnStarted();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
        }

        public override bool CanGameOver()
        {
            Player[] players = Game.GetAllPlayers();
            foreach (Player p in players)
            {
                if (p.TurnNum >= limitTurn)
                //if (Game.TurnIndex >= limitTurn)
                {
                    return true;
                }
            }
            kill = 0;
            foreach (SimpleNpc npc in someNpc)
            {
                if (!npc.IsLiving)
                {
                    kill++;
                }
            }
            return false;
        }

        public override int UpdateUIData()
        {
            base.UpdateUIData();
            return kill;
        }
        public override void OnTakeDamage()
        {
            base.OnTakeDamage();
            boss.PlayMovie("dieB", 2000, 3000);
            boss.CallFuction(Catching, 4500);
        }
        private void Catching()
        {
            if (boss.Blood < 10000)
            {
                boss.CallFuction(AddScore, 500);
                //Console.WriteLine("AddScore {0}", boss.Blood);
            }
            else
            {
                boss.PlayMovie("dieC", 500, 1000);
                boss.CallFuction(Escape, 1500);
                //Console.WriteLine("Escape {0}", boss.Blood);
            }
        }
        private void AddScore()
        {
            RemoveBoss();
            Player[] players = Game.GetAllPlayers();
            foreach (Player p in players)
            {
                p.PlayerDetail.SendMessage(LanguageMgr.GetTranslation("CatchInsect.AddScore", 120));
                p.PlayerDetail.AddSummerScore(120);
            }
        }
        private void Escape()
        {
            boss.PlayMovie("dieD", 0, 2500);
            boss.CallFuction(RemoveBoss, 3000);
        }
        private void RemoveBoss()
        {
            Game.RemoveLiving(boss.Id);
            boss = null;
        }
        public override void OnGameOver()
        {
            base.OnGameOver();
            Game.IsWin = true;
        }
    }
}