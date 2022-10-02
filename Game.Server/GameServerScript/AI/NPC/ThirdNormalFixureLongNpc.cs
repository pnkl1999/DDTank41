using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using System.Drawing;
using Game.Logic.Actions;
using Bussiness;


namespace Game.Server.GameServerScript.AI.NPC
{
    public class ThirdNormalFixureLongNpc : ABrain
    {
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
            PersonalAttack();
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }

        private void PersonalAttack()
        {
            Player target = Game.FindRandomPlayer();
            Body.CurrentDamagePlus = 1.8f;

            if (target != null)
            {

                if (Body.ShootPoint(target.X, target.Y, 54, 1000, 10000, 1, 2f, 2300))
                {
                    Body.PlayMovie("beatA", 1500, 0);
                }
            }
        }

    }
}
