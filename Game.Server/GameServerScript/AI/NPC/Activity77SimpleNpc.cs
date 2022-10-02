using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class Activity77SimpleNpc: ABrain
    {
        private Player m_target;

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
            Body.Direction = Game.FindlivingbyDir(Body);
            bool result = false;
            result = ShootLowestBooldPlayer();
            if (result == true)
                return;
            RandomShootPlayer();            
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }
        
        private bool ShootLowestBooldPlayer()
        {
            List<Player> players = new List<Player>();
 
            foreach (Player player in Game.GetAllLivingPlayers())
            {
                if(player.Blood < player.MaxBlood * 0.2)
                {
                    players.Add(player);
                }
            }

            if (players.Count > 0)
            {
                int index = Game.Random.Next(0, players.Count);
                m_target = players[index];
                NpcAttack();
                return true;
            }
            else
            {
                return false;
            }
        }

        private void RandomShootPlayer()
        {
            List<Player> players = Game.GetAllLivingPlayers();
            int index = Game.Random.Next(0, players.Count);
            m_target = players[index];
            NpcAttack();
        }

        private void NpcAttack()
        {
            int npcDirection = 1;
            if (m_target.X > Body.X)
            {
                npcDirection = 1;
                Body.ChangeDirection(1, 0);
            }
            else
            {
                npcDirection = -1;
                Body.ChangeDirection(-1, 0);
            }

            int dis = Math.Abs(m_target.X - Body.X);
            if (dis < 300)
            {
                ShootAttack();
            }
            else
            {
                int length = Game.Random.Next(((SimpleBoss)Body).NpcInfo.MoveMin, ((SimpleBoss)Body).NpcInfo.MoveMax) * 3;
                if (length > dis)
                {
                    length = dis - 300;
                }
                length *= npcDirection;
                if (!Body.MoveTo(Body.X + length, m_target.Y - 20, "walk", 0, "", ((SimpleBoss)Body).NpcInfo.speed, new LivingCallBack(ShootAttack)))
                {
                    ShootAttack();
                }
            }
        }

        private void ShootAttack()
        {
            int dis = Math.Abs(m_target.X - Body.X);
            int offset = 30;
            if (dis < 200)
            {
                offset = 10;
            }
            else if (dis < 500)
            {
                offset = 30;
            }
            else
            {
                offset = 50;
            }

            int mtX = Game.Random.Next(m_target.X - offset, m_target.X + offset);
            if (Body.ShootPoint(mtX, m_target.Y, ((SimpleBoss)Body).NpcInfo.CurrentBallId, 1000, 10000, 1, 2, 1700))
            {
                Body.PlayMovie("beat", 1700, 0);
            }
        }
    }
}
