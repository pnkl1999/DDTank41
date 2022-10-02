using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using Game.Logic.Actions;
using Bussiness;
using Game.Server.Rooms;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class QX70001 : AMissionControl
    {
        private SimpleBoss boss = null;
        private SimpleBoss lastBoss = null;
        private SimpleNpc npc = null;
        LivingConfig config;
        private int bossID = 0;
        private int m_state = 0;
        private int kill = 0;
        private int[] resources = { 70001, 70002, 70003, 70006, 70007, 70008, 70009, 70010, 70011, 70099 };
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
            //int[] gameOverResource = { bossID };
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(resources);
            Game.SetMap(1311);			
        }
        
        public override void OnStartGame()
        {
            base.OnStartGame();
            Game.AddAction(new CallFunctionAction(AddNpc, 2000));
            config = Game.BaseConfig();
            config.IsFly = true;
        }
        private void AddNpc()
        {
            config.HasTurn = false;
            npc = Game.CreateNpc(resources[9], 220, 630, 0, 1, config);
            Game.SendGameFocus(npc, 0, 1000);            
            npc.SetRelateDemagemRect(0, 0, 0, 0);
            npc.CallFuction(AddBoss, 3000);
        }
        private void AddBoss()
        {            
            m_state = resources[bossID];
            config.HasTurn = true;
            boss = Game.CreateBoss(m_state, 1120, 763, -1, 1, "", config);
            Game.SendGameFocus(boss, 0, 1000);
            boss.SetRelateDemagemRect(boss.NpcInfo.X, boss.NpcInfo.Y, boss.NpcInfo.Width, boss.NpcInfo.Height);
            bossID++;
        }

        public override void OnNewTurnStarted()
        {
            base.OnNewTurnStarted();           
        }     

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();           
        }
        private int MinDelay()
        {
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
            return minDelay;
        }
        private void AddNextBoss()
        {           
            Game.RemoveLiving(boss.Id);
            m_state = resources[bossID];
            if (bossID > 2 && bossID < 8)
            {
                config.IsFly = false;
            }
            else
            {
                config.IsFly = true;
            }
            boss = Game.CreateBoss(m_state, boss.X, boss.Y, boss.Direction, 1, "", config);
            if (boss.Direction == 1)
            {
                boss.SetRect(boss.NpcInfo.X, boss.NpcInfo.Y, boss.NpcInfo.Width, boss.NpcInfo.Height);
            }
            boss.AddDelay(MinDelay() - 2000);
            bossID++;
        }
        private void AddLastBoss()
        {
            Game.RemoveLiving(boss.Id);
            m_state = resources[bossID];
            lastBoss = Game.CreateBoss(m_state, boss.X, boss.Y, boss.Direction, 1, "");            
            if (lastBoss.Direction == 1)
            {
                lastBoss.SetRect(boss.NpcInfo.X, boss.NpcInfo.Y, boss.NpcInfo.Width, boss.NpcInfo.Height);
                lastBoss.SetRelateDemagemRect(boss.NpcInfo.X, boss.NpcInfo.Y, boss.NpcInfo.Width, boss.NpcInfo.Height);
            }
            lastBoss.AddDelay(MinDelay() - 2000);

        }
        public override bool CanGameOver()
        {
            if (Game.TurnIndex > Game.MissionInfo.TotalTurn - 1)
            {
                return true;
            }
            if (!boss.IsLiving && bossID < 8)
            {
                UpdateAward(boss.NpcInfo.DropId, boss.IsLiving);
                AddNextBoss();
            }
            if (m_state == resources[7] && !boss.IsLiving && lastBoss == null)
            {
                UpdateAward(boss.NpcInfo.DropId, boss.IsLiving);
                AddLastBoss();
            }
            if (lastBoss != null && !lastBoss.IsLiving)
            {
                UpdateAward(lastBoss.NpcInfo.DropId, lastBoss.IsLiving);
                kill++;
                return true;
            }
            return false;
        }
        private void UpdateAward(int dropID, bool IsLiving)
        {
            List<Player> players = Game.GetAllFightPlayers();
            foreach (Player p in players)
            {
                p.PlayerDetail.UpdatePveResult("qx", dropID, IsLiving);
            }
        }
               
        public override int UpdateUIData()
        {
            base.UpdateUIData();
            return kill;
        }      

        public override void OnGameOver()
        {
            base.OnGameOver();

            if (lastBoss != null && !lastBoss.IsLiving)
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