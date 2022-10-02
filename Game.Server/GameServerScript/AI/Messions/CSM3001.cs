using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;
using Bussiness.Managers;
using Game.Server.Statics;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class CSM3001: AMissionControl
    {
        private List<SimpleNpc> SomeNpc = new List<SimpleNpc>();
        private SimpleBoss boss = null;
        private PhysicalObj Tip = null;

        private bool result = false;

        private int killCount = 0;

        private int preKillNum = 0;

        private bool canPlayMovie = false;

        public override int CalculateScoreGrade(int score)
        {
            base.CalculateScoreGrade(score);
            if (score > 900)
            {
                return 3;
            }
            else if (score > 825)
            {
                return 2;
            }
            else if (score > 725)
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
            //Game.AddLoadingFile(2, "image/map/1086/object/Asset.swf", "com.map.trainer.TankTrainerAssetII");
            Game.AddLoadingFile(1, "bombs/51.swf", "tank.resource.bombs.Bomb51");
            Game.AddLoadingFile(1, "bombs/17.swf", "tank.resource.bombs.Bomb17");
            Game.AddLoadingFile(1, "bombs/18.swf", "tank.resource.bombs.Bomb18");
            Game.AddLoadingFile(1, "bombs/19.swf", "tank.resource.bombs.Bomb19");
            Game.AddLoadingFile(1, "bombs/67.swf", "tank.resource.bombs.Bomb67");
            //Game.AddLoadingFile(1, "bombs/67.swf", "tank.resource.bombs.Bomb67");
            //Game.AddLoadingFile(1, "bombs/52.swf", "tank.resource.bombs.Bomb52");
            //Game.AddLoadingFile(1, "bombs/53.swf", "tank.resource.bombs.Bomb53");
            int[] resources = {3001,3003,3004,3005};
            Game.LoadResources(resources);

            Game.LoadNpcGameOverResources(resources);
            Game.SetMap(1089);
        }

        public override void OnStartGame()
        {
            base.OnStartGame();
            //for (int i = 0; i < 4; i++)
            //{
            //    SomeNpc.Add(Game.CreateNpc(3005, (i + 1) * 100, 100, 1));
            //}
            boss = Game.CreateBoss(3005, 2000, 1200, -1, 1, "");
            boss.SetRelateDemagemRect(-42, -200, 84, 194);
            //SomeNpc.Add(Game.CreateNpc(3005, 2000, 100, 1));
             //SomeNpc.Add(Game.CreateNpc(3003, 300, 200, 1));
            turnCount=1;
           
        }
        public  int  turnCount;
        public override void OnNewTurnStarted()
        {
            List<ItemTemplateInfo> goods = new List<ItemTemplateInfo>();

            List<ItemInfo> items = new List<ItemInfo>();

            //foreach (Player player in Game.GetAllFightPlayers())
            //{
            //    foreach (SimpleNpc npc in Game.GetLivedLivings())
            //    {
            //        if (npc.Distance(player.X, player.Y) <= 100)
            //        {
            //            canPlayMovie = true;
            //        }
            //    }
            //}
            //turnCount++;
            //switch (turnCount)
            //{
            //    case 2:
                   
            //        break;
            //    case 3:
            //        break;
            //    case 4:
            //        break;

            //}
            #region
            if (Game.TurnIndex > 1 && (Game.CurrentPlayer == null || Game.CurrentPlayer.Delay > Game.PveGameDelay))
            {
                for (int i = 0; i < 3; i++)
                {
                    if (SomeNpc.Count < 7)
                    {
                        if (turnCount % 2 == 0)
                        {

                            SomeNpc.Add(Game.CreateNpc(3003, (i + 1) * 50, boss.Y - 50, 1, 1));
                        }
                        else
                        {
                            SomeNpc.Add(Game.CreateNpc(3003, (i + 1) * 50 + 500, boss.Y - 50, 1, 1));
                        }
                        turnCount++;
                    }
                    else
                    {
                        break;
                    }
                }
            }
            #endregion
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
        }

        public override bool CanGameOver()
        {
            base.CanGameOver();
            if (Game.TurnIndex > 99)
            {
                return true;
            }

            result = false;

            foreach (SimpleNpc npc in SomeNpc)
            {
                if (npc.IsLiving == true)
                {
                    result = true;
                }
            }

            if (result == false && SomeNpc.Count == 15)
            {
                return true;
            }
            return false;
        }

        public override int UpdateUIData()
        {
            preKillNum = Game.TotalKillCount;
            return Game.TotalKillCount;
        }

        public override void OnGameOver()
        {
            if (result == false)
            {
                foreach (Player player in Game.GetAllFightPlayers())
                {
                    player.CanGetProp = true;
                }
                Game.IsWin = true;
            }
        }
    }
}
