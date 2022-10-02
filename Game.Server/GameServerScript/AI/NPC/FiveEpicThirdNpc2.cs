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
    public class FiveEpicThirdNpc2 : ABrain
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

            if (m_targer == null)
            {
                m_targer = ((PVEGame)Game).FindPlayer((int)Body.Properties1);
            }
        }

        public override void OnCreated()
        {
            base.OnCreated();
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();

            KillAttack();
        }

        private void KillAttack()
        {
            ((PVEGame)Game).SendObjectFocus(Body, 1, 1000, 0);
            Body.PlayMovie("beatA", 1500, 0);
            m_targer.Die(3000);
            Body.CallFuction(new LivingCallBack(CheckState), 4000);
        }

        private void CheckState()
        {
            if (m_targer.IsLiving == false)
            {
                DieState();
            }
        }

        private void DieState()
        {
            if (Body.IsLiving)
            {
                //Body.PlayMovie("die", 500, 2000);
                Body.Die(1000);
            }
        }

        public override void OnDie()
        {
            if (m_targer.IsLiving)
            {
                m_targer.BoltMove(((Point)Body.Properties2).X, ((Point)Body.Properties2).Y, 0);
            }

            m_targer.SetVisible(true);
            m_targer.BlockTurn = false;
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }

        public override void OnBeforeTakedDamage(Living source, ref int damageAmount, ref int criticalAmount)
        {
            base.OnBeforeTakedDamage(source, ref damageAmount, ref criticalAmount);
        }
    }
}
