using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class CNM1177 : AMissionControl
    {
        private SimpleBoss m_king = null;

        private int m_kill = 0;

        private int IsSay = 0;

        private int bossID = 1107;

        private int npcID = 1104;
        private static string[] KillChat = new string[]{
           "灭亡是你唯一的归宿！",                  
 
            "太不堪一击了！"
        };

        private static string[] ShootedChat = new string[]{
            "哎哟～你打的我好疼啊！<br/>啊哈哈哈哈！",
               
            "你们就只有这点本事？！",
               
            "哼～有点意思了"
        };
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
            int[] resources = { npcID, bossID };
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(resources);
            Game.SetMap(1076);
            //Game.IsBossWar = "炸弹人王";
        }

        public override void OnStartGame()
        {
            base.OnStartGame();
            m_king = Game.CreateBoss(bossID, 750, 510, -1, 0, "");

            m_king.SetRelateDemagemRect(-41, -187, 83, 140);
            m_king.Say("你们知道的太多了，我不能让你们继续活着！", 0, 3000);
            m_king.AddDelay(16);
        }

        public override void OnNewTurnStarted()
        {
            base.OnNewTurnStarted();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            IsSay = 0;
        }

        public override bool CanGameOver()
        {

            if (m_king.IsLiving == false)
            {
                m_kill++;
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
            return m_kill;
        }

        public override void OnGameOver()
        {
            base.OnGameOver();
            bool IsAllPlayerDie = true;
            foreach (Player player in Game.GetAllFightPlayers())
            {
                if (player.IsLiving == true)
                {
                    IsAllPlayerDie = false;
                }
            }
            if (m_king.IsLiving == false && IsAllPlayerDie == false)
            {
                Game.IsWin = true;
            }
            else
            {
                Game.IsWin = false;
            }

            //List<LoadingFileInfo> loadingFileInfos = new List<LoadingFileInfo>();
            //loadingFileInfos.Add(new LoadingFileInfo(2, "image/map/8", ""));
            //Game.SendLoadResource(loadingFileInfos);
        }

        public override void DoOther()
        {
            base.DoOther();
            if (m_king == null)
                return;
            int index = Game.Random.Next(0, KillChat.Length);
            m_king.Say(KillChat[index], 0, 0);

        }

        public override void OnShooted()
        {
            if (m_king.IsLiving && IsSay == 0)
            {
                int index = Game.Random.Next(0, ShootedChat.Length);
                m_king.Say(ShootedChat[index], 0, 1500);
                IsSay = 1;
            }

        }
    }
}
