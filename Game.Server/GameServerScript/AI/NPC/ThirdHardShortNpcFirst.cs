using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class ThirdHardShortNpcFirst : ABrain
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
                            Body.MoveTo(25, Body.Y, "walk", 1200, "", ((SimpleNpc)Body).NpcInfo.speed, new LivingCallBack(Jump));
                        }
                        else
                        {
                            Body.MoveTo(Body.X - dis, Body.Y, "walk", 1200, "", ((SimpleNpc)Body).NpcInfo.speed, new LivingCallBack(MoveBeat));
                        }
                    }
                    else
                    {
                        if (player.X > Body.X)
                        {
                            Body.MoveTo(Body.X + dis, Body.Y, "walk", 1200, "", ((SimpleNpc)Body).NpcInfo.speed, new LivingCallBack(MoveBeat));
                        }
                        else
                        {
                            Body.MoveTo(Body.X - dis, Body.Y, "walk", 1200, "", ((SimpleNpc)Body).NpcInfo.speed, new LivingCallBack(MoveBeat));
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
                            Body.MoveTo(200, Body.Y, "walk", 1200, "", ((SimpleNpc)Body).NpcInfo.speed, new LivingCallBack(Fall));
                        }
                    }
                    else
                    {
                        if (player.X > Body.X)
                        {
                            Body.MoveTo(Body.X + dis, Body.Y, "walk", 1200, "", ((SimpleNpc)Body).NpcInfo.speed, new LivingCallBack(MoveBeat));
                        }
                        else
                        {
                            Body.MoveTo(Body.X - dis, Body.Y, "walk", 1200, "", ((SimpleNpc)Body).NpcInfo.speed, new LivingCallBack(MoveBeat));
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
            if (m_targer != null && !Body.Beat(m_targer, "beatA", 100, 0, 0, 1, 1))
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
            "Kẻ thù ở phía trước, sẵn sàng chiến đấu!",
            "Sức mạnh bộ tộc là bất diệt!",
            "Nhanh chóng để tiêu diệt kẻ thù!",
            "Bộ tộc của chúng ta là vô địch"
        };

        public static string GetOneChat()
        {
            int index = random.Next(0, listChat.Length);
            return listChat[index];
        }
        

        #endregion
    }
}
