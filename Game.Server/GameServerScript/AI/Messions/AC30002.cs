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
    public class AC30002 : AMissionControl
    {
        private SimpleBoss boss = null;
        private SimpleBoss boss2 = null;
        private int m_state = 30002;
        private int bossID1 = 30002;
        private int bossID2 = 30003;
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
            int[] resources = { bossID1 };
            int[] gameOverResource = { bossID1 };
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(gameOverResource);
            Game.AddLoadingFile(2, "image/game/effect/0/294b.swf", "asset.game.zero.294b");
            Game.SetMap(1250);			
        }
       
        public override void OnStartGame()
        {
            base.OnStartGame();
            LivingConfig config = Game.BaseConfig();
            config.IsFly = true;
            config.IsWorldBoss = true;
            boss = Game.CreateBoss(bossID1, 944, 581, -1, 0, "", config);
            boss.SetRelateDemagemRect(boss.NpcInfo.X, boss.NpcInfo.Y, boss.NpcInfo.Width, boss.NpcInfo.Height);  
            boss.Say(LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.Messions.DCSM2002.msg1"), 0, 200, 0);
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
            if (Game.TurnIndex > Game.MissionInfo.TotalTurn - 1)
            {
                return true;
            }

            if (!boss.IsLiving)
            {
                if (m_state == bossID1)
                    m_state++;
            }

            if (m_state == bossID2 && boss2 == null)
            {
                boss2 = Game.CreateBoss(m_state, boss.X, boss.Y, boss.Direction, 0, "");
                Game.RemoveLiving(boss.Id);
                if (boss2.Direction == 1)
                    boss2.SetRect(boss.NpcInfo.X, boss.NpcInfo.Y, boss.NpcInfo.Width, boss.NpcInfo.Height);

                boss2.SetRelateDemagemRect(boss.NpcInfo.X, boss.NpcInfo.Y, boss.NpcInfo.Width, boss.NpcInfo.Height);
                List<Player> players = Game.GetAllFightPlayers();
                Player RandomPlayer = Game.FindRandomPlayer();
                int minDelay = 0;

                if (RandomPlayer != null)
                    minDelay = RandomPlayer.Delay;

                foreach (Player player in players)
                {
                    if (player.Delay < minDelay)
                        minDelay = player.Delay;
                }

                boss2.AddDelay(minDelay - 2000);
            }
            //if (boss != null && boss.IsLiving && RoomMgr.WorldBossRoom.IsDie)
            //{
            //    boss.PlayMovie("die", 100, 0);
            //    kill++;
            //    return true;
            //}
            //else if (boss != null && !boss.IsLiving)
            if (boss != null && !boss.IsLiving)
            {
                kill++;
                return true;
            }
            return false;
        }

        public override int UpdateUIData()
        {
            base.UpdateUIData();
            return kill;
        }

        //public override void OnPrepareGameOver()
        //{
        //    base.OnPrepareGameOver();
        //}

        public override void OnGameOver()
        {
            base.OnGameOver();
            //if (boss != null && boss.IsLiving && RoomMgr.WorldBossRoom.IsDie)
            //{
            //    Game.IsWin = true;
            //    Game.IsKillWorldBoss = false;
            //}
            //else if (boss != null && !boss.IsLiving)
            if (boss != null && !boss.IsLiving)
            {
                Game.IsWin = true;
            }
            else
            {
                Game.IsWin = false;
                Game.IsKillWorldBoss = false;
            }
            List<Player> players = Game.GetAllFightPlayers();
            foreach (Player p in players)
            {
                p.PlayerDetail.UpdatePveResult("worldboss", p.TotalDameLiving, Game.IsWin);
            }
        }
    }
}