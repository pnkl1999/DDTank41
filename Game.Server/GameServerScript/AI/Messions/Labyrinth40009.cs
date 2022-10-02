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
    public class Labyrinth40009 : AMissionControl
    {
        private List<SimpleNpc> someNpc = new List<SimpleNpc>();
        private int kill = 0;

        private int npcID1 = 40010;

        private int npcID2 = 40011;

        private int[] birthX = { 1110, 1090, 1060, 1040, 1020, 1000, 1050, 1310 };

        public override int CalculateScoreGrade(int score)
        {
            base.CalculateScoreGrade(score);
            if (score > 1870)
                return 3;
            else if (score > 1825)
                return 2;
            else if (score > 1780)
                return 1;
            else
                return 0;
        }

        public override void OnPrepareNewSession()
        {
            base.OnPrepareNewSession();
            int[] resources = { npcID1, npcID2 };
            int[] gameOverResources = { npcID1, npcID2 };
            //Game.AddLoadingFile(2, "image/bomb/blastOut/blastOut58.swf", "bullet58");
            //Game.AddLoadingFile(2, "image/bomb/bullet/bullet58.swf", "bullet58");
            Game.AddLoadingFile(1, "bombs/58.swf", "tank.resource.bombs.Bomb58");
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(gameOverResources);           
            Game.SetMap(1222);
        }
       
        public override void OnStartGame()
        {

            base.OnStartGame();
            //左边五只小怪
            for (int i = 0; i < birthX.Length; i++)
            {
                if (i < 6)
                    someNpc.Add(Game.CreateNpc(npcID1, birthX[i], 430, 1, -1));
                else
                {
                    someNpc.Add(Game.CreateNpc(npcID2, birthX[i], 430, 1, -1));
                    someNpc.Add(Game.CreateNpc(npcID2, birthX[i] + 10, 430, 1, -1));
                }

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

            foreach (SimpleNpc npc in someNpc)
            {
                if (npc.IsLiving)
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
