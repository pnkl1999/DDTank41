using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class CSM1073 : AMissionControl
    {
        private SimpleBoss m_boss;
        private PhysicalObj m_moive;
        private PhysicalObj m_front;
        private int IsSay = 0;
        private int bossID = 1003;
        private int npcID = 1009;
        private static string[] KillChat = new string[]{
           "送你回老家！",

           "就凭你还妄想能够打败我？"
        };

        private static string[] ShootedChat = new string[]{
            "哎呦！很痛…",

            "我还顶的住…"
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
            //Game.AddLoadingFile(1, "bombs/61.swf", "tank.resource.bombs.Bomb61");
            Game.AddLoadingFile(2, "image/bomb/blastout/blastout61.swf", "bullet61");
            Game.AddLoadingFile(2, "image/bomb/bullet/bullet61.swf", "bullet61");          
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.boguoLeaderAsset");
            int[] resources = { bossID, npcID };
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(resources);
            Game.SetMap(1073);
            //Game.IsBossWar = "啵咕队长";
        }

        public override void OnStartGame()
        {
            base.OnStartGame();
            m_moive = Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 0);
            m_front = Game.Createlayer(680, 330, "font", "game.asset.living.boguoLeaderAsset", "out", 1, 0);
            m_boss = Game.CreateBoss(bossID, 770, -1500, -1, (int)eLivingType.SimpleBoss1, "");

            m_boss.FallFrom(770, 301, "fall", 0, 2, 1000);
            m_boss.SetRelateDemagemRect(34, -35, 11, 18);
            m_boss.AddDelay(10);
            m_boss.Say("你们胆敢闯入我的地盘，准备受死吧！", 0, 6000);
            m_boss.PlayMovie("call", 5900, 0);
            m_moive.PlayMovie("in", 9000, 0);
            m_boss.PlayMovie("weakness", 10000, 5000);
            m_front.PlayMovie("in", 9000, 0);
            m_moive.PlayMovie("out", 15000, 0);

            //设置本关卡为Boss关卡，关卡胜利后，玩家可以翻一张牌
            Game.BossCardCount = 1;
        }

        public override void OnNewTurnStarted()
        {
            base.OnNewTurnStarted();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            IsSay = 0;
            if (Game.TurnIndex > 1)
            {
                if (m_moive != null)
                {
                    Game.RemovePhysicalObj(m_moive, true);
                    m_moive = null;
                }
                if (m_front != null)
                {
                    Game.RemovePhysicalObj(m_front, true);
                    m_front = null;
                }
            }
        }

        public override bool CanGameOver()
        {
            if (Game.TurnIndex > Game.MissionInfo.TotalTurn - 1)
            {
                return true;
            }
            base.CanGameOver();

            if (Game.TurnIndex > Game.MissionInfo.TotalTurn - 1)
            {
                return true;
            }

            if (m_boss.IsLiving == false)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public override int UpdateUIData()
        {

            if (m_boss == null)
                return 0;

            if (m_boss.IsLiving == false)
            {
                return 1;
            }
            return base.UpdateUIData();
        }

        public override void OnGameOver()
        {
            base.OnGameOver();

            if (m_boss.IsLiving == false)
            {
                Game.IsWin = true;
            }
            else
            {
                Game.IsWin = false;
            }

            //List<LoadingFileInfo> loadingFileInfos = new List<LoadingFileInfo>();
            //loadingFileInfos.Add(new LoadingFileInfo(2, "image/map/show4.jpg", ""));
            //Game.SendLoadResource(loadingFileInfos);
        }

        public override void DoOther()
        {
            base.DoOther();
            if (m_boss == null)
                return;
            int index = Game.Random.Next(0, KillChat.Length);
            if (m_boss == null)
                return;
            m_boss.Say(KillChat[index], 0, 0);

        }

        public override void OnShooted()
        {
            if (m_boss == null)
                return;
            if (m_boss.IsLiving && IsSay == 0)
            {
                int index = Game.Random.Next(0, ShootedChat.Length);
                m_boss.Say(ShootedChat[index], 0, 1500);
                IsSay = 1;
            }

        }
    }
}
