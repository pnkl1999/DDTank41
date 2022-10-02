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
    public class NTM1088 : AMissionControl
    {
        private int mapId = 1132;//810,600

        //private int indexOf = 0;
        private bool isAddBlood = true;

        private int redNpcID = 24001;
        private SimpleBoss m_boss;

        private PhysicalObj m_moive;

        private PhysicalObj m_front;

        private int bossID = 24002;//24002

        private PhysicalObj m_effect;

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
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.jianjiaoAsset");
            Game.AddLoadingFile(2, "image/bomb/blastout/blastout96.swf", "bullet96");
            Game.AddLoadingFile(2, "image/bomb/bullet/bullet96.swf", "bullet96");
            Game.AddLoadingFile(2, "image/game/effect/0/guangquan.swf", "asset.game.0.guangquan");        
            int[] npcIdList = { redNpcID, bossID };
            Game.LoadResources(npcIdList);
            Game.LoadNpcGameOverResources(npcIdList);
            Game.SetMap(mapId);
        }

        public override void OnStartGame()
        {            
            m_moive = Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 0);
            m_front = Game.Createlayer(25, 265, "font", "game.asset.living.jianjiaoAsset", "out", 1, 0);
            m_boss = Game.CreateBoss(bossID, 100, 320, 1, 1, "");
            m_boss.FallFrom(100, 520, "fall", 0, 2, 1000);
            m_boss.SetRelateDemagemRect(m_boss.NpcInfo.X, m_boss.NpcInfo.Y, m_boss.NpcInfo.Width, m_boss.NpcInfo.Height);
            m_boss.Say("Bay ra ngoài đi，núp trong đóa ko thịt được ta đâu！", 0, 3000);
            m_moive.PlayMovie("in", 4000, 0);
            m_front.PlayMovie("in", 4000, 0);
            m_moive.PlayMovie("out", 7000, 0);
            m_front.PlayMovie("out", 7000, 0);
          
        }

        //public override void OnPrepareNewGame()
        //{
        //    base.OnPrepareNewGame();
        //}

        public override void OnNewTurnStarted()
        {
            if ( m_effect == null)
            {
                m_effect = Game.Createlayer(1150, 544, "moive", "asset.game.0.guangquan", "in", 1, 0);
            }
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            Player target = Game.FindRandomPlayer();
            if (target != null)
                return;
            if (target.X > 1050)
            {
                m_effect.PlayMovie("standA", 1000, 0);
                if (isAddBlood)
                {
                    target.AddBlood(2000);
                    isAddBlood = false;
                }
            }
            else
            {
                m_effect.PlayMovie("standB", 1000, 0);
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
        private void CreateNpc()
        {
            simpleNpcList.Add(Game.CreateNpc(redNpcID, 1110, 520, 1, 1));
        }
    }
}
