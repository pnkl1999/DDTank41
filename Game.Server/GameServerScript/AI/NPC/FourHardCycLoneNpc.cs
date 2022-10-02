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
    public class FourHardCycLoneNpc : ABrain
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

            Body.MoveTo(randX, randY, "fly", 1000, 3);
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }

    }
}
