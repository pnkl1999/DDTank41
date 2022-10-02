using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class InsectThree : ABrain
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
            else
            {
                Move();
                m_attackTurn = 0;
            }
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }
        private void Move()
        {
            Body.MoveTo(Game.Random.Next(125, 1215), Game.Random.Next(113, 554), "fly", 500, "", 12, null);
        }

        private void MoveBeat()
        {
            Body.MoveTo(Game.Random.Next(125, 1215), Game.Random.Next(113, 554), "fly", 500, "", 12, null);
        }        
    }
}
