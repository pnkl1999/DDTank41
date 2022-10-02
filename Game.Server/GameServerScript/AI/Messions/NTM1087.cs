using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;
using Bussiness.Managers;
using Game.Server.Statics;
using Game.Logic;
using Game.Base.Packets;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class NTM1087 : AMissionControl
    {
        private int mapId = 2012;//825,565

        private SimpleBoss m_boss;

        private PhysicalObj m_moive;

        private PhysicalObj m_front;

        private int bossID = 23003;
        private int redNpcID = 23001;
        private int blueNpcID = 23002;
       
        private List<SimpleNpc> simpleNpcList = new List<SimpleNpc>();

        public override int CalculateScoreGrade(int score)
        {
            base.CalculateScoreGrade(score);
            if (score > 900)
            {
                return 3;
            }
            if (score > 825)
            {
                return 2;
            }
            if (score > 725)
            {
                return 1;
            }
            return 0;
        }

        public override void OnPrepareNewSession()
        {
            base.OnPrepareNewSession();
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.boguoLeaderAsset");
            Game.AddLoadingFile(2, "image/bomb/blastout/blastout61.swf", "bullet61");
            Game.AddLoadingFile(2, "image/bomb/bullet/bullet61.swf", "bullet61");
            int[] npcIdList = { redNpcID, blueNpcID, bossID};
            Game.LoadResources(npcIdList);
            Game.LoadNpcGameOverResources(npcIdList);
            Game.SetMap(mapId);
        }

        public override void OnStartGame()
        {
            CreateNpc();
        }

        //public override void OnPrepareNewGame()
        //{
        //    base.OnPrepareNewGame();
        //}

        public override void OnNewTurnStarted()
        {
            
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
        }

        public override bool CanGameOver()
        {
            foreach (SimpleNpc npc in simpleNpcList)
            {
                if (npc.IsLiving)
                {
                    return false;
                }

            }
            if (m_boss != null && !m_boss.IsLiving)
            {
                return true;
            }
            else
            {
                if (m_boss == null)
                {
                    CreateBoss();
                }

                return false;
            }
        }
        public void CreateBoss()
        {
            //base.OnStartGame();           
            m_moive = Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 0);
            m_front = Game.Createlayer(200, 470, "font", "game.asset.living.boguoLeaderAsset", "out", 1, 0);
            m_boss = Game.CreateBoss(bossID, 260, 560, 1, 1, "");
            m_boss.FallFrom(260, 620, "fall", 0, 2, 1000);
            m_boss.SetRelateDemagemRect(m_boss.NpcInfo.X, m_boss.NpcInfo.Y, m_boss.NpcInfo.Width, m_boss.NpcInfo.Height);
            m_boss.Say("Loài người kia，đến được đây quả nhiên có chút bản lĩnh！", 0, 3000);
            m_moive.PlayMovie("in", 6000, 0);
            //m_boss.PlayMovie("weakness", 10000, 5000);
            m_front.PlayMovie("in", 6000, 0);
            m_moive.PlayMovie("out", 9000, 0);
            m_front.PlayMovie("out", 9000, 0);

        }
        public override int UpdateUIData()
        {
            base.UpdateUIData();
            return Game.TotalKillCount;
        }

        public override void OnGameOver()
        {
            base.OnGameOver();            
            if (Game.GetLivedLivings().Count == 0)
            {
                Game.IsWin = true;
            }
            else
            {
                Game.IsWin = false;
            }
        }
        private void CreateNpc()
        {
            int[,] points = new int[,]
            {                
                { 260, 620 }, 
                { 312, 625 }, 
                { 350, 621 },
                { 285, 620 }, 
                { 331, 625 },
            };
            for (int i = 0; i <= 2; i++)
            {
                simpleNpcList.Add(Game.CreateNpc(redNpcID, points[i, 0], points[i, 1], 1, 1));
            }
            for (int i = 3; i <= 4; i++)
            {
                simpleNpcList.Add(Game.CreateNpc(blueNpcID, points[i, 0], points[i, 1], 1, 1));
            }
        }
    }
}
