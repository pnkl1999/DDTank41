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
    public class FiveHardSecondNpc : ABrain
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
            List<Player> playerCanAttacks = new List<Player>();
            foreach (Player p in Game.GetAllLivingPlayers())
            {
                if (p.Y > 760)
                {
                    playerCanAttacks.Add(p);
                }
            }

            if (playerCanAttacks.Count > 0)
            {
                int randSlot = Game.Random.Next(0, playerCanAttacks.Count);
                m_targer = playerCanAttacks[randSlot];

                MoveToTarget();
            }
        }

        private void MoveToTarget()
        {
            Body.MoveTo(m_targer.X, m_targer.Y, "walk", 1000, 3, BeatTarget);
        }

        private void BeatTarget()
        {
            Body.PlayMovie("beatA", 1000, 0);
            Body.RangeAttacking(Body.X - 50, Body.X + 50, "cry", 3000, true);
        }

        private void DelayBeat()
        {

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
