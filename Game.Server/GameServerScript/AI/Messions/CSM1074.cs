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
    public class CSM1074 : AMissionControl
    {
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
            Game.SetMap(1074);
        }

        public override void OnStartGame()
        {
            base.OnStartGame();
            
            Game.TotalTurn = Game.PlayerCount * 3;
   
            Game.SendMissionInfo(null);

            List<ItemInfo> items = new List<ItemInfo>();

            for (int i = 0; i < 24; i++)
            {
                List<ItemInfo> infos = null;
                DropInventory.SpecialDrop(1074, 2, ref infos);
                if (infos != null)
                {
                    foreach (ItemInfo info in infos)
                    {
                        items.Add(info);
                    }
                }
            }

            //"1"黄色箱子、"2"红色箱子
            Game.CreateBox(550, 68, "2", items[0]);
            Game.CreateBox(750, 68, "2", items[1]);
            Game.CreateBox(932, 68, "2", items[2]);
            Game.CreateBox(1104, 68, "2", items[3]);

            Game.CreateBox(451, 184, "1", items[4]);
            Game.CreateBox(451, 285, "1", items[5]);
            Game.CreateBox(451, 394, "1", items[6]);
            Game.CreateBox(451, 499, "1", items[7]);
            Game.CreateBox(643, 184, "1", items[8]);
            Game.CreateBox(643, 285, "1", items[9]);
            Game.CreateBox(643, 394, "1", items[10]);
            Game.CreateBox(643, 499, "1", items[11]);
            Game.CreateBox(830, 184, "1", items[12]);
            Game.CreateBox(830, 285, "1", items[13]);
            Game.CreateBox(830, 394, "1", items[14]);
            Game.CreateBox(830, 499, "1", items[15]);
            Game.CreateBox(1022, 184, "1", items[16]);
            Game.CreateBox(1022, 285, "1", items[17]);
            Game.CreateBox(1022, 394, "1", items[18]);
            Game.CreateBox(1022, 499, "1", items[19]);
            Game.CreateBox(1201, 184, "1", items[20]);
            Game.CreateBox(1201, 285, "1", items[21]);
            Game.CreateBox(1201, 394, "1", items[22]);
            Game.CreateBox(1201, 499, "1", items[23]);
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

            foreach (Player player in Game.GetAllFightPlayers())
            {
                SealEffect effect = (SealEffect)player.EffectList.GetOfType(eEffectType.SealEffect);
                if (effect != null)
                    effect.Stop();
            }

            List<LoadingFileInfo> loadingFileInfos = new List<LoadingFileInfo>();
            loadingFileInfos.Add(new LoadingFileInfo(2, "image/map/show5.jpg", ""));
            Game.SendLoadResource(loadingFileInfos);
        }
    }
}
