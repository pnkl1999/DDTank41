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
    public class FiveNormalThirdNpc1 : ABrain
    {
        private int m_attackTurn = 0;

        protected Player m_targer;

        private int m_bossId = 0;

        private int m_npcId = 0;
        
        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            m_body.CurrentDamagePlus = 1;
            m_body.CurrentShootMinus = 1;

            if(m_targer == null)
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
            Body.CurrentDamagePlus = 1000f;
            Body.Beat(m_targer, "beatA", 100, 0, 1000);
            Body.CallFuction(new LivingCallBack(CheckState), 3000);
        }

        private void CheckState()
        {
            if(m_targer.IsLiving == false)
            {
                DieState();
            }
        }

        private void DieState()
        {
            if(Body.IsLiving)
            {
                Body.PlayMovie("die", 500, 2000);
                Body.Die(2000);
            }
        }

        public override void OnDie()
        {
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
