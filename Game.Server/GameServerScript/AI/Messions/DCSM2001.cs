using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class DCSM2001 : AMissionControl
    {
        private List<SimpleNpc> someNpc = new List<SimpleNpc>();

        private int dieRedCount = 0;

        private int[] npcIDs = { 2001, 2002 };

        private int[] birthX = { 52, 115, 183, 253, 320, 1206, 1275, 1342, 1410, 1475 };

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
            int[] resources = { npcIDs[0], npcIDs[1] };
            int[] gameOverResources = { npcIDs[1], npcIDs[0], npcIDs[0], npcIDs[0] };
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(gameOverResources);
            Game.SetMap(1120);
        }

        public override void OnStartGame()
        {           
            base.OnStartGame();
            Game.IsBossWar = "2001";
            //左边五只小怪
            int index = Game.Random.Next(0, npcIDs.Length);
            someNpc.Add(Game.CreateNpc(npcIDs[index], 52, 206, 1,1));
            index = Game.Random.Next(0, npcIDs.Length);
            someNpc.Add(Game.CreateNpc(npcIDs[index], 100, 207, 1, 1));
            index = Game.Random.Next(0, npcIDs.Length);
            someNpc.Add(Game.CreateNpc(npcIDs[index], 155, 208, 1, 1));
            index = Game.Random.Next(0, npcIDs.Length);
            someNpc.Add(Game.CreateNpc(npcIDs[index], 210, 207, 1, 1));
            index = Game.Random.Next(0, npcIDs.Length);
            someNpc.Add(Game.CreateNpc(npcIDs[index], 253, 207, 1, 1));

            //右边五只小怪
            index = Game.Random.Next(0, npcIDs.Length);
            someNpc.Add(Game.CreateNpc(npcIDs[index], 1275, 208, 1, -1));
            index = Game.Random.Next(0, npcIDs.Length);
            someNpc.Add(Game.CreateNpc(npcIDs[index], 1325, 206, 1, -1));
            index = Game.Random.Next(0, npcIDs.Length);
            someNpc.Add(Game.CreateNpc(npcIDs[index], 1360, 208, 1, -1));
            index = Game.Random.Next(0, npcIDs.Length);
            someNpc.Add(Game.CreateNpc(npcIDs[index], 1410, 206, 1, -1));
            index = Game.Random.Next(0, npcIDs.Length);
            someNpc.Add(Game.CreateNpc(npcIDs[index], 1475, 208, 1, -1));
        }

        public override void OnNewTurnStarted()
        {
            base.OnNewTurnStarted();

            if (Game.GetLivedLivings().Count == 0)
            {
                Game.PveGameDelay = 0;
            }

            if (Game.TurnIndex > 1 && (Game.CurrentPlayer == null || Game.CurrentPlayer.Delay > Game.PveGameDelay))
            {
                if (Game.GetLivedLivings().Count < 10)
                {
                    for (int i = 0; i < 10 - Game.GetLivedLivings().Count; i++)
                    {
                        if (someNpc.Count == Game.MissionInfo.TotalCount)
                        {
                            break;
                        }
                        else
                        {
                            int index = Game.Random.Next(0, birthX.Length);
                            int NpcX = birthX[index];
                            
                            index = Game.Random.Next(0, npcIDs.Length);

                            if (index == 1 && GetNpcCountByID(npcIDs[1]) < 10)
                            {
                                someNpc.Add(Game.CreateNpc(npcIDs[1], NpcX, 506, 1, 1));
                            }
                            else
                            {
                                someNpc.Add(Game.CreateNpc(npcIDs[0], NpcX, 506, 1, 1));
                            }
                        }
                    }
                }
            }

        }
        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
        }

        public override bool CanGameOver()
        {
            bool result = true;

            base.CanGameOver();

            dieRedCount = 0;

            foreach (SimpleNpc redNpc in someNpc)
            {
                if (redNpc.IsLiving)
                {
                    result = false;
                }
                else
                {
                    dieRedCount++;
                }
            }

            if (result && dieRedCount == Game.MissionInfo.TotalCount)
            {
                Game.IsWin = true;
                return true;
            }

            return false;
        }

        public override int UpdateUIData()
        {
            return Game.TotalKillCount;
        }

        //public override void OnPrepareGameOver()
        //{
        //    base.OnPrepareGameOver();
        //}

        public override void OnGameOver()
        {
            base.OnGameOver();
            if (Game.GetLivedLivings().Count == 0)
            {
                Game.IsWin = true;
                List<LoadingFileInfo> loadingFileInfos = new List<LoadingFileInfo>();
                loadingFileInfos.Add(new LoadingFileInfo(2, "image/map/2/show2", ""));
                Game.SendLoadResource(loadingFileInfos);
            }
            else
            {
                Game.IsWin = false;
            }
            
           
        }

        protected int GetNpcCountByID(int Id)
        {
            int Count = 0;
            foreach (SimpleNpc npc in someNpc)
            {
                if (npc.NpcInfo.ID == Id)
                    Count++;
            }
            return Count;
        }
    }
}
