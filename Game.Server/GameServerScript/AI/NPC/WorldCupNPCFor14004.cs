using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class WorldCupNPCFor14004 : ABrain
    {	
        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();


        }

        public override void OnCreated()
        {
            base.OnCreated();
        }
        protected SimpleNpc m_targer;
        public override void OnStartAttacking()
        {
            base.OnStartAttacking();
            if (Body.IsFrost)
                return;
            m_targer = Game.FindHelper();
            RunToGoal();
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }

        private void RunToGoal()
        {
            if (m_targer != null && Body.Y > m_targer.X)
            {
                MoveToGoal(m_targer);
            }
        }
        public void MoveToGoal(SimpleNpc player)
        {
            int dis = (int)m_targer.Distance(Body.X, Body.Y);
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
                if (Body.Y < 420)
                {
                    if (Body.X + dis > 200)
                    {
                        Body.MoveTo(300, Body.Y, "walk", 1200, "", 7, Shoot);
                    }
                }
                else
                {
                    if (player.X > Body.X)
                    {
                        Body.MoveTo(Body.X + dis, Body.Y, "walk", 1200, "", 7, Shoot);
                    }
                    else
                    {
                        Body.MoveTo(Body.X - dis, Body.Y, "walk", 1200, "", 7, Shoot);
                    }
                }
            }
        }

        private void Shoot()
        {
            int dis = (int)m_targer.Distance(Body.X, Body.Y);
            if (dis < 300)
            {
                ((PVEGame)Game).SendGameFocus(Body, 0, 100);
                Body.PlayMovie("beatA", 1500, 0);
                Body.CallFuction(Goal, 2000);
            }
        }
        private PhysicalObj moive;
        private void Goal()
        {
            if (m_targer != null)
            {
                moive = ((PVEGame)Game).Createlayer(m_targer.X, m_targer.Y, "moive", "game.living.Living371", "stand", 1, 1);
                moive.PlayMovie("walk", 1000, 0);
                ((PVEGame)Game).IsMissBall = true;
            }
        }
    }
	
}
