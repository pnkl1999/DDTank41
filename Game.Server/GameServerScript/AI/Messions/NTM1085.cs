using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;
using Bussiness.Managers;
using Game.Server.Statics;
using Game.Logic;
//using Game.Logic.Actions;
using Game.Base.Packets;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class NTM1085 : AMissionControl
    {
        private int mapId = 2013;
        private SimpleBoss m_boss;

        private PhysicalObj m_moive;

        private PhysicalObj m_front;

        private int bossID = 21002;//NewTrainingBoss21002
        private int blueNpcID = 21001;//NewTrainingNpc21001
        //private int totalNpcCount = 1;     

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
            //Game.AddLoadingFile(1, "bombs/61.swf", "tank.resource.bombs.Bomb61");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.boguoLeaderAsset");
            Game.AddLoadingFile(2, "image/bomb/blastout/blastout61.swf", "bullet61");
            Game.AddLoadingFile(2, "image/bomb/bullet/bullet61.swf", "bullet61");
         
            int[] npcIdList = { bossID, blueNpcID };
            Game.LoadResources(npcIdList);
            Game.LoadNpcGameOverResources(npcIdList);
            Game.SetMap(mapId);
        }
        
        public override void OnStartGame()
        {
            CreateNpc();            
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
        public void CreateBoss()
        {
            //base.OnStartGame();           
            m_moive = Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 0);
            m_front = Game.Createlayer(730, 510, "font", "game.asset.living.boguoLeaderAsset", "out", 1, 0);
            m_boss = Game.CreateBoss(bossID, 850, 360, -1, 1, "");
            m_boss.FallFrom(850, 410, "fall", 0, 2, 1000);
            m_boss.SetRelateDemagemRect(m_boss.NpcInfo.X, m_boss.NpcInfo.Y, m_boss.NpcInfo.Width, m_boss.NpcInfo.Height);
            m_boss.Say("Loài người kia，gặp phải ta là hên rồi！", 0, 6000);
            m_moive.PlayMovie("in", 9000, 0);
            //m_boss.PlayMovie("weakness", 10000, 5000);
            m_front.PlayMovie("in", 9000, 0);
            m_moive.PlayMovie("out", 15000, 0);
            
        }
        private void CreateNpc()
        {
            simpleNpcList.Add(Game.CreateNpc(blueNpcID, 775, 553, 1, 1));
        }
    }
}
