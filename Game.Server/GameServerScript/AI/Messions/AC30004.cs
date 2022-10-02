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
    public class AC30004 : AMissionControl
    {
        private SimpleBoss boss = null;

        private int bossID = 30004;
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
            int[] resources = { bossID };
            int[] gameOverResource = { bossID };
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(gameOverResource);
            Game.AddLoadingFile(2, "image/game/effect/0/294b.swf", "asset.game.zero.294b");
            Game.AddLoadingFile(1, "bombs/24.swf", "tank.resource.bombs.Bomb24");
            Game.AddLoadingFile(1, "bombs/25.swf", "tank.resource.bombs.Bomb25");
            Game.SetMap(1303);            
        }
       
        public override void OnStartGame()
        {
            base.OnStartGame();
            LivingConfig config = Game.BaseConfig();
            config.IsFly = false;
            config.IsWorldBoss = true;
            boss = Game.CreateBoss(bossID, 1379, 681, -1, 1, "", config);
            boss.SetRelateDemagemRect(boss.NpcInfo.X, boss.NpcInfo.Y, boss.NpcInfo.Width, boss.NpcInfo.Height);  
            boss.Say(LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.Messions.DCSM2002.msg1"), 0, 200, 0);
            List<Player> players = Game.GetAllFightPlayers();
            foreach (Player player in players)
            {
                player.ChangeSpecialBall = 25;
            }               
        }

        public override void OnNewTurnStarted()
        {
            base.OnNewTurnStarted();
            
        }
        public override void OnShooted()
        {
            base.OnShooted();

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