using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using System.Drawing;
using Game.Logic.Actions;
using Bussiness;
using Game.Logic.Effects;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class SixNormalThirdBadNpcAi : ABrain
    {
        private int m_attackTurn = 0;

        private List<PhysicalObj> m_objects = new List<PhysicalObj>();

        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            m_body.CurrentDamagePlus = 1;
            m_body.CurrentShootMinus = 1;

            foreach (PhysicalObj obj in m_objects)
            {
                Game.RemovePhysicalObj(obj, true);
            }

            m_objects = new List<PhysicalObj>();
        }

        public override void OnCreated()
        {
            base.OnCreated();
            Body.MaxBeatDis = 200;
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();

            m_attackTurn++;
            
        }

        public override void OnDie()
        {
            base.OnDie();
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }

        public override void OnAfterTakedBomb()
        {
            base.OnAfterTakedBomb();
        }
    }
}
