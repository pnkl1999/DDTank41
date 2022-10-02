using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class ETN3101 : AMissionControl
    {
        private List<SimpleNpc> SomeNpc = new List<SimpleNpc>();

        private SimpleBoss boss = null;

        private int redTotalCount = 0;

        private int redNpcID = 3101;

        private int blueNpcID = 3104;

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
            int[] resources = { blueNpcID, redNpcID };
            Game.AddLoadingFile(1, "bombs/58.swf", "tank.resource.bombs.Bomb58");
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(resources);
            Game.SetMap(1122);
        }

        public override void OnStartGame()
        {
            base.OnStartGame();
            Game.IsBossWar = "3101";
            if (Game.GetLivedLivings().Count == 0)
            {
                Game.PveGameDelay = 0;
            }

            for (int i = 0; i < 4; i++)
            {
                redTotalCount++;

                if (i < 1)
                {
                    SomeNpc.Add(Game.CreateNpc(redNpcID, 900 + (i + 1) * 100, 444, 1, -1));
                }
                else if (i < 2)
                {
                    SomeNpc.Add(Game.CreateNpc(redNpcID, 920 + (i + 1) * 100, 444, 1, -1));
                }
                else
                {
                    SomeNpc.Add(Game.CreateNpc(redNpcID, 1000 + (i + 1) * 100, 444, 1, -1));
                }
            }

            redTotalCount++;
            boss = Game.CreateBoss(blueNpcID, 1300, 444, -1, 1,"");
            boss.FallFrom(boss.X, boss.Y, "", 0, 0, 1000, null);
        }

        public override void OnNewTurnStarted()
        {
            base.OnNewTurnStarted();
            if (Game.GetLivedLivings().Count == 0)
                Game.PveGameDelay = 0;
            if (Game.TurnIndex <= 1 || Game.GetLivedLivings().Count >= 4)
                return;
            for (int index = 0; index < 4; ++index)
            {
                if (redTotalCount < 15)
                {
                    redTotalCount++;
                    if (index < 1)
                        SomeNpc.Add(Game.CreateNpc(redNpcID, 900 + (index + 1) * 100, 444, -1, 1));
                    else if (index < 2)
                        SomeNpc.Add(Game.CreateNpc(redNpcID, 920 + (index + 1) * 100, 444, -1, 1));
                    else
                        SomeNpc.Add(Game.CreateNpc(redNpcID, 1000 + (index + 1) * 100, 444, -1, 1));
                }
            }
            if (redTotalCount < 15 && !boss.IsLiving)
            {
                redTotalCount++;
                boss = Game.CreateBoss(blueNpcID, 1300, 444, -1, 1, "");
                boss.FallFrom(boss.X, boss.Y, "", 0, 0, 1000, null);
            }
        }
        
        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
        }

        public override bool CanGameOver()
        {
            //bool result = true;
            base.CanGameOver();

            if (Game.GetLivedLivings().Count != 0 || boss.IsLiving || Game.TotalKillCount != 15)
                return false;

            Game.IsWin = true;
            if (Game.TurnIndex > Game.MissionInfo.TotalTurn - 1)
            {
                return true;
            }

            return true;
        }

        public override int UpdateUIData()
        {
            return Game.TotalKillCount;
        }

        public override void OnGameOver()
        {
            base.OnGameOver();
            if (Game.GetLivedLivings().Count == 0 && boss != null && boss.IsLiving == false)
            {
                Game.IsWin = true;
            }
            else
            {
                Game.IsWin = false;
            }
            List<LoadingFileInfo> loadingFileInfos = new List<LoadingFileInfo>();
            loadingFileInfos.Add(new LoadingFileInfo(2, "image/map/show2.jpg", ""));
            Game.SendLoadResource(loadingFileInfos);
        }
    }
}
