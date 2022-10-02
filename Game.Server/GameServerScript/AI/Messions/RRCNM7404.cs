using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using Bussiness;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class RRCNM7404 : AMissionControl
    {
        private PhysicalObj m_kingMoive;

        private PhysicalObj m_kingFront;

        private PhysicalObj m_npc2;

        private SimpleBoss boss = null;

        private SimpleNpc npc = null;

        private int m_kill = 0;

        private int bossId = 7431; // chicken

        private int npcId = 7432; // long ga

        private int npcId2 = 7433; // trung thoi

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
            Game.AddLoadingFile(1, "bombs/83.swf", "tank.resource.bombs.Bomb83");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.choudanbenbenAsset");
            Game.AddLoadingFile(2, "image/game/effect/7/choud.swf", "asset.game.seven.choud");
            Game.AddLoadingFile(2, "image/game/effect/7/jinqucd.swf", "asset.game.seven.jinqucd");
            Game.AddLoadingFile(2, "image/game/effect/7/du.swf", "asset.game.seven.du");
            int[] resources = { bossId, npcId, npcId2 };
            Game.LoadResources(resources);
            int[] gameOverResources = { bossId };
            Game.LoadNpcGameOverResources(gameOverResources);

            Game.SetMap(1164);
        }

        public override void OnStartGame()
        {
            base.OnStartGame();
            m_kingMoive = Game.Createlayer(0, 0, "kingmoive", "game.asset.living.BossBgAsset", "out", 1, 1);
            m_kingFront = Game.Createlayer(300, 595, "font", "game.asset.living.choudanbenbenAsset", "out", 1, 1);

            // create npc2
            //Game.CreateNpc(npcId2, 2170, 636, 0, -1, config);
            m_npc2 = Game.Createlayer(2170, 636, "", "game.living.Living178", "stand", 1, 1);
            LivingConfig config = Game.BaseConfig();
            config.HasTurn = false;
            config.IsFly = true;

            npc = Game.CreateNpc(npcId, 1920, 900, 1, -1, config);

            npc.PlayMovie("stand", 1000, 0);
            npc.Say("Chúng mình không muốn bị lây bệnh. Cứu!! Cứu!!", 0, 2000);

            npc.CallFuction(new LivingCallBack(CreateBossEffect), 4000);
        }

        private void CreateBossEffect()
        {
            boss = Game.CreateBoss(bossId, 200, 590, 1, 1, "born");
            boss.SetRelateDemagemRect(boss.NpcInfo.X, boss.NpcInfo.Y, boss.NpcInfo.Width, boss.NpcInfo.Height);
            m_kingMoive.PlayMovie("in", 1000, 0);
            m_kingFront.PlayMovie("in", 2000, 0);
            m_kingMoive.PlayMovie("out", 5000, 0);
            m_kingFront.PlayMovie("out", 5400, 0);
            boss.Say("Định cứu gà con cuối cùng à? Không dễ vậy đâu.", 0, 6000);
            boss.PlayMovie("skill", 8000, 0);
            boss.Say("Giỏi thì phá lá chắn bảo vệ của ta.", 0, 8000);
            Game.SendObjectFocus(npc, 1, 9000, 0);
            npc.PlayMovie("standB", 10000, 0);
            npc.Config.CanTakeDamage = false;
            npc.Say("Chết phải hạ những quả trứng thối mới phá vỡ được lá chắn", 0, 11000);
            Game.SendObjectFocus(boss, 1, 13000, 0);
            boss.Say("Đã đến thì đừng hòng đi. Ta sẽ nhốt hết vào lồng.", 0, 14000, 3000);
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
        }

        public override bool CanGameOver()
        {
            if (boss != null && boss.IsLiving == false && npc != null && npc.IsLiving == false)
            {
                m_kill++;
                return true;
            }

            if (Game.TotalTurn > Game.MissionInfo.TotalTurn)
                return true;

            return false;
        }

        public override void OnDied()
        {
            base.OnDied();

            if (boss != null && boss.IsLiving == false && npc.IsLiving)
            {
                int waitTime = (int)Game.GetWaitTimerLeft();
                Game.SendObjectFocus(npc, 1, waitTime + 500, 500);
                npc.PlayMovie("out", waitTime + 1000, 0);
                npc.Say("Nhanh phá lồng cứu chúng tôi với...", 0, waitTime + 1500, 3500);
                npc.Config.CanTakeDamage = true;
            }
        }

        public override int UpdateUIData()
        {
            base.UpdateUIData();
            return m_kill;
        }

        public override void OnGameOver()
        {
            base.OnGameOver();
            if (boss != null && boss.IsLiving == false && npc != null && npc.IsLiving == false)
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
