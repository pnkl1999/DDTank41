using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using Bussiness;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class RRCN7103 : AMissionControl
    {
        private SimpleBoss boss = null;

        private List<SimpleNpc> someNpc = new List<SimpleNpc>();

        private int npcID = 7121;
		
		private int npcID2 = 7122;

        private int bossID = 7123;

        private int kill = 0;
        private int count = 0;

        private int TotalCount = 0;

        private int dieCount = 0;

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
            int[] resources = { bossID, npcID, npcID2 };
            int[] gameOverResource = { bossID };
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(gameOverResource);
			Game.AddLoadingFile(2, "image/game/effect/7/cao.swf", "asset.game.seven.cao");
            Game.AddLoadingFile(2, "image/game/effect/7/jinquhd.swf", "asset.game.seven.jinquhd");
            Game.SetMap(1163);
        }

        public override void OnStartGame()
        {
            base.OnStartGame();
            Game.IsBossWar = "7103";
            boss = Game.CreateBoss(bossID, 275, 950, 1, 2, "");
            boss.FallFrom(338, 950, "", 0, 0, 1000);
            boss.SetRelateDemagemRect(boss.NpcInfo.X, boss.NpcInfo.Y, boss.NpcInfo.Width, boss.NpcInfo.Height);
            for (int i = 0; i < 2; i++)
            {
                TotalCount++;
                someNpc.Add(Game.CreateNpc(npcID, 700, 900, 1, 1));
            }
        }

        public override void OnNewTurnStarted()
        {
            //base.OnBeginNewTurn();
            count = TotalCount - dieCount;
            if (Game.TurnIndex > 1)
            {
                if (TotalCount < 2)
                {
                    for (int i = 0; i < 2; i++)
                    {
                        TotalCount++;
                        someNpc.Add(Game.CreateNpc(npcID, 700, 900, 1, 1));
                    }
                }
                else
                {
                    if (count < 2)
                    {
                        if (2 - count >= 0)
                        {
                            for (int i = 0; i < 3; i++)
                            {
                                TotalCount++;
                                someNpc.Add(Game.CreateNpc(npcID, 700, 900, 1, 1));
                            }
                        }
                    }
                }

            }

        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
        }

        public override bool CanGameOver()
        {
            dieCount = 0;
            foreach (SimpleNpc npc in someNpc)
            {
                if (!npc.IsLiving)
                {
                    dieCount++;
                }
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
            if (boss != null && boss.IsLiving == false)
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
