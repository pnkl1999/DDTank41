using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System;
using System.Collections.Generic;

namespace Game.Server.GameServerScript.AI.Messions
{
  public class TVS12001 : AMissionControl
  {
        private List<SimpleNpc> someNpc = new List<SimpleNpc>();

        private int bossId = 12003;

        private int npcID = 12002;

        private int npcID1 = 12001;

        private int npcHelper = 12004;

        private SimpleBoss m_boss = null;

        private SimpleBoss m_helper = null;

        private int countSpawnBigNpc = 2;

        private int countSpawnSmallNpc = 3;

        private int CountDownSpawnBoss = 2;

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
            int[] resources = { npcID, npcID1, npcHelper, bossId };
            int[] gameOverResource = { npcID, npcID1, npcHelper, bossId };
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(gameOverResource);
            Game.SetMap(1207);
        }

        public override void OnStartGame()
        {
            base.OnStartGame();

            LivingConfig config = Game.BaseConfig();
            config.IsHelper = true;
            config.HasTurn = false;
            config.CanCountKill = false;
            m_helper = Game.CreateBoss(npcHelper, 850, 777, -1, 0, "", config);

            Game.PveGameDelay = 0;
            CreateChildNpc();
        }

        public override void OnGameOverMovie()
        {
            base.OnGameOverMovie();
        }

        public override void OnNewTurnStarted()
        {
            base.OnNewTurnStarted();
            // check another npc
            if(CountDownSpawnBoss <= 0 && m_boss == null)
            {
                // create boss and set next turn is him
                CreateBoss();
            }
            if (CountChildLiving() <= 0)
            {
                Game.PveGameDelay = 0;
                CreateChildNpc();
            }
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            if(m_boss == null)
            {
                CountDownSpawnBoss--;
            }
        }

        public override bool CanGameOver()
        {
            base.CanGameOver();
            
            if (Game.TurnIndex >= Game.MissionInfo.TotalTurn || Game.TotalKillCount >= Game.MissionInfo.TotalCount)
                return true;

            return false;
        }

        public override int UpdateUIData()
        {
            base.UpdateUIData();
            return Game.TotalKillCount;
        }

        public override void OnGameOver()
        {
            base.OnGameOver();
            
            if (Game.TotalKillCount >= Game.MissionInfo.TotalCount)
            {
                Game.IsWin = true;
                if (m_boss != null)
                {
                    Game.SendObjectFocus(m_boss, 0, 1000, 0);
                    m_boss.PlayMovie("die", 2000, 2000);
                    m_boss.Say("Không thể nào…", 0, 2500);
                }
            }
            else
                Game.IsWin = false;
            
        }

        private void CreateBoss()
        {
            LivingConfig config = Game.BaseConfig();
            config.IsShield = true;
            config.CanTakeDamage = false;
            config.CanFrost = true;

            m_boss = Game.CreateBoss(bossId, 55, 770, 1, 4, "", config);
            m_boss.SetRelateDemagemRect(m_boss.NpcInfo.X, m_boss.NpcInfo.Y, m_boss.NpcInfo.Width, m_boss.NpcInfo.Height);
            m_boss.Delay = Game.GetLowDelayTurn() - 1;
        }

        private void CreateChildNpc()
        {
            for (int i = 0; i < countSpawnBigNpc; i++)
            {
                someNpc.Add(Game.CreateNpc(npcID, 1735, 766, 1, -1));
            }
            for (int i = 0; i < countSpawnSmallNpc; i++)
            {
                someNpc.Add(Game.CreateNpc(npcID1, 1735, 766, 1, -1));
            }
        }

        private int CountChildLiving()
        {
            int totalLiving = 0;
            foreach (SimpleNpc npc in someNpc)
            {
                if (npc.IsLiving)
                    totalLiving++;
            }
            return totalLiving;
        }

    }
}
