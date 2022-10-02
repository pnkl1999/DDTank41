using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class CSM1071 : AMissionControl
    {
        private List<SimpleNpc> SomeNpc = new List<SimpleNpc>();

        private int redTotalCount = 0;

        private int dieRedCount = 0;

        private int redNpcID = 1001;

        public override int CalculateScoreGrade(int score)
        {
            base.CalculateScoreGrade(score);
            if (score > 600)
            {
                return 3;
            }
            else if (score > 520)
            {
                return 2;
            }
            else if (score > 450)
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
            int[] resources = {1001};
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(resources);
            Game.SetMap(1072);
        }

        public override void OnStartGame()
        {
            base.OnStartGame();

            if (Game.GetLivedLivings().Count == 0)
            {
                Game.PveGameDelay = 0;
            }

            for (int i = 0; i < 4; i++)
            {
                redTotalCount++;

                if (i < 1)
                {
                    SomeNpc.Add(Game.CreateNpc(redNpcID, 900 + (i + 1) * 100, 505, 1, 1));
                }
                else if (i < 3)
                {
                    SomeNpc.Add(Game.CreateNpc(redNpcID, 920 + (i + 1) * 100, 505, 1, 1));
                }
                else
                {
                    SomeNpc.Add(Game.CreateNpc(redNpcID, 1000 + (i + 1) * 100, 515, 1, 1));
                }
            }

            redTotalCount++;
            SomeNpc.Add(Game.CreateNpc(redNpcID, 1467, 495, 1, 1));
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
                for (int i = 0; i < 4; i++)
                {
                    if (redTotalCount < 15)
                    {
                        redTotalCount++;

                        if (i < 1)
                        {
                            SomeNpc.Add(Game.CreateNpc(redNpcID, 900 + (i + 1) * 100, 505, 1, 1));
                        }
                        else if (i < 3)
                        {
                            SomeNpc.Add(Game.CreateNpc(redNpcID, 920 + (i + 1) * 100, 505, 1, 1));
                        }
                        else
                        {
                            SomeNpc.Add(Game.CreateNpc(redNpcID, 1000 + (i + 1) * 100, 515, 1, 1));
                        }
                    }
                }

                if (redTotalCount < 15)
                {
                    redTotalCount++;
                    SomeNpc.Add(Game.CreateNpc(redNpcID, 1467, 495, 1, 1));
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
            
            foreach (SimpleNpc redNpc in SomeNpc)
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

            if (result && dieRedCount == 15)
            {
                Game.IsWin = true;
                return true;
            }
            

            if (Game.TurnIndex > Game.MissionInfo.TotalTurn - 1)
            {
                return true;
            }

            return false;
        }

        public override int UpdateUIData()
        {
            return Game.TotalKillCount;
        }

        public override void OnGameOver()
        {
            base.OnGameOver();
            if (Game.GetLivedLivings().Count == 0)
            {
                Game.IsWin = true;
            }
            else
            {
                Game.IsWin = false;
            }
            List<LoadingFileInfo> loadingFileInfos = new List<LoadingFileInfo>();
            loadingFileInfos.Add(new LoadingFileInfo(2, "image/map/2", ""));
            Game.SendLoadResource(loadingFileInfos);
        }
    }
}
