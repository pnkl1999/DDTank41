using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using Bussiness;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class DCN4103 : AMissionControl
    {
        private SimpleBoss m_king = null;

        private int bossID = 4108; // Minotaur

        private int npcId = 4107; // lua di nguc

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
            int[] resources = { bossID, npcId };
            int[] gameOverResource = { bossID };
            Game.AddLoadingFile(2, "image/game/effect/4/power.swf", "game.crazytank.assetmap.Buff_powup");
            Game.AddLoadingFile(2, "image/game/effect/4/blade.swf", "asset.game.4.blade");
            Game.AddLoadingFile(2, "image/game/thing/bossbornbgasset.swf", "game.asset.living.BossBgAsset");
            Game.AddLoadingFile(2, "image/game/thing/bossbornbgasset.swf", "game.asset.living.tingyuanlieshouAsset");
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(gameOverResource);
            Game.SetMap(1144);
        }

        public override void OnStartGame()
        {
            base.OnStartGame();

            LivingConfig config = Game.BaseConfig();
            config.IsShield = true;

            m_moive = Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 0);
            m_front = Game.Createlayer(1019, 620, "front", "game.asset.living.emozhanshiAsset", "out", 1, 0);

            m_king = Game.CreateBoss(bossID, 1255, 958, -1, 1, "born", config);
            m_king.SetRelateDemagemRect(m_king.NpcInfo.X, m_king.NpcInfo.Y, m_king.NpcInfo.Width, m_king.NpcInfo.Height);

            //Game.SendFreeFocus(m_king, 1, 100, 0);

            m_king.CallFuction(new LivingCallBack(MovieCreateBoss), 1000);
        }

        private void MovieCreateBoss()
        {
            Game.SendObjectFocus(m_king, 1, 500, 0);

            m_king.PlayMovie("in", 2000, 0);
            Game.SendObjectFocus(m_king, 2, 2000, 3000);
            m_king.PlayMovie("standA", 9000, 0);
            m_king.Say("Ngọn lửa sôi sục đang cháy trong ta!", 0, 9200);

            m_moive.PlayMovie("in", 13000, 0);
            m_front.PlayMovie("in", 13200, 0);
            m_moive.PlayMovie("out", 16200, 0);
            m_front.PlayMovie("out", 16000, 0);
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
            if (m_king != null && m_king.IsLiving == false)
                return true;

            if (Game.TotalTurn > Game.MissionInfo.TotalTurn)
                return true;

            return false;
        }

        public override int UpdateUIData()
        {
            base.UpdateUIData();
            return Game.TotalKillCount;
        }

        public override void OnGameOver()
        {
            base.OnGameOver();
            if (m_king != null && m_king.IsLiving == false)
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
