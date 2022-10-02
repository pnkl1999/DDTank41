using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using Bussiness;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class ETH3202 : AMissionControl
    {
        private List<SimpleNpc> someNpc = new List<SimpleNpc>();

        private SimpleBoss boss = null;

        protected int m_maxBlood;

        protected int m_blood;

        private SimpleBoss m_king;

        private int npcID = 3202;

        private int npcID1 = 3207;

        private int npcID2 = 3205;

        private int bossId = 3008;

        private int countSpawnNpc = 3;

        private int kill = 0;

        private SimpleBoss m_boss = null;

        private int CountDownRespawnBoss = 0;

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
            int[] resources = { npcID, npcID1, npcID2, bossId };
            int[] gameOverResource = { npcID, npcID1, npcID2 };
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(gameOverResource);
            Game.AddLoadingFile(1, "bombs/58.swf", "tank.resource.bombs.Bomb58");
            Game.SetMap(1123);
        }

        public override void OnStartGame()
        {
            base.OnStartGame();
            m_king = Game.CreateBoss(bossId, 100, 444, 1, 0, "");
            m_king.FallFrom(m_king.X, m_king.Y, "", 0, 0, 2000);
            m_king.PlayMovie("castA", 500, 0);
            m_king.Say("Các ngươi dám mò vào đây là chết chắc rồi! Sẽ không có lối ra cho tụi bay đâu...", 0, 300);
            m_king.CallFuction(new LivingCallBack(CreateStarGame), 2500);
        }

        public void CreateStarGame()
        {
            LivingConfig config = Game.BaseConfig();
            config.IsHelper = true;
            config.ReduceBloodStart = 2;
            boss = Game.CreateBoss(npcID1, 1100, 444, -1, 1, "born", config);
            boss.SetRelateDemagemRect(boss.NpcInfo.X, boss.NpcInfo.Y, boss.NpcInfo.Width, boss.NpcInfo.Height);
            boss.FallFrom(boss.X, boss.Y, "", 0, 0, 1000, null);
            

            CreateBoss();

            CreateChildNpc();

            ((PVEGame)Game).SendObjectFocus(boss, 1, 500, 3000);

            boss.Say(LanguageMgr.GetTranslation("Hồi máu cho tôi, tôi sẽ dẫn các cậu ra khỏi đây !"), 0, 1500, 0);


        }

        public void CreateBoss()
        {
            m_boss = Game.CreateBoss(npcID2, 300, 444, 1, 0, "");
            m_boss.SetRelateDemagemRect(m_boss.NpcInfo.X, m_boss.NpcInfo.Y, m_boss.NpcInfo.Width, m_boss.NpcInfo.Height);
            m_boss.FallFrom(m_boss.X, m_boss.Y, "", 0, 0, 1000, null);
            CountDownRespawnBoss = 1;
        }

        public void CreateOutGame()
        {
            m_king.Blood = 0;
            m_king.Die();
            Game.RemoveLiving(m_king.Id);
        }

        public override void OnNewTurnStarted()
        {
            base.OnNewTurnStarted();
            if (m_boss != null && m_boss.IsLiving == false && (Game.CurrentLiving is Player) == false)
            {
                if (CountDownRespawnBoss <= 0)
                    CreateBoss();
                else
                    CountDownRespawnBoss--;
            }
            // check another npc
            if (CountChildLiving() <= 0)
            {
                CreateChildNpc();
            }

        }

        private void CreateChildNpc()
        {
            int x = 350;
            for (int i = 0; i < countSpawnNpc; i++)
            {
                someNpc.Add(Game.CreateNpc(npcID, x, 344, 1, 1));
                x += 50;
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

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            if (Game.TurnIndex == 1)
            {
                m_king.PlayMovie("out", 0, 2000);
                m_king.CallFuction(new LivingCallBack(CreateOutGame), 1200);
            }
        }


        public override bool CanGameOver()
        {
            base.CanGameOver();
            if (boss != null && boss.Blood >= boss.NpcInfo.Blood)
            {
                return true;
            }

            if (boss != null && boss.IsLiving == false)
            {
                kill++;
                return true;
            }
            return false;
        }

        public override int UpdateUIData()
        {
            base.UpdateUIData();
            return kill;
        }

        public override void OnGameOver()
        {
            base.OnGameOver();
            if (boss.Blood >= boss.NpcInfo.Blood)
            {
                boss.PlayMovie("grow", 0, 3000);
                Game.IsWin = true;
            }
            if (boss.IsLiving == false)
            {
                Game.IsWin = false;
            }
        }
    }
}
