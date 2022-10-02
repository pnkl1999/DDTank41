using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class DLEpic5402 : AMissionControl
    {
        private SimpleBoss m_boss = null;

        private SimpleNpc m_helper = null;

        private SimpleBoss m_npcRight = null;

        private SimpleBoss m_npcLeft = null;

        private SimpleNpc m_npcBottom = null;

        private SimpleNpc m_npcCenter = null;

        private SimpleNpc m_npc = null;

        private PhysicalObj m_kingMoive;

        private PhysicalObj m_kingFront;

        private List<PhysicalObj> m_targetEffect = new List<PhysicalObj>();

        private PhysicalObj m_wallBlock;

        private int m_kill = 0;

        private int bossId = 5414;

        private int npcId = 5411;

        private int npcLeftId = 5412;

        private int npcRightId = 5413;

        private int npcBottomId = 5416;

        private int npcCenterId = 5417;

        private int npcHelperId = 5404;

        private int m_map = 1152;

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
            Game.AddLoadingFile(2, "image/game/effect/5/jinqudan.swf", "asset.game.4.jinqudan"); //tia set mau xanh
            Game.AddLoadingFile(2, "image/game/effect/5/mubiao.swf", "asset.game.4.mubiao"); // target effect
            Game.AddLoadingFile(2, "image/game/effect/5/zao.swf", "asset.game.4.zao"); // vong bao ve
            Game.AddLoadingFile(2, "image/game/effect/5/xiaopao.swf", "asset.game.4.xiaopao"); // bom
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.gebulinzhihuiguanAsset");

            int[] resources = { bossId, npcLeftId, npcRightId, npcBottomId, npcCenterId, npcHelperId, npcId };
            Game.LoadResources(resources);
            int[] gameOverResources = { bossId };
            Game.LoadNpcGameOverResources(gameOverResources);
            Game.SetMap(m_map);
        }

        public override void OnStartGame()
        {
            base.OnStartGame();
            CreateBossAndNpc();
            CreateEffectBegin();
        }

        private void CreateBossAndNpc()
        {
            m_kingMoive = Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 1);
            m_kingFront = Game.Createlayer(1300, 413, "front", "game.asset.living.gebulinzhihuiguanAsset", "out", 1, 1);


            m_boss = Game.CreateBoss(bossId, 1478, 596, -1, 1, "born", Game.BaseConfig());
            m_boss.SetRelateDemagemRect(m_boss.NpcInfo.X, m_boss.NpcInfo.Y, m_boss.NpcInfo.Width, m_boss.NpcInfo.Height);
            m_boss.Config.CanTakeDamage = false;
            //m_boss.Config.IsFly = true;
            Game.SendHideBlood(m_boss, 0);

            m_wallBlock = Game.Createlayer(m_boss.X, m_boss.Y, "", "asset.game.4.zao", "stand", 1, 1);

            // left npc
            m_npcLeft = Game.CreateBoss(npcLeftId, 1323, 663, -1, 1, "", Game.BaseConfig());
            m_npcLeft.SetRelateDemagemRect(m_npcLeft.NpcInfo.X, m_npcLeft.NpcInfo.Y, m_npcLeft.NpcInfo.Width, m_npcLeft.NpcInfo.Height);
            m_npcLeft.Config.HasTurn = false;

            m_npcRight = Game.CreateBoss(npcRightId, 1664, 532, -1, 1, "", Game.BaseConfig());
            m_npcRight.SetRelateDemagemRect(m_npcRight.NpcInfo.X, m_npcRight.NpcInfo.Y, m_npcRight.NpcInfo.Width, m_npcRight.NpcInfo.Height);
            m_npcRight.Config.HasTurn = false;

            m_npcBottom = Game.CreateNpc(npcBottomId, 1360, 840, 1, -1, Game.BaseConfig());
            m_npcBottom.Config.HasTurn = false;
            m_npcBottom.OnSmallMap(false);
            Game.SendHideBlood(m_npcBottom, 0);

            m_npcCenter = Game.CreateNpc(npcCenterId, 1546, 650, 1, -1, Game.BaseConfig());
            m_npcCenter.Config.HasTurn = false;
            m_npcCenter.OnSmallMap(false);
            Game.SendHideBlood(m_npcCenter, 0);
            //m_kingMoive.PlayMovie("in", 0, 0);

            m_npc = Game.CreateNpc(npcId, 503, 831, 1, 1, Game.BaseConfig());
            m_npc.Config.HasTurn = true;
            m_npc.Config.CanTakeDamage = false;
            m_npc.OnSmallMap(false);
            Game.SendHideBlood(m_npc, 0);
        }

        private void CreateEffectBegin()
        {
            //1022, 828
            m_helper = Game.CreateNpc(npcHelperId, 1022, 828, 0, 1, "standB");
            Game.SendObjectFocus(m_helper, 1, 1000, 0);
            m_helper.Say("Ê, hãy nếm thử sức mạnh này!", 0, 2000);
            m_helper.PlayMovie("beatA", 2000, 0);

            Game.SendObjectFocus(m_npcBottom, 1, 4000, 0);
            m_npcBottom.PlayMovie("beatA", 5000, 0);
            m_helper.PlayMovie("outB", 7000, 0);
            m_helper.Die(10000);

            Game.SendObjectFocus(m_boss, 1, 10000, 0);
            m_boss.PlayMovie("beatC", 10500, 0);
            m_kingMoive.PlayMovie("in", 11000, 0);
            m_kingFront.PlayMovie("in", 11000, 0);

            m_kingMoive.PlayMovie("out", 16000, 6000);
            m_kingFront.PlayMovie("out", 16000, 6000);
            m_boss.CallFuction(new LivingCallBack(CreateTargetEffect), 17000);
        }

        private void CreateTargetEffect()
        {
            m_targetEffect.Add(Game.Createlayer(m_boss.X, m_boss.Y, "", "asset.game.4.mubiao", "", 1, 1));
            m_targetEffect.Add(Game.Createlayer(m_npcLeft.X, m_npcLeft.Y, "", "asset.game.4.mubiao", "", 1, 1));
            m_targetEffect.Add(Game.Createlayer(m_npcRight.X, m_npcRight.Y, "", "asset.game.4.mubiao", "", 1, 1));

        }

        private void RemoveShield()
        {
            if (m_wallBlock != null)
            {
                Game.RemovePhysicalObj(m_wallBlock, true);
            }
        }


        public override void OnNewTurnStarted()
        {
            base.OnNewTurnStarted();
            if (m_npcLeft.IsLiving == false && m_npcRight.IsLiving == false)
            {
                Game.SendObjectFocus(m_wallBlock, 1, 1000, 0);
                m_wallBlock.PlayMovie("die", 2000, 2000);
                m_boss.Config.CanTakeDamage = true;
            }
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
            if (m_targetEffect.Count > 0)
            {
                foreach (PhysicalObj phy in m_targetEffect)
                    Game.RemovePhysicalObj(phy, true);

                m_targetEffect = new List<PhysicalObj>();
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
        }

    }
}
