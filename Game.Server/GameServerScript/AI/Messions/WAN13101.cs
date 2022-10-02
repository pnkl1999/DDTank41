using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class WAN13101 : AMissionControl
    {
        private int bossAntID = 13101;

        private int bossChickenID = 13102;

        private PhysicalObj m_moive;

        private PhysicalObj m_front;

        private SimpleBoss bossAnt = null;

        private SimpleBoss bossChicken = null;

        public override int CalculateScoreGrade(int score)
        {
            base.CalculateScoreGrade(score);
            if (score > 600)
            {
                return 3;
            }
            else if (score > 520)
            {
                return 2;
            }
            else if (score > 450)
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
            int[] resources = { bossAntID, bossChickenID };
            Game.AddLoadingFile(1, "bombs/51.swf", "tank.resource.bombs.Bomb51"); // con cave ant ban bt
            Game.AddLoadingFile(1, "bombs/61.swf", "tank.resource.bombs.Bomb61"); // con chicken ban
            Game.AddLoadingFile(1, "bombs/99.swf", "tank.resource.bombs.Bomb99"); // bang cua con ant

            Game.AddLoadingFile(2, "image/game/effect/10/jianyu.swf", "asset.game.ten.jianyu");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.canbaoAsset");
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(resources);
            Game.SetMap(1214);
        }

        public override void OnStartGame()
        {
            base.OnStartGame();

            m_moive = Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 0);
            m_front = Game.Createlayer(820, 400, "front", "game.asset.living.canbaoAsset", "out", 1, 0);

            bossChicken = Game.CreateBoss(bossChickenID, 1290, 1013, -1, 1, "");
            bossChicken.SetRelateDemagemRect(bossChicken.NpcInfo.X, bossChicken.NpcInfo.Y, bossChicken.NpcInfo.Width, bossChicken.NpcInfo.Height);

            Game.SendObjectFocus(bossChicken, 0, 0, 0);

            bossChicken.CallFuction(new LivingCallBack(CreateBossAnt), 1500);
        }

        private void CreateBossAnt()
        {
            bossAnt = Game.CreateBoss(bossAntID, 1295, 445, -1, 1, "");
            bossAnt.SetRelateDemagemRect(bossAnt.NpcInfo.X, bossAnt.NpcInfo.Y, bossAnt.NpcInfo.Width, bossAnt.NpcInfo.Height);
            bossAnt.Delay = 1;

            Game.SendObjectFocus(bossAnt, 0, 0, 0);

            m_moive.PlayMovie("in", 2000, 0);
            m_front.PlayMovie("in", 2200, 0);
            m_moive.PlayMovie("out", 6000, 0);
            m_front.PlayMovie("out", 6200, 0);
        }

        public override void OnNewTurnStarted()
        {
            base.OnNewTurnStarted();

            
        }
        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
        }

        public override bool CanGameOver()
        {
            base.CanGameOver();
            if ((bossAnt != null && bossAnt.IsLiving == false && bossChicken != null && bossChicken.IsLiving == false) || Game.TotalTurn > 200)
            {
                return true;
            }

            return false;
        }

        public override int UpdateUIData()
        {
            return Game.TotalKillCount;
        }

        public override void OnGameOver()
        {
            base.OnGameOver();

            if ((bossAnt != null && bossAnt.IsLiving == false && bossChicken != null && bossChicken.IsLiving == false))
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
