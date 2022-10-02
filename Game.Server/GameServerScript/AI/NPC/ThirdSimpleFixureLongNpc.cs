using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using System.Drawing;
using Game.Logic.Actions;
using Bussiness;


namespace Game.Server.GameServerScript.AI.NPC
{
    public class ThirdSimpleFixureLongNpc : ABrain
    {
        private int m_attackTurn = 0;

        private int isSay = 0;

        #region NPC 说话内容
        private static string[] AllAttackChat = new string[] {
            LanguageMgr.GetTranslation("Ddtank Vn là số 1"),
        };

        private static string[] ShootChat = new string[]{
            LanguageMgr.GetTranslation("Anh em tiến lên !"),
        };

        private static string[] KillPlayerChat = new string[]{
            LanguageMgr.GetTranslation("Anh em tiến lên !")
        };

        private static string[] CallChat = new string[]{
            LanguageMgr.GetTranslation("Ai giết được chúng sẻ được ban thưởng !"),

        };

        private static string[] JumpChat = new string[]{
             LanguageMgr.GetTranslation("Ai giết được chúng sẻ được ban thưởng !"),

        };

        private static string[] KillAttackChat = new string[]{
             LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.SimpleQueenAntAi.msg13"),

              LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.SimpleQueenAntAi.msg14")
        };

        private static string[] ShootedChat = new string[]{
            LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.SimpleQueenAntAi.msg15"),

            LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.SimpleQueenAntAi.msg16")

        };

        private static string[] DiedChat = new string[]{
            LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.SimpleQueenAntAi.msg17")
        };

        #endregion

        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();

            Body.CurrentDamagePlus = 1;
            Body.CurrentShootMinus = 1;

            isSay = 0;
        }

        public override void OnCreated()
        {
            base.OnCreated();
        }

        public override void OnStartAttacking()
        {
            Body.Direction = Game.FindlivingbyDir(Body);
            bool result = false;
            int maxdis = 0;
            foreach (Player player in Game.GetAllFightPlayers())
            {
                if (player.IsLiving && player.X > 0 && player.X < 0)
                {
                    int dis = (int)Body.Distance(player.X, player.Y);
                    if (dis > maxdis)
                    {
                        maxdis = dis;
                    }
                    result = true;
                }
            }

            if (result)
            {
                KillAttack(0, 0);

                return;
            }

            if (m_attackTurn == 0)
            {
                if (((PVEGame)Game).GetLivedLivings().Count == 9)
                {
                    PersonalAttack();
                }
                else
                {
                    PersonalAttack();
                }
                m_attackTurn++;
            }
            else
            {
                PersonalAttack();
                m_attackTurn = 0;
            }
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }

        private void KillAttack(int fx, int tx)
        {
            int index = Game.Random.Next(0, KillAttackChat.Length);
            Body.Say(KillAttackChat[index], 1, 1000);
            Body.CurrentDamagePlus = 10;
            Body.PlayMovie("beatB", 3000, 0);
            Body.RangeAttacking(fx, tx, "cry", 5000, null);
        }

        private void PersonalAttack()
        {
            Player target = Game.FindRandomPlayer();


            if (target != null)
            {
                Body.CurrentDamagePlus = 0.8f;
				Body.Direction = Game.FindlivingbyDir(Body);
                int mtX = Game.Random.Next(target.X - 0, target.X + 0);

                if (Body.ShootPoint(target.X, target.Y, 58, 1000, 10000, 1, 3.0f, 2550))
                {
                    Body.PlayMovie("beatA", 1700, 0);
                }
            }
        }
		

        public override void OnKillPlayerSay()
        {
            base.OnKillPlayerSay();
            int index = Game.Random.Next(0, KillPlayerChat.Length);
            Body.Say(KillPlayerChat[index], 1, 0, 2000);
        }

        public override void OnDiedSay()
        {
            //int index = Game.Random.Next(0, DiedChat.Length);
            //Body.Say(DiedChat[index], 1, 0, 1500);

        }

        private void CreateChild()
        {

        }

        public override void OnShootedSay()
        {
            int index = Game.Random.Next(0, ShootedChat.Length);
            if (isSay == 0 && Body.IsLiving == true)
            {
                Body.Say(ShootedChat[index], 1, 900, 0);
                isSay = 1;
            }

            if (!Body.IsLiving)
            {
                index = Game.Random.Next(0, DiedChat.Length);
                Body.Say(DiedChat[index], 1, 900 - 800, 2000);
                //Game.AddAction(new FocusAction(Body.X, Body.Y - 90, 0, delay - 900, 4000));
            }
        }
		#region NPC 小怪说话

        private static Random random = new Random();
        private static string[] listChat = new string[] { 
            "Để tôn vinh! Để giành chiến thắng! !",
            "Tổ chức cướp vũ khí của họ, không run sợ!",
            "Super Ddtank muôn năm !",
            "Kẻ thù ở phía trước, sẵn sàng chiến đấu!",
            "Cảm thấy hành vi của nhà vua và bất thường hơn ...",
            "Để Boo Goo chiến thắng! ! Brothers phí!",
            "Nhanh chóng để tiêu diệt kẻ thù!",
            "Sức mạnh số 1 !",
            "Với một sửa chữa nhanh chóng!",
            "Vây quanh kẻ thù và tiêu diệt chúng.",
            "Quân tiếp viện! Quân tiếp viện! Chúng tôi cần thêm quân tiếp viện! !",
            "Hy sinh bản thân, sẽ không cho phép bạn có được đi với.",
            "Đừng đánh giá thấp sức mạnh của Boo Goo, nếu không bạn sẽ phải trả cho việc này."
        };

        public static string GetOneChat()
        {
            int index = random.Next(0, listChat.Length);
            return listChat[index];
        }


        /// <summary>
        /// 小怪说话
        /// </summary>
        public static void LivingSay(List<Living> livings)
        {
            if (livings == null || livings.Count == 0)
                return;
            int sayCount = 0;
            int livCount = livings.Count;
            foreach (Living living in livings)
            {
                living.IsSay = false;
            }
            if (livCount <= 5)
            {
                sayCount = random.Next(0, 2);
            }
            else if (livCount > 5 && livCount <= 10)
            {
                sayCount = random.Next(1, 3);
            }
            else
            {
                sayCount = random.Next(1, 4);
            }

            if (sayCount > 0)
            {
                int[] sayIndexs = new int[sayCount];
                for (int i = 0; i < sayCount;)
                {
                    int index = random.Next(0, livCount);
                    if (livings[index].IsSay == false)
                    {
                        livings[index].IsSay = true;
                        int delay = random.Next(0, 5000);
                        livings[index].Say(ThirdSimpleFixureLongNpc.GetOneChat(), 0, delay);
                        i++;
                    }
                }
            }
        }

        #endregion
    }
}
