using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class WorldCupNPCFor14008 : ABrain
    {
        protected Player m_targer;
        private int arbiID = 14007;
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
            Body.MoveTo(Game.Random.Next(325, 1015), Game.Random.Next(113, 354), "fly", 500, "", 12, null);
        }

        private void MoveBeat()
        {
            Body.MoveTo(Game.Random.Next(325, 1015), Game.Random.Next(113, 354), "fly", 500, "", 12, new LivingCallBack(Beating));
        }
        public void Beating()
        {            
            m_body.CurrentDamagePlus = 1.5f;
            Body.PlayMovie("beat", 1000, 0);
            Body.CallFuction(RangeAttacking, 1500);           
        }
        private void RangeAttacking()
        {
            List<Living> list = Game.FindLivingByID(arbiID);
            Body.RangeAttackingNPC("cryB", 1000, list);
        }
        
    }
}
