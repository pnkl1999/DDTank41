using Game.Logic.AI;
using Game.Logic.Phy.Object;

namespace Game.Server.GameServerScript.AI.Messions
{
  public class GOT6304 : AMissionControl
  {
        private SimpleBoss m_boss;

        private PhysicalObj m_front;

        private PhysicalObj m_moive;

        private PhysicalObj m_fan;

        private int IsSay = 0;

        private int bossID = 6341; // trong tai

        private int fanID = 6343; // fan

        private static string[] KillChat = new string[]{
           "Gửi cho bạn trở về nhà!",

           "Một mình, bạn có ảo tưởng có thể đánh bại tôi?"
        };

        private static string[] ShootedChat = new string[]{
            " Đau ah! Đau ...",

            "Quốc vương vạn tuế ..."
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
            Game.AddLoadingFile(1, "bombs/61.swf", "tank.resource.bombs.Bomb61");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.bogucaipanAsset");
            Game.AddLoadingFile(2, "image/game/effect/6/chang.swf", "asset.game.six.chang");
            Game.AddLoadingFile(2, "image/game/effect/6/bluecircle.swf", "asset.game.six.bluecircle");
            Game.AddLoadingFile(2, "image/game/effect/6/greencircle.swf", "asset.game.six.greencircle");
            int[] resources = { bossID, fanID };
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(resources);
            Game.SetMap(1168);
        }

        public override void OnStartGame()
        {
            base.OnStartGame();

            m_fan = Game.Createlayer(1250, 520, "moive", "game.living.Living189", "", 1, 0);

            m_moive = Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 0);
            m_front = Game.Createlayer(1550, 850, "front", "game.asset.living.bogucaipanAsset", "out", 1, 0);


            m_boss = Game.CreateBoss(bossID, 1250, 1000, -1, 1, "");
            m_boss.FallFrom(m_boss.X, m_boss.Y, "", 0, 0, 1000);
            m_boss.SetRelateDemagemRect(m_boss.NpcInfo.X, m_boss.NpcInfo.Y, m_boss.NpcInfo.Width, m_boss.NpcInfo.Height);
            Game.SendGameFocus(m_boss, 0, 3000);//((PVEGame)Game).SendGameFocus(1245, 520, 1, 0, 3000);
            m_boss.PlayMovie("shengqi", 1000, 2000);
            m_boss.PlayMovie("xialai", 2000, 3000);

            m_moive.PlayMovie("in", 6000, 0);
            m_front.PlayMovie("in", 6100, 0);
            m_moive.PlayMovie("out", 9000, 0);
            m_front.PlayMovie("out", 9100, 0);
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
        }
    }
}
