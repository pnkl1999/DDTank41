using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using Bussiness;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class DLEpic5403 : AMissionControl
    {
        private SimpleBoss m_boss = null;

        private SimpleBoss m_tempBoss = null;

        private PhysicalObj m_kingMoive;

        private PhysicalObj m_kingFront;

        private int m_kill = 0;

        private int bossId = 5421;

        private int npcId1 = 5422;

        private int npcId2 = 5423;

        private int npcId3 = 5424;

        private int npcId4 = 5404;

        private int m_map = 1153;

        public override int CalculateScoreGrade(int score)
        {
            base.CalculateScoreGrade(score);
            if (score > 1150)
            {
                return 3;
            }
            else if (score > 925)
            {
                return 2;
            }
            else if (score > 700)
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
            //Game.AddLoadingFile(1, "bombs/00.swf", "tank.resource.bombs.Bomb00");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.hongpaoxiaoemoAsset");
            Game.AddLoadingFile(2, "image/game/effect/5/heip.swf", "asset.game.4.heip"); // global attack black
            Game.AddLoadingFile(2, "image/game/effect/5/tang.swf", "asset.game.4.tang"); // bi lua di vao ass
            Game.AddLoadingFile(2, "image/game/effect/5/lanhuo.swf", "asset.game.4.lanhuo"); // bien vao hom`

            int[] resources = { bossId, npcId1, npcId2, npcId3, npcId4 };
            Game.LoadResources(resources);
            int[] gameOverResources = { bossId };
            Game.LoadNpcGameOverResources(gameOverResources);
            Game.SetMap(m_map);
        }

        public override void OnStartGame()
        {
            base.OnStartGame();

            m_kingMoive = Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 1);
            m_kingFront = Game.Createlayer(850, 258, "front", "game.asset.living.hongpaoxiaoemoAsset", "out", 1, 1);

            LivingConfig config = Game.BaseConfig();
            config.IsFly = true;

            m_boss = Game.CreateBoss(bossId, 1000, 500, 1, 3, "", config);
            m_boss.SetRelateDemagemRect(m_boss.NpcInfo.X, m_boss.NpcInfo.Y, m_boss.NpcInfo.Width, m_boss.NpcInfo.Height);

            m_boss.Say("Ta đợi lâu lắm rồi!", 0, 1000);

            m_kingMoive.PlayMovie("in", 4000, 0);
            m_kingFront.PlayMovie("in", 4000, 0);

            m_kingMoive.PlayMovie("out", 7000, 0);
            m_kingFront.PlayMovie("out", 7200, 0);
        }

        public override void OnNewTurnStarted()
        {
            base.OnNewTurnStarted();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();

            if (m_kingMoive != null)
            {
                Game.RemovePhysicalObj(m_kingMoive, true);
                m_kingMoive = null;
            }
            if (m_kingFront != null)
            {
                Game.RemovePhysicalObj(m_kingFront, true);
                m_kingFront = null;
            }
        }

        public override bool CanGameOver()
        {
            base.CanGameOver();
            if (m_boss != null && m_boss.IsLiving == false)
            {
                m_kill++;
                return true;
            }

            if (Game.TurnIndex > 200)
                return true;

            return false;
        }

        private void CreateEffectEndGame()
        {
            m_tempBoss.ChangeDirection(1, 500);
            m_tempBoss.Say("Thôi ta éo đùa nữa.", 0, 1000);
            m_tempBoss.PlayMovie("out", 1000, 0);
            m_tempBoss.CallFuction(new LivingCallBack(CreateNpcEndGame), 4000);
        }

        private void CreateNpcEndGame()
        {
            //m_tempBoss.Die();
            SimpleNpc npc = ((PVEGame)Game).CreateNpc(npcId4, 179, 552, 1, 1, "standC", ((PVEGame)Game).BaseConfig());
            npc.PlayMovie("cool", 1000, 0);
            npc.Say("Thôi hãy rời khỏi đây mau. Chúa rồng đã sống lại rồi.", 0, 4000, 2000);
            Game.RemoveLiving(m_tempBoss.Id);
        }

        public override int UpdateUIData()
        {
            base.UpdateUIData();
            return m_kill;
            //return Game.TotalKillCount;
        }

        public override void OnGameOver()
        {
            base.OnGameOver();

            if (m_boss != null && m_boss.IsLiving == false)
            {
                Game.IsWin = true;
            }
            else
            {
                Game.IsWin = false;
            }
        }

        public override void DoOther()
        {
            base.DoOther();
        }

        public override void OnShooted()
        {
            base.OnShooted();
        }

        public override void OnDied()
        {
            base.OnDied();
            if (m_boss.IsLiving == false)
            {
                LivingConfig config = Game.BaseConfig();
                config.IsFly = true;
                config.CanTakeDamage = false;

                m_tempBoss = Game.CreateBoss(bossId, m_boss.X, m_boss.Y, m_boss.Direction, 1, "", config);
                Game.RemoveLiving(m_boss.Id);

                Game.SendHideBlood(m_tempBoss, 0);
                m_tempBoss.MoveTo(1000, 485, "fly", Game.GetWaitTimerLeft(), 10, CreateEffectEndGame);
            }
        }
    }
}
