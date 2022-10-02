using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using Bussiness;
namespace Game.Server.GameServerScript.AI.Messions
{
    public class DCN4102 : AMissionControl
    {
        private SimpleBoss m_king = null;

        private SimpleBoss m_boss = null;

        private int bossID = 4105; // than ung

        private int bossID2 = 4106; // soi sa mac

        private int npcId = 4102;

        private int kill = 0;

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
            int[] resources = { bossID, bossID2, npcId };
            int[] gameOverResource = { bossID, bossID2 };
            Game.AddLoadingFile(2, "image/game/effect/4/feather.swf", "asset.game.4.feather");
            Game.AddLoadingFile(2, "image/game/thing/bossbornbgasset.swf", "game.asset.living.BossBgAsset");
            Game.AddLoadingFile(2, "image/game/thing/bossbornbgasset.swf", "game.asset.living.tingyuanlieshouAsset");
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(gameOverResource);
            Game.SetMap(1143);
        }

        public override void OnStartGame()
        {
            base.OnStartGame();


            m_moive = Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 0);
            m_front = Game.Createlayer(1098, 706, "front", "game.asset.living.tingyuanlieshouAsset", "out", 1, 0);

            LivingConfig config = Game.BaseConfig();
            config.IsFly = true;

            m_king = Game.CreateBoss(bossID, 354, 344, -1, 1, "born", config);
            m_king.SetRelateDemagemRect(m_king.NpcInfo.X, m_king.NpcInfo.Y, m_king.NpcInfo.Width, m_king.NpcInfo.Height);

            Game.SendObjectFocus(m_king, 1, 100, 0);

            Game.SendFreeFocus(1460, 962, 1, 3000, 0);

            m_king.CallFuction(new LivingCallBack(CreateBoss), 4000);
        }

        private void CreateBoss()
        {
            m_boss = Game.CreateBoss(bossID2, 1460, 962, -1, 1, "born");
            m_boss.SetRelateDemagemRect(m_boss.NpcInfo.X, m_boss.NpcInfo.Y, m_boss.NpcInfo.Width, m_boss.NpcInfo.Height);

            m_moive.PlayMovie("in", 3000, 0);
            m_front.PlayMovie("in", 3200, 0);
            m_moive.PlayMovie("out", 6000, 0);
            m_front.PlayMovie("out", 6000, 0);
        }

        public override void OnNewTurnStarted()
        {
            base.OnNewTurnStarted();
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
            if (m_king != null && m_king.IsLiving == false && m_boss != null && m_boss.IsLiving == false)
            {
                kill++;
                return true;
            }

            if (Game.TotalTurn > Game.MissionInfo.TotalTurn)
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
            if (m_king != null && m_king.IsLiving == false && m_boss != null && m_boss.IsLiving == false)
            {
                Game.IsWin = true;
            }
            else
            {
                Game.IsWin = false;
            }
        }

        public override void OnShooted()
        {
            base.OnShooted();
        }
    }
}
