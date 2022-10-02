using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Bussiness;


namespace Game.Server.GameServerScript.AI.NPC
{
    public class TrainingNormalNpc : ABrain
    {
        private int dis = 0;
        public override void OnCreated()
        {
            base.OnCreated();
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();
            int[] direction = { 1, -1 };
            dis = Game.Random.Next(50, 100);
            Body.MoveTo(Body.X + dis * direction[Game.Random.Next(0, 2)], Body.Y, "walk", 3000, 3);
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
        }
    }
}
