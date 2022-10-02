using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class SimpleNpcFor40060 : ABrain
    {
        protected Player m_targer;

        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
        }
        private int m_attackTurn = 0;
        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            m_body.CurrentDamagePlus = 0.5f;
            m_body.CurrentShootMinus = 1;            
        }

        public override void OnCreated()
        {
            base.OnCreated();
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking(); 
            if (m_attackTurn == 0)
            {
                MoveBeat();
                m_attackTurn++;
            }
            else if (m_attackTurn == 1)
            {
                Move();
                m_attackTurn++;
            }
            else
            {
               MoveBeat();
                m_attackTurn = 0;
            }
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }
        private void Move()
        {
            Body.MoveTo(Game.Random.Next(225, 1115), Game.Random.Next(113, 354), "fly", 500, "", 12, null);
        }

        private void MoveBeat()
        {
            Body.MoveTo(Game.Random.Next(225, 1115), Game.Random.Next(113, 354), "fly", 500, "", 12, new LivingCallBack(Beating));
        }
        public void Beating()
        {
            Body.PlayMovie("beatA", 2000, 0);
            Body.CallFuction(new LivingCallBack(RangeAttacking), 3000);
            
        }
        private void RangeAttacking()
        {
            Body.RangeAttacking(0, Body.Game.Map.Info.ForegroundWidth + 1, "cry", 1000, null);
        }
        
    }
}
