using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;
using Bussiness.Managers;
using Game.Server.Statics;
using Game.Logic;
using Game.Base.Packets;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class NTM1083 : AMissionControl
    {
        private int mapId = 2013;

        //private int indexOf = 0;
        //private bool isDander = false;

        private int CaptainNpcID = 23003;//NewTrainingBoss23003
        private int blueNpcID = 21001;//NewTrainingNpc21001
        private int totalNpcCount = 3;

        //private bool isPlayMovie = false;
        //private bool isLoadItems = false;

        //private PhysicalObj tip = null;
        private List<SimpleNpc> simpleNpcList = new List<SimpleNpc>();

        public override int CalculateScoreGrade(int score)
        {
            base.CalculateScoreGrade(score);
            if (score > 900)
            {
                return 3;
            }
            if (score > 825)
            {
                return 2;
            }
            if (score > 725)
            {
                return 1;
            }
            return 0;
        }

        public override void OnPrepareNewSession()
        {
            base.OnPrepareNewSession();
            int[] npcIdList = { CaptainNpcID, blueNpcID };
            Game.LoadResources(npcIdList);
            Game.LoadNpcGameOverResources(npcIdList);
            //Game.AddLoadingFile(2, "flash/ui/vietnam/swf/trainer2.swf", "asset.trainer.getOne");
            Game.SetMap(mapId);
        }

        public override void OnStartGame()
        {
            CreateNpc();
            //tip = Game.CreateTip(390, 120, "firstFront", "com.map.trainer.TankTrainerAssetII", "Empty", 1, 1);
        }

        //public override void OnPrepareNewGame()
        //{
        //    base.OnPrepareNewGame();
        //}

        public override void OnNewTurnStarted()
        {
            /*
            List<ItemInfo> items = new List<ItemInfo>();
            List<ItemTemplateInfo> goods = new List<ItemTemplateInfo>();
            
            if (Game.CurrentPlayer.Delay < Game.PveGameDelay)
            {
                if (tip.CurrentAction == "Empty")
                {
                    tip.PlayMovie("tip1", 0, 3000);
                }

                if (Game.TotalKillCount >= 1 && indexOf < 1)
                {
                    isLoadItems = true;
                    tip.PlayMovie("tip2", 0, 2000);
                    indexOf++;
                }
                if (isPlayMovie)
                {
                    bool isHiden = false;
                    tip.PlayMovie("tip3", 0, 2000);
                    foreach (Player p in Game.GetAllFightPlayers())
                    {
                        if (p.Dander < 200)
                        {
                            isHiden = true;
                            break;
                        }
                    }
                    if (isHiden)
                        tip.PlayMovie("tip4", 0, 2000);
                }

                if (isLoadItems)
                {
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
                            player.PlayerDetail.AddTemplate(item, eBageType.FightBag, item.Count);
                        }

                        if (isDander == false)
                        {
                            player.Dander = 200;
                            isPlayMovie = true;
                            isDander = true;

                        }
                    }
                    isLoadItems = false;
                }
              
            }
             */
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
        }

        public override bool CanGameOver()
        {
            foreach (SimpleNpc npc in simpleNpcList)
            {
                if (npc.IsLiving)
                { return false; }
            }
            if (simpleNpcList.Count == totalNpcCount)
            { return true; }
            else
            { return false; }
        }

        public override int UpdateUIData()
        {
            base.UpdateUIData();
            return Game.TotalKillCount;
        }

        public override void OnGameOver()
        {
            base.OnGameOver();
            foreach (Player p in Game.GetAllFightPlayers())
            {
               p.CanGetProp = true;
               
            }
            if (Game.GetLivedLivings().Count == 0)
            {
                Game.IsWin = true;
            }
            else
            {
                Game.IsWin = false;
            }
        }
        private void CreateNpc()
        {
            simpleNpcList.Add(Game.CreateNpc(blueNpcID, 775, 553, 1, 1));
        }
    }
}
