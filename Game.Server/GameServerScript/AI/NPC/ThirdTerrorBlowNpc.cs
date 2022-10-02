using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class ThirdTerrorBlowNpc : ABrain
    {
        private int attackingTurn = 1;

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

            if (attackingTurn == 1)
            {
                NoDame();
            }
            else if (attackingTurn == 2)
            {
                Beat();
            }
            else
            {
                NoDame();
                attackingTurn = 1;
            }
            attackingTurn++;
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }

        public void NoDame()
        {
            Body.PlayMovie("stand", 100, 0);
        }

        public void Beat()
        {
            Body.PlayMovie("beatA", 500, 0);
            Body.RangeAttacking(Body.X - 100, Body.X + 100, "cry", 1500, null);
            Body.Die(1000);
        }
    }
}
