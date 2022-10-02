using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;
using Bussiness.Managers;
using Game.Server.Statics;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class CSM1083 : AMissionControl
    {
        private List<SimpleNpc> SomeNpc = new List<SimpleNpc>();

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
            Game.AddLoadingFile(2, "image/map/1086/object/Asset.swf", "com.map.trainer.TankTrainerAssetII");
            int[] resources = {1, 2};
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(resources);
            Game.SetMap(1086);
        }

        public override void OnStartGame()
        {
            base.OnStartGame();
            for (int i = 0; i < 4; i++)
            {
                SomeNpc.Add(Game.CreateNpc(201, (i + 1) * 100, 500, 1,1));
            }
            SomeNpc.Add(Game.CreateNpc(202, 500, 500, 1, 1));
            Tip = Game.CreateTip(390, 120, "firstFront", "com.map.trainer.TankTrainerAssetII", "Empty", 1, 0);
        }

        public override void OnNewTurnStarted()
        {
            List<ItemTemplateInfo> goods = new List<ItemTemplateInfo>();

            List<ItemInfo> items = new List<ItemInfo>();

            foreach (Player player in Game.GetAllFightPlayers())
            {
                foreach (SimpleNpc npc in Game.GetLivedLivings())
                {
                    if (npc.Distance(player.X, player.Y) <= 100)
                    {
                        canPlayMovie = true;
                    }
                }
            }

            if (Game.TurnIndex > 1 && (Game.CurrentPlayer == null || Game.CurrentPlayer.Delay > Game.PveGameDelay))
            {
                for (int i = 0; i < 5; i++)
                {
                    if (SomeNpc.Count < 15)
                    {
                        SomeNpc.Add(Game.CreateNpc(201, (i + 1) * 100, 500, 1, 1));
                    }
                    else
                    {
                        break;
                    }
                }


            }

            if (Game.CurrentPlayer.Delay < Game.PveGameDelay)
            {
                if (Tip.CurrentAction == "Empty")
                {
                    Tip.PlayMovie("tip1", 0, 3000);
                }
                if (preKillNum < Game.TotalKillCount && killCount < 2)
                {
                    killCount++;
                }

                if (killCount == 2)
                {
                    Tip.PlayMovie("tip2", 0, 2000);
                }

                if (canPlayMovie)
                {
                    Tip.PlayMovie("tip3", 0, 2000);
                }

                goods.Add(Bussiness.Managers.ItemMgr.FindItemTemplate(10001));
                goods.Add(Bussiness.Managers.ItemMgr.FindItemTemplate(10003));
                goods.Add(Bussiness.Managers.ItemMgr.FindItemTemplate(10018));

                foreach (ItemTemplateInfo info in goods)
                {
                    items.Add(ItemInfo.CreateFromTemplate(info, 1, 101));
                }

                foreach (Player player in Game.GetAllFightPlayers())
                {
                    player.CanGetProp = false;
                    player.PlayerDetail.ClearFightBag();
                    foreach (ItemInfo item in items)
                    {
                        player.PlayerDetail.AddTemplate(item, eBageType.FightBag, item.Count, eGameView.dungeonTypeGet);
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
