using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class WorldCupNPCFor14203 : ABrain
    {	
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
            int dis = Game.Random.Next(1410, 1700);
            Body.MoveTo(dis, Body.Y, "walk", 1000, "", 3, PersonalAttack);
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }      

        private void PersonalAttack()
        {
            Player target = Game.FindRandomPlayer();
            if (target != null)
            {
                Body.CurrentDamagePlus = 1.5f;
                Body.Direction = Game.FindlivingbyDir(Body);
                if (Body.ShootPoint(target.X, target.Y, 109, 1000, 10000, 1, 3.0f, 1600))
                {
                    Body.PlayMovie("beatA", 1100, 0);
                }
            }
        }

    }
	
}
