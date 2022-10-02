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
    public class Labyrinth40023 : AMissionControl
    {
        private List<SimpleNpc> someNpc = new List<SimpleNpc>();

        private int kill = 0;

        private int npcIDs = 40031;

        private int[] birthX = { 1010, 990, 960, 940, 920, 800, 880, 860, 840, 820 };

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
            int[] resources = { npcIDs };
            int[] gameOverResources = { npcIDs };
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(gameOverResources);;
            Game.SetMap(1283);
        }
       
        public override void OnStartGame()
        {

            base.OnStartGame();
            //左边五只小怪
            for (int i = 0; i < birthX.Length; i++)
            {
                someNpc.Add(Game.CreateNpc(npcIDs, birthX[i], 200, 1, -1));
            }
            
        }

        public override void OnNewTurnStarted()
        {
            base.OnNewTurnStarted();
        }
        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
        }
        
        public override bool CanGameOver()
        {
            bool result = true;

            base.CanGameOver();
            if (Game.TurnIndex > Game.MissionInfo.TotalTurn - 1)
            {
                return true;
            }
            kill = 0;

            foreach (SimpleNpc redNpc in someNpc)
            {
                if (redNpc.IsLiving)
                {
                    result = false;
                }
                else
                {
                    kill++;
                }
            }

            if (result && kill == Game.MissionInfo.TotalCount)
                Game.CreateGate(true);

            return result;
        }
        
        public override int UpdateUIData()
        {
            return Game.TotalKillCount;
        }

        public override void OnGameOverMovie()
        {
            base.OnGameOverMovie();
            if (Game.GetLivedLivings().Count == 0)
            {
                Game.IsWin = true;               
            }
            else
            {
                Game.IsWin = false;
            }
        }
      
        public override void OnGameOver()
        {
            base.OnGameOver();
            
        }
        
    }
}
