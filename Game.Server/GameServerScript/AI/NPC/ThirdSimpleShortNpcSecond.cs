using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class ThirdSimpleShortNpcSecond : ABrain
    {
        protected Player m_targer;

        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            m_body.CurrentDamagePlus = 1;
            m_body.CurrentShootMinus = 1;
            if (m_body.IsSay)
            {
                string msg = GetOneChat();
                int delay = Game.Random.Next(0, 5000);
                m_body.Say(msg, 0, delay);
            }
        }

        public override void OnCreated()
        {
            base.OnCreated();
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();
            m_targer = Game.FindNearestPlayer(Body.X, Body.Y);
            Beating();
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }

        public void MoveToPlayer(Player player)
        {
            int dis = (int)player.Distance(Body.X, Body.Y);
            int ramdis = Game.Random.Next(((SimpleNpc)Body).NpcInfo.MoveMin, ((SimpleNpc)Body).NpcInfo.MoveMax);
            if (dis > 97)
            {
                if (dis > ((SimpleNpc)Body).NpcInfo.MoveMax)
                {
                    dis = ramdis;
                }
                else
                {
                    dis = dis - 90;
                }

                if (player.Y < 420 && player.X < 210)
                {
                    if (Body.Y > 420)
                    {
                        if (Body.X - dis < 50)
                        {
                            Body.MoveTo(25, Body.Y, "walk", 1200, "", 3, new LivingCallBack(Jump));
                        }
                        else
                        {
                            Body.MoveTo(Body.X - dis, Body.Y, "walk", 1200, "", 3, new LivingCallBack(MoveBeat));
                        }
                    }
                    else
                    {
                        if (player.X > Body.X)
                        {
                            Body.MoveTo(Body.X + dis, Body.Y, "walk", 1200, "", 3, new LivingCallBack(MoveBeat));
                        }
                        else
                        {
                            Body.MoveTo(Body.X - dis, Body.Y, "walk", 1200, "", 3, new LivingCallBack(MoveBeat));
                        }
                    }
                }
                else
                {
                    if (Body.Y < 420)
                    {
                        //if (Body.X > 200 && Body.X < 300)
                        //{
                        //    Body.FallFrom(Body.X, Body.Y + 240, null, 0, 0, 12, new LivingCallBack(FallBeat));
                        //}
                        //else
                        //{
                        //    Body.MoveTo(Body.X + dis, Body.Y, "walk", 1200, new LivingCallBack(MoveBeat));
                        //}
                        if (Body.X + dis > 200)
                        {
                            Body.MoveTo(200, Body.Y, "walk", 1200, "", 3, new LivingCallBack(Fall));
                        }
                    }
                    else
                    {
                        if (player.X > Body.X)
                        {
                            Body.MoveTo(Body.X + dis, Body.Y, "walk", 1200, "", 3, new LivingCallBack(MoveBeat));
                        }
                        else
                        {
                            Body.MoveTo(Body.X - dis, Body.Y, "walk", 1200, "", 3, new LivingCallBack(MoveBeat));
                        }
                    }
                }
            }
        }

        public void MoveBeat()
        {
            Body.Beat(m_targer, "beatA", 100, 0, 0, 1, 1);
        }

        public void FallBeat()
        {
            Body.Beat(m_targer, "beatA", 100, 0, 2000, 1, 1);
        }

        public void Jump()
        {
            Body.Direction = 1;
            Body.JumpTo(Body.X, Body.Y - 240, "Jump", 0, 2, 3, new LivingCallBack(Beating));
        }

        public void Beating()
        {
            if (m_targer != null && Body.Beat(m_targer, "beatA", 100, 0, 0, 1, 1) == false)
            {
                MoveToPlayer(m_targer);
            }
        }

        public void Fall()
        {
            Body.FallFrom(Body.X, Body.Y + 240, null, 0, 0, 12, new LivingCallBack(Beating));
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
                        livings[index].Say(ThirdSimpleShortNpcSecond.GetOneChat(), 0, delay);
                        i++;
                    }
                }
            }
        }

        #endregion
    }
}
