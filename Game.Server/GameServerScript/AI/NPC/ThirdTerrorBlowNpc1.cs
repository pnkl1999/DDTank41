using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class ThirdTerrorBlowNpc1 : ABrain
    {
        private Player m_target= null;

        private int m_targetDis = 0;
        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            Body.CurrentDamagePlus = 1;
            Body.CurrentShootMinus = 1;

        }

        public override void OnCreated()
        {
            base.OnCreated();
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();
            m_target = Game.FindNearestPlayer(Body.X, Body.Y);
            m_targetDis = (int)m_target.Distance(Body.X, Body.Y);
            if (m_targetDis < 100)
            {
                Body.PlayMovie("die", 100, 0);
                Body.RangeAttacking(Body.X - 100, Body.X + 100, "cry", 1500, null);
                Body.Die(1000);
            }
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }

        public void MoveToPlayer(Player player)
        {
            int dis = Game.Random.Next(((SimpleNpc)Body).NpcInfo.MoveMin, ((SimpleNpc)Body).NpcInfo.MoveMax);
            if (player.X > Body.X)
            {
                Body.MoveTo(Body.X + dis, Body.Y, "walk", 2000, "", 3, new LivingCallBack(Beat));
            }
            else
            {
                Body.MoveTo(Body.X - dis, Body.Y, "walk", 2000, "", 3, new LivingCallBack(Beat));
            }
        }

        public void Beat()
        {
            if (m_targetDis < 100)
            {
                Body.PlayMovie("die", 100, 0);
                Body.RangeAttacking(Body.X - 100, Body.X + 100, "cry", 1500, null);
                Body.Die(1000);
            }
        }
    }
}
