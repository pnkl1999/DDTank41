using Bussiness;
using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Effects;
using Game.Logic.Phy.Object;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Text;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class ThirteenSimpleNpc : ABrain
    {
        private int m_attackTurn = 0;

        private Player m_target;
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

            switch (m_attackTurn)
            {
                case 0:
                    // gau gau
                    TakeDamage();
                    break;

                case 1:
                    MakeDead();
                    break;

            }
            m_attackTurn++;
        }

        private void TakeDamage()
        {
            // find target
            if(Body.Properties1 != null)
            {
                m_target = Game.FindPlayerWithId((int)Body.Properties1);
                if(m_target != null && m_target.IsLiving)
                {
                    Body.PlayMovie("beatA", 500, 0);
                    Body.BeatDirect(m_target, "", 2000, 1, 1);
                }
            }
            
        }

        private void MakeDead()
        {
            Body.PlayMovie("die", 1000, 0);
            if(m_target != null)
            {
                Body.CallFuction(ShowPlayer, 2500);
                m_target.Die(3000);
                
            }
            Body.Die(4000);
        }

        private void ShowPlayer()
        {
            m_target.SetVisible(true);
            m_target.BlockTurn = false;
        }

        public override void OnDie()
        {
            base.OnDie();
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }
    }
}
