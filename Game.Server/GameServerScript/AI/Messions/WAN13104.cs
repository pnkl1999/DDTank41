using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class WAN13104 : AMissionControl
    {
        private int bossId = 13108; // mathia

        private int boss2Id = 13109; // ao anh mathia

        private int npc1Id = 13112;

        private int npc2Id = 13113;

        private int npc3Id = 13114;

        private PhysicalObj m_moive;

        private PhysicalObj m_front;

        private SimpleBoss boss = null;

        private SimpleBoss boss2 = null;

        private SimpleBoss m_tempBoss = null;

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
            int[] resources = { bossId, boss2Id, npc1Id, npc2Id, npc3Id };

            Game.AddLoadingFile(2, "image/game/effect/10/danbao.swf", "asset.game.ten.danbao"); // damage alone
            Game.AddLoadingFile(2, "image/game/effect/10/qunbao.swf", "asset.game.ten.qunbao"); // damage global
            Game.AddLoadingFile(2, "image/game/effect/10/tedabiaoji.swf", "asset.game.ten.tedabiaoji"); // vach ke duong

            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.shuangwangAsset");

            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(resources);
            Game.SetMap(1217);
        }

        public override void OnStartGame()
        {
            base.OnStartGame();

            m_moive = Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 0);
            m_front = Game.Createlayer(810, 750, "front", "game.asset.living.shuangwangAsset", "out", 1, 0);

            boss = Game.CreateBoss(bossId, 83, 1020, 1, 1, "");
            boss.SetRelateDemagemRect(boss.NpcInfo.X, boss.NpcInfo.Y, boss.NpcInfo.Width, boss.NpcInfo.Height);

            Game.SendObjectFocus(boss, 0, 0, 0);

            boss.CallFuction(new LivingCallBack(CreateBossHelp), 2000);
        }

        private void CreateBossHelp()
        {
            LivingConfig config = Game.BaseConfig();

            boss2 = Game.CreateBoss(boss2Id, 1912, 1020, -1, 1, "", config);
            boss2.SetRelateDemagemRect(boss2.NpcInfo.X, boss2.NpcInfo.Y, boss2.NpcInfo.Width, boss2.NpcInfo.Height);
            boss2.Delay = 1;

            Game.SendObjectFocus(boss2, 0, 0, 0);

            Game.SendFreeFocus(1000, 900, 1, 2000, 0);

            m_moive.PlayMovie("in", 3000, 0);
            m_front.PlayMovie("in", 3200, 0);
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
            if (m_moive != null && m_front != null)
            {
                Game.RemovePhysicalObj(m_moive, true);
                Game.RemovePhysicalObj(m_front, true);

                m_moive = null;
                m_front = null;
            }
        }

        public override bool CanGameOver()
        {
            base.CanGameOver();

            if (boss != null && boss.IsLiving == false && boss2 != null && boss2.IsLiving == false)
            {
                return true;
            }
            else if (Game.TotalTurn > 200)
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

            if (boss.IsLiving == false && boss2.IsLiving == false)
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
