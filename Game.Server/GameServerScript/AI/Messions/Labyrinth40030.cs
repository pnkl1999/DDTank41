using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using Bussiness.Managers;
using SqlDataProvider.Data;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class Labyrinth40030 : AMissionControl
    {
        private int bossID = 40041;
        private int bossID2 = 40042;
        private int bossID3 = 40038;
        private int npcIDl = 40048;
        private int npcIDr = 40047;
        private int npcID2 = 40049;
        private int npcID3 = 40050;
        private SimpleBoss boss;
        private SimpleBoss boss2;
        private SimpleBoss boss3;
        private int kill = 0;
        private int m_state = 40041;
        private int turn = 0;
        public override int CalculateScoreGrade(int score)
        {
            base.CalculateScoreGrade(score);
            if (score > 1870)
            {
                return 3;
            }
            else if (score > 1825)
            {
                return 2;
            }
            else if (score > 1780)
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
            int[] resources = { bossID, bossID2, bossID3, npcIDl, npcIDr, npcID2, npcID3 };
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(resources);
            Game.AddLoadingFile(2, "image/bomb/blastOut/blastOut51.swf", "bullet51");
            Game.AddLoadingFile(2, "image/bomb/bullet/bullet51.swf", "bullet51");
            Game.SetMap(1280);
        }

        public override void OnStartGame()
        {
            base.OnStartGame();
            LivingConfig config = Game.BaseConfig();
            config.IsFly = true;
            boss = Game.CreateBoss(bossID, 1316, 444, -1, 1, "", config);
            boss.SetRelateDemagemRect(boss.NpcInfo.X, boss.NpcInfo.Y, boss.NpcInfo.Width, boss.NpcInfo.Height);
        }

        public override void OnNewTurnStarted()
        {
        }
        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();            
        }

        public override bool CanGameOver()
        {
            if (Game.TurnIndex > Game.MissionInfo.TotalTurn - 1)
            {
                return true;
            }           

            if (!boss.IsLiving && boss2 == null)
            {
                LivingConfig config = Game.BaseConfig();
                config.IsFly = true;
                boss2 = Game.CreateBoss(bossID2, boss.X, boss.Y, boss.Direction, 2, "", config);
                Game.RemoveLiving(boss.Id);

                if (boss2.Direction == 1)
                    boss2.SetRect(boss.NpcInfo.X, boss.NpcInfo.Y, boss.NpcInfo.Width, boss.NpcInfo.Height);

                boss2.SetRelateDemagemRect(boss.NpcInfo.X, boss.NpcInfo.Y, boss.NpcInfo.Width, boss.NpcInfo.Height);
                List<Player> players = Game.GetAllFightPlayers();
                Player RandomPlayer = Game.FindRandomPlayer();
                int minDelay = 0;

                if (RandomPlayer != null)
                    minDelay = RandomPlayer.Delay;

                foreach (Player player in players)
                {
                    if (player.Delay < minDelay)
                        minDelay = player.Delay;
                }

                boss2.AddDelay(minDelay - 2000);
                turn = Game.TurnIndex;
            }
            if (boss2 != null && !boss2.IsLiving && boss3 == null)
            {
                LivingConfig config = Game.BaseConfig();
                config.IsFly = true;
                boss3 = Game.CreateBoss(bossID3, boss.X, boss.Y, boss.Direction, 2, "", config);
                Game.RemoveLiving(boss2.Id);

                if (boss3.Direction == 1)
                    boss3.SetRect(boss.NpcInfo.X, boss.NpcInfo.Y, boss.NpcInfo.Width, boss.NpcInfo.Height);

                boss3.SetRelateDemagemRect(boss.NpcInfo.X, boss.NpcInfo.Y, boss.NpcInfo.Width, boss.NpcInfo.Height);
                List<Player> players = Game.GetAllFightPlayers();
                Player RandomPlayer = Game.FindRandomPlayer();
                int minDelay = 0;

                if (RandomPlayer != null)
                    minDelay = RandomPlayer.Delay;

                foreach (Player player in players)
                {
                    if (player.Delay < minDelay)
                        minDelay = player.Delay;
                }

                boss3.AddDelay(minDelay - 2000);
                turn = Game.TurnIndex;
            }
            if (boss3 != null && !boss3.IsLiving)
            {
                if (Game.CanEnterGate)
                {
                    return true;
                }
                kill++;
                Game.CanShowBigBox = true;
            }
            return false;
        }

        public override int UpdateUIData()
        {
            base.UpdateUIData();
            return kill;
        }

        public override void OnGameOverMovie()
        {
            base.OnGameOverMovie();
            if (boss3 != null && boss3.IsLiving == false)
            {
                Game.IsWin = true;
            }
            else
            {
                Game.IsWin = false;
            }
        }

        public override void OnGameOver()
        {
            base.OnGameOver();

        }
        
    }
}
