using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class CHM1277 : AMissionControl
    {
        private SimpleBoss m_king = null;

        private int m_kill = 0;
        
        private int bossID = 1207;

        private int npcID = 1204;

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

            m_king = Game.CreateBoss(bossID, 890, 590, -1, 0, "");
            m_king.FallFrom(890, 590, "fall", 0, 2, 1000);
            m_king.SetRelateDemagemRect(-41, -187, 83, 140);
            m_king.AddDelay(16);
            /*
            int i = 0;
            foreach (Player player in Game.GetAllFightPlayers())
            {
                player.Direction = 1;
                player.SetXY((i + 1) * 100, 520);
                i++;
            }
            m_preKing = Game.CreateBoss(21, 600, 510, -1, 0);
            m_preKing.Say("啊~~我的头好痛……为什么我会在这里！？炸弹王马迪亚斯呢？………..我记起来了。", 1000);
            m_preKing.Say("感谢你们高贵的勇士，我是啵咕国王尼尔鲁奥要不是有你们的帮助，我可能永远也无法摆脱马迪亚斯的控制。", 3000);
            m_preKing.Say("几年前炸弹人向啵咕国发动战争，在一次战斗中我不小心中了炸弹王马迪亚斯的诡计被他用精神枷锁诅咒控制。", 5000);
            m_preKing.Say("在刚刚和你们的战斗中他的诅咒被破坏，才让我重获自由！ 时间不多了他也肯定感知到诅咒的消失，可能正赶往这里！", 7000);
            m_preKing.Say("马迪亚斯非常强大，现在的我非常虚弱可能抵挡不了多久，在他赶来之前请你们赶快离开这里！", 9000);
             */
        }

        public override void OnNewTurnStarted()
        {
            base.OnNewTurnStarted();
            /*
            m_king = Game.CreateBoss(23, 750, 510, -1, 0);
            m_king.SetRelateDemagemRect(-41, -187, 83, 140);
            m_king.Say("尼尔鲁奥没想到你竟然能打破我的精神枷锁！", 3000);
            m_king.Say("原来是这样….果然是借助了某种外力。我给你最后一次机会，臣服于我或者被永远的放逐到无尽的虚空中承受痛苦？", 3000);
            m_king.AddDelay(16);
             */
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
        }

        public override bool CanGameOver()
        {

            if (m_king.IsLiving == false)
            {
                m_kill++;
                m_king.PlayMovie("die", 0, 200);
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

    }
}
