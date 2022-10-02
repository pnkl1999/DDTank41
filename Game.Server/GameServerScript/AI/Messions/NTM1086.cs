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
    public class NTM1086 : AMissionControl
    {
        private int mapId = 1015;//450,400      

        private SimpleBoss m_boss;

        private PhysicalObj m_moive;

        private PhysicalObj m_front;
        private int bossID = 22001;//NewTrainingBoss22001

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
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.qiheibojueAsset");
            Game.AddLoadingFile(2, "image/bomb/blastout/blastout86.swf", "bullet86");
            Game.AddLoadingFile(2, "image/bomb/bullet/bullet86.swf", "bullet86");            
            int[] npcIdList = { bossID };
            Game.LoadResources(npcIdList);
            Game.LoadNpcGameOverResources(npcIdList);            
            Game.SetMap(mapId);
        }

        public override void OnStartGame()
        {
            //base.OnStartGame();
           
            m_moive = Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 0);
            m_front = Game.Createlayer(680, 330, "font", "game.asset.living.qiheibojueAsset", "out", 1, 0);
            m_boss = Game.CreateBoss(bossID, 750, 420, -1, 1, "");
            m_boss.FallFrom(750, 520, "fall", 0, 2, 1000);
            m_boss.SetRelateDemagemRect(m_boss.NpcInfo.X, m_boss.NpcInfo.Y, m_boss.NpcInfo.Width, m_boss.NpcInfo.Height);
            m_boss.Say("Đến đúng lúc lắm，ta đang chán đây！", 0, 4000);
            m_moive.PlayMovie("in", 6000, 0);
            m_front.PlayMovie("in", 6000, 0);
            m_moive.PlayMovie("out", 9000, 0);
           
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();

            if (Game.TurnIndex > 1)
            {
                if (m_moive != null)
                {
                    //Game.RemovePhysicalObj(m_moive, true);
                    //m_moive = null;
                }
                if (m_front != null)
                {
                    Game.RemovePhysicalObj(m_front, true);
                    m_front = null;
                }
            }
            
        }

        public override bool CanGameOver()
        {
            if (m_boss != null && !m_boss.IsLiving)
            {
                //kill++;
                return true;
            }
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
            if (!m_boss.IsLiving)
            {

                Game.IsWin = true;
            }
            else
            {
                Game.IsWin = false;
            }
        }
        
    }
}
