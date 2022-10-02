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
    public class Labyrinth40040 : AMissionControl
    {
        private SimpleBoss boss = null;
        private SimpleBoss boss2 = null;
        private int kill = 0;
        private int m_state = 40065;
        private int turn = 0;
        private int bossID = 40065;
        private int bossID2 = 40066;

        public override int CalculateScoreGrade(int score)
        {
            base.CalculateScoreGrade(score);
            if (score > 1870)
                return 3;
            else if (score > 1825)
                return 2;
            else if (score > 1780)
                return 1;
            else
                return 0;
        }

        public override void OnPrepareNewSession()
        {
            base.OnPrepareNewSession();
            int[] resources = { bossID, bossID2 };
            int[] gameOverResource = { bossID, bossID2 };
            //Game.AddLoadingFile(1, "bombs/55.swf", "tank.resource.bombs.Bomb55");
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(gameOverResource);
            Game.SetMap(1318);
        }

        public override void OnStartGame()
        {
            base.OnStartGame();
            boss = Game.CreateBoss(bossID, 1169, 606, -1, 1, "");
            boss.SetRelateDemagemRect(boss.NpcInfo.X, boss.NpcInfo.Y, boss.NpcInfo.Width, boss.NpcInfo.Height);
            boss.AddDelay(10);
            turn = Game.TurnIndex;
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
            if (!boss.IsLiving)
            {
                if (m_state == bossID)
                    m_state++;
            }

            if (m_state == bossID2 && boss2 == null)
            {
                LivingConfig config = Game.BaseConfig();
                config.IsFly = true;
                boss2 = Game.CreateBoss(m_state, boss.X, 606, boss.Direction, 2, "", config);
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

            if (boss2 != null && !boss2.IsLiving)
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
            if (boss2 != null && boss2.IsLiving == false)
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
