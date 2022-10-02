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
    public class FourHardFireNpc : ABrain
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

            int randX = Game.Random.Next(Body.X - 300, Body.X + 300);
            int randY = Game.Random.Next(Body.Y - 300, Body.Y + 300);

            randX = randX < 50 ? 50 : randX;

            randX = randX > Game.Map.Info.DeadWidth - 50 ? Game.Map.Info.DeadWidth - 50 : randX;

            randY = randY > 750 ? 750 : randY;

            randY = randY < 50 ? 50 : randY;

            Body.MoveTo(randX, randY, "fly", 1000, 3);
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }

    }
}
