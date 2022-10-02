using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using Bussiness;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class WAS13003 : AMissionControl
    {
        private int bossId = 13007; // minortaur

        private int npcHelpId = 13006;

        private int npcId = 13010; // hop hinh cu

        private PhysicalObj m_moive;

        private PhysicalObj m_front;

        private SimpleBoss boss = null;

        private SimpleBoss bossHelp = null;

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
            int[] resources = { bossId, npcHelpId, npcId };

            Game.AddLoadingFile(2, "image/game/effect/10/chengtuo.swf", "asset.game.ten.chengtuo"); // ta 1k
            Game.AddLoadingFile(2, "image/game/effect/10/laotie.swf", "asset.game.ten.laotie"); // fire
            Game.AddLoadingFile(2, "image/game/effect/10/laotie.swf", "asset.game.ten.laotie2"); // fire
            Game.AddLoadingFile(2, "image/game/effect/5/lanhuo.swf", "asset.game.4.lanhuo"); // effect move player
            Game.AddLoadingFile(2, "image/game/effect/5/heip.swf", "asset.game.4.heip"); //global attacking

            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.dadangAsset");

            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(resources);
            Game.SetMap(1216);
        }

        public override void OnStartGame()
        {
            base.OnStartGame();

            m_moive = Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 0);
            m_front = Game.Createlayer(1200, 700, "front", "game.asset.living.dadangAsset", "out", 1, 0);

            boss = Game.CreateBoss(bossId, 1683, 1012, -1, 1, "");
            boss.SetRelateDemagemRect(boss.NpcInfo.X, boss.NpcInfo.Y, boss.NpcInfo.Width, boss.NpcInfo.Height);

            Game.SendObjectFocus(boss, 0, 0, 0);

            boss.CallFuction(new LivingCallBack(CreateBossHelp), 2000);
        }

        private void CreateBossHelp()
        {
            LivingConfig config = Game.BaseConfig();
            config.CanTakeDamage = false;
            config.IsFly = true;

            bossHelp = Game.CreateBoss(npcHelpId, 1683, 762, -1, 1, "", config);
            bossHelp.Delay = 1;

            Game.SendObjectFocus(bossHelp, 0, 0, 0);

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

            if (boss != null && boss.IsLiving == false)
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

            if (boss.IsLiving == false)
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
