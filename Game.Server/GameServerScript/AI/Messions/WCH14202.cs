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
    public class WCH14202 : AMissionControl
    {
        private SimpleNpc goal = null;
        private SimpleBoss boss = null;
        private int npcID = 14103;
        private int chillID = 14104;
        private int bossID = 14105;
        private int goalID = 14106;
        private int kill = 0;

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
        private int[] birthX = { 1650, 1590, 1530 };
        public override void OnPrepareNewSession()
        {
            base.OnPrepareNewSession();
            int[] resources = { bossID, npcID, goalID, chillID };
            int[] gameOverResource = resources;
            Game.LoadResources(resources);
            Game.AddLoadingFile(1, "bombs/109.swf", "tank.resource.bombs.Bomb109");
            Game.AddLoadingFile(1, "bombs/14005.swf", "tank.resource.bombs.Bomb14005");
            Game.AddLoadingFile(2, "image/game/living/living371.swf", "game.living.Living371");
            Game.LoadNpcGameOverResources(gameOverResource);
            Game.SetMap(1406);			
        }
        private List<SimpleNpc> someNpc = new List<SimpleNpc>();
        public override void OnStartGame()
        {
            base.OnStartGame();
            Game.AddAction(new CallFunctionAction(AddBoss, 2000)); 
            LivingConfig config = Game.BaseConfig();
            config.IsHelper = true;
            config.HasTurn = false;
            goal = Game.CreateNpc(goalID, 117, 720, 1, 1, config);
            Game.SendGameFocus(goal, 0, 1000);
            
        }        
        private void AddBoss()
        {
            boss = Game.CreateBoss(bossID, 1816, 861, -1, 1, "");
            Game.SendGameFocus(boss, 0, 1000);
            boss.SetRelateDemagemRect(boss.NpcInfo.X, boss.NpcInfo.Y, boss.NpcInfo.Width, boss.NpcInfo.Height);
            Game.AddAction(new CallFunctionAction(AddNpc, 3000));
        }
        private void AddNpc()
        {
            for (int i = 0; i < birthX.Length; i++)
            {
                someNpc.Add(Game.CreateNpc(npcID, birthX[i], 790, 1, -1));
            }
        }
        
        public override void OnNewTurnStarted()
        {
            base.OnNewTurnStarted();
            int die = 0;
            foreach (SimpleNpc npc in someNpc)
            {
                if (!npc.IsLiving)
                    die++;
            }
            if (someNpc.Count - die < 3)
            {
                for (int i = 0; i < die; i++)
                {
                    int pos = Game.Random.Next(birthX.Length);
                    someNpc.Add(Game.CreateNpc(npcID, birthX[pos], 790, 1, -1));
                }
            }
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();           
        }

        public override bool CanGameOver()
        {
            if (Game.TurnIndex > Game.MissionInfo.TotalTurn - 1)
            {
                return true;
            }
            if (Game.IsMissBall)
            {
                return true;
            }
            if (boss != null && boss.IsLiving == false)
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

        public override void OnGameOver()
        {
            base.OnGameOver();

            if (boss != null && boss.IsLiving == false && !Game.IsMissBall)
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