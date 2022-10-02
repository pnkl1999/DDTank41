using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using Bussiness;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class WAEpic13402 : AMissionControl
    {	
		private SimpleBoss m_king = null;
		
		private List<SimpleNpc> redNpc = new List<SimpleNpc>();
		
		private List<PhysicalObj> m_bord = new List<PhysicalObj>();

        private List<PhysicalObj> m_key = new List<PhysicalObj>();

        private int bossID = 13405;
		
		private int npcID = 13403;
		
		private int npcID2 = 13404;
		
		private int npcID3 = 3312;
		
		private int npcID4 = 13000;

        private int kill = 0;

        private PhysicalObj m_moive;

        private PhysicalObj m_front;
		
		private PhysicalObj front;
		
		private SimpleBoss boss = null;

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
            int[] resources = { bossID, npcID, npcID2, npcID3 };
            int[] gameOverResource = { bossID };
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(gameOverResource);
            Game.AddLoadingFile(1, "bombs/55.swf", "tank.resource.bombs.Bomb55");
            Game.AddLoadingFile(2, "image/game/effect/10/jitan.swf", "asset.game.ten.jitan");
            Game.AddLoadingFile(2, "image/game/living/living035.swf", "game.living.Living035");
            Game.AddLoadingFile(2, "image/game/living/living126.swf", "game.living.Living126");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.ClanLeaderAsset");
            Game.SetMap(1215);
        }


        public override void OnStartGame()
        {
            base.OnStartGame();
            Game.IsBossWar = "13002";
            m_moive = Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 1);
            m_front = Game.Createlayer(950, 750, "font", "game.asset.living.ClanLeaderAsset", "out", 1, 1);
            front = Game.CreatePhysicalObj(609, 1023, "font", "game.living.Living035", "", 1, 0);
            front = Game.CreatePhysicalObj(1604, 1023, "font", "game.living.Living035", "", 1, 0);
            m_king = Game.CreateBoss(bossID, 1100, 1000, -1, 1, "");
            m_king.SetRelateDemagemRect(m_king.NpcInfo.X, m_king.NpcInfo.Y, m_king.NpcInfo.Width, m_king.NpcInfo.Height);
            m_king.Say(LanguageMgr.GetTranslation("Sự dận dữ của thần linh sẻ tiêu diệt các ngươi !"), 0, 200, 0);
            m_moive.PlayMovie("in", 6000, 0);
            m_front.PlayMovie("in", 6100, 0);
            m_moive.PlayMovie("out", 10000, 1000);
            m_front.PlayMovie("out", 9900, 0);


        }

        //private Point[] brithPoint = { new Point(709, 590), new Point(1504, 590) };

        public override void OnNewTurnStarted()
        {
            base.OnNewTurnStarted();
            //if (bossL == null)
            {
                //int index = Game.Random.Next(brithPoint.Length);
                //bossL = ((PVEGame)Game).CreateBoss(npcID, brithPoint[index].X, brithPoint[index].Y, 1, 0, "");
            }
            //if (bossR == null)
            //    bossR = Game.CreateBoss(npcID2, 1704, 590, -1, 0, "");
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
            if (m_king != null && m_king.IsLiving == false)
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
            if (m_king != null && m_king.IsLiving == false)
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
