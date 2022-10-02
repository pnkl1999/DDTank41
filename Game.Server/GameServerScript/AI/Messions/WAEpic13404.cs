using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using Bussiness;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class WAEpic13404 : AMissionControl
    {
        private List<SimpleBoss> someBoss = new List<SimpleBoss>();

        private int bossID = 13408;

        private int bossID2 = 13409;
		
		private int npcID = 13412;

        private int kill = 0;
		
		private int m_kill = 0;
        
        private PhysicalObj m_moive;

        private PhysicalObj m_front;

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
            int[] resources = { bossID2, bossID, npcID };
            int[] gameOverResource = { bossID };
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(gameOverResource);
            Game.AddLoadingFile(2, "image/game/effect/10/tedabiaoji.swf", "asset.game.ten.tedabiaoji");
			Game.AddLoadingFile(2, "image/game/effect/10/qunbao.swf", "asset.game.ten.qunbao");
			
			Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.canbaoAsset");
            Game.SetMap(1217);
        }

        public override void OnStartGame()
        {
            base.OnStartGame();
			m_moive = Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 1);
            m_front = Game.Createlayer(1000, 600, "font", "game.asset.living.canbaoAsset", "out", 1, 1);

            SimpleBoss boss = Game.CreateBoss(bossID, 100, 990, 1, 1, "");
            boss.SetRelateDemagemRect(boss.NpcInfo.X, boss.NpcInfo.Y, boss.NpcInfo.Width, boss.NpcInfo.Height);
            someBoss.Add(boss);
            boss = Game.CreateBoss(bossID2, 1890, 990, -1, 1, "");
            boss.SetRelateDemagemRect(boss.NpcInfo.X, boss.NpcInfo.Y, boss.NpcInfo.Width, boss.NpcInfo.Height);
            someBoss.Add(boss);
		
            m_moive.PlayMovie("in", 6000, 0);
            m_front.PlayMovie("in", 6100, 0);
            m_moive.PlayMovie("out", 10000, 1000);
            m_front.PlayMovie("out", 9900, 0);
        }

        public override void OnNewTurnStarted()
        {
		
        }
		
        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();

            if (Game.TurnIndex > 1)
            {
                if (m_moive != null)
                {
                    Game.RemovePhysicalObj(m_moive, true);
                    m_moive = null;
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
            kill = 0;
            bool result = true;
            base.CanGameOver();
            foreach (SimpleBoss npc in someBoss)
            {
                if (npc.IsLiving)
                {
                    result = false;
                }
                else
                {
                    kill++;
                }
            }
            if (result && kill == Game.MissionInfo.TotalCount)
                return true;

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
            if (kill == Game.MissionInfo.TotalCount)
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
