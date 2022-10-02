using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class WAH13202 : AMissionControl
    {
        private int bossId = 13205;

        private int npcLeftId = 13203;

        private int npcRightId = 13204;

        private PhysicalObj m_moive;

        private PhysicalObj m_front;

        private PhysicalObj m_zhuzi;

        private SimpleBoss boss = null;

        private SimpleNpc npcLeft = null;

        private SimpleBoss npcRight = null;

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
            int[] resources = { bossId, npcRightId, npcLeftId };
            Game.AddLoadingFile(1, "bombs/55.swf", "tank.resource.bombs.Bomb55");

            Game.AddLoadingFile(2, "image/game/effect/10/tuteng.swf", "asset.game.ten.baozha"); // damage
            Game.AddLoadingFile(2, "image/game/effect/10/tuteng.swf", "asset.game.ten.jiaodu"); // lock
            Game.AddLoadingFile(2, "image/game/effect/10/tuteng.swf", "asset.game.ten.pilao"); // met
            Game.AddLoadingFile(2, "image/game/effect/10/jitan.swf", "asset.game.ten.jitan");
            Game.AddLoadingFile(2, "image/game/effect/10/gongfang.swf", "asset.game.ten.down");
            Game.AddLoadingFile(2, "image/game/effect/10/gongfang.swf", "asset.game.ten.up");
            Game.AddLoadingFile(2, "image/game/effect/10/zhuzi.swf", "asset.game.ten.zhuzi"); // 2 cot 2 ben

            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.ClanLeaderAsset");

            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(resources);
            Game.SetMap(1215);
        }

        public override void OnStartGame()
        {
            base.OnStartGame();

            m_zhuzi = Game.Createlayer(1150, 1041, "normal", "asset.game.ten.zhuzi", "1", 1, 0);

            m_moive = Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 0);
            m_front = Game.Createlayer(970, 750, "front", "game.asset.living.ClanLeaderAsset", "out", 1, 0);

            boss = Game.CreateBoss(bossId, 1290, 1013, -1, 1, "");
            boss.SetRelateDemagemRect(boss.NpcInfo.X, boss.NpcInfo.Y, boss.NpcInfo.Width, boss.NpcInfo.Height);

            Game.SendObjectFocus(boss, 0, 0, 0);

            boss.CallFuction(new LivingCallBack(CreateBossLeft), 2000);
        }

        private void CreateBossLeft()
        {
            LivingConfig config = Game.BaseConfig();
            config.CanTakeDamage = false;
            config.IsFly = true;
            config.HasTurn = false;

            npcLeft = Game.CreateNpc(npcLeftId, 701, 594, 1, 1, "", config);
            npcLeft.SetRelateDemagemRect(npcLeft.NpcInfo.X, npcLeft.NpcInfo.Y, npcLeft.NpcInfo.Width, npcLeft.NpcInfo.Height);

            Game.SendHideBlood(npcLeft, 0);

            Game.SendObjectFocus(npcLeft, 0, 0, 0);

            boss.CallFuction(CreateBossRight, 2000);

        }

        private void CreateBossRight()
        {
            LivingConfig config = Game.BaseConfig();
            config.CanTakeDamage = false;
            config.IsFly = true;

            npcRight = Game.CreateBoss(npcRightId, 1604, 594, -1, 1, "", config);
            npcRight.SetRelateDemagemRect(npcRight.NpcInfo.X, npcRight.NpcInfo.Y, npcRight.NpcInfo.Width, npcRight.NpcInfo.Height);

            npcRight.Delay = Game.GetHighDelayTurn() + 1;

            Game.SendHideBlood(npcRight, 0);

            Game.SendObjectFocus(npcRight, 0, 0, 0);

            Game.SendFreeFocus(1160, 860, 0, 2000, 0);

            m_moive.PlayMovie("in", 4000, 0);
            m_front.PlayMovie("in", 4200, 0);
            m_moive.PlayMovie("out", 7000, 0);
            m_front.PlayMovie("out", 7200, 0);
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

        private void MovieEndGame()
        {
            Game.SendObjectFocus(npcLeft, 1, 3000, 0);
            npcLeft.Say("Có lẽ nào đây là giá phải trả cho nghi thức tà thần?", 0, 4000);
            npcLeft.PlayMovie("die", 6000, 0);
            npcLeft.CallFuction(RemoveLeftNpc, 7700);

            Game.SendObjectFocus(npcRight, 1, 8000, 0);
            npcRight.Say("Các ngươi hãy đợi đấy. Ta sẽ còn quay lại..", 1, 9000);
            npcRight.PlayMovie("die", 12000, 3000);
            npcRight.CallFuction(RemoveRightNpc, 13700);
        }

        private void RemoveLeftNpc()
        {
            Game.RemoveLiving(npcLeft.Id);
        }

        private void RemoveRightNpc()
        {
            Game.RemoveLiving(npcRight.Id);
        }

        public override void OnShooted()
        {
            base.OnShooted();
            if (boss != null && boss.IsLiving == false)
            {
                int waitTimer = Game.GetWaitTimerLeft();
                boss.CallFuction(new LivingCallBack(MovieEndGame), waitTimer);
            }
        }

        public override int UpdateUIData()
        {
            return Game.TotalKillCount;
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
