using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using Game.Logic.Actions;
using Bussiness;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class DLH5201 : AMissionControl
    {
        private SimpleBoss m_boss = null;

        private SimpleNpc m_helper = null;

        private SimpleNpc m_npc = null;

        private PhysicalObj m_specialEffect = null;

        private PhysicalObj m_dianEffect = null;

        private PhysicalObj m_kingMoive;

        private PhysicalObj m_kingFront;

        private int m_kill = 0;

        private int bossId = 5201; //quypuchi

        private int npcId1 = 5202; //nole

        private int npcId2 = 5203; //banh rang

        private int helperId = 5204; // nha tham hiem

        private int m_map = 1151;

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
            Game.AddLoadingFile(1, "bombs/56.swf", "tank.resource.bombs.Bomb56");
            Game.AddLoadingFile(1, "bombs/72.swf", "tank.resource.bombs.Bomb72");
            Game.AddLoadingFile(2, "image/game/effect/5/zap.swf", "asset.game.4.zap"); //tia set mau xanh
            Game.AddLoadingFile(2, "image/game/effect/5/zap2.swf", "asset.game.4.zap2"); // tia set mau hong
            Game.AddLoadingFile(2, "image/game/effect/5/dian.swf", "asset.game.4.dian"); // tia set xanh tu duoi len
            Game.AddLoadingFile(2, "image/game/effect/5/minigun.swf", "asset.game.4.minigun"); // na dan
            Game.AddLoadingFile(2, "image/game/effect/5/jinqud.swf", "asset.game.4.jinqud"); // tia dien
            Game.AddLoadingFile(2, "image/game/effect/5/xiaopao.swf", "asset.game.4.xiaopao"); //ban bomb
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.gebulinzhihuiguanAsset");

            int[] resources = { bossId, npcId1, npcId2, helperId };
            Game.LoadResources(resources);
            int[] gameOverResources = { bossId };
            Game.LoadNpcGameOverResources(gameOverResources);
            Game.SetMap(m_map);
        }

        public override void OnStartGame()
        {
            base.OnStartGame();

            m_kingMoive = Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 1);
            m_kingFront = Game.Createlayer(1172, 587, "front", "game.asset.living.gebulinzhihuiguanAsset", "out", 1, 1);

            LivingConfig config = Game.BaseConfig();
            config.IsFly = true;

            m_boss = Game.CreateBoss(bossId, 1484, 750, -1, 1, "born", config);
            Game.SendHideBlood(m_boss, 0);

            config = Game.BaseConfig();
            config.HasTurn = false;

            m_helper = Game.CreateNpc(helperId, 1287, 859, 0, 1, config);
            Game.SendHideBlood(m_helper, 0);

            //m_boss.PlayMovie("in", 1000, 5000);
            //m_kingMoive.PlayMovie("in", 0, 0);
            Game.SendObjectFocus(m_helper, 1, 700, 0);
            m_helper.Say("Haha, ta thích cái máy này!", 0, 2000);
            m_helper.MoveTo(1388, 867, "walk", 4000, 3, new LivingCallBack(StepAfterWalk));
        }

        private void StepAfterWalk()
        {
            m_specialEffect = Game.Createlayer(1470, 822, "", "asset.game.4.jinqud", "", 1, 1);

            m_dianEffect = Game.Createlayer(m_helper.X, m_helper.Y, "", "asset.game.4.dian", "", 1, 1);

            m_helper.PlayMovie("outA", 500, 2000);
            m_helper.Die(2500);

            m_boss.PlayMovie("in", 3000, 5000);

            m_kingMoive.PlayMovie("in", 5000, 0);
            m_kingFront.PlayMovie("in", 5200, 0);

            m_kingMoive.PlayMovie("out", 8000, 0);
            m_kingFront.PlayMovie("out", 8200, 0);

            m_boss.CallFuction(new LivingCallBack(CreateProtectNpc), 10000);
        }

        private void CreateProtectNpc()
        {
            LivingConfig config = Game.BaseConfig();
            config.HasTurn = false;
            config.CanTakeDamage = false;

            m_npc = Game.CreateNpc(npcId1, 187, 370, 1, 1, config);
            Game.SendLivingActionMapping(m_npc, "stand", "standA");

            // look npc
            Game.SendObjectFocus(m_npc, 1, 700, 0);
            m_npc.PlayMovie("in", 1500, 10000);
            m_npc.PlayMovie("walkA", 9000, 3000);
        }

        private void RemoveDianEffect()
        {
            if (m_dianEffect != null)
                Game.RemovePhysicalObj(m_dianEffect, true);
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
            RemoveDianEffect();
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

        private void CallActionEndGame()
        {
            m_helper = Game.CreateNpc(helperId, 243, 368, 0, 1);

            Game.SendObjectFocus(m_helper, 1, 0, 500);

            m_helper.Say("Đừng có để hắn trốn thoát.", 0, 1000);

            m_helper.Say("Grrr. Máy bị các ngươi làm hư cmnr.", 0, 3000, 2000);
        }

        public override void OnShooted()
        {
            base.OnShooted();

            if (m_boss != null && m_boss.IsLiving == false)
            {
                int waitTimer = Game.GetWaitTimerLeft();
                Game.ClearAllChild();
                m_boss.CallFuction(new LivingCallBack(CallActionEndGame), waitTimer + 3000);
            }
        }

        public override void OnDied()
        {
            base.OnDied();
        }
    }
}
