using Game.Logic.AI;
using System;
using System.Collections.Generic;
using System.Text;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class FourNormalCycLoneNpc : ABrain
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
            Body.Properties1 = 0;
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();

            int randX = Game.Random.Next(Body.X - 150, Body.X + 150);
            int randY = Game.Random.Next(Body.Y - 150, Body.Y + 150);

            randX = randX < 0 ? 0 : randX;

            randX = randX > Game.Map.Info.DeadWidth ? Game.Map.Info.DeadWidth : randX;

            randY = randY > 778 ? 778 : randY;

            Body.MoveTo(randX, randY, "fly", 1000, 5);
        }
        
        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }
    }
}
