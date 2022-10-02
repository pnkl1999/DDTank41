using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using Bussiness.Managers;
using SqlDataProvider.Data;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class Labyrinth40018 : AMissionControl
    {
        private SimpleBoss boss = null;

        private SimpleBoss m_boss = null;

        private List<SimpleNpc> someNpc = new List<SimpleNpc>();

        private int bossID2 = 5302;

        private int bossID = 40024;
        private int Delay = 0;
        private int kill = 0;

        private PhysicalObj moive;

        private PhysicalObj m_moive;

        private PhysicalObj m_front;

        public override int CalculateScoreGrade(int score)
        {
            base.CalculateScoreGrade(score);
            if (score > 1870)
            {
                return 3;
            }
            else if (score > 1825)
            {
                return 2;
            }
            else if (score > 1780)
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
            int[] resources = { bossID, bossID2 };
            int[] gameOverResource = { bossID };
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(gameOverResource);
            Game.AddLoadingFile(2, "image/game/effect/5/minigun.swf", "asset.game.4.minigun");
            Game.AddLoadingFile(2, "image/game/effect/5/jinqud.swf", "asset.game.4.jinqud");
            Game.AddLoadingFile(2, "image/game/effect/5/zap.swf", "asset.game.4.zap");

            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.gebulinzhihuiguanAsset");
            Game.AddLoadingFile(1, "bombs/56.swf", "tank.resource.bombs.Bomb56");
            Game.AddLoadingFile(1, "bombs/72.swf", "tank.resource.bombs.Bomb72");
            Game.SetMap(1274);
        }

        public override void OnStartGame()
        {
            base.OnStartGame();
            m_moive = Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 1);
            m_front = Game.Createlayer(1131, 650, "font", "game.asset.living.gebulinzhihuiguanAsset", "out", 1, 1);
            moive = Game.Createlayer(1567, 810, "moive", "asset.game.4.jinqud", "out", 1, 0);
            m_boss = Game.CreateBoss(bossID2, 190, 365, 1, 1, "");
            boss = Game.CreateBoss(bossID, 1477, 768, -1, 0, "");
            boss.SetRelateDemagemRect(-110, -179, 220, 180);
            m_boss.SetRelateDemagemRect(-42, -200, 84, 104);
            boss.PlayMovie("in", 0, 2000);
            m_boss.PlayMovie("in", 4000, 2000);
            m_boss.PlayMovie("in", 0, 2000);
            m_moive.PlayMovie("in", 6000, 0);
            m_front.PlayMovie("in", 6100, 0);
            m_moive.PlayMovie("out", 10000, 1000);
            m_front.PlayMovie("out", 9900, 0);       
        }

        public override void OnNewTurnStarted()
        {
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
            if (Game.TurnIndex > Game.MissionInfo.TotalTurn - 1)
            {
                return true;
            }
            if (boss != null && !boss.IsLiving)
            {
                if (Game.CanEnterGate)
                {
                    return true;
                }                
                kill++;
                Game.CanShowBigBox = true;                               
            }
            return false;
        }
        
        public override int UpdateUIData()
        {
            base.UpdateUIData();
            return kill;
        }

        public override void OnGameOverMovie()
        {
            base.OnGameOverMovie();
            if (boss != null && boss.IsLiving == false)
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
            if (boss.IsLiving)
            {
                if (boss.Y == 659)
                {
                    boss.SetXY(1477, 659);
                    boss.SetXY(1477, 759);
                    boss.CallFuction(new LivingCallBack(kill1), 100);
                }
                else if (boss.Y == 559)
                {
                    boss.SetXY(1477, 559);
                    boss.SetXY(1477, 759);
                    boss.CallFuction(new LivingCallBack(kill2), 100);
                }
                else if (boss.Y == 459)
                {
                    boss.SetXY(1477, 459);
                    boss.SetXY(1477, 759);
                    boss.CallFuction(new LivingCallBack(kill3), 100);
                }
                else if (boss.Y == 359)
                {
                    boss.SetXY(1477, 359);
                    boss.SetXY(1477, 759);
                    boss.CallFuction(new LivingCallBack(kill4), 100);
                }
                else if (boss.Y == 259)
                {
                    boss.SetXY(1477, 259);
                    boss.SetXY(1477, 759);
                    boss.CallFuction(new LivingCallBack(kill5), 100);
                }
            }
        }

        private void kill1()
        {
            Delay += 155;
            boss.PlayMovie("cryA", 1000 + Delay, 0);
            boss.SetXY(1477, 659);
        }
        private void kill2()
        {
            Delay += 155;
            boss.PlayMovie("cryB", 1000 + Delay, 0);
            boss.SetXY(1477, 559);
        }
        private void kill3()
        {
            Delay += 155;
            boss.PlayMovie("cryC", 1000 + Delay, 0);
            boss.SetXY(1477, 459);
        }
        private void kill4()
        {
            Delay += 155;
            boss.PlayMovie("cryD", 1000 + Delay, 0);
            boss.SetXY(1477, 359);
        }
        private void kill5()
        {
            Delay += 155;
            boss.PlayMovie("cryE", 1000 + Delay, 0);
            boss.SetXY(1477, 259);
        }
        
    }
}
