using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Bussiness;


namespace Game.Server.GameServerScript.AI.NPC
{
    public class TrainingNpc : ABrain
    {
        private static int  direction = 1;

        private int dis = 0;

        private int mtX = 0;
        public override void OnCreated()
        {
            base.OnCreated();
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();

            dis = Game.Random.Next(((SimpleNpc)Body).NpcInfo.MoveMin, ((SimpleNpc)Body).NpcInfo.MoveMax);
            if (direction == 1)
            {
                mtX = Body.X + dis;
                if (mtX > 800)
                {
                    //Body.MoveTo(800, Body.Y, "walk", 100, NextMove);
                    //dis = dis - (800 - Body.X);
                    Body.MoveTo(800, Body.Y, "walk", 100, 3);
                    direction = -direction;
                }
                else
                {
                    Body.MoveTo(mtX, Body.Y, "walk", 100, 3);
                }
            }
            else
            {
                mtX = Body.X - dis;
                if (mtX < 100)
                {
                    //Body.MoveTo(100, Body.Y, "walk", 100, NextMove);
                    //dis = dis - (Body.X - 100);
                    Body.MoveTo(100, Body.Y, "walk", 100, 3);
                    direction = -direction;
                }
                else
                {
                    Body.MoveTo(mtX, Body.Y, "walk", 100, 3);
                }
            }

        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
        }

        public void NextMove()
        {
            direction = -direction;
            if (direction == 1)
            {
                mtX = Body.X + dis;
                Body.MoveTo(mtX, Body.Y, "walk", 100, 3);
            }
            else
            {
                mtX = Body.X - dis;
                Body.MoveTo(mtX, Body.Y, "walk", 100, 3);
            }
        }
    }
}
