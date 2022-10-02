using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class NewTrainingBoss25002 : ABrain
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
            int ramdis = Game.Random.Next(((SimpleBoss)Body).NpcInfo.MoveMin, ((SimpleBoss)Body).NpcInfo.MoveMax);
            if (dis > 97)
            {
                if (dis > ((SimpleBoss)Body).NpcInfo.MoveMax)
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
                        Body.MoveTo(Body.X - dis, Body.Y, "walk", 1200, "",((SimpleBoss)Body).NpcInfo.speed, new LivingCallBack(MoveBeat));
                    }
                    else
                    {
                        if (player.X > Body.X)
                        {
                            Body.MoveTo(Body.X + dis, Body.Y, "walk", 1200, "", ((SimpleBoss)Body).NpcInfo.speed, new LivingCallBack(MoveBeat));
                        }
                        else
                        {
                            Body.MoveTo(Body.X - dis, Body.Y, "walk", 1200, "", ((SimpleBoss)Body).NpcInfo.speed, new LivingCallBack(MoveBeat));
                        }
                    }
                }
                else
                {
                    if (Body.Y < 420)
                    {
                        
                        if (Body.X + dis > 200)
                        {
                            Body.MoveTo(200, Body.Y, "walk", 1200, "", ((SimpleBoss)Body).NpcInfo.speed, new LivingCallBack(Fall));
                        }
                    }
                    else
                    {
                        if (player.X > Body.X)
                        {
                            Body.MoveTo(Body.X + dis, Body.Y, "walk", 1200, "", ((SimpleBoss)Body).NpcInfo.speed, new LivingCallBack(MoveBeat));
                        }
                        else
                        {
                            Body.MoveTo(Body.X - dis, Body.Y, "walk", 1200, "", ((SimpleBoss)Body).NpcInfo.speed, new LivingCallBack(MoveBeat));
                        }
                    }
                }
            }
        }

        public void MoveBeat()
        {
            
            Body.Beat(m_targer, "beatA", 100, 0, 200, 1, 1);
            
        }

       
        public void Beating()
        {
            if (m_targer != null && !Body.Beat(m_targer, "beatA", 100, 0, 200, 1, 1))
            {
                MoveToPlayer(m_targer);
            }
        }

        public void Fall()
        {
            Body.FallFrom(Body.X, Body.Y + 240, null, 200, 0, 12, new LivingCallBack(Beating));
        }

        #region NPC 小怪说话

        private static Random random = new Random();
        private static string[] listChat = new string[] { 
            "Ý! Bị đánh đến vầy sao！",
            "Chỉ là một đứa nhóc mà mạnh vậy sao?!",
            "Ta đến báo thù đây, cẩn thận！"
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
                for (int i = 0; i < sayCount; )
                {
                    int index = random.Next(0, livCount);
                    if (livings[index].IsSay == false)
                    {
                        livings[index].IsSay = true;
                        int delay = random.Next(0, 5000);
                        livings[index].Say(SimpleNpcAi.GetOneChat(), 0, delay);
                        i++;
                    }
                }
            }
        }

        #endregion

    }
}
