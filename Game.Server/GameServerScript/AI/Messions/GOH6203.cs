using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Phy.Object;

namespace Game.Server.GameServerScript.AI.Messions
{
  public class GOH6203 : AMissionControl
  {
        private SimpleBoss m_boss;

        private SimpleBoss m_arbitra;

        private SimpleNpc m_holegen;

        private PhysicalObj m_front;

        private PhysicalObj m_moive;

        private PhysicalObj m_fan;

        private int IsSay = 0;

        private int bossID = 6231; // oai tu

        private int fanID = 6234; // fan

        private int arbitraID = 6232; // trong tai

        private int holegenID = 6235; // buc dung

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
            Game.AddLoadingFile(2, "image/game/effect/6/popcan.swf", "asset.game.six.popcan");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.boguquanwangAsset");
            int[] resources = { bossID, fanID, arbitraID, holegenID };
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(resources);
            Game.SetMap(1167);
        }

        public override void OnStartGame()
        {
            base.OnStartGame();

            m_fan = Game.Createlayer(1250, 520, "moive", "game.living.Living189", "", 1, 0);

            m_moive = Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 0);
            m_front = Game.Createlayer(1250, 750, "front", "game.asset.living.boguquanwangAsset", "out", 1, 0);

            LivingConfig configHolegen = Game.BaseConfig();
            configHolegen.HasTurn = false;
            configHolegen.CanTakeDamage = false;
            configHolegen.IsFly = true;
            m_holegen = Game.CreateNpc(holegenID, 1250, 700, 1, 1, configHolegen);
            Game.SendHideBlood(m_holegen, 0);
            m_holegen.OnSmallMap(false);

            m_boss = Game.CreateBoss(bossID, 1650, 1000, -1, 1, "");
            m_boss.SetRelateDemagemRect(m_boss.NpcInfo.X, m_boss.NpcInfo.Y, m_boss.NpcInfo.Width, m_boss.NpcInfo.Height);

            LivingConfig configArbit = Game.BaseConfig();
            configArbit.IsFly = true;

            m_arbitra = Game.CreateBoss(arbitraID, 1250, 600, 1, 1, "", configArbit);

            m_arbitra.SetRelateDemagemRect(m_arbitra.NpcInfo.X, m_arbitra.NpcInfo.Y, m_arbitra.NpcInfo.Width, m_arbitra.NpcInfo.Height);

            Game.SendObjectFocus(m_arbitra, 1, 1000, 0);
            m_arbitra.Say("Chào mừng quý vị đến với trận đấu boxing gây cấn.", 0, 1500);
            m_arbitra.Say("Có sự hiện diện của Vua Boxing Oai Tử lừng lẫy giang hồ.", 0, 3000);

            Game.SendObjectFocus(m_boss, 1, 4000, 0);

            m_moive.PlayMovie("in", 5000, 0);
            m_front.PlayMovie("in", 5100, 0);
            m_moive.PlayMovie("out", 7000, 0);
            m_front.PlayMovie("out", 7100, 0);
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
