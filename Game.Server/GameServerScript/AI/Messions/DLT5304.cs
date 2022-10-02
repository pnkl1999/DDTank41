using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class DLT5304 : AMissionControl
    {
        private List<PhysicalObj> phyObjects = new List<PhysicalObj>();

        private SimpleBoss m_boss = null;

        private SimpleBoss m_npcHelper = null;

        private PhysicalObj m_kingMoive;

        private PhysicalObj m_kingFront;

        private int m_kill = 0;

        private int bossId = 5331;

        private int npcId = 5332;

        private int npcHelperId1 = 5333; // nha tham hiem

        private int npcHelperId2 = 5334; // pha le

        private int m_map = 1154;

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
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.hongpaoxiaoemoAsset");
            Game.AddLoadingFile(2, "image/game/effect/5/cuipao.swf", "asset.game.4.cuipao"); //hieu ung khi bi thoi bay
            Game.AddLoadingFile(2, "image/game/effect/5/guang.swf", "asset.game.4.guang"); //ultil hong
            Game.AddLoadingFile(2, "image/game/effect/5/da.swf", "asset.game.4.da"); //troi dat mau nau
            Game.AddLoadingFile(2, "image/game/effect/5/mubiao.swf", "asset.game.4.mubiao"); // target effect

            int[] resources = { bossId, npcHelperId1, npcHelperId2, npcId };
            Game.LoadResources(resources);
            int[] gameOverResources = { bossId };
            Game.LoadNpcGameOverResources(gameOverResources);
            Game.SetMap(m_map);
        }

        public override void OnStartGame()
        {
            base.OnStartGame();

            m_kingMoive = Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 1);
            m_kingFront = Game.Createlayer(1291, 257, "top", "game.asset.living.xieyanjulongAsset", "out", 1, 1);

            LivingConfig config = Game.BaseConfig();
            config.IsFly = true;

            m_boss = Game.CreateBoss(bossId, 1700, 480, -1, 1, "", config);
            m_boss.SetRect(-180, -90, 300, 100);
            m_boss.SetRelateDemagemRect(-60, -200, 116, 100);
            //m_boss.SetRect(-180, -100, 300, 100);
            //m_boss.SetRelateDemagemRect(-60, -200, 116, 91);
            Game.SendHideBlood(m_boss, 0);

            //start moving effect
            m_boss.CallFuction(new LivingCallBack(EffectCuiPao), 3300);
            m_boss.CallFuction(new LivingCallBack(MoveAllPlayer), 3300);
            m_boss.CallFuction(new LivingCallBack(SetDefaultSpeedMult), 6000);

            m_kingMoive.PlayMovie("in", 7000, 0);
            m_kingFront.PlayMovie("in", 7000, 0);

            m_kingMoive.PlayMovie("out", 10000, 0);
            m_kingFront.PlayMovie("out", 10000, 0);
            m_boss.CallFuction(new LivingCallBack(CreateHelperNpc), 11000);
            /*config = Game.BaseLivingConfig();
            config.IsFly = true;
            config.CanTakeDamage = false;
            m_npcHelper = Game.CreateBoss(npcHelperId1, 190, 250, 1, 1, "born", config);*/

            //m_kingMoive.PlayMovie("in", 0, 0);
        }

        private void CreateHelperNpc()
        {
            LivingConfig config = Game.BaseConfig();
            config.IsFly = true;
            config.CanTakeDamage = false;
            config.IsHelper = true;
            m_npcHelper = Game.CreateBoss(npcHelperId1, 190, 250, 1, 2, "", config);
            m_npcHelper.Delay += 1;
            Game.SendHideBlood(m_npcHelper, 0);
            m_npcHelper.Say("Đừng sợ. Đã có ta ở đây.", 0, 3000, 2000);
        }

        private void EffectCuiPao()
        {
            foreach (Player p in Game.GetAllLivingPlayers())
            {
                phyObjects.Add(Game.CreatePhysicalObj(0, 0, "top", "asset.game.4.cuipao", "", 1, 1, p.Id + 1));
            }
        }

        private void MoveAllPlayer()
        {
            foreach (Player p in Game.GetAllLivingPlayers())
            {
                p.SpeedMultX(18);
                p.StartSpeedMult(750 + Game.Random.Next(0, 50), p.Y, 0);
            }
        }

        private void SetDefaultSpeedMult()
        {
            foreach (Player p in Game.GetAllLivingPlayers())
            {
                p.SpeedMultX(3);
            }
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
            foreach (PhysicalObj obj in phyObjects)
            {
                Game.RemovePhysicalObj(obj, true);
            }
            phyObjects = new List<PhysicalObj>();
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
