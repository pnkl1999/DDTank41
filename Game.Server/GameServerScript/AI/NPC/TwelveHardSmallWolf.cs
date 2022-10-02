using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class TwelveHardSmallWolf : ABrain
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
                            Body.MoveTo(25, Body.Y, "walk", 1200, "", 3, new LivingCallBack(MoveBeat));
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
                        if (Body.X + dis > 200)
                        {
                            Body.MoveTo(200, Body.Y, "walk", 1200, "", 3, new LivingCallBack(MoveBeat));
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

        public void Beating()
        {
            if (m_targer != null && Body.Beat(m_targer, "beatA", 100, 0, 0, 1, 1) == false)
            {
                MoveToPlayer(m_targer);
            }
        }
    }
}
