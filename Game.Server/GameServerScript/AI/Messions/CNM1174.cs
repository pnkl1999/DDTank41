using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using SqlDataProvider.Data;
using Game.Logic.Effects;
namespace Game.Server.GameServerScript.AI.Messions
{
    public class CNM1174 : AMissionControl
    {
        public override int CalculateScoreGrade(int score)
        {
            base.CalculateScoreGrade(score);
            if (score > 2045)
            {
                return 3;
            }
            else if (score > 2035)
            {
                return 2;
            }
            else if (score > 2025)
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
            Game.SetMap(1074);
        }
        //public override void OnPrepareStartGame()
        //{
        //    base.OnPrepareStartGame();
        //    Game.TotalTurn = Game.PlayerCount * 3;
        //    Game.SendMissionInfo();

        //}


        public override void OnStartGame()
        {
            base.OnStartGame();

            #region 生成箱子
            List<ItemInfo> items = new List<ItemInfo>();
            for (int boxCount = 0; boxCount < 54; boxCount++)
            {
                List<ItemInfo> infos = null;
                if (boxCount > 9)
                {
                    DropInventory.SpecialDrop(Game.MissionInfo.Id, 1, ref infos);  //黄箱（9~80）
                }
                else
                {
                    DropInventory.SpecialDrop(Game.MissionInfo.Id, 2, ref infos);  //红箱（0~8）
                }
                if (infos != null)
                {
                    foreach (ItemInfo info in infos)
                    {
                        items.Add(info);
                    }
                }
                else
                {
                    items.Add(null);
                }
            }
            #endregion

            //"1"黄色箱子、"2"红色箱子
            Game.CreateBox(455, 88, "2", items[0]);
            Game.CreateBox(555, 88, "2", items[1]);
            Game.CreateBox(655, 88, "2", items[2]);
            Game.CreateBox(755, 88, "2", items[3]);
            Game.CreateBox(855, 88, "2", items[4]);
            Game.CreateBox(955, 88, "2", items[5]);
            Game.CreateBox(1055, 88, "2", items[6]);
            Game.CreateBox(1155, 88, "2", items[7]);
            Game.CreateBox(1255, 88, "2", items[8]);

            Game.CreateBox(450, 184, "1", items[9]);
            Game.CreateBox(450, 259, "1", items[10]);
            Game.CreateBox(450, 335, "1", items[11]);
            Game.CreateBox(450, 420, "1", items[12]);
            Game.CreateBox(450, 504, "1", items[13]);


            Game.CreateBox(550, 184, "1", items[14]);
            Game.CreateBox(550, 259, "1", items[15]);
            Game.CreateBox(550, 335, "1", items[16]);
            Game.CreateBox(550, 420, "1", items[17]);
            Game.CreateBox(550, 504, "1", items[18]);


            Game.CreateBox(650, 184, "1", items[19]);
            Game.CreateBox(650, 259, "1", items[20]);
            Game.CreateBox(650, 335, "1", items[21]);
            Game.CreateBox(650, 420, "1", items[22]);
            Game.CreateBox(650, 504, "1", items[23]);


            Game.CreateBox(750, 184, "1", items[24]);
            Game.CreateBox(750, 259, "1", items[25]);
            Game.CreateBox(750, 335, "1", items[26]);
            Game.CreateBox(750, 420, "1", items[27]);
            Game.CreateBox(750, 504, "1", items[28]);


            Game.CreateBox(850, 184, "1", items[29]);
            Game.CreateBox(850, 259, "1", items[30]);
            Game.CreateBox(850, 335, "1", items[31]);
            Game.CreateBox(850, 420, "1", items[32]);
            Game.CreateBox(850, 504, "1", items[33]);


            Game.CreateBox(950, 184, "1", items[34]);
            Game.CreateBox(950, 259, "1", items[35]);
            Game.CreateBox(950, 335, "1", items[36]);
            Game.CreateBox(950, 420, "1", items[37]);
            Game.CreateBox(950, 504, "1", items[38]);

            Game.CreateBox(1050, 184, "1", items[39]);
            Game.CreateBox(1050, 259, "1", items[40]);
            Game.CreateBox(1050, 335, "1", items[41]);
            Game.CreateBox(1050, 420, "1", items[42]);
            Game.CreateBox(1050, 504, "1", items[43]);


            Game.CreateBox(1150, 184, "1", items[44]);
            Game.CreateBox(1150, 259, "1", items[45]);
            Game.CreateBox(1150, 335, "1", items[46]);
            Game.CreateBox(1150, 420, "1", items[47]);
            Game.CreateBox(1150, 504, "1", items[48]);


            Game.CreateBox(1250, 189, "1", items[49]);
            Game.CreateBox(1250, 259, "1", items[50]);
            Game.CreateBox(1250, 335, "1", items[51]);
            Game.CreateBox(1250, 420, "1", items[52]);
            Game.CreateBox(1250, 504, "1", items[53]);


            Game.BossCardCount = 1;

        }


        public override void OnNewTurnStarted()
        {
            base.OnNewTurnStarted();

            ((Player)Game.CurrentLiving).Seal((Player)Game.CurrentLiving, 0, 0);

        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            ((Player)Game.CurrentLiving).SetBall(3);

        }

        public override bool CanGameOver()
        {
            base.CanGameOver();
            return Game.TurnIndex > Game.TotalTurn - 1;
        }

        public override int UpdateUIData()
        {
            return base.UpdateUIData();
        }



        public override void OnGameOver()
        {
            base.OnGameOver();
            Game.IsWin = true;

            //foreach (Player player in Game.GetAllFightPlayers())
            //{
            //    player.OffSeal(player, 0);
            //}
            foreach (Player player in Game.GetAllFightPlayers())
            {
                SealEffect effect = (SealEffect)player.EffectList.GetOfType(eEffectType.SealEffect);
                if (effect != null)
                    effect.Stop();
            }
            List<LoadingFileInfo> loadingFileInfos = new List<LoadingFileInfo>();
            loadingFileInfos.Add(new LoadingFileInfo(2, "image/map/show4.jpg", ""));
            Game.SendLoadResource(loadingFileInfos);
        }
    }
}
